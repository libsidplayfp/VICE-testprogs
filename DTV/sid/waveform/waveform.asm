; waveform
; --------
; 2008 Hannu Nuotio

; This program outputs short bursts of all waveform combinations.

!ct scr

; --- Constants

; --- Variables

; - zero page

delaylen = $ff

; --- Main 

; start of program
*=$0801
entry:
; BASIC stub: "1 SYS 2061"
!by $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00

mlcodeentry:
lda #$00
ldy #$08
ldx #$f0
sta $d410   ; set PWL
sty $d411   ; set PWH
sta $d413   ; set AD
stx $d414   ; set SR

lda #$0f
sta $d418   ; set volume

lda #$00
ldx #$40
sta $d40e   ; set freqL
stx $d40f   ; set freqH

ldx #0

testloop:
; set SR
lda waveform_lut,x
sta $d412

; play waveform for some time
ldy #$10
sty delaylen
jsr delay

; osc3 = pulse, gate = 0
and #$fe
sta $d412

; brief pause
ldy #$20
sty delaylen
jsr delay

inx
cpx #16
bne testloop

inc $d020

- jmp -

; -- Subroutines

delay:
ldy #0
- dey
bne -
dec delaylen
bne delay
rts

; --- Data

waveform_lut !by $01,$11,$21,$31,$41,$51,$61,$71,$81,$91,$a1,$b1,$c1,$d1,$e1,$f1
