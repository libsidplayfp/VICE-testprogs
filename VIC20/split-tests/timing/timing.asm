;**************************************************************************
;*
;* FILE  timing.asm 
;* Copyright (c) 2010 Daniel Kahlin <daniel@kahlin.net>
;* Written by Daniel Kahlin <daniel@kahlin.net>
;*
;* DESCRIPTION
;*
;******
	processor 6502

TEST_NAME	eqm	"TIMING"
TEST_REVISION	eqm	"R??"

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
	sei

	lda	#$7f
	sta	$912e
	sta	$912d
	jsr	check_time
	sta	cycles_per_line
	stx	num_lines
	jsr	calc_frame_time

	jsr	test_present

soc_lp2:
	jmp	soc_lp2

cycles_per_line:
	dc.b	0
num_lines:
	dc.b	0
cycles_per_frame:
	dc.w	0

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
	lda	#%11000000
	sta	$912e
	lda	#%01000000
	sta	$912b
;--- wait vb
ct_lp1:
	lda	$9004
	beq	ct_lp1
ct_lp2:
	lda	$9004
	bne	ct_lp2
;--- raster line 0
	lda	#$fe
	sta	$9124
	sta	$9125		; load timer with $fefe
;	lda	#%00010001
;	sta	$dc0e		; start one shot timer
ct_lp3:
	bit	$9004
	bpl	ct_lp3
;--- raster line 256
	lda	$9125		; timer msb
	eor	#$ff		; invert
; Acc = cycles per line
;--- scan for raster wrap
	pha

ct_lp4:
	ldy	$9003
	ldx	$9004
ct_lp5:
	tya
	ldy	$9003
	cpx	$9004
	beq	ct_lp5
	inx
	cpx	$9004
	beq	ct_lp4
	dex
	asl
	txa
	rol
	tax
	inx

	pla
; X = number of raster lines (LSB)

	rts

;**************************************************************************
;*
;* NAME  calc_frame_time
;*   
;* DESCRIPTION
;*   Calculate the number of cycles per frame
;*   
;******
calc_frame_time:
	lda	#0
	tay
	ldx	cycles_per_line
cft_lp1:
	clc
	adc	num_lines
	bcc	cft_skp1
	iny
cft_skp1:
	iny
	dex
	bne	cft_lp1
	sta	cycles_per_frame
	sty	cycles_per_frame+1
	rts

;**************************************************************************
;*
;* common startup and raster code
;*
;******
	include	"../common/scandump.asm"


;**************************************************************************
;*
;* NAME  test_present
;*   
;******
test_present:
	jsr	show_info

	rts


BUFFER	equ	$1800
BUFFER_END	equ	$1900

; eof
