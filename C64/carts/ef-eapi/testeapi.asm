
; offset    bank  addrhi        erase   erase
; in .bin                       bank    addrhi
;
; 00:0000   0     8000           0      8000
; 00:2000   0     a000 / e000    0      a000 / e000
; 00:4000   1     8000           0
; 00:6000   1     a000 / e000    0
; 00:8000   2     8000           0
; 00:a000   2     a000 / e000    0
; 00:c000   3     8000           0
; 00:e000   3     a000 / e000    0

; 01:0000   4     8000           0

; 02:0000   8     8000           8      8000
; 02:2000   8     a000 / e000    8      a000 / e000
; 02:4000   9     8000           8
; 02:6000   9     a000 / e000    8
; 02:8000  10     8000           8
; 02:a000  10     a000 / e000    8


; 0f:e000  63     a000 / e000   56      a000 / e000

EAPI_RAM_CODE           = $df80

EAPIWriteFlash        = EAPI_RAM_CODE + (0*3)
EAPIEraseSector       = EAPI_RAM_CODE + (1*3)
EAPISetBank           = EAPI_RAM_CODE + (2*3)
EAPIGetBank           = EAPI_RAM_CODE + (3*3)
EAPISetPtr            = EAPI_RAM_CODE + (4*3)
EAPISetLen            = EAPI_RAM_CODE + (5*3)
EAPIReadFlashInc      = EAPI_RAM_CODE + (6*3)
EAPIWriteFlashInc     = EAPI_RAM_CODE + (7*3)
EAPISetSlot           = EAPI_RAM_CODE + (8*3)   ; RTS
EAPIGetSlot           = EAPI_RAM_CODE + (9*3)   ; RTS

EasyAPI_dest = $c800    ; 3 pages
EasyAPI_src = $b800     ; in cartridge
EAPIInit = EasyAPI_dest + $14

scrptr  = $02

linepos = $04

bankcount = $0400

statusline1 = $0400+(1*40)
statusline2 = $0400+(5*40)

ROMLTAG = $9ff0
ROMHTAG = $bff0
RAMTAG  = $df00

;------------------------------------------------------------------------------

    *=$5000

    jsr clrscr

    ldx #0          ; first bank
    stx $de00
    lda #$07        ; switch to 16k game mode
    sta $de02

    ; tag ram UNDER cart
;     php
;     lda $01
;     pha
    sei
    lda #$34
    sta $01
    lda #$fe        ; FE = C64 memory
    sta ROMLTAG
    sta ROMHTAG
    sta RAMTAG
;     pla
;     sta $01
;     plp

    lda #$37
    sta $01

    lda #$fd        ; FD = cart mem
    sta RAMTAG

;     ldx #0          ; first bank
;     stx $de00
;     lda #$07        ; switch to 16k game mode
;     sta $de02
;
;     jmp *

    ldx #0
-
    lda EasyAPI_src+$0000,x        ;copy EAPI-routines
    sta EasyAPI_dest+$0000,x
    lda EasyAPI_src+$0100,x
    sta EasyAPI_dest+$0100,x
    lda EasyAPI_src+$0200,x
    sta EasyAPI_dest+$0200,x
    inx
    bne -

    lda #$12 ; dummy
    ldx #$34 ; dummy
    ldy #$56 ; dummy

    jsr printregs
    jsr space
    jsr printmem

    jsr EAPIInit
    bcc +
    ; if carry set, error
    inc $d020
    jmp * - 3
+
;       A   Device ID
;       X   Manufacturer ID
;       Y   Number of physical banks (>= 64) or
;           number of slots (< 64) with 64 banks each
;     lda #$fd        ; FD = cart mem
;     sta RAMTAG

    jsr tab
    jsr printregs
    jsr space
    jsr printmem
    jsr checkregs1

    jsr crlf


    ;------------------------------------------------------
    ; EAPISetBank           = EAPI_RAM_CODE + (2*3)
    lda #$08 ; bank
    ldx #$34 ; dummy
    ldy #$56 ; dummy

    jsr printregs
    jsr space
    jsr printmem
    jsr EAPISetBank
    jsr tab
    jsr printregs
    jsr space
    jsr printmem
    jsr checkregs1

    jsr crlf

    ;------------------------------------------------------
    ; EAPIEraseSector       = EAPI_RAM_CODE + (1*3)

;     lda #$08    ; bank 8
;     sta $de00
;     lda #$87    ; 16k config, LED on
;     sta $de02

    lda #$08 ; bank
    ldx #$34 ; dummy
    ldy #$80 ; addrhi

    jsr printregs
    jsr space
    jsr printmem
    jsr EAPIEraseSector
;       C   set: Error
;           clear: Okay
;       Z,N <- bank
    jsr tab
    jsr printregs
    jsr space
    jsr printmem
    jsr checkregs1

    jsr crlf

;     lda #$18    ; bank 8
;     sta $de00
;     lda #$87    ; 16k config, LED on
;     sta $de02

    ;------------------------------------------------------
    ; EAPISetBank           = EAPI_RAM_CODE + (2*3)
    lda #$18 ; bank
    ldx #$34 ; dummy
    ldy #$56 ; dummy

    jsr printregs
    jsr space
    jsr printmem
    jsr EAPISetBank
    jsr tab
    jsr printregs
    jsr space
    jsr printmem
    jsr checkregs1

    jsr crlf
    lda #$18 ; bank
    ldx #$34 ; dummy
    ldy #$a0 ; addrhi

    jsr printregs
    jsr space
    jsr printmem
    jsr EAPIEraseSector
    jsr tab
    jsr printregs
    jsr space
    jsr printmem
    jsr checkregs1

    jsr crlf

    ;------------------------------------------------------
    ; EAPISetBank           = EAPI_RAM_CODE + (2*3)
    lda #$08 ; bank
    ldx #$34 ; dummy
    ldy #$56 ; dummy

    jsr printregs
    jsr space
    jsr printmem
    jsr EAPISetBank
    jsr tab
    jsr printregs
    jsr space
    jsr printmem
    jsr checkregs1

    jsr crlf

    ;------------------------------------------------------
    ; EAPIWriteFlash        = EAPI_RAM_CODE + (0*3)
    lda #$18 ; value
    ldx #$f0 ; addrlo
    ldy #$9f ; addrhi

    jsr printregs
    jsr space
    jsr printmem
    jsr EAPIWriteFlash
;       C   set: Error
;           clear: Okay
;       Z,N <- value
    jsr tab
    jsr printregs
    jsr space
    jsr printmem
    jsr checkregs1

    jsr crlf

    ;------------------------------------------------------
    ; EAPIGetBank           = EAPI_RAM_CODE + (3*3)
    lda #$12 ; dummy
    ldx #$34 ; dummy
    ldy #$56 ; dummy

    jsr printregs
    jsr space
    jsr printmem
    jsr EAPISetBank
;       A  bank
;       Z,N <- bank
    jsr tab
    jsr printregs
    jsr space
    jsr printmem
    jsr checkregs1

    jsr crlf

    ;------------------------------------------------------
    ; EAPISetPtr            = EAPI_RAM_CODE + (4*3)
    lda #$d0 ; bank mode    $D0: 00:0:1FFF=>00:1:0000, 00:1:1FFF=>01:0:1FFF (lhlh...)
    ldx #$f0 ; addrlo
    ldy #$9f ; addrhi

    jsr printregs
    jsr space
    jsr printmem
    jsr EAPISetPtr
    jsr tab
    jsr printregs
    jsr space
    jsr printmem
    jsr checkregs1

    jsr crlf

    ;------------------------------------------------------
    ; EAPISetBank           = EAPI_RAM_CODE + (2*3)
    lda #$08 ; bank
    ldx #$34 ; dummy
    ldy #$56 ; dummy

    jsr printregs
    jsr space
    jsr printmem
    jsr EAPISetBank
    jsr tab
    jsr printregs
    jsr space
    jsr printmem
    jsr checkregs1

    jsr crlf

    ;------------------------------------------------------
    ; EAPIWriteFlashInc     = EAPI_RAM_CODE + (7*3)
    lda #$18 ; value
    ldx #$34 ; dummy
    ldy #$56 ; dummy
    clc
    jsr printregs
    jsr space
    jsr printmem
    jsr EAPIWriteFlashInc
;       C   set: Error
;           clear: Okay
;       Z,N <- value
    jsr tab
    jsr printregs
    jsr space
    jsr printmem
    jsr checkregs1

    jsr crlf;       A   value

    ;------------------------------------------------------
    ; EAPISetLen            = EAPI_RAM_CODE + (5*3)
    ldx #$01 ;
    ldy #$1f ;
    lda #$23 ; length, 24 bits (X = low, Y = med, A = high)
    jsr printregs
    jsr space
    jsr printmem
    jsr EAPISetLen
    jsr tab
    jsr printregs
    jsr space
    jsr printmem
    jsr checkregs1

    jsr crlf
    ;------------------------------------------------------
    ; EAPIReadFlashInc      = EAPI_RAM_CODE + (6*3)
    lda #$12 ; dummy
    ldx #$34 ; dummy
    ldy #$56 ; dummy
    jsr printregs
    jsr space
    jsr printmem
    jsr EAPIReadFlashInc
;       C   set if EOF
;       Z,N <- value
    jsr tab
    jsr printregs
    jsr space
    jsr printmem
    jsr checkregs1

    jsr crlf;       A   value
    ;------------------------------------------------------
    ; EAPISetSlot           = EAPI_RAM_CODE + (8*3)

    ;------------------------------------------------------
    ; EAPIGetSlot           = EAPI_RAM_CODE + (9*3)

    jsr checkref
    jmp *

;-----------------------------------------------------------------------------

linepos1 = $10
linepos2 = $12
colptr = $14

checkregs1:

    lda #19
    sta linepos1
    clc
    adc #20
    sta linepos2

    lda scrptr
    sta colptr
    lda scrptr+1
    clc
    adc #$d4
    sta colptr+1

-
    ldx #5 ; green
    ldy linepos1
    lda (scrptr),y
    ldy linepos2
    cmp (scrptr),y
    beq +
    ldx #7 ; yellow
+
    txa
    ldy linepos1
    sta (colptr),y

    dec linepos2
    dec linepos1
    bpl -
    rts

checkref:

    ldy #5 ; green
    sty result

    ldx #0
-
    lda refdata,x
    beq ++
    ldy #5  ; green
    cmp $0400,x
    beq +
    ldy #10 ; red
    sty result
+
    tya
    sta $d800,x
++
    inx
    bne -

    ldx #0
-
    lda refdata+$100,x
    beq ++
    ldy #5  ; green
    cmp $0500,x
    beq +
    ldy #10 ; red
    sty result
+
    tya
    sta $d900,x
++
    inx
    bne -

    ldx #0
-
    lda refdata+$200,x
    beq ++
    ldy #5  ; green
    cmp $0600,x
    beq +
    ldy #10 ; red
    sty result
+
    tya
    sta $da00,x
++
    inx
    bne -

    ldy #0 ; ok
result=*+1
    lda #5
    sta $d020
    cmp #5
    beq +
    ldy #$ff    ; fail
+
    sty $d7ff

    rts

space:
    php
    inc linepos
    plp
    rts

tab:
    php
    pha
    lda #20
    sta linepos
    pla
    plp
    rts

printmem:
    php
    pha
    lda $01
    jsr putbyte
    jsr space
    lda ROMLTAG
    jsr putbyte
    lda ROMHTAG
    jsr putbyte
    lda RAMTAG
    jsr putbyte
    pla
    plp
    rts

printregs:
    sta abuff
    php
    pla
    sta sbuff
    stx xbuff
    sty ybuff

abuff=*+1
    lda #0
    jsr putbyte
xbuff=*+1
    lda #0
    jsr putbyte
ybuff=*+1
    lda #0
    jsr putbyte
sbuff=*+1
    lda #0
    jsr putbyte

    lda sbuff
    pha
    lda abuff
    ldx xbuff
    ldy ybuff
    plp
    rts

clrscr:
    ldx #0
-
    lda #$20
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    lda #$01
    sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $db00,x
    inx
    bne -

    lda #>$0400
    sta scrptr+1
    lda #<$0400
    sta scrptr
    lda #0
    sta linepos

    rts

crlf:
    lda #0
    sta linepos
    lda scrptr
    clc
    adc #40
    sta scrptr
    lda scrptr+1
    adc #0
    sta scrptr+1

    rts


putbyte:
    sta byteval
    pha
    tya
    pha
    txa
    pha

byteval=*+1
    lda #0
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tax
    lda hextab,x
    ldy linepos
    sta (scrptr),y
    inc linepos

    lda byteval
    and #$0f
    tax
    lda hextab,x
    ldy linepos
    sta (scrptr),y
    inc linepos

    pla
    tax
    pla
    tay
    pla
    rts

hextab:
    !scr "0123456789abcdef"

refdata:
!scr "@@@@@@@@@@@@@@@@@@@ @@@@4034 37 2020fd  "
!scr "@@@@@@@@@@@@@@@@@@@ 08345634 37 2828fd  "
!scr "@@@@@@@@@@@@@@@@@@@ 08348034 37 ff28fd  "
!scr "@@@@@@@@@@@@@@@@@@@ 18345634 37 3838fd  "
!scr "@@@@@@@@@@@@@@@@@@@ 1834a034 37 38fffd  "
!scr "@@@@@@@@@@@@@@@@@@@ 08345634 37 ff28fd  "
!scr "@@@@@@@@@@@@@@@@@@@ 18f09f34 37 1828fd  "
!scr "@@@@@@@@@@@@@@@@@@@ 12345634 37 3232fd  "
!scr "@@@@@@@@@@@@@@@@@@@ d0f09fb4 37 3232fd  "
!scr "@@@@@@@@@@@@@@@@@@@ 08345634 37 1828fd  "
!scr "@@@@@@@@@@@@@@@@@@@ 18345634 37 1828fd  "
!scr "@@@@@@@@@@@@@@@@@@@ 23011f34 37 1828fd  "
!scr "@@@@@@@@@@@@@@@@@@@ ff3456b4 37 1828fd  "
