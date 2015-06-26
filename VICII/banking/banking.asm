        *=$0801
        ; BASIC stub: "1 SYS 2061"
        !byte $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00
start:  jmp main

baseline = $32

main:
        jsr preparescreens

        sei
        lda #$1b
        sta $d011
        lda #$c8
        sta $d016
        lda #$15        ; screen: $0400 char: $1000
        sta $d018

mainlp:
        lda #0
        sta $d020
        sta $d021

-       lda $d011
        bmi -
        lda $d012
        cmp #8
        bne -
        inc $d020

        lda #$3f        ; bits 0-1 output
        sta $dd02

        lda #3
        sta $dd00

-       lda $d012
        cmp #baseline + (2 * 8)
        bne -
        inc $d020

        lda #2
        sta $dd00

-       lda $d012
        cmp #baseline + (4 * 8)
        bne -
        inc $d020

        lda #1
        sta $dd00

-       lda $d012
        cmp #baseline + (6 * 8)
        bne -
        inc $d020

        lda #0
        sta $dd00

-       lda $d012
        cmp #baseline + (8 * 8)
        bne -
        inc $d020
        dec $d021

        ;------------------------------

        lda #0
        sta $dd00

        lda #$3c | $00
        sta $dd02

-       lda $d012
        cmp #baseline + (10 * 8)
        bne -
        inc $d020

        lda #$3c | $01
        sta $dd02

-       lda $d012
        cmp #baseline + (12 * 8)
        bne -
        inc $d020

        lda #$3c | $02
        sta $dd02

-       lda $d012
        cmp #baseline + (14 * 8)
        bne -
        inc $d020

        lda #$3c | $03
        sta $dd02

-       lda $d012
        cmp #baseline + (16 * 8)
        bne -
        inc $d020
        inc $d021

        ;------------------------------

        lda #3
        sta $dd00

        lda #$3c | $03
        sta $dd02

-       lda $d012
        cmp #baseline + (18 * 8)
        bne -
        inc $d020

        lda #$3c | $02
        sta $dd02

-       lda $d012
        cmp #baseline + (20 * 8)
        bne -
        inc $d020

        lda #$3c | $01
        sta $dd02

-       lda $d012
        cmp #baseline + (22 * 8)
        bne -
        inc $d020

        lda #$3c | $00
        sta $dd02

-       lda $d012
        cmp #baseline + (24 * 8)
        bne -
        inc $d020

        jmp mainlp

screen0 = $0400
screen1 = $4400
screen2 = $8400
screen3 = $c400

charset1 = $5000
charset3 = $d000

ptr = $02
tmp = $04

preparescreens:
        ldy #>screen0
        lda #<screen0
        ldx #3
        jsr preparescr
        ldy #>screen1
        lda #<screen1
        ldx #2
        jsr preparescr
        ldy #>screen2
        lda #<screen2
        ldx #1
        jsr preparescr
        ldy #>screen3
        lda #<screen3
        ldx #0
        jsr preparescr

        jsr preparechar

        lda #12
        ldx #0
-
        sta $d800,x
        sta $d900,x
        sta $da00,x
        sta $db00,x
        inx
        bne -

        rts

preparescr:
        sta ptr+0
        sty ptr+1
        stx tmp

        ldx #0
--
        ldy #0
        lda tmp
-
        sta (ptr),y
        iny
        cpy #40
        bne -

        clc
        lda ptr
        adc #40
        sta ptr
        lda ptr+1
        adc #0
        sta ptr+1

        inx
        cpx #25
        bne --

        rts

preparechar:
        sei
        lda #$33
        sta $01

        ldx #0
-
        lda $d000+($30*8),x
        sta charset1,x
        inx
        bne -

        lda #$33
        sta $01

        ldx #0
-
        lda charset1,x
        sta charset3,x
        inx
        bne -

        lda #$35
        sta $01
        rts
