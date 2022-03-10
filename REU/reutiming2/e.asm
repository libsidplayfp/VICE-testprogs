TESTTIMING = 0

SHOWSPRITES = 1     ; set to 1 to show the sprites

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

        lda #$7f
        sta $dc0d
        sta $dd0d
        lda $dc0d
        lda $dd0d

        ldx #0
        stx $d020
        stx $d021
-
        lda #$01
        sta $d800,x
        sta $d900,x
        sta $da00,x
        sta $db00,x
        lda #$20
        sta $0400,x
        sta $0500,x
        sta $0600,x
        sta $0700,x
        inx
        bne -

        jsr initbuffer

        .if SHOWSPRITES == 1
        ldx #$3f
-       lda #$ff
        sta $03c0,x
        dex
        bpl -
        ldx #7
-
        lda #$03c0 / 64
        sta $07f8,x
        dex
        bpl -
        .endif

        lda #3
        sta $dd00
        lda #8
        sta $d016
        lda #$15
        sta $d018
        lda #19
        sta $d011

        .if SPRITES == 1
        ; setup sprites
        lda #255
        sta $d015   ; enable
        sta $d017   ; y-expand
        sta $d01d   ; x-expand
;         .if SHOWSPRITES == 1
;         lda #$fe
;         .endif
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
        .if REVERSEORDER == 1
        eor #$0e
        .endif
        asl a
        asl a
        ora #128
        sta $d000,x ; y-pos = 132 140 148 156 164 172 180 188
        lda #0
        dex
        sta $d000,x ; x-pos all 0
        bne -
        .endif

        ldx #5
-
        lda $d011
        bpl *-3
        lda $d011
        bmi *-3
        dex
        bne -

        jmp loop
        .align 256
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
        ldy #40-1
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

        ; we want the timing match a.asm
        ldx #5
        .page
-       dex
        bne -
        .endp
        bit $ea

        ; setup CIA timer
        inc $d020
        ldx #0
        stx $dc0e   ; stop timer
        dex
        stx $dc04
        stx $dc05   ; timer = $ffff
        lda #$11
        sta $dc0e   ; start timer
        dec $d020

        .section data
.if TESTTIMING == 0
        ; transfer pattern to REU
.if SWAP == 0
reu1    .byte %10010000 ;start c64->reu
.else
reu1    .byte %10010010 ;start c64<->reu
.endif
        .word $dc04     ;c64 addr
        .long 0         ;reu addr
.if SWAP == 0
        .word 63*200    ;len
.else
        .word 63*100    ;len
.endif
        .byte 0         ;irq mask
        .byte $80       ;addr control (fixed c64 addr)

.else

.if SWAP == 0
reu1    .byte %10010001  ;start reu->c64
.else
reu1    .byte %10010010  ;start c64<->reu
.endif
        .word $d020
        .long 0
.if SWAP == 0
        .word 63*200
.else
        .word 63*100
.endif
        .byte 0
        .byte $80
.endif
        .send data

        ; we are now in line 40, cycle 35

        ldx #9
-       lda reu1,x
        sta $df01,x
        dex
        bpl -

        lda $d012
        inc $d020
-       cmp $d012
        beq -
        
resultcolor=*+1
        lda #0
        sta $d020

        ;jmp loop

        ;----------------------------------------------------
        ; wait for start of frame
        lda $d011
        bpl *-3
        lda $d011
        bmi *-3
testagain:
        ; transfer the pattern from REU to result buffer
        .section data
reu2    .byte %10010001 ;start reu->c64
        .word result    ; c64 addr
        .long 0         ; reu addr
.if SWAP == 0
        .word 63*200    ; len
.else
        .word 63*100
.endif
        .byte 0         ; irq mask
        .byte 0         ; addr-control
        .send data

        ldx #9
-       lda reu2,x
        sta $df01,x
        dex
        bpl -
testcompare:
        ; copy start of buffer to the screen
;         ldx #0
; -
;         lda result,x
;         sta $0400,x
;         lda result+$100,x
;         sta $0500,x
;         lda result+$200,x
;         sta $0600,x
;         lda result+$300,x
;         sta $0700,x
;         inx
;         bne -

        ; compare buffer with reference
        lda #>reference
        sta refad+2
        lda #>result
        sta resad+2

        ldy #$31+1 ; really +1?
tlp2:

        lda #$20
        ldx #0
-
        sta $0400,x
        sta $0400+(8*40),x
        sta $0400+(16*40),x
        inx
        bne -

        ldx #0
tlp1:
;.if 1
;refad:  lda reference,x
;resad:  cmp result,x
;.else
        inc $0400+(16*40),x
        stx $0400+(23*40)+39

refad:  lda reference,x
        sta $0400,x
        sta $0400+(23*40)+36
resad:  lda result,x
        sta $0400+(8*40),x
        sta $0400+(23*40)+37
        cmp $0400,x
;.endif
        beq +

        ; failure
        lda #$ff
        sta $d7ff
        lda #10 ; red
        sta resultcolor
        sta $d020
        jmp continue
+
        inx 
        bne tlp1

        inc refad+2
        inc resad+2

        dey 
        bne tlp2

        lda #0
        sta $d7ff
        lda #13
        sta resultcolor
        sta $d020

continue:
-       lda $dc01
        cmp #$ff
        beq -
;        jmp *
;        jmp testagain
        jmp testcompare
.if SWAP == 1
        ; after a swap, we need to reinit the REU memory
        jsr initbuffer2
.endif
        jmp loop

;-----------------------------------------------------------------------------

initbuffer:
.if TESTTIMING == 0
        ; clear buffer
        lda #>buffer
        sta bufad1+2
        lda #>result
        sta resad1+2

        lda #0
        ldy #$31+1
        ldx #0
-
bufad1: sta buffer,x
resad1: sta result,x
        inx 
        bne -
        inc bufad1+2
        inc resad1+2
        dey 
        bne -
.else
        ; create pattern
        lda #>buffer
        sta off+2

        ldy #201
lp1
        ldx #63
-       dex
        txa
off     sta buffer,x
        bne -

        lda off+1
        clc
        adc #63
        sta off+1
        bcc +
        inc off+2
+
        dey
        bne lp1
.endif


        ; transfer buffer to REU
        .section data
reu1a   .byte %10010000 ;start c64->reu
        .word buffer
        .long 0
.if SWAP == 0
        .word 63*201
.else
        .word 63*101
.endif
        .byte 0
        .byte 0
        .send data

initbuffer2:
        ldx #9
-       lda reu1a,x
        sta $df01,x
        dex
        bpl -
        rts

;------------------------------------------------------------------------------

        * = $0c00   ; - $3d38
;        .align 256
reference:
.if IOGLITCH == 0
    .if SWAP = 0
            .if SPRITES == 1
                .if REVERSEORDER == 1
                    .binary "ref/e3-m2.bin"
                .else
                    .binary "ref/e-m2.bin"      ; gpz breadbox
                .endif
            .else
                .binary "ref/e2-ref.bin"    ; ok
            .endif
    .else
            .if SPRITES == 1
                .if REVERSEORDER == 1
                    .binary "ref/e6-m2.bin"
                .else
                    .binary "ref/e4-m2.bin"
                .endif
            .else
                .binary "ref/e5-m2.bin"
            .endif
    .endif
.else
    .if SWAP = 0
            .if SPRITES == 1
                .if REVERSEORDER == 1
                    .binary "ref/e3-ref.bin"
    ;                .binary "e3-vice.bin"
                .else
                    .binary "ref/e-ref.bin"
    ;                .binary "e-vice.bin"        ; works with this but shouldnt
                .endif
            .else
                .binary "ref/e2-ref.bin"
    ;            .binary "e2-vice.bin"
            .endif
    .else
            .if SPRITES == 1
                .if REVERSEORDER == 1
                    .binary "ref/e6-ref.bin"
                .else
                    .binary "ref/e4-ref.bin"
    ;                .binary "e4-vice.bin"
                .endif
            .else
                .binary "ref/e5-ref.bin"
            .endif
    .endif
.endif
        .align 256  ; to make sure data section start at next page
        
    ; 63*200 = 12600 = $3138
        * = $4000   ; - $7138
result:

    ; 63*200 = 12600 = $3138
        * = $8000   ; - $b138
buffer:

        .send code
