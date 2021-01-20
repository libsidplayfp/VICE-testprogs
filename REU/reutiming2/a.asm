
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

        lda #3
        sta $dd00
        lda #8
        sta $d016
        lda #29
        sta $d018
        lda #59
        sta $d011

        .if SPRITES == 1
        ; setup sprites
        lda #255
        sta $d015   ; enable
        sta $d017   ; y-expand
        sta $d01b   ; prio
        sta $d01d   ; x-expand
        lda #0
        sta $d010   ; x-msb
        sta $d01c   ; muco

        ldx #8
-       dex
        sta $d027,x ; color
        bne -

        ldx #16
-       dex
        txa
        asl a
        asl a
        ora #128
        sta $d000,x ; y-pos = 132 140 148 156 164 172 180 188
        lda #0
        dex
        sta $d000,x ; x-pos all 0
        bne -
        .endif

        ; main loop

loop
        ; wait for start of frame
        lda $d011
        bpl *-3
        lda $d011
        bmi *-3
        ; stabilize
        .page
        ldy #40
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
        nop
        nop
        nop

        ; transfer the pattern from REU to $d020
        .section data
reu2    .byte %10010001
        .word $d020
        .long 0
        .word 63*188+1
        .byte 0
        .byte 128
        .send data

        ldx #10
-       lda reu2-1,x
        sta $df00,x
        dex
        bne -

        dec framecount
        bne +
        lda #0
        sta $d7ff
+
        jmp loop

framecount: .byte 5

        *=$2000
        .binary "a.hpi",2

        .section bss
tmp     .fill 63
        .send bss

        .send code
