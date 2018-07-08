
; Test program by lft, 180703.

; Green = pass
; Red = fail
; Black = other error

	*=$801

	!byte	$b,$8,1,0,$9e,"2","0","6","1",0,0,0

	sei

	ldx	#$18
	lda	#0
	sta	$d011
clear
	sta	$d400,x
	dex
	bpl	clear

	jsr	waitframe
	jsr	waitframe

	; rate counter is now in range 0..8

	lda	#$0
	ldx	$d41c	; env output
	bne	assert

	lda	#$ff
	sta	$d414	; voice #3 sr

	; allow rate counter to escape

	nop
	nop
	nop
	nop
	nop

	lda	#$01
	sta	$d412	; voice #3 control

	; Expected behaviour is that the note start is delayed by
	; 32768 cycles (1.67 frames).
	; This is because the rate counter has escaped, and must
	; overflow back to 0 before the envelope counter begins
	; to increase.

	jsr	waitframe

	lda	#$2
	ldx	$d41c	; env output should still be zero
	bne	assert

	lda	#$5
assert
	sta	$d020
	
	ldx #$ff
	cmp #5
	bne failed
	ldx #0
failed:
    stx $d7ff
	jmp	*

waitframe
	bit	$d011
	bmi	*-3
	bit	$d011
	bpl	*-3
	rts
