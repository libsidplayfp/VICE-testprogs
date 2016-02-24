    .macpack longbranch
    .export Start

; test the assumption that the value read from unused bits in input mode can
; not be modified when the bit is in input mode, and instead comes from the
; value written to the output before (within reasonable time, ie before it
; faded away)

Start:
        sei
        ldx #0

        ; output, write 1
        lda #$ff
        sta 0
        sta 1

        ; must read back 1
        lda 1
        and #$80
        jeq fail
        inx ; 1

        ; set to input
        lda #0
        sta 0

        ; must read back 1
        lda 1
        and #$80
        jeq fail
        inx

        ; write 0
        lda #0
        sta 1

        ; must read back 1
        lda 1
        and #$80
        jeq fail
        inx ; 2

        ; output, write 0
        lda #$ff
        sta 0
        lda #0
        sta 1

        ; must read back 0
        lda 1
        and #$80
        jne fail
        inx ; 3

        ; set to input
        lda #0
        sta 0

        ; must read back 0
        lda 1
        and #$80
        jne fail
        inx

        ; write 1
        lda #$ff
        sta 1

        ; must read back 0
        lda 1
        and #$80
        jne fail
        inx ; 4

        lda #5
        sta $d020
        ldx #0 ; success
        stx $d7ff
        jmp *

fail:
        txa
        clc
        adc #'0'
        sta $0400
        ldx #$ff ; failure
        stx $d7ff
        inc $d020
        jmp *-3