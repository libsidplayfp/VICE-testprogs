
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
    ; test CIA2 (NMI)

    ; Set NMI vector
    lda #<continue1
    sta $fffa
    lda #>continue1
    sta $fffb

    lda #$81
    sta $dd0d

    ; Set timer to $100 cycles
    lda #TESTVAL
    sta $dd04
    lda #0
    sta $dd05

.ifdef ONESHOT
    lda #%10011001 ; Fire a 1-shot timer
.else
    lda #%10010001 ; normal timer
.endif
    sta $dd0e

    lda $dd0d
    lda $dd0d
    .repeat 40,count
    lda $dd04
    sta $0400+count
    .endrepeat

    ; we should not come here
    lda #2
    sta $d020

    jmp continue2

continue1:
    lda $dd0d
    pla
    pla
    pla

    lda #5
    sta $d020

continue2:
    lda #$7f
    sta $dd0d

    inc $0450
    jmp mainloop

