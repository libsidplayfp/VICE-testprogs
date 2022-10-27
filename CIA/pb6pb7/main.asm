
    *=$0801
    !word l
    !word 10
    !byte $9e
    !text "2061"
    !byte 0
l:  !word 0

    sei
    ;-----------------------
    lda #$ff
    sta $dc02
    lda #$00
    sta $dc03

    lda #2
    sta $dc0e
    sta $dc0f
    lda #$ff
    sta $dc01

    lda $dc01
    sta $0400

    lda #0
    sta $dc0e
    sta $dc0f

    lda $dc01
    sta $0401

    lda $0400
    cmp #$3f
    bne fail
    lda $0401
    cmp #$ff
    bne fail

    ; success
    lda #0
    sta $d7ff
    lda #13
    sta $d020
    jmp *

fail:
    ; failure
    lda #$ff
    sta $d7ff
    lda #10
    sta $d020
    jmp *
