

SHOWSPRITES = 0     ; set to 1 to show the sprites and move sprite 0

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
-       lda #$f0
        sta $400+range(4)*256,x
        inx
        bne -

        .if SHOWSPRITES == 1
-       lda #$ff
        sta $0300,x
        lda #$0300 / 64
        sta $07f8
        inx
        bne -
        .endif

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
        sta $d01d   ; x-expand
        .if SHOWSPRITES == 1
        lda #$fe
        .endif
        sta $d01b   ; prio
        lda #0
        sta $d010   ; x-msb
        sta $d01c   ; muco

        ldx #7
-
        .if SHOWSPRITES == 1
        txa
        ora #$08
        .endif
        sta $d027,x ; color
        dex
        bpl -

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

;------------------------------------------------------------------------------
; main loop
;------------------------------------------------------------------------------

loop
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
.if SWAP == 0
reu2    .byte %10010001
.else
reu2    .byte %10010010
.endif
        .word $d020
        .long 0
.if SWAP == 0
        .word 63*188+1
.else
        .word 63*94+1
.endif
        .byte 0
        .byte $80
        .send data

        ldx #9
-       lda reu2,x
        sta $df01,x
        dex
        bpl -

        .if SHOWSPRITES == 1
        lda $d000
        clc
        adc #1
        sta $d000
        bcc +
        lda $d010
        eor #$01
        sta $d010
+
        .endif

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
        ; transfer pattern to REU
        ldx #9
-       lda reu1,x
        sta $df01,x
        dex
        bpl -
.endif
        jmp loop

framecount: .byte 5

;-------------------------------------------------------------------------------

        *=$2000
        .binary "a.hpi",2

        .align 256  ; to make sure data section start at next page

        .section bss
tmp     .fill 63*201
        .send bss

        .send code
