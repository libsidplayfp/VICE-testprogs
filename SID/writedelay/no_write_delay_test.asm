;-------------------------------------------------------------------------------
            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-------------------------------------------------------------------------------


; set pulse width
    lda #$03
    ldx #$00
    sta $d410
    stx $d411
; set frequency
    lda #$00
    ldx #$10
    sta $D40E
    stx $D40F
; reset oscillator
    lda #$08
    sta $D412
; start pulse
    lda #$41
    sta $D412
;read OSC3
    lda $d41B
    sta $0400
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
    and #$0f
    cmp #5
    beq +
    ldy #$ff    ; failure
+
    sty $d7ff

    jmp *

;----------------------------------------------------------------------------

result:
    !byte $ff
