
NUMLINES = 25

TESTTIMING = 0

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

        lda #$34
        sta $01

        ; put a marker byte into the RAM under the I/O register we are going to
        ; transfer
        lda #$42
        sta $dc04

        ; put a marker byte into the idle byte
        lda #$f1
        sta $3fff

        lda #$36
        sta $01

        ; setup userport
        lda #$ff
        sta $dd01   ; all pins inactive
        sta $dd03   ; all output

        lda #$7f
        sta $dc0d
        sta $dd0d
        lda $dc0d
        lda $dd0d

        lda #$01
        ldx #0
        stx $d020
        stx $d021
-
        sta $d800,x
        sta $d900,x
        sta $da00,x
        sta $db00,x
        inx
        bne -

.if TESTTIMING == 1
        ; create pattern
        ldx #0
-       dex
        txa
        sta buffer,x
        sta buffer+$100,x
        sta result,x
        sta result+$100,x
        bne -
.else
        ; clear buffer
        ldx #0
        txa
-
        sta buffer,x
        sta buffer+$100,x
        sta result,x
        sta result+$100,x
        inx
        bne -
.endif

        ; transfer pattern to REU (clear memory)
        .section data
reu0:   .byte %10010000
        .word buffer
        .long 0
        .word $200
        .byte 0
        .byte 0
        .send data

        ldx #9
-       lda reu0,x
        sta $df01,x
        dex
        bpl -

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

        jmp loop

        .align 256
;------------------------------------------------------------------------------
; main loop
;------------------------------------------------------------------------------

loop
        lda #$13
        sta $d011

        ldx #0
        stx reu2a
        stx reu2a+1

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

        lda #$13 | 8
        sta $d011

        ldx #49-6
-       dex
        bne -
        nop
.if TRANSFERBYTES == 6
        bit $eaea
        bit $ea
.else
        bit $eaea
        bit $eaea
.endif

        ; setup CIA timer
        ldx #0
        stx $dc0e   ; stop timer
        dex
        stx $dc04   ; timer=$ffff
        stx $dc05
        lda #$11
        sta $dc0e   ; start timer

        ; do the transfer we want to measure

        ldy #NUMLINES
lp2
.if TESTTIMING == 0
        ; transfer pattern to REU
        .section data
.if SWAP == 0
reu2    .byte %10010000 ;start c64->reu
.else
reu2    .byte %10010010
.endif
        .word $dc04     ;c64 addr
reu2a   .long 0         ;reu addr
        .word TRANSFERBYTES    ;len
        .byte 0         ;irq mask
        .byte $80       ;addr control (fixed c64 addr)
        .send data
.else
        ; transfer the pattern from REU to $d020
        .section data
.if SWAP == 0
reu2    .byte %10010001
.else
reu2    .byte %10010010
.endif
        .word $d020
reu2a   .long 0
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

.if TRANSFERBYTES == 6
        ldx #52-5
-       dex
        bne -
        bit $ea
        nop
.elsif TRANSFERBYTES == 5
        ldx #52-5
-       dex
        bne -
        bit $eaea
        bit $eaea
        nop
        bit $ea
        bit $ea
        bit $ea
.else
        ldx #52-5
-       dex
        bne -
        bit $ea
        bit $ea
.endif

        lda reu2a
        clc
        adc #TRANSFERBYTES
        sta reu2a
        lda reu2a+1
        adc #0
        sta reu2a+1
        
        dey
        bne lp2
        
        ldx $d012
        inx
        inc $d020
-       cpx $d012
        bpl -
        dec $d020

;        jmp loop

        ;----------------------------------------------------
        ; wait for start of frame
        lda $d011
        bpl *-3
        lda $d011
        bmi *-3

        ; transfer the pattern from REU to result buffer
        .section data
reu     .byte %10010001
        .word result
        .long 0
        .word TRANSFERBYTES * NUMLINES
        .byte 0
        .byte 0
        .send data

        ldx #9
-       lda reu,x
        sta $df01,x
        dex
        bpl -

        ldx #0
-
        lda result,x
        sta $0400,x
        lda result+$100,x
        sta $0500,x
;         lda result+$200,x
;         sta $0600,x
;         lda result+$300,x
;         sta $0700,x
        inx
        bne -

        lda #0
        sta failed
        
        lda #>reference
        sta refad+2
        lda #>result
        sta bufad+2

        ldy #$02 ; pages to compare
tlp2:
        ldx #0
tlp1:
refad:  lda reference,x
bufad:  cmp result,x
        beq +
        lda #1
        sta failed
+
        inx 
        bne tlp1
        inc refad+2
        inc bufad+2

        dey 
        bne tlp2

        ldx #0
        ldy #13
failed=*+1
        lda #0
        beq +
        ldx #$ff
        ldy #10
+
        stx $d7ff
        sty $d020

        ; after a swap, we need to reinit the REU memory
.if SWAP == 1
        ldx #9
-       lda reu0,x
        sta $df01,x
        dex
        bpl -
.endif

        jmp loop
        jmp *

;------------------------------------------------------------------------------


        * = $0b00   ; - $0cff
reference:
.if IOGLITCH == 0
    .if SWAP == 0
            .if TRANSFERBYTES == 12
                .binary "ref/g-ref.bin"
            .else
                .binary "ref/g2-ref.bin"
            .endif
    .else
            .if TRANSFERBYTES == 6
                .binary "ref/g3-m2.bin"    ; gpz breadbox
            .else
                .binary "ref/g4-m2.bin"    ; gpz breadbox
            .endif
    .endif
.else
    .if SWAP == 0
            .if TRANSFERBYTES == 12
                .binary "ref/g-ref.bin"
            .else
                .binary "ref/g2-ref.bin"
            .endif
    .else
            .if TRANSFERBYTES == 6
                .binary "ref/g3-ref.bin"
            .else
                .binary "ref/g4-ref.bin"
            .endif
    .endif
.endif
        .align 256  ; to make sure data section start at next page

        * = $1000   ; - $10ff
result:

        * = $2000   ; - $20ff
buffer:

        .send code
