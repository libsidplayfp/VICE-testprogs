
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
+
        dey
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

        ldx #51
-       dex
        bne -
        nop

        ldy #25
lp2
        ; transfer the pattern from REU to $d020
.if SWAP == 0
        .section data
reu2    .byte %10010001
        .word $d020
        .long 0
        .word TRANSFERBYTES
        .byte 0
        .byte $80
        .send data
.else
        .section data
reu2    .byte %10010010
        .word $d020
        .long 0
        .word TRANSFERBYTES
        .byte 0
        .byte $80
        .send data
.endif
        ldx #9
-       lda reu2,x
        sta $df01,x
        dex
        bpl -

.if SWAP == 0
        ldx #59
-       dex
        bne -
.else
        ldx #57
-       dex
        bne -
.if TRANSFERBYTES == 10
        bit $eaea
        nop
.else
        bit $eaea
        bit $eaea
.endif
.endif
        dey
        bne lp2

        dec framecount
        bne +
-       lda $d011
        bpl -
-       lda $d011
        bmi -
        lda #0
        sta $d7ff
        ;------------ chameleon hack start
        ; disable VICII framebuffer writes, so we have time to download the
        ; framebuffer over USB before it changes again
        lda #42
        sta $d0fe       ; enable config mode

        lda $d0f2       ; get vic-ii config
        and #%10111111  ; disable framebuffer writes
        sta $d0f2       ; set vic-ii config

        sta $d0ff       ; leave config mode
        ;------------ chameleon hack end
+
.if SWAP == 1
        lda #0
        sta $d020
        sta $d021
        ; transfer pattern to REU
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
