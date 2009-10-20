;**************************************************************************
;*
;* FILE  via_wrap2.asm 
;* Copyright (c) 2009 Daniel Kahlin <daniel@kahlin.net>
;* Written by Daniel Kahlin <daniel@kahlin.net>
;*
;* DESCRIPTION
;*   Test case for via timer wrap around.
;*
;******
	processor 6502
	include	"macros.i"

SCR_BASE	equ	$1e00
COL_BASE	equ	$9600

tmp_zp	equ	$fb

	seg	code
	org	$1001
;**************************************************************************
;*
;* Basic line!
;*
;******
start_of_line:
	dc.w	end_line
	dc.w	0
	dc.b	$9e,"4117 /T.L.R/",0
;	        0 SYS4117 /T.L.R/
end_line:
	dc.w	0

;**************************************************************************
;*
;* NAME  startofcode
;*
;******
startofcode:
	lda	#<greet_msg
	ldy	#>greet_msg
	jsr	$cb1e
	sei

	ldx	#0
soc_lp00:
	ldy	#10
soc_lp0:
	tya
	sta	SCR_BASE+22*7,x
	inx
	dey
	cpy	#254
	beq	soc_lp00
	cpx	#22
	bne	soc_lp0
	

	ldx	#22
	lda	#6
soc_lp1:
	sta	COL_BASE+22*4-1,x
	sta	COL_BASE+22*7-1,x
	dex
	bne	soc_lp1

	ldx	#0
soc_lp2:
	lda	#$7f
	sta	$912e
	sta	$912d
	lda	#%11000000
	sta	$912e
	lda	#%01000000
	sta	$912b
	lda	#10
	sta	$9124
	lda	#0
	sta	$9125	;load T1
	stx	tmp_zp
	lda	#BR_LEN-1
	sec
	sbc	tmp_zp	
	sta	soc_sm1+1
	clc
soc_sm1:
	bcc	soc_branch
soc_branch:
	ds.b	20,$a9
	dc.b	$24,$ea
BR_LEN	equ	. - soc_branch

	lda	$9124
	sta	SCR_BASE+22*4,x
	inx
	cpx	#BR_LEN
	bne	soc_lp2

	lda	#$7f
	sta	$912e
	sta	$912d
lp:
	jmp	lp
	rts


greet_msg:
	dc.b	147,"VIA WRAP2 (CONTINUOUS)",13,13
	dc.b	"MEASURED:",13,13,13
	dc.b	"REF:",0
; eof

	
