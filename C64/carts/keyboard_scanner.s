
minikey:
	lda #$0
	sta $dc03	; port b ddr (input)
	lda #$ff
	sta $dc02	; port a ddr (output)
			
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
	!for count, 256 {
		!set a=count-1
		!if a = ($ff-$80) {
			!byte $70 
		} else {
		!if a = ($ff-$40) {
			!byte $60 
		} else {
		!if a = ($ff-$20) {
			!byte $50 
		} else {
		!if a = ($ff-$10) {
			!byte $40 
		} else {
		!if a = ($ff-$08) {
			!byte $30 
		} else {
		!if a = ($ff-$04) {
			!byte $20 
		} else {
		!if a = ($ff-$02) {
			!byte $10 
		} else {
		!if a = ($ff-$01) {
			!byte $00 
		} else {
			!byte $ff
		}
		}}}}}}}
	}
rowtab:			
	!for count, 256 {
		!set a=count-1
		!if a = ($ff-$80) {
			!byte 7
		} else {
		!if a = ($ff-$40) {
			!byte 6
		} else {
		!if a = ($ff-$20) {
			!byte 5
		} else {
		!if a = ($ff-$10) {
			!byte 4
		} else {
		!if a = ($ff-$08) {
			!byte 3
		} else {
		!if a = ($ff-$04) {
			!byte 2
		} else {
		!if a = ($ff-$02) {
			!byte 1
		} else {
		!if a = ($ff-$01) {
			!byte 0
		} else {
			!byte $ff
		}
		}}}}}}}
	}
