;-------------------------------------------------------------------------------
            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-------------------------------------------------------------------------------

    ldy #$18
loop1:
;write to reg
    lda #$a5
    sta $d410
;read from reg
    lda $d41B
    sta result
;read from write-only regs
    lda $d400,y
    cmp result
    bne nok
    dey
    bne loop1

    ldy #$2
loop2:
;write to reg
    lda #$a5
    sta $d410
;read from reg
    lda $d41B
    sta result
;read from non-existing regs
    lda $d41D,y
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
