
    .export Start

Start:
    lda #$93
    jsr $ffd2

    sei

    lda #$35
    sta $01

mainloop:

    lda $d011
    bpl *-3
    lda $d011
    bmi *-3

    inc $d020
    dec $d020

    ; test CIA1 (IRQ)

    ; Set IRQ vector
    lda #<continue2
    sta $fffe
    lda #>continue2
    sta $ffff

    lda #%10001000
    sta $dc0e
    lda $dc0d

    lda #$81
    sta $dc0d
    cli

    ; Set timer to $100 cycles
    lda #TESTVAL
    sta $dc04
    lda #0
    sta $dc05

.ifdef ONESHOT
    lda #%10011001 ; Fire a 1-shot timer
.else
    lda #%10010001 ; normal timer
.endif
    sta $dc0e

    lda $dc0d
    lda $dc0d
    .repeat 40,count
    lda $dc04
    sta $0400+count
    .endrepeat

    ; we should not come here
    lda #2
    sta $d020

    jmp continue1

continue2:
    sei
    lda $dc0d
    pla
    pla
    pla

    lda #5
    sta $d020

continue1:
    lda #$7f
    sta $dc0d

    inc $0450
    jmp mainloop
