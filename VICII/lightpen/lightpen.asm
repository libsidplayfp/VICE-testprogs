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
ptr_zp:
	ds.w	1

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

	lda	#$7f
	sta	$dc0d
	lda	$dc0d
	jsr	check_time
	sta	cycles_per_line
	stx	num_lines
	sec
	sbc	#63
	bcc	sa_fl1		;<63, fail
	cmp	#66-63		;>=66, fail
	bcs	sa_fl1
	tax
	lda	time1,x
	sta	is_sm1+1

	jsr	prepare_test
	
	jsr	wait_vb

;	lda	#$1b | (>LINE << 7)
	lda	#$9b
	sta	$d011
	lda	num_lines
	sec
	sbc	#4
;	lda	#<LINE
	sta	$d012
	lda	#1
	sta	$d019
	sta	$d01a

	cli
	
sa_lp2:
	if	0
; be evil to timing to provoke glitches
	inx
	bpl	sa_lp2
	inc	$4080,x
	dec	$4080,x
	endif
	jmp	sa_lp2

vectors:
	dc.w	nmi_entry,0,irq_stable

sa_fl1:
nmi_entry:
	sei
	lda	#$37
	sta	$01
	jmp	$fe66

cycles_per_line:
	dc.b	0
num_lines:
	dc.b	0
	
time1:
	dc.b	irq_stable2_pal, irq_stable2_ntscold, irq_stable2_ntsc

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
;* NAME  check_time
;*   
;* DESCRIPTION
;*   Determine number of cycles per raster line.
;*   Acc = number of cycles.
;*   X = LSB of number of raster lines.
;*   
;******
check_time:
	lda	#0
	sta	$dc0e
	jsr	wait_vb
;--- raster line 0
	lda	#$fe
	sta	$dc04
	sta	$dc05		; load timer with $fefe
	lda	#%00010001
	sta	$dc0e		; start one shot timer
ct_lp1:
	bit	$d011
	bpl	ct_lp1
;--- raster line 256
	lda	$dc05		; timer msb
	eor	#$ff		; invert
; Acc = cycles per line
;--- scan for raster wrap
ct_lp2:
	ldx	$d012
ct_lp3:
	cpx	$d012
	beq	ct_lp3
	bmi	ct_lp2
	inx
; X = number of raster lines (LSB)
twelve:
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
	lda	#<irq_stable2_pal	; 2
	sta	$fffe		; 4
	tsx			; 2
	cli			; 2
;10 * nop for PAL (63)
;11 * nop for NTSC (65)
	ds.b	11,$ea		; 22
; guard
is_lp1:
	sei
	inc	$d020
	jmp	is_lp1	

;28 cycles for NTSC (65)
;27 cycles for NTSCOLD (64)
;26 cycles for PAL (63)
irq_stable2_ntsc:
	dc.b	$2c		; bit <abs>
irq_stable2_ntscold:
	dc.b	$24		; bit <zp>
irq_stable2_pal:
	dc.b	$ea
	jsr	twelve		; 12
	jsr	twelve		; 12
;---
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


;**************************************************************************
;*
;* NAME  prepare_test
;*   
;******
prepare_test:
	lda	#%11111111
	sta	$dc00
	lda	#%00000000
	sta	$dc02
	lda	#%11111111
	sta	$dc01
	sta	$dc03
	lda	#$0f
	sta	$d019		; clear interrupts
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
	lda	$d019
	and	#$0f
	sta	BUFFER+$0400,x
	lda	#$0f
	sta	$d019		; clear interrupts

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
