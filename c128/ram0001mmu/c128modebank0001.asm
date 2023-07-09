; This is a c128 mode test to what happens when the zero page is remapped to page $30 in bank 1 and address $01 is written to,
; what happens to the ram at address $3001 in bank 1.
;
; test needs to be confirmed on real hardware
;
; colors:
;   black = ram at $3001 in bank 1 stays the same
;   white = ram at $3001 in bank 1 gets the value written to $01
;   green = ram at $3001 in bank 1 gets the last value on the data bus
;
; Test made by Marco van den Heuvel


start=$1c40

basicHeader=1 

!ifdef basicHeader {
; 10 SYS7181
*=$1c01
	!byte  $0c,$08,$0a,$00,$9e,$37,$31,$38,$31,$00,$00,$00
*=$1c0d 
	jmp start
}
*=start
; clear the screen
	lda #$93
	jsr $ffd2

	sei

; share bottom 8k
	lda #$06
	sta $d506

; bank in bank 1 and make everything rom
	lda #$40
	sta $ff00

; store $aa at $3001 in bank 1
	lda #$aa
	sta $3001

; bank in bank 0 and make everything rom
	lda #$00
	sta $ff00

; no shared memory
	lda #$00
	sta $d506

; change the zero page translation to page $30 in bank 1
	lda #$01
	sta $d508
	lda #$30
	sta $d507

; read the current value in $01, which will be the internal cpu port at $01
	lda $01

; write the value to $01
	sta $01

; undo the zero page mapping
	ldx #$00
	stx $d508
	ldx #$00
	stx $d507

; share bottom 8k
	ldx #$06
	stx $d506

; bank in bank 1 and make everything rom
	ldx #$40
	stx $ff00

; find out what is in $3001 in bank 1
	cmp $3001
	beq got01
	lda $3001
	cmp #$aa
	beq unchanged

; vicii value
	ldx #$00
	lda #$05
	bne result

; $01 stored value
got01:
	lda #$01
	ldx #$ff
	bne result

; unchanged
unchanged:
	lda #$00
	ldx #$ff

result:
	sta $d020
	stx $d7ff

	clc
l0:
	bcc l0
