
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

        ; create pattern
        ldx #63
-       dex
        txa
        sta tmp,x
        bne -
        stx $3fff

        ; transfer pattern to REU
        .section data
reu1    .byte %10010000
        .word tmp
off     .long 0
        .word 63
        .byte 0
        .byte 0
        .send data

        ldy #201
lp      ldx #10
-       lda reu1-1,x
        sta $df00,x
        dex
        bne -

        lda off
        clc
        adc #63
        sta off
        bcc +
        inc off+1
+       dey
        bne lp

        ; setup vram
        ldx #0
        lda #$f0
-       sta $400+range(4)*256,x
        inx
        bne -


        ; main loop

loop    lda #$13
        sta $d011
        ; wait for start of frame
        lda $d011
        bpl *-3
        lda $d011
        bmi *-3
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

        ldx #51
-       dex
        bne -
        nop
        
        ldy #25
lp2
        ; transfer the pattern from REU to $d020
        .section data
reu2    .byte %10010001
        .word $d020
        .long 0
        .word 10+9
        .byte 0
        .byte 128
        .send data

        ldx #10
-       lda reu2-1,x
        sta $df00,x
        dex
        bne -

        ldx #59
-       dex
        bne -

        dey
        bne lp2
        
        dec framecount
        bne +
        lda #0
        sta $d7ff
+
        jmp loop

framecount: .byte 5

        .section bss
tmp     .fill 63
        .send bss

        .send code
