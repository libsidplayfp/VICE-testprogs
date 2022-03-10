
        *= $0801
        .dsection code
        .section code
        .word +,2016
        .null $9e,^start
+       .word 0
        .send
;------------------------------------------------------------------------------
        .dsection data
        .dsection bss

start   .section code
        sei

        ; setup userport
        lda #$ff
        sta $dd01   ; all pins inactive
        sta $dd03   ; all output

        ; create pattern
        ldy #201
lp
        ldx #63
-       dex
        txa
off     sta tmp,x
        bne -
        stx $3fff

        lda off+1
        clc
        adc #63
        sta off+1
        bcc +
        inc off+2
+       dey
        bne lp

        ; transfer pattern to REU
        .section data
reu1    .byte %10010000
        .word tmp
        .long 0
        .word 63*201
        .byte 0
        .byte 0
        .send data

        ldx #9
-       lda reu1,x
        sta $df01,x
        dex
        bpl -

        ; setup vram
        ldx #0
        lda #$20
-       sta $400+range(4)*256,x
        inx
        bne -

        ; setup sprites
        lda #$80
        sta $d015   ; enable
        sta $d017   ; y-expand
        sta $d01d   ; x-expand
        lda #0
        sta $d010   ; x-msb

        lda #0
        sta $d000+(7*2) ; x-pos
        lda #$38
        sta $d001+(7*2) ; y-pos

;------------------------------------------------------------------------------
; main loop
;------------------------------------------------------------------------------

loop    lda #$13
        sta $d011

        ; wait for start of frame
        lda $d011
        bpl *-3
        lda $d011
        bmi *-3

        ; pulse userport pins
        ldx #$00
        lda #$ff
        stx $dc01   ; lo
        sta $dc01   ; hi

        ; stabilize
        .page
        ldy #48
-       lda $d012
        cmp $d012
        bne e
e       ldx #8
s       dex
        bne s
        cmp (0,x)
        dey
        bne -
        .endp
        pha
        pla
        pha
        pla
        nop
        ; the white line
        iny
        sty $d020
        ldy #7
-       dey
        bne -
        sty $d020

        ldx #28+9
-       dex
        bne -
        bit $ea

        lda #$1b
        sta $d011

        ldx #49
-       dex
        bne -
        nop
        
        ldy #6
lp2
        ; transfer the pattern from REU to $d020
        .section data
.if SWAP == 0
reu2    .byte %10010001
.else
reu2    .byte %10010010
.endif
        .word $d020
        .long 0
        .word TRANSFERBYTES
        .byte 0
        .byte 128
        .send data

        ldx #9
-       lda reu2,x
        sta $df01,x
        dex
        bpl -

.if SWAP == 0
        ldx #52
-       dex
        bne -

        bit $ea
.else
        ldx #51
-       dex
        bne -
.if TRANSFERBYTES == 6
        bit $ea
        nop
.else
        nop
        nop
        nop
.endif
.endif
        dey
        bne lp2

        dec framecount
        bne +
        lda #0
        sta $d7ff
+

.if SWAP == 1
        ldx #9
-       lda reu1,x
        sta $df01,x
        dex
        bpl -
.endif
        jmp loop


framecount: .byte 5

        .align 256  ; to make sure data section start at next page

        .section bss
tmp     .fill 63*201
        .send bss

        .send code
