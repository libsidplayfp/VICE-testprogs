;**************************************************************************
;*
;* FILE  steal.asm
;* Copyright (c) 2007 Daniel Kahlin <daniel@kahlin.net>
;* Written by Daniel Kahlin <daniel@kahlin.net>
;*
;* DESCRIPTION
;*   Simple test to check if cycle stealing is working correctly.
;*
;******
	processor 6502

	
	MAC	sac
	dc.b	$32,{1}
	ENDM
	MAC	sir
	dc.b	$42,{1}
	ENDM
	MAC	bra
_TMPBRA	set	{1}-2-.
	if	_TMPBRA < -128 || _TMPBRA > 127
	ECHO 	"Branch to long!"
	ERR
	endif
	dc.b	$12,_TMPBRA
	ENDM

	seg	code
	org	$0801
;**************************************************************************
;*
;* Basic line!
;*
;******
StartOfFile:
	dc.w	EndLine
	dc.w	0
	dc.b	$9e,"2069 /T.L.R/",0
;	        0 SYS2069 /T.L.R/
EndLine:
	dc.w	0

;**************************************************************************
;*
;* SysAddress... When run we will enter here!
;*
;******
SysAddress:
	sei
	lda	#$01
	sta	$d03f

	lda	#$80
	sta	$d001	
	sta	$d003
	sta	$d005
	sta	$d007	
	sta	$d009
	sta	$d00b
	sta	$d00d
	sta	$d00f
	lda	#$ff
	sta	$d015

	lda	#0
	sta	mode
sa_lp1:
	jsr	set_mode
sa_lp2:
	lda	#$05
	sta	$d021
sa_lp3:
	lda	$d021
	eor	#8
	sta	$d021
	nop
	nop
	lda	$d011
	bpl	sa_lp3
sa_lp4:
	lda	$d011
	bmi	sa_lp4
	lda	#$7f
	sta	$dc00
	lda	$dc01
	and	#$10
	bne	sa_lp2
sa_lp5:
	lda	$dc01
	and	#$10
	beq	sa_lp5

	ldx	mode
	inx
	txa
	and	#3
	sta	mode

	jmp	sa_lp1

mtab:
	dc.b	$00,$10,$20,$30
text:
	dc.b	"D03C=00 "
	dc.b	"D03C=10 "
	dc.b	"D03C=20 "
	dc.b	"D03C=30 "
	
mode:
	dc.b	0

set_mode:
	ldx	mode
	lda	mtab,x
	sta	$d03c
	ldy	#0
sm_lp1:
	lda	#0
	sta	$d800,y
	sta	$d900,y
	sta	$da00,y
	sta	$db00,y
	lda	#$20
	sta	$0400,y
	sta	$0500,y
	sta	$0600,y
	sta	$0700,y
	iny
	bne	sm_lp1

	txa
	asl
	asl
	asl
	tax
sm_lp2:
	lda	text,x
	and	#$3f
	sta	$0400,y
	sta	$0428,y
	sta	$0450,y
	sta	$0478,y
	iny
	inx
	cpy	#8
	bne	sm_lp2		
	rts	
; eof
