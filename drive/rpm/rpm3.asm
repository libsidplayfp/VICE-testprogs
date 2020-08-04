        !convtab pet
        !cpu 6510

        !src "mflpt.inc"

DEBUG = 0
TESTTRACK = 36

;-------------------------------------------------------------------------------

rpmline = $0400 + (0 * 40)

drivecode_start = $0300
drivecode_exec = drvstart ; skip $10 bytes table

factmp = $340

        !src "../framework.asm"

start:
        jsr clrscr

        inc $d021

        lda #<drivecode
        ldy #>drivecode
        ldx #((drivecode_end - drivecode) + $1f) / $20 ; upload x * $20 bytes to 1541
        jsr upload_code

        lda #<drivecode_exec
        ldy #>drivecode_exec
        jsr start_code

        dec $d021

        lda #$01
        sta $286
        lda #$93
        jsr $ffd2

        sei
        jsr rcv_init
lp:
        sei
        jsr rcv_wait

        ; get time stamp

        jsr rcv_1byte
        sta $c000     ; lo
        jsr rcv_1byte
        sta $c028     ; hi

        lda #19
        jsr $ffd2
        lda #$0d
        jsr $ffd2
        lda #$0d
        jsr $ffd2

!if DEBUG = 1 {
        ; print timer lo/hi
        ldy $c000     ; lo
        lda #0
        jsr $b395     ; to FAC

        jsr $aabc     ; print FAC

        lda #$0d
        jsr $ffd2

        ldy $c028     ; hi
        lda #0
        jsr $b395     ; to FAC

        jsr $aabc     ; print FAC

        lda #$0d
        jsr $ffd2
}
        ; calculate total time for one revolution

        lda $c028     ; lo
        ldy $c000
        jsr $b395     ; to FAC
        lda $90
        eor #$ff
        sta $90
        jsr $bc0c       ; ARG = FAC

        lda #<c2000000
        ldy #>c2000000
        jsr $bba2       ; in FAC

        lda $61
        jsr $b853       ; FAC = FAC - ARG

        ; need to preserve FAC
        ldx #5
-
        lda $61,x
        sta factmp,x
        dex
        bpl -

        jsr $aabc       ; print FAC

        ; restore FAC
        ldx #5
-
        lda factmp,x
        sta $61,x
        dex
        bpl -

        lda #$20
        ldx #10
-       sta rpmline+4,x
        dex
        bpl -

        ; calculate RPM

        ; expected ideal:
        ; 300 rounds per minute 
        ; = 5 rounds per second
        ; = 200 milliseconds per round
        ; at 1MHz (0,001 milliseconds per clock)
        ; = 200000 cycles per round

        ; to calculate RPM from cycles per round:
        ; RPM = (200000 * 300) / cycles

        lda #<c6000000
        ldy #>c6000000
        jsr $ba8c       ; in ARG

        lda $61
        jsr $bb12       ; FAC = ARG / FAC
 
        lda #19
        jsr $ffd2

        jsr $aabc       ; print FAC

        ; give the test two loops to settle
framecount = * + 1
        lda #2
        beq +
        dec framecount
        jmp lp
+
        ; compare, we consider 299,300,301 as acceptable
        ldy #10

        lda rpmline+1
        cmp #$32    ; 2
        bne cmp300
        lda rpmline+2
        cmp #$39    ; 9
        bne cmp300
        lda rpmline+3
        cmp #$39    ; 9
        bne cmp300
        ; is 299
        ldy #5
cmp300:
        lda rpmline+1
        cmp #$33    ; 3
        bne cmp301
        lda rpmline+2
        cmp #$30    ; 0
        bne cmp301
        lda rpmline+3
        cmp #$30    ; 0
        bne cmp301
        ; is 301
        ldy #5
cmp301:
        lda rpmline+1
        cmp #$33    ; 3
        bne cmpfail
        lda rpmline+2
        cmp #$30    ; 0
        bne cmpfail
        lda rpmline+3
        cmp #$31    ; 1
        bne cmpfail
        ; is 301
        ldy #5
cmpfail:

        sty rpmline+$d401
        sty rpmline+$d402 
        sty rpmline+$d403 
        sty $d020

        lda #$ff
        cpy #5
        bne +
        lda #0
+
        sta $d7ff

        jsr wait2frame

        jmp lp

c6000000:
        +mflpt (-200000 * 300)
c2000000:
        +mflpt ((65536 * 3) - 4)

wait2frame:
        jsr waitframe
waitframe:
-       lda $d011
        bpl -
-       lda $d011
        bmi -
        rts

;-------------------------------------------------------------------------------

drivecode:
!pseudopc drivecode_start {
.data1 = $0016

        !src "../framework-drive.asm"

drvstart
        sei
        lda $180b
        and #%11011111  ; start timer B
        sta $180b
        jsr snd_init

drvlp:
        jsr measure

sendresult:
        sei
        jsr snd_start

        lda ltime
        jsr snd_1byte
        lda htime
        jsr snd_1byte

        jmp drvlp

measure:

        lda #TESTTRACK  ; track nr
        sta $08
        ldx #$00        ; sector nr
        stx $09
        lda #$e0        ; seek and start program at $0400
        sta $01
        cli
        lda $01
        bmi *-2
        rts

htime:  !byte 0
ltime:  !byte 0

        ;* = $0400
        !align $ff, 0, 0

measureirq:

        sei

trackwritten = * + 1
        lda #0
        bne +
        jsr write_reference_track
+
        lda #1
        sta trackwritten

        jsr test_rpm
        sta ltime
        stx htime

        jmp sendresult

;         cli
; 
;         lda #0
;         sta $01
; 
;         jmp $F99C       ; to job loop


write_reference_track:
        ; set head to write mode
        lda     #$ce
        sta     $1c0c           ; peripheral control register

        ; write a full track $ff
        lda     #$ff
        sta     $1c03           ; data direction register a
        sta     $1c01           ; data port a (data to/from head)

        ldy     #$30
        ldx     #$28
-
        ; wait for byte ready
        bvc     *
        clv

        dey
        bne     -
        dex
        bne     -

        ; write $5a5a5a5a5a
        lda     #$5a
        sta     $1c01           ; data port a (data to/from head)

        ldy     #5
-
        ; wait for byte ready
        bvc     *
        clv

        dey
        bne     -
        ; head to read mode
        lda     #$ee
        sta     $1c0c           ; peripheral control register
        rts

test_rpm:
        ; head to read mode
        lda     #$ee
        sta     $1c0c           ; peripheral control register

        ; port to input
        ldy     #0
        sty     $1c03           ; data direction register a

        ; init timer lowbyte latch
        ldy     #$ff
        sty     $1808

        ldx     #5
        ; wait for sync
-
        bit     $1c00
        bmi     -

        ; read one byte
        clv
        ; wait for byte ready
        bvc     *

        ; init timer hibyte, also inits lobyte from latch
;         ldy     #$ff
;         sty     $1808
        sty     $1809

        ; read 5 more bytes
-
        clv
        ; wait for byte ready
        bvc     *

        dex
        bne     -

        ; get timer value
        lda $1808       ; 4 lo
        ldx $1809       ; 4 hi
        cmp #4
        bcs +
        inx             ; compensate hi-byte decrease
+
        rts
} 
drivecode_end:
