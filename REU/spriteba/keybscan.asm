minikey:
	lda #$0
	sta $dd03	; port b ddr (input)
	lda #$ff
	sta $dd02	; port a ddr (output)

	lda #$00
	sta $dc00	; port a
	lda $dc01       ; port b
	cmp #$ff
	beq nokey
	; got column
	tay

	lda #$7f
	sta nokey2+1
	ldx #8
nokey2:
	lda #0
	sta $dc00	; port a

	sec
	ror nokey2+1
	dex
	bmi nokey

	lda $dc01       ; port b
	cmp #$ff
	beq nokey2

	; got row in X
	txa
	ora columntab,y
;	sta $d021

	sec
	rts

nokey:
	clc
	rts
			
columntab:
	!for count, 0, 256 {
		!if count = ($ff-$80) {
			!byte $70
		} else if count = ($ff-$40) {
			!byte $60
		} else if count = ($ff-$20) {
			!byte $50
		} else if count = ($ff-$10) {
			!byte $40
		} else if count = ($ff-$08) {
			!byte $30
		} else if count = ($ff-$04) {
			!byte $20
		} else if count = ($ff-$02) {
			!byte $10
		} else if count = ($ff-$01) {
			!byte $00
		} else {
			!byte $ff
		}
	}

