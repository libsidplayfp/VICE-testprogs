;-------------------------------------------------------------------------------
            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-------------------------------------------------------------------------------

;write to reg
    lda #$a5
    sta $d410
;read from reg
    lda $d41B
    sta result
;read from invalid reg
    lda $d41F
    cmp result
    beq ok
nok:
    lda #2
    jmp prnt 

ok:
    lda #5

prnt:
    sta $D020

    ldy #0      ; success
    lda $d020
    cmp #5
    beq +
    ldy #$ff    ; failure
+
    sty $d7ff

    jmp *

;----------------------------------------------------------------------------

result:
    !byte 0
