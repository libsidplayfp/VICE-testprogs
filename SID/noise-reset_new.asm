;
; noise-reset.a65 - Demonstration of fast noise LFSR reset for voice 3
;
; Dag Lem <resid@nimrod.no>
;
; The noise LFSR reset is performed as follows:
;
; 1. Clear all bits. Bits are cleared by combined waveform writeback (noise +
;    sawtooth + triangle), and shifted in by setting and clearing the test bit.
; 2. Set bits 0 - 17 by setting and clearing the test bit.
; 3. Set bits 18 - 22 by allowing the LFSR to be clocked by oscillator bit 19.
; 4. Reset the LFSR and oscillator by setting and clearing the test bit once.
;
; Noise LFSR:
;
;                reset    -------------------------------------------
;                  |     |                                           |
;           test--OR-->EOR<--                                        |
;                  |         |                                       |
;                  2 2 2 1 1 1 1 1 1 1 1 1 1                         |
; Register bits    2 1 0 9 8 7 6 5 4 3 2 1 0 9 8 7 6 5 4 3 2 1 0 <---
;                      |   |       |     |   |       |     |   |
; Waveform bits        1   1       9     8   7       6     5   4
;                      1   0

zero_lfsr
    LDA #$00
    STA $D40E
    STA $D40F
    LDX #03  ; Max number of bits between waveform outputs
zero_bits
    LDA #$B8 ; Noise + sawtooth + triangle + test bit
    STA $D412
    LDA #$B0 ; Shift in zeros
    STA $D412
    DEX
    BNE zero_bits

set_lfsr_0_17
    LDX #17  ; Set bits 0-17
set_low_bits
    LDA #$88 ; Noise + test bit
    STA $D412
    LDA #$80 ; Shift
    STA $D412
    DEX
    BPL set_low_bits

; This part is timing sensitive, so make sure
; that no badlines or interrupts can interfere
set_lfsr_18_22
    LDA #$20 ; Sawtooth
    STA $D412
    LDX #5  ; Set bits 18-22
set_high_bits
    LDA #$80 ; 32 cycles between shifts
    STA $D40F
shift ; Wait for LFSR shift
    LDA $D41B
    AND #$08 ; Oscillator bit 19 = OSC3 bit 3
    BEQ shift
clear ; Wait for oscillator bit 19 to go low again
    LDA $D41B
    AND #$08
    BNE clear
    ; Stop counting
    STA $D40F
    DEX
    BNE set_high_bits

reset_lfsr
    LDA #$08
    STA $D412

; The test program must clear the test bit to finalize the reset
