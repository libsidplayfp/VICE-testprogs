;-------------------------------------------------------------------------------
            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-------------------------------------------------------------------------------

; acme -f cbm -o testWave00.prg testWave00.asm

; Finally, we can do some experiments with the pulse waveform.  The pulse
; waveform is useful for these tests, since at zero frequency we can set both
; the minimum and the maximum constant DC levels at the voice D/A just by using
; the pulse width registers. Reset the computer. Set voice 1 to zero frequency,
; pulse level $0fff, sustain level 15, and $d404=$41 (pulse waveform + gate on).
; Route only voice 1 through the mixer ($d417 = $0e). The output voltage is
; similar to the test when no waveform was selected -- 5.29 volts! This seems to
; show that "waveform accu = $0fff" is the same as when no waveform is selected
; (i.e. the waveform D/A digital input pins are pulled high when they're not
; driven, as seen in most other NMOS chips).
;
; When the pulse width is 0 in the above test the output changes to 6.34 volts.
; 
; From http://codebase64.org/doku.php?id=magazines:chacking20#the_c64_digi

; zero attack
    lda #$00
    sta $D413

; zero frequency
    sta $D40E
    sta $D40F

; zero pulse-width
    sta $D410
    sta $D411

; set max sustain
    lda #$f0
    sta $D414

; Route only voice 3 through the mixer
    lda #$0b
    sta $D417

; set max volume
    lda #$0f
    sta $D418

; reset oscillator
    lda #$08
    sta $D412

; set Pulse and gate on
    lda #$41
    sta $D412

; print message
    lda #<msg     ; Load lo-byte of string adress 
    ldy #>msg     ; Load hi-byte of string adress 
    jsr $ab1e     ; Print string 

; wait for a keypress
waitspace
    lda #$7f
    sta $dc00
    lda $dc01
    and #$10
    bne waitspace
releasespace
    lda $dc01
    cmp #$ff
    bne releasespace

; just to show we've started
    sta $0400

; set wave 0 and gate on
; output should fade to zero after a while
    lda #$01
    sta $D412

; wait till keypress and count frames
loop
w1: bit $d011
    bmi w1
w2: bit $d011
    bpl w2
    inc counter
    bne nocarry
    inc counter+1
nocarry
    lda $dc01
    cmp #$ef
    bne loop

; set Pulse and gate on again
    lda #$41
    sta $D412

; Print counter
    ldx counter 
    lda counter+1 
    jsr $bdcd

    jmp *

msg
    !text "PRESS SPACE TO START"
    !byte $0D, $00

counter
    !word $00
