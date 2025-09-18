    .macpack longbranch
    .export Start

Start:
        sei

        lda #$2f
        sta $00
        lda #$35
        sta $01

        lda #5
        sta $d020

        ; stop timers
        lda #0
        sta $dc0e
        sta $dc0f

        lda #$ff
        sta $dc04
        lda #$02        ; JAM, turns into some zp/2 byte opcode
        sta $dc05
        lda #$ff        ; argument
        sta $dc06
        lda #$60        ; rts
        sta $dc07

        ; copy latch to timer
        lda #%00010000
        sta $dc0f
        ; copy latch to timer, start timer
        lda #%00010001
        sta $dc0e

        jsr $dc05       ; JAM

        ; if we ever come here, something is seriously wrong
        lda #2
        sta $d020
        lda #$ff
        sta $d7ff
        jmp *

