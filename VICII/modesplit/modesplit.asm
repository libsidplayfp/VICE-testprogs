;**************************************************************************
;*
;* FILE  modesplit.asm
;* Copyright (c) 2010 Daniel Kahlin <daniel@kahlin.net>
;* Written by Daniel Kahlin <daniel@kahlin.net>
;* $Id: intro.asm,v 1.101 2009-06-02 20:49:58 tlr Exp $
;*
;* DESCRIPTION
;*
;******
	processor 6502


LINE		equ	56

	seg.u	zp
;**************************************************************************
;*
;* SECTION  zero page
;*
;******
	org	$02

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
	lda	#$35
	sta	$01

	ldx	#6
sa_lp1:
	lda	vectors-1,x
	sta	$fffa-1,x
	dex
	bne	sa_lp1

	jsr	prepare_test

	jsr	wait_vb

	lda	#$7f
	sta	$dc0d
	lda	$dc0d
	lda	#$1b | (>LINE << 7)
	sta	$d011
	lda	#<LINE
	sta	$d012
	lda	#1
	sta	$d019
	sta	$d01a

	cli
	
sa_lp2:
	if	0
	inx
	bpl	sa_lp2
	inc	$4080,x
	dec	$4080,x
	endif
	jmp	sa_lp2

vectors:
	dc.w	nmi_entry,0,irq_stable

nmi_entry:
	sei
	lda	#$37
	sta	$01
	jmp	$fe66
	
;**************************************************************************
;*
;* NAME  wait_vb
;*   
;******
wait_vb:
wv_lp1:
	bit	$d011
	bpl	wv_lp1
wv_lp2:
	bit	$d011
	bmi	wv_lp2
	rts

;**************************************************************************
;*
;* NAME  irq_stable, irq_stable2
;*   
;******
irq_stable:
	sta	accstore	; 4
	sty	ystore		; 4
	stx	xstore		; 4
	inc	$d019		; 6
	inc	$d012		; 6
is_sm1:
	lda	#<irq_stable2	; 2
	sta	$fffe		; 4
	tsx			; 2
	cli			; 2
	ds.b	13,$ea		; 24
	if	0
is_lp1:
	sei
	inc	$d020
	jmp	is_lp1	
irq_stable2:
	ds.b	13,$ea		; 26
	else
irq_stable2	equ	.-13
	endif
	txs			; 2
	dec	$d019		; 6
	dec	$d012		; 6
	lda	#<irq_stable	; 2
	sta	$fffe		; 4	=46
	lda	$d012		; 4
	eor	$d012		; 4
	beq	is2_skp1	; 2 (3)
is2_skp1:

	jsr	perform_test
		
accstore	equ	.+1
	lda	#0
xstore	equ	.+1
	ldx	#0
ystore	equ	.+1
	ldy	#0
	rti



label:
	dc.b	"0123456789012345678901234567890123456789"

prepare_test:

	ldx	#0
prt_lp1:
	lda	#$5f
	sta	$0400,x
	sta	$0500,x
	sta	$0600,x
	sta	$06e8,x
	lda	#14
	sta	$d800,x
	sta	$d900,x
	sta	$da00,x
	sta	$dae8,x
	inx
	bne	prt_lp1

	ldx	#40
prt_lp2:
	lda	label-1,x
	sta	$0400-1,x
	dex
	bne	prt_lp2

	lda	#$17
	sta	$d018	
	rts


	align	256
perform_test:
	ds.b	4,$ea
	bit	$ea
; start 0
	ldy	#$08
	jsr	line0
	iny
	jsr	line0
	iny
	jsr	line0
	iny
	jsr	line0
	iny
	jsr	line0
	iny
	jsr	line0
	iny
	jsr	line0
	iny
	jsr	line0
; start 1
	ldy	#$08
	jsr	line1
	iny
	jsr	line1
	iny
	jsr	line1
	iny
	jsr	line1
	iny
	jsr	line1
	iny
	jsr	line1
	iny
	jsr	line1
	iny
	jsr	line1
; start 2
	ldy	#$08
	jsr	line2
	iny
	jsr	line2
	iny
	jsr	line2
	iny
	jsr	line2
	iny
	jsr	line2
	iny
	jsr	line2
	iny
	jsr	line2
	iny
	jsr	line2

	ds.b	6,$ea	
	lda	#$1b
	sta	$d011
	lda	#$08
	sta	$d016
	lda	#7
	sta	$d021
	lda	#6
	sta	$d021
	rts

	align	256
line0:
	ds.b	6,$ea
	sty	$d016
	lda	#7
	sta	$d021
	lda	#6
	sta	$d021
	ds.b	11,$ea

	jsr	line0_do
	jsr	line0_do
	jsr	line0_do
	jsr	line0_do
	jsr	line0_do
	jsr	line0_do

	ldx	#$1b
	stx	$d011
	sty	$d016
	ds.b	3,$ea
	bit	$ea
	rts

line0_do:
	ldx	#$1b
	stx	$d011
	sty	$d016
	tya
	ora	#%00010000
	sta	$d016		; mc
	ldx	#$5b		; illegal text
	stx	$d011
	ldx	#$3b		; bitmap
	stx	$d011
	and	#%11101111
	sta	$d016		; hires
	ldx	#$7b
	stx	$d011		; illegal bitmap1
	ldx	#$5b
	stx	$d011		; ECM
	bit	$ea
	rts

	align	256
line1:
	ds.b	6,$ea
	sty	$d016
	lda	#7
	sta	$d021
	lda	#6
	sta	$d021
	ds.b	11,$ea

	jsr	line1_do
	jsr	line1_do
	jsr	line1_do
	jsr	line1_do
	jsr	line1_do
	jsr	line1_do

	ldx	#$1b
	stx	$d011
	sty	$d016
	ds.b	3,$ea
	bit	$ea
	rts

line1_do:
	ldx	#$1b
	stx	$d011
	sty	$d016

	ldx	#$5b
	stx	$d011
	ldx	#$1b
	stx	$d011
	ds.b	13,$ea
	bit	$ea
	rts

	align	256
line2:
	ds.b	6,$ea
	sty	$d016
	lda	#7
	sta	$d021
	lda	#6
	sta	$d021
	ds.b	11,$ea

	jsr	line2_do
	jsr	line2_do
	jsr	line2_do
	jsr	line2_do
	jsr	line2_do
	jsr	line2_do

	ldx	#$1b
	stx	$d011
	sty	$d016
	ds.b	3,$ea
	bit	$ea
	rts

line2_do:
	ldx	#$1b
	stx	$d011
	sty	$d016
	tya
	ora	#%00010000
	sta	$d016
	and	#%11101111
	sta	$d016
	ds.b	12,$ea
	bit	$ea
	rts
	
; eof
