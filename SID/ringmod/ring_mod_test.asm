;-------------------------------------------------------------------------------
            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-------------------------------------------------------------------------------


; Voice 2
; set frequency
    lda #$00
    sta $D407
    sta $D408
; Voice 3
; set frequency
    sta $D40E
    sta $D40F
; reset oscillators
    lda #$08
    sta $D40B
    sta $D412
; start triangle with ring mod
    lda #$15
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
