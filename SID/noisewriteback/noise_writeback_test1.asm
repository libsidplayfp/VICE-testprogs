;-------------------------------------------------------------------------------
; acme -f cbm -o noise_writeback_test1.prg noise_writeback_test1.asm
;-------------------------------------------------------------------------------
            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-------------------------------------------------------------------------------

; disallow interrupts and disable screen to get stable timing
    sei
    lda #0
    sta $d011
    
; set frequency
    lda #$00
    ldx #$00
    sta $d40E
    stx $d40F

; set testbit and noise+triangle
    lda #$98
    sta $d412

; noise reg may need some time
; to reset
; TODO use CIA for a timed delay?
    ldy #$10
---
    ldx #$00
--
    lda #$f0
-
    cmp $d012
    bne -
    dex
    bne --
    dey
    bne ---

; at this point all bit should be high
; except for the ones connected to
; the waveform selector

; release testbit and set noise only
    lda #$80
    sta $d412

; after the first shift we should read all
; ones except for bit zero due to the XOR feedback
    lda $d41b
    sta $0400
    cmp #$fe
    bne nok

; set frequency
    lda #$ff
    ldx #$ff
    sta $d40E
    stx $d40F

; wait until next shift
    nop
    nop
    nop

; the bits pulled down by the writeback
; will now show in the output
; at bits 2, 11 and 20
    lda $d41b
    sta $0401
    cmp #$fe
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

; enable screen again to make result visible
    cli
    lda #$1b
    sta $d011

    jmp *

