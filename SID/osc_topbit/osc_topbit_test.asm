;-------------------------------------------------------------------------------
; acme -DNEWSID=0 -DWAVEFORM=0 -f cbm -o osc_topbit_test.prg osc_topbit_test.asm
;
; WAVEFORM=0 -> triangle
; WAVEFORM=1 -> pulse
; WAVEFORM=2 -> noise
;-------------------------------------------------------------------------------
            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-------------------------------------------------------------------------------
; This test checks the effect of combined waveforms on the oscillator.
; In the 8580, the oscillator topbit is buffered by a flipflop
; before it enters that Sawtooth switch in the waveform selector.
; On the 6581 instead the connection is direct so if the line is pulled low
; by combined waveforms a zero will enter the oscillator adder MSB in the next cycle
; causing the topbit to go low.

;set a low frequency ($0001)
    lda #$01
    sta $d40e
    lda #$00
    sta $d40f

!if WAVEFORM=1 {
; set pw $fff so the pulse output will be $000
    lda #$ff
    sta $d410
    sta $d411
}
!if WAVEFORM=2 {
; set noise register to $000 using combined waveforms
    ldy #5
-
    lda #$f8
    sta $d412
    lda #$f0
    sta $d412
    dey
    bne -
}
; reset oscillator
    lda #$08
    sta $d412

; set saw
    lda #$20
    sta $d412

; wait until oscillator topbit raises
-
    lda $d41b
    and #$80
    beq -

!if WAVEFORM=0 {
    ; set saw+tri
    lda #$30
}
!if WAVEFORM=1 {
    ; set saw+pul
    lda #$60
}
!if WAVEFORM=2 {
    ; set saw+noi
    lda #$a0
}

; the output MSB will be zeroed out
; on 6581 the oscillator topbit will be pulled down
    sta $d412

; set saw again
    lda #$20
    sta $d412

; read OSC3 and check topbit
    lda $d41b
    sta $0400
    and #$80
!if NEWSID = 0 {
    bne nok
} else {
    beq nok
}

ok:
    lda #5
    ldy #0
    jmp prnt 

nok:
    lda #2
    ldy #$ff
prnt:
    sta $D020
    sty $d7ff

  jmp *
