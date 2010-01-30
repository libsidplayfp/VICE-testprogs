;**************************************************************************
;*
;* FILE  lightpen.asm
;* Copyright (c) 2010 Daniel Kahlin <daniel@kahlin.net>
;* Written by Daniel Kahlin <daniel@kahlin.net>
;* $Id: intro.asm,v 1.101 2009-06-02 20:49:58 tlr Exp $
;*
;* DESCRIPTION
;*
;******
	processor 6502


LINE		equ	308

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


prepare_test:
	lda	#%11111111
	sta	$dc00
	lda	#%00000000
	sta	$dc02
	lda	#%11111111
	sta	$dc01
	sta	$dc03
	rts

perform_test:
	lda	enable
	beq	pt_ex1

	lda	cycle
	jsr	delay
	ldx	#%00000000
	stx	$dc01
pt_sm1:
	lda	$d011
	ldx	#%11111111
	stx	$dc01
	inc	$d020
	dec	$d020
	ldx	cycle
pt_sm2:
	sta	BUFFER,x

	inc	cycle
	bne	pt_skp1
	inc	pt_sm1+1
	inc	pt_sm2+2
pt_skp1:

	lda	646
	sta	$d800
	sta	$d801
	sta	$d802
	lda	cycle
	sta	$0400
	lda	pt_sm1+1
	sta	$0401
	cmp	#$15
	bne	pt_ex1
	lda	#15
	sta	$d020
	lda	#$60
	sta	perform_test

pt_ex1:
	lda	enable
	eor	#1
	sta	enable
	sta	$0402

	rts

cycle:
	dc.b	0
test:
	dc.b	0
enable:
	dc.b	0

	align	256
delay:
	eor	#$ff
	lsr
	sta	dl_sm1+1
	bcc	dl_skp1
dl_skp1:
dl_sm1:
	bne	dl_skp1
	ds.b	128,$ea
	rts

	
BUFFER	equ	$4000
	
; eof
