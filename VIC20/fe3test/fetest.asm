	processor	6502


io_reg1	= $9c02
io_reg2	= $9c03

screen	= $1000

	org	$1201

	; BASIC stub
	dc.w	$120b
	dc.w	10
	dc.b	$9e,"4621",0
	dc.w	0

	; save current register state
	sta	$a000
	lda	io_reg1
	pha
	lda	io_reg2
	pha

	lda	#0
	sta	io_reg2
	ldy	#20
loop2:
	lda	#%10100001	; super RAM mode, bank 1
	sta	io_reg1
	lda	#'1
	sta	$a000,y
	lda	#%10100010	; super RAM mode, bank 2
	sta	io_reg1
	lda	#'2
	sta	$a000,y
	dey
	bpl	loop2

	lda	#%01100000	; RAM/ROM mode BLK5 RAM
	sta	io_reg1
	lda	#$17
	sta	$a001		; writes to second byte in RAM bank 1

	lda	#%01110000	; RAM/ROM mode BLK5 ROM
	sta	io_reg1
	lda	#$17
	sta	$a000		; writes to first byte in RAM bank 2

	ldy	#20
loop1:
	lda	$a000,y		; reads from flash bank 0
	sta	screen,y
	dey
	bpl	loop1

	lda	#%01100000	; RAM/ROM mode BLK5 RAM
	sta	io_reg1
	ldy	#10
loop3:
	lda	$a000,y		; reads from RAM bank 1
	sta	screen+44,y	; show changes to RAM bank 1
	dey
	bpl	loop3

	lda	#%10100010	; super RAM mode, bank 2
	sta	io_reg1
	ldy	#10
loop4:
	lda	$a000,y
	sta	screen+88,y	; show changes to RAM bank 2
	dey
	bpl	loop4

	; check results
	lda	screen+6
	cmp	#$c3
	bne	fail
	lda	screen+7
	cmp	#$c2
	bne	fail
	lda	screen+8
	cmp	#$cd
	bne	fail
	lda	screen+$2c
	cmp	#$31
	bne	fail
	lda	screen+$2d
	cmp	#$17
	bne	fail
	lda	screen+$58
	cmp	#$17
	bne	fail
	lda	screen+$59
	cmp	#$32
	bne	fail

	lda	#29
	sta	$900f

restore:
	; restore register state
	pla
	sta	io_reg2
	pla
	sta	io_reg1
	rts

fail:
	lda	#26
	sta	$900f
	bne	restore
