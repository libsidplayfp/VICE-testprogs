;-------------------------------------------------------------------------------
            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-------------------------------------------------------------------------------

    lda #$00
    ldx #$18
-   sta $d400,x
    dex
    bpl -

    lda #$20
    ldx #0
-   sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    dex
    bne -

    ldy #$18
loop1:
;write to reg
    lda #$a5
    sta $d410

    lda $d410
    sta $0400+(0*40),y
    lda $d411
    sta $0400+(1*40),y
;read from reg (OSC3)
    lda $d41B
    sta result
    sta $0400+(3*40),y
;read from write-only regs
    lda $d400,y
    sta $0400+(4*40),y
    cmp result
    bne nok
    dey
    bne loop1

    ldy #$2
loop2:
;write to reg
    lda #$a5
    sta $d410

    lda $d410
    sta $0400+(10*40),y
    lda $d411
    sta $0400+(11*40),y
;read from reg (OSC3)
    lda $d41B
    sta result
    sta $0400+(13*40),y
;read from non-existing regs
    lda $d41D,y
    sta $0400+(14*40),y
    cmp result
    bne nok
    dey
    bne loop2
ok:
    lda #5
    jmp prnt

nok:
    lda #2

prnt:
    sta $D020

    ldy #0      ; success
    lda $d020
    and #$0f
    cmp #5
    beq +
    ldy #$ff    ; failure
+
    sty $d7ff

    jmp *

;----------------------------------------------------------------------------

result:
    !byte 0
