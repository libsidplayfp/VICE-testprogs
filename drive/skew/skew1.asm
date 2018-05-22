
; by Krill/Plush

; initial run does not invalidate previous BAM,
; so it will happily run without an inserted disk -
; however, this can be used to check disks
; without a standard directory track

; successive runs will error out on non-inserted disk

        !convtab pet
        !cpu 6510
        !to "skew1.prg", cbm

;-------------------------------------------------------------------------------

drivecode_start = $0300
drivecode_exec = drvstart

        !src "../framework.asm"

;-------------------------------------------------------------------------------

maxtrack = 35
maxskew = 1024

goodfg = $01
goodbg = $05
goodlight = $03
evilfg = $07
evilbg = $02
evillight = $0a

delaysl = $c000
delaysh = $c100
prevdelaysl = $c200
prevdelaysh = $c300

start:  
        jsr clrscr

        lda #<drivecode
        ldy #>drivecode
        ldx #((drivecode_end - drivecode) + $1f) / $20 ; upload x * $20 bytes to 1541
        jsr upload_code

        lda #<drivecode_exec
        ldy #>drivecode_exec
        jsr start_code

        lda #$5b; EBCM
        sta $d011

        lda #goodbg
        sta $d020
        sta $d021
        lda #goodlight
        sta $d022
        lda #evilbg
        sta $d023
        lda #evillight
        sta $d024

        jsr rcv_init
        sei
        jsr rcv_wait

        jsr rcv_1byte   ; status
        cmp #2
        bcc +
        jmp error

+       ldy #0
-       jsr rcv_1byte
        cmp #$a0
        bne +
        lda #' '
+       sta .headerid+1,y
        iny
        cpy #16
        bne -
        ldy #0
-       jsr rcv_1byte
        cmp #$a0
        bne +
        lda #' '
+       sta .headerid+1+16+1,y
        iny
        cpy #5
        bne -

        jsr printheaderid

        jsr scroll
        jsr printnames
++
        lda #$ff
        sta .fmt
        sta .align

        lda #1
        sta .track
trackloop:
        lda .track
        ldx #21
        cmp #18
        bcc +
        dex
        dex
        cmp #25
        bcc +
        dex
        cmp #31
        bcc +
        dex
+       stx .numsectors

        ldx #20
-       lda delaysl,x
        sta prevdelaysl,x
        lda delaysh,x
        sta prevdelaysh,x
        dex
        bpl -

        lda .nextskewfrom
        sta .skewfrom
        lda .nextskewto
        sta .skewto
        lda .nextskewexp
        sta .skewexp
        lda .nextseekdelayl
        sta .seekdelayl
        lda .nextseekdelayh
        sta .seekdelayh

        jsr receivedata
        bcc +
        jmp error

+       ldy #0
        sty .lo
        sty .mid
        sty .hi
-       ; calculate rotation time
        clc
        lda delaysl,y
        adc .lo
        sta .lo
        lda delaysh,y
        adc .mid
        sta .mid
        bcc +
        inc .hi
+       iny
        cpy .numsectors
        bne -

        ; calculate rpm
        lda #$00        ; 60,000,000
        ldx #$87
        ldy #$93
        sec
        jsr $af87       ; 24-bit integer to float mantissa
        lda #$03
        sta $62         ; MSB of 32-bit integer
        jsr $af7e       ; normalise
        jsr $bc0c       ; ARG = FAC        

        lda .lo         ; avoid division by zero
        ora .mid
        ora .hi
        tay
        beq +

        lda .lo
        ldx .mid
        ldy .hi
        sec
        jsr $af87       ; 24-bit integer to float mantissa
        jsr $af7e       ; normalise FAC

        lda $61
        jsr $bb12       ; FAC = ARG / FAC

        jsr $b849       ; FAC = FAC + 0.5
        jsr $b7f7       ; to int
+       sta .rpmh
        sty .rpml

        ; find minimum value
        lda #$ff
        tax
        stx .semin
        ldy #0
-       pha
        cmp delaysl,y
        txa
        sbc delaysh,y
        pla
        bcc +           ; update if min >= value
        lda delaysl,y
        ldx delaysh,y
        sty .semin
+       iny
        cpy .numsectors
        bne -
        sta .minl
        stx .minh

        ; find maximum value
        lda #$00
        tax
        stx .semax
        ldy #0
-       pha
        cmp delaysl,y
        txa
        sbc delaysh,y
        pla
        bcs +           ; update if max < value
        lda delaysl,y
        ldx delaysh,y
        sty .semax
+       iny
        cpy .numsectors
        bne -
        sta .maxl
        stx .maxh

        ; calculate arithmetical mean
        lda .lo
        ldx .mid
        ldy .hi
        sec
        jsr $af87       ; 24-bit integer to float mantissa
        jsr $af7e       ; normalise
        jsr $bc0c       ; ARG = FAC        

        lda .numsectors ; is never 0
        jsr $bc3c       ; to FAC

        lda $61
        jsr $bb12       ; FAC = ARG / FAC

        jsr $b7f7       ; to int
        sta .meanh
        sty .meanl

        ; calculate maximum difference of min and max to mean
        sec
        lda .meanl
        sbc .minl
        sta .mindl
        lda .meanh
        sbc .minh
        sta .mindh

        sec
        lda .maxl
        sbc .meanl
        sta .maxdl
        lda .maxh
        sbc .meanh
        sta .maxdh

        ldx .mindl
        ldy .mindh
        cpx .maxdl
        tya
        sbc .maxdh
        bcs +
        ldx .maxdl
        ldy .maxdh
+       stx .diffl
        sty .diffh

        lda .track
        cmp #1
        beq +

        lda .skewto
        cmp .skewexp
        beq calcskew
+       jmp judge

        ; calculate skew
calcskew:
        lda #0
        sta .minskewl
        sta .minskewh
        sta .maxskewl
        sta .maxskewh
        sta .diffskewl
        sta .diffskewh
        lda #99
        sta .seminskew
        sta .semaxskew

        ; no further measurement of track skew across speed zone
        ; boundaries, as sector and tailgap times are different
        lda .track
        cmp #18
        beq +
        cmp #25
        beq +
        cmp #31
        bne ++
+       jmp judge

++      lda .skewfrom
        tax
        tay
        iny
        cpy .numsectors
        bcc +
        ldy #0

        clc
+       lda prevdelaysl,x
        adc prevdelaysl,y
        sta .prevdelayl+1
        lda prevdelaysh,x
        adc prevdelaysh,y
        sta .prevdelayh+1

trackskew: 
        iny
        cpy .numsectors
        bcc +
        ldy #0
+       cpy .skewfrom
        beq diffskew

        sec
.prevdelayl:
        lda #0
        sbc .seekdelayl
        tax
.prevdelayh:
        lda #0
        sbc .seekdelayh
        bpl +
        sty .seminskew
        stx .minskewl
        sta .minskewh
        bmi ++
+       sty .semaxskew
        stx .maxskewl
        sta .maxskewh
++
        clc
        lda prevdelaysl,y
        adc .prevdelayl+1
        sta .prevdelayl+1
        lda prevdelaysh,y
        adc .prevdelayh+1
        sta .prevdelayh+1
        clc
        lda delaysl,y
        adc .seekdelayl
        sta .seekdelayl
        lda delaysh,y
        adc .seekdelayh
        sta .seekdelayh
        jmp trackskew

diffskew:
        ldx .minskewl
        ldy .minskewh
        bpl +
        sec
        lda #0
        sbc .minskewl
        tax
        lda #0
        sbc .minskewh
        tay
+       cpx .maxskewl
        tya
        sbc .maxskewh
        bcs +
        ldx .maxskewl
        ldy .maxskewh
+       stx .diffskewl
        sty .diffskewh

judge:
        ldx .numsectors
        dex
        cpx .semax
        clc
        bne ++

        lda .track
        ldx #0
        cmp #18
        bcc +
        inx
        inx
        cmp #25
        bcc +
        inx
        inx
        cmp #31
        bcc +
        inx
        inx
+       lda diffthresholds+0,x
        cmp .diffl
        lda diffthresholds+1,x
        sbc .diffh
++      ror .ok

        lda .track
        cmp #1
        beq ++

        lda .skewto
        cmp .skewexp
        clc
        bne +
        lda #<maxskew
        cmp .diffskewl
        lda #>maxskew
        sbc .diffskewh
+       ror .okskw

        lda .okskw
        and .align
        sta .align

        jsr printtrackskew

++      lda .ok
        and .fmt
        sta .fmt

        jsr printsametrack

        cli

        inc .track
        lda .track
        cmp #maxtrack+1
        bcs finished
 
        cmp #13
        beq +
        cmp #25
        bne ++
+       jsr scroll
        jsr printnames
++

-       bit $cb         ; pause on key press
        bvc -
        jmp trackloop

finished:

        sei
        jsr rcv_wait

        ; status
        jsr rcv_1byte
        cmp #2
        bcc +
        jmp error

+       jsr printheaderid

        jsr scroll

        lda .fmt
        and .align
        jsr setcol

        lda .fmt
        asl
        ldx #0
-       lda kernalfmt,x
        bcs +
        lda fastfmt,x
+       beq +
        php
        jsr $ffd2
        plp
        inx
        bne -

+       lda .align
        asl
        ldx #0
-       lda aligned,x
        bcs +
        lda notaligned,x
+       beq +
        php
        jsr $ffd2
        plp
        inx
        bne -

+       lda .fmt
        and .align
        asl
        ldx #$27
-       lda #$00
        bcs +
        ora #$80
+       ora $07c0,x
        sta $07c0,x
        dex
        bpl -

waitrestart:
        lda #$00        ; success
        bcs +
        lda #$ff        ; failure
+       sta $d7ff

        cli

-       bit $cb         ; wait for key
        bvs -
        jmp start

;-------------------------------------------------------------------------------

receivedata:
        sei
        jsr rcv_wait

        ; status
        jsr rcv_1byte
        cmp #2
        bcc +
        rts

+       ; get time stamps
        ldy #0
-       jsr rcv_1byte
        sta delaysl,y     ; lo
        jsr rcv_1byte
        sta delaysh,y     ; hi
        iny
        cpy .numsectors
        bne -

        lda .track
        cmp #maxtrack
        bcs +

        ; get skew data
        jsr rcv_1byte
        sta .nextskewfrom
        jsr rcv_1byte
        sta .nextskewto
        jsr rcv_1byte
        sta .nextskewexp
        cmp .nextskewto
        bne +
        jsr rcv_1byte     ; possibly aligned
        sta .nextseekdelayl
        jsr rcv_1byte
        sta .nextseekdelayh

+       clc
        rts

        ; print same-track min/max/mean/diff
printsametrack:
        bit .ok
        bmi +
        lda #evilbg
        sta $d020
+
        jsr scroll

        lda .ok
        jsr setcol

        lda .track
        tax
        jsr printtracknos

        ldx .rpml
        ldy .rpmh
        jsr pad4
        lda .rpmh
        ldx .rpml
        jsr $bdcd       ; print int

        lda #' '
        jsr $ffd2
        lda .semin
        jsr print2
        lda #':'
        jsr $ffd2
        ldx .minl
        ldy .minh
        jsr pad5
        lda .minh
        ldx .minl
        jsr $bdcd       ; print int
        lda #' '
        jsr $ffd2

        lda #' '
        jsr $ffd2
        lda .semax
        jsr print2
        lda #':'
        jsr $ffd2
        ldx .maxl
        ldy .maxh
        jsr pad5
        lda .maxh
        ldx .maxl
        jsr $bdcd       ; print int
        lda #' '
        jsr $ffd2

        ldx .meanl
        ldy .meanh
        jsr pad5
        lda .meanh
        ldx .meanl
        jsr $bdcd       ; print int

        lda #' '
        jsr $ffd2
        ldx .diffl
        ldy .diffh
        jsr pad4
        lda .diffh
        ldx .diffl
        jsr $bdcd       ; print int

        lda .ok
        jmp setrowcol

printtrackskew:
        bit .okskw
        bmi +
        lda #evilbg
        sta $d020
+
        jsr scroll

        lda .okskw
        jsr setcol

        sec
        lda .track
        tax
        sbc #1
        jsr printtracknos

        ldx #4
        jsr spaces

        lda .skewto
        cmp .skewexp
        beq skew

        sec
        sbc .skewexp
        sta .skewsectordiff+1
        bpl +

        clc
        eor #$ff
        adc #$01
        pha
        asl
        cmp .numsectors
        bcc negskew     ; pick smaller diff
        pla
        clc
.skewsectordiff:
        lda #0
        adc .numsectors

+       pha
        beq zeroskew
        asl
        cmp .numsectors
        bcc posskew     ; pick smaller diff
        pla
        sec
        lda .numsectors
        sbc .skewsectordiff+1
        pha
negskew:
        lda #'-'
        !byte $2c
posskew:
        lda #'+'
        !byte $2c
zeroskew:
        lda #' '

printskew:
        jsr $ffd2
        pla
        jsr print2
        lda #':'
        jsr $ffd2
        lda .skewexp
        jsr print2
        lda #'-'
        jsr $ffd2
        lda #'>'
        jsr $ffd2
        lda .skewto
        jsr print2
        jmp skewdone

skew:   lda .track
        cmp #18
        beq +
        cmp #25
        beq +
        cmp #31
        bne ++
+       lda #' '
        jsr $ffd2
        lda #0
        jsr print2
        jmp skewdone

++      lda #' '
        jsr $ffd2

        lda .seminskew
        jsr print2
        lda #':'
        jsr $ffd2
        lda .minskewh
        bpl +
        sec
        lda #0
        sbc .minskewl
        sta .minskewl
        tax
        lda #0
        sbc .minskewh
        sta .minskewh
        tay
        jsr pad4
        lda #'-'
        jsr $ffd2
        jmp ++
+       ldx .minskewl
        ldy .minskewh
        jsr pad5
++      ldx .minskewl
        lda .minskewh
        jsr $bdcd       ; print int

        ldx #2
        jsr spaces

        lda .semaxskew
        jsr print2
        lda #':'
        jsr $ffd2
        ldx .maxskewl
        ldy .maxskewh
        jsr pad5
        lda .maxskewh
        ldx .maxskewl
        jsr $bdcd       ; print int

        ldx #6
        jsr spaces

        ldx .diffskewl
        ldy .diffskewh
        jsr pad5
        lda .diffskewh
        ldx .diffskewl
        jsr $bdcd       ; print int

skewdone:
        lda .okskw
        jmp setrowcol

printheaderid:
        jsr scroll

        ldx #0
-       lda .headerid,x
        and #$3f
        sta $07c0,x
        lda #goodfg
        sta $dbc0,x
        inx
        cpx #1+16+1+5+1
        bne -
        rts

printnames:
        ldx #$27
-       lda colnames,x
        ora #$40
        sta $07c0,x
        lda #goodfg
        sta $dbc0,x
        dex
        bpl -
        rts

scroll: lda #49
        sta $d5
        ldx #$19
-       lda #$80        ; never scroll extra line
        ora $d9,x
        sta $d9,x
        dex
        bpl -
        ldx #24
        jsr $e9f0       ; set print line
        lda #0
        sta $d3         ; set print column
        jmp $e8ea       ; scroll

setcol:
        asl
        lda #goodfg
        bcs +
        lda #evilfg
+       sta $0286
        rts

setrowcol:
        ldx #$27
        asl
-       lda columns,x
        bcs +
        ora #$80
+       ora $07c0,x
        sta $07c0,x
        dex
        bpl -
        rts

printtracknos:
        pha
        stx .totrack+1
        jsr print2
        pla
        tax
        lda #'='
        cpx .totrack+1
        beq +
        lda #'-'
+       jsr $ffd2
.totrack:
        lda #0
        jsr print2
        lda #':'
        jmp $ffd2

print2: pha
        cmp #10
        bcs +
        lda #'0'
        jsr $ffd2
+       pla
        tax
        lda #0
        jmp $bdcd       ; print int

pad5:   cpx #<10000
        tya
        sbc #>10000
        bcs pad4
        lda #' '
        jsr $ffd2
pad4:   cpx #<1000
        tya
        sbc #>1000
        bcs +
        lda #' '
        jsr $ffd2
+       cpx #<100
        tya
        sbc #>100
        bcs +
        lda #' '
        jsr $ffd2
+       cpx #<10
        tya
        sbc #>100
        bcs +
        lda #' '
        jsr $ffd2
+       rts

spaces: lda #' '
        jsr $ffd2
        dex
        bne spaces
        rts

error:  pha
        lda #evilfg
        sta $0286
        jsr scroll
        pla

        cmp #10
        bne +
        ldx #0
-       lda direrror,x
        beq ++
        jsr $ffd2
        inx
        bne -

+       pha
        ldx #0
-       lda errorstring,x
        beq +
        jsr $ffd2
        inx
        bne -
+       pla
        tax
        lda #0
        jsr $bdcd       ; print int
++      ldx #$27
-       lda #$80
        ora $07c0,x
        sta $07c0,x
        dex
        bpl -
        clc
        jmp waitrestart

;-------------------------------------------------------------------------------

kernalfmt:
        !text "kernal format, "
        !byte 0
fastfmt:
        !text "fast formatter, "
        !byte 0

aligned:
        !text "tracks are aligned"
        !byte 0
notaligned:
        !text "tracks are not aligned"
        !byte 0

direrror:
        !text "cannot read directory"
        !byte 0

errorstring: 
        !text "error "
        !byte 0

; these are arbitrary values beyond what
; has been seen with KERNAL format
diffthresholds:
        !word 3000
        !word 3000
        !word 3000
        !word 3000

.headerid:
        !text '"'
        !text "normal is boring"
        !text ','
        !text "plush"
        !text '"'

.track: !byte 0

.numsectors:
        !byte 0

.lo:    !byte 0
.mid:   !byte 0
.hi:    !byte 0

.rpml:  !byte 0
.rpmh:  !byte 0

.semin: !byte 0
.minl:  !byte 0
.minh:  !byte 0

.semax: !byte 0
.maxl:  !byte 0
.maxh:  !byte 0

.meanl: !byte 0
.meanh: !byte 0

.mindl: !byte 0
.mindh: !byte 0

.maxdl: !byte 0
.maxdh: !byte 0

.diffl: !byte 0
.diffh: !byte 0

.skewfrom:
        !byte 0
.skewto:
        !byte 0
.skewexp:
        !byte 0
.seekdelayl:
        !byte 0
.seekdelayh:
        !byte 0

.nextskewfrom:
        !byte 0
.nextskewto:
        !byte 0
.nextskewexp:
        !byte 0
.nextseekdelayl:
        !byte 0
.nextseekdelayh:
        !byte 0

.seminskew:
        !byte 0
.minskewl:
        !byte 0
.minskewh:
        !byte 0

.semaxskew:
        !byte 0
.maxskewl:
        !byte 0
.maxskewh:
        !byte 0

.diffskewl:
        !byte 0
.diffskewh:
        !byte 0

.ok:    !byte 0
.okskw: !byte 0

.fmt:   !byte 0
.align: !byte 0

colnames:
        !scr "tr tr  rpm minimum   maximum   mean diff"

columns:
        !scr "@@@@@@@@@@"
        !text          "@@@@@@@@@@"
        !scr                     "@@@@@@@@@@"
        !text                              "@@@@@"
        !scr                                    "@@@@@"

;-------------------------------------------------------------------------------

drivecode:
!pseudopc drivecode_start {

        !src "../framework-drive.asm"

!macro gettimestamp {
        lda $1808       ; 4 lo
        ldx $1809       ; 4 hi
        cmp #4
        bcs +
        inx             ; compensate hi-byte decrease
+
}

!macro nextsector {
        iny
        cpy dnumsectors
        bcc +
        ldy #0
+
}

drvstart:
        sei
        lda #$20        ; faster track step
        sta $1c07

        jsr snd_init

        jsr snd_start
        
        lda #18
        cmp $0700
        bne +
        lda #1
        cmp $0701
        beq ++
+       lda #10
        jmp derror

++      lda #0
        sta $0700
        sta $0701
        jsr snd_1byte

        ldy #0
-       lda $0790,y
        jsr snd_1byte
        iny
        cpy #16
        bne -
        ldy #0
-       lda $07a2,y
        jsr snd_1byte
        iny
        cpy #5
        bne -
+
        lda #1          ; track no
        sta $08
        lda #0          ; sector no (ignored)
        sta $09  
        lda #$e0        ; seek and start program at $0400
        sta $01
        cli
        lda $01
        bmi *-2
        sei

        pha
        jsr snd_start
        pla
derror: jsr snd_1byte   ; status

        lda #$10        ; motor off
        ora $20
        sta $20
        lda #$f7
        and $1c00
        sta $1c00
        cli
        rts

        ;* = $0400
        !align $ff, 0, 0

        lda #$df        ; start timer B
        and $180b
        sta $180b

        lda #$52        ; GCR header tag
        sta $24

        lda #1
        sta .dtrack+1
.dtrack:
        lda #0
        ldx #21
        cmp #18
        bcc +
        dex
        dex
        cmp #25
        bcc +
        dex
        cmp #31
        bcc +
        dex
+       stx dnumsectors

        stx .retries
-       jsr nexthdr     ; next block likely isn't on sector #0

        lda #$ff
        sta $1808       ; reset timer B
        sta $1809

        cpy dnumsectors
        bcc +
        ldy #0
+       sty .secno+1

        ; measuring track skew across speed zone boundaries:
        ; second-to-last sector on current track/speed zone -> sector 0 on next track/speed zone
        lda .dtrack+1
        cmp #18-1
        beq boundary
        cmp #25-1
        beq boundary
        cmp #31-1
        bne sametrack
boundary:
        ldx dnumsectors
        dex
        dex             ; second-to-last sector on track
        cpx .secno+1
        beq sametrack
        dec .retries
        bne -

        ; same-track sector-to-sector delay measurement
sametrack:
        sty .from+1

        jsr nexthdr

        php             ; delay 10+4 cycles to
        plp             ; compensate for initial
        php             ; timer setup time above
        plp             ; and read time below
        +gettimestamp
        sta .prevtimel
        stx .prevtimeh

.from:  ldy #0          ; previous sector
        sta timel,y
        txa
        sta timeh,y

        +nextsector
.secno: cpy #0
        bne sametrack

        ; collected time stamps for the track,
        ; move to next track
        inc .dtrack+1

        lda .dtrack+1
        cmp #maxtrack+1
        beq +

        clc
        lda $1c00
        and #$fb
        adc #$01        ; move head to next half-track
        ora #$04
        sta $1c00
+
        ; calculate sector-to-sector delays
        lda #$ff
        tax
-       sec
        sbc timel,y
        sta dlyl,y
        txa
        sbc timeh,y
        and #$7f
        sta dlyh,y
        lda timel,y
        ldx timeh,y
        +nextsector
        cpy .secno+1
        bne -

        lda .dtrack+1
        cmp #maxtrack+1
        bne +
        jmp senddata

+
        ; track skew measurement

        ; seek wait time is measured time between current sector and sector after next,
        ; which is long enough for the stepper, one sector delay isn't
        delayoffset = $0ac0 ; a large part of this is the time it takes to read and decode a block header,
                            ; increase value to add tolerance
        lda .secno+1
        tax
        tay
        +nextsector
        clc
        lda dlyl,x
        adc dlyl,y
        sta .stepdlyl+1
        lda dlyh,x
        adc dlyh,y
        sta .stepdlyh+1

        +nextsector
        sty .expno+1

        sec
        lda .stepdlyl+1
        sbc #<delayoffset
        sta .stepdlyl+1
        lda .stepdlyh+1
        sbc #>delayoffset
        
        lsr             ; two half-tracks
        sta .stepdlyh+1
        ror .stepdlyl+1

-       +gettimestamp
        sta .nextprevtimel+1
        stx .nextprevtimeh+1
        sec
        sbc .prevtimel
        pha
        txa
        sbc .prevtimeh
        tax
        pla
        clc
.stepdlyl:
        adc #0
        txa
.stepdlyh:
        adc #0
        bcs -

        clc
        lda $1c00
        and #$fb
        adc #$01        ; move head to next half-track
        ora #$04
        sta $1c00

-       +gettimestamp
        sec
.nextprevtimel:
        sbc #0
        pha
        txa
.nextprevtimeh:
        sbc #0
        tax
        pla
        clc
        adc .stepdlyl+1
        txa
        adc .stepdlyh+1
        bcs -

        lda .dtrack+1
        cmp #18
        beq setbitrate
        cmp #25
        beq setbitrate
        cmp #31
        bne nexttrack

setbitrate:
        lda $1c00
        sec
        sbc #$20
        sta $1c00
        lda #0          ; expect sector 0 on next speed zone
        sta .expno+1

nexttrack:
        jsr nexthdr

        php             ; delay 10+4 cycles to
        plp             ; compensate for initial
        php             ; timer setup time above
        plp             ; and read time below
        +gettimestamp
        sta .seektimel+1
        stx .seektimeh+1
        sec
        lda .prevtimel
.seektimel:
        sbc #0
        sta .seekdlyl+1
        lda .prevtimeh
.seektimeh:
        sbc #0
        sta .seekdlyh+1

senddata:
        lda #$08
        eor $1c00
        sta $1c00

        jsr snd_start
        
        lda #0          ; status
        jsr snd_1byte

        ldy #0
-       lda dlyl,y
        jsr snd_1byte
        lda dlyh,y
        jsr snd_1byte
        iny
        cpy dnumsectors
        bne -

        lda .dtrack+1
        cmp #maxtrack+1
        bcs done

        sta $22         ; current track

        lda .secno+1    ; skewfrom
        jsr snd_1byte
        lda $19         ; sector no
        jsr snd_1byte
.expno:
        lda #0
        jsr snd_1byte

        lda $19         ; sector no
        cmp .expno+1
        bne +

.seekdlyl:
        lda #0
        jsr snd_1byte
.seekdlyh:
        lda #0
        jsr snd_1byte        

+       jmp .dtrack

done:   lda #1
        sta $01

        jmp $f99c       ; to job loop

nexthdr:
        jsr waitsync
        bvc *           ; wait byte ready
        clv             ; clear byte ready flag
        lda $1c01
        cmp $24
        beq +

        jsr waitsync
        bvc *           ; wait byte ready
        clv             ; clear byte ready flag

+       ldx #$00
-       bvc *           ; wait byte ready
        clv             ; clear byte ready flag
        lda $1c01
        sta $25,x
        inx
        cpx #$07
        bne -

        jsr $f497       ; decode GCR $24- to $16-

        ldy $19         ; sector no
        cpy #21
        bcc +
        ldy #0
        sty $19         ; sector no
+       rts

waitsync:
        lda #$d0
        sta $1805
-       bit $1805
        bpl +
        bit $1c00
        bmi -
+       lda $1c01
        clv
        rts

dnumsectors:
        !byte 0

.retries:
        !byte 0

.prevtimel:
        !byte 0
.prevtimeh:
        !byte 0

timeh:  !byte 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21
timel:  !byte 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21

dlyl:   !byte 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21
dlyh:   !byte 1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21
} ; !pseudpc drivecode_start
drivecode_end:
