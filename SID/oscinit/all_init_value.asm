;-------------------------------------------------------------------------------
            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-------------------------------------------------------------------------------


    lda #$00
    sta $d412
    lda $d41B
    sta $0400
    lda #$80
    sta $d412
    lda $d41B
    sta $0401
    lda #$40
    sta $d412
    lda $d41B
    sta $0402
    lda #$20
    sta $d412
    lda $d41B
    sta $0403
    lda #$10
    sta $d412
    lda $d41B
    sta $0404



    lda $0400
    cmp #$00
    bne nok
    lda $0401
    cmp #$fe
    bne nok
    lda $0402
    cmp #$ff
    bne nok
    lda $0403
    cmp #$55
    bne nok
    lda $0404
    cmp #$aa
    bne nok

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
