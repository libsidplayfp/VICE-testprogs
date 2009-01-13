; envcmp
; ------
; 2008 Hannu Nuotio

; This program tests (DTV)SID envelope sustain compare values.

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
ldx #$ff
ldy #$08
stx $d40e   ; set freqL
stx $d40f   ; set freqH
sta $d410   ; set PWL
sty $d411   ; set PWH
sta $d413   ; set AD
sta $d418   ; set volume

ldx #0

testloop:
; set SR
lda sustain_lut,x
sta $d414

; osc3 = pulse, gate = 1
lda #$41
sta $d412

; wait for envelope to reach sustain
lda #$0e
sta delaylen
jsr delay

; store envelope value
lda $d41c
sta $0400,x
sta $c000,x

; osc3 = pulse, gate = 0
lda #$40
sta $d412

; wait for envelope die off
lda #$20
sta delaylen
jsr delay

inx
cpx #16
bne testloop

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

sustain_lut !by $00,$10,$20,$30,$40,$50,$60,$70,$80,$90,$a0,$b0,$c0,$d0,$e0,$f0
