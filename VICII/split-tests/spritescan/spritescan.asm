;**************************************************************************
;*
;* FILE  spritescan.asm
;* Copyright (c) 2010 Daniel Kahlin <daniel@kahlin.net>
;* Written by Daniel Kahlin <daniel@kahlin.net>
;*
;* DESCRIPTION
;*
;******
	processor 6502

TEST_NAME	eqm	"SPRITESCAN"
TEST_REVISION	eqm	"R??"
LINE	equ	48+8*7+6
SPRPOS	equ	LINE+6
	
	seg.u	zp
;**************************************************************************
;*
;* SECTION  zero page
;*
;******
	org	$02
test_num_zp:
	ds.b	1
pattern_num_zp:
	ds.b	1
xpos_zp:
	ds.w	1
bufptr_zp:
	ds.w	1
msbmask0_zp:
	ds.b	1
msbmask1_zp:
	ds.b	1
offs_zp:
	ds.b	1
bit_zp:
	ds.b	1

;**************************************************************************
;*
;* common startup and raster code
;*
;******
HAVE_TEST_RESULT	equ	1
;HAVE_STABILITY_GUARD	equ	1
	include	"../common/startup.asm"

	include	"../common/scandump.asm"

;**************************************************************************
;*
;* NAME  test_present
;*
;******
test_present:
	jsr	show_info

	lda	#<measure_msg
	ldy	#>measure_msg
	jsr	$ab1e
	rts

measure_msg:
	dc.b	13,"MEASURING $DC04 AT CYCLE $00...",0

	if	0
show_params:
	lda	$d3
	sec
	sbc	#20
	tay
	lda	curr_reg+1
	jsr	update_hex
	lda	curr_reg
	jsr	update_hex

	lda	$d3
	sec
	sbc	#5
	tay
	lda	cycle_zp
	jmp	update_hex
;	rts
	endif
	
;**************************************************************************
;*
;* NAME  test_result
;*
;******
test_result:
	lda	#<done_msg
	ldy	#>done_msg
	jsr	$ab1e

	lda	#<result_msg
	ldy	#>result_msg
	jsr	$ab1e


	ldx	#<filename
	ldy	#>filename
	lda	#FILENAME_LEN
	jsr	$ffbd
	jsr	save_file

	rts

done_msg:
	dc.b	"DONE",13,13,0

result_msg:
	dc.b	13,13,"(RESULT AT $4000-$5000)",0

filename:
	dc.b	"SSCRESULT"
FILENAME_LEN	equ	.-filename
	
;**************************************************************************
;*
;* NAME  test_prepare
;*
;******
test_prepare:
	
; prepare test
	lda	#0
	sta	test_num_zp
	sta	pattern_num_zp
; clear sprite area
	ldx	#$80
tpr_lp1:
	sta	$3f80-1,x
	dex
	bne	tpr_lp1
	
; setup the first test
	jsr	setup_test


; setup initial raster line
	lda	#$1b | (>LINE << 7)
	sta	$d011
	lda	#<LINE
	sta	$d012

	rts

	
;**************************************************************************
;*
;* NAME  test_perform
;*
;******
test_perform:

	ldx	#0
tp_lp1:
	inc	$d020
	lda	sprtab,x
tp_sm1:
SM_SUT_YREG	equ	.+1
	sta	$d001
SM_SUP_YREG	equ	.+1
	sta	$d009

	ldy	#0
	lda	xpos_zp+1
	beq	tp_skp1
	ldy	msbmask0_zp	;%00010001
tp_skp1:
	lda	xpos_zp
SM_SUT_XREG	equ	.+1
	sta	$d000
	sec
	sbc	offs_zp
	bcs	tp_skp2
	pha
	tya
	eor	msbmask1_zp	;%00010000
	tay
	pla
tp_skp2:
SM_SUP_XREG	equ	.+1
	sta	$d008
	sty	$d010

	dec	$d020
	
; wait until one line before the measurement line
	lda	postab1,x
tp_lp2:
	cmp	$d012
	bne	tp_lp2
	lda	#0
	sta	$d021
;******
; before measurement line
	lda	$d01e

; wait until one line after the measurement line
	lda	postab2,x
tp_lp3:
	cmp	$d012
	bne	tp_lp3
	jsr	twelve
;******
; after measurement line
	lda	$d01e
	beq	tp_skp4
	lda	bit_zp
tp_skp4:
	sta	$d021
	ldy	xpos_zp
SM_WRITEMODE	equ	.
	ora	(bufptr_zp),y
WM_STORE	equ	$24	; BIT <zp>
WM_OR		equ	$11	; ORA (<zp>),y
	sta	(bufptr_zp),y
	sta	$d021
	lda	#6
	sta	$d021
	
	inc	xpos_zp
	bne	tp_skp3
	inc	xpos_zp+1
	inc	bufptr_zp+1
tp_skp3:
	
	inx
	cpx	#16
	bne	tp_lp1

	lda	xpos_zp+1
	cmp	#2
	bne	pt_ex1

	inc	test_num_zp
	lda	test_num_zp
	cmp	#NUM_TESTS
	beq	pt_ex2

	jsr	setup_test
	jmp	pt_ex1
; cosmetic print out
;	jsr	show_params
pt_ex2:
	lda	#$60
	sta	test_perform
	sta	test_done
pt_ex1:
	rts


setup_test:
	lda	#0
	sta	xpos_zp
	sta	xpos_zp+1

	lda	test_num_zp
	asl
	asl
	tax
;X=test_num_zp*4
	lda	sprmask,x
	sta	bufptr_zp
	lda	sprmask+1,x
	sta	bufptr_zp+1
	
	ldy	sprmask+3,x
	lda	bittab,y
	sta	msbmask1_zp
	ldy	sprmask+2,x
	ora	bittab,y
	sta	$d015
	sta	msbmask0_zp

; sprite under test
	ldy	sprmask+2,x
	lda	#1
	sta	$d027,y
	lda	#$fe
	sta	$07f8,y
	tya
	asl
	tay
	sty	SM_SUT_XREG
	iny
	sty	SM_SUT_YREG
	
; measurement sprite
	ldy	sprmask+3,x
	lda	#12
	sta	$d027,y
	lda	#$ff
	sta	$07f8,y
	tya
	asl
	tay
	sty	SM_SUP_XREG
	iny
	sty	SM_SUP_YREG


; set up specific pattern
	lda	pattern_num_zp
	asl
	asl
	asl
	tax
;X=pattern_num_zp*8
	lda	patterns+0,x
	php
	and	#$7f
	sta	bit_zp
	lda	#WM_OR
	plp
	bpl	st_skp1
	lda	#WM_STORE
st_skp1:
	sta	SM_WRITEMODE

	lda	patterns+1,x
	sta	offs_zp
	ldy	#0
st_lp1:
	lda	patterns+2,x
	sta	$3f80+3*2,y
	sta	$3f80+3*10,y
	sta	$3f80+3*18,y
	lda	patterns+5,x
	sta	$3fc0+3*2,y
	sta	$3fc0+3*10,y
	sta	$3fc0+3*18,y
	inx
	iny
	cpy	#3
	bne	st_lp1
	rts

bittab:
	dc.b	%00000001
	dc.b	%00000010
	dc.b	%00000100
	dc.b	%00001000
	dc.b	%00010000
	dc.b	%00100000
	dc.b	%01000000
	dc.b	%10000000

NUM_TESTS	equ	8
sprmask:
	dc.w	BUFFER+$0000
	dc.b	0,1
	dc.w	BUFFER+$0200
	dc.b	1,2
	dc.w	BUFFER+$0400
	dc.b	2,3
	dc.w	BUFFER+$0600
	dc.b	3,4
	dc.w	BUFFER+$0800
	dc.b	4,5
	dc.w	BUFFER+$0a00
	dc.b	5,6
	dc.w	BUFFER+$0c00
	dc.b	6,7
	dc.w	BUFFER+$0e00
	dc.b	7,0

NUM_PATTERNS	equ	1
patterns:
	dc.b	%10000001	;pattern
	dc.b	0		;offset
	dc.b	%10000000,%00000000,%00000000 ;SUT
	dc.b	%10000000,%00000000,%00000000 ;SUP

	
	
SPLITPOS1	equ	SPRPOS+2
postab1:
	dc.b	SPLITPOS1+8*0, SPLITPOS1+8*1, SPLITPOS1+8*2, SPLITPOS1+8*3
	dc.b	SPLITPOS1+8*4, SPLITPOS1+8*5, SPLITPOS1+8*6, SPLITPOS1+8*7
	dc.b	SPLITPOS1+8*8, SPLITPOS1+8*9, SPLITPOS1+8*10,SPLITPOS1+8*11
	dc.b	SPLITPOS1+8*12,SPLITPOS1+8*13,SPLITPOS1+8*14,SPLITPOS1+8*15
SPLITPOS2	equ	SPRPOS+4
postab2:
	dc.b	SPLITPOS2+8*0, SPLITPOS2+8*1, SPLITPOS2+8*2, SPLITPOS2+8*3
	dc.b	SPLITPOS2+8*4, SPLITPOS2+8*5, SPLITPOS2+8*6, SPLITPOS2+8*7
	dc.b	SPLITPOS2+8*8, SPLITPOS2+8*9, SPLITPOS2+8*10,SPLITPOS2+8*11
	dc.b	SPLITPOS2+8*12,SPLITPOS2+8*13,SPLITPOS2+8*14,SPLITPOS2+8*15
sprtab:
	dc.b	SPRPOS+8*0,    SPRPOS+8*0,    SPRPOS+8*0,    SPRPOS+8*3
	dc.b	SPRPOS+8*3,    SPRPOS+8*3,    SPRPOS+8*6,    SPRPOS+8*6
	dc.b	SPRPOS+8*6,    SPRPOS+8*9,    SPRPOS+8*9,    SPRPOS+8*9
	dc.b	SPRPOS+8*12,   SPRPOS+8*12,   SPRPOS+8*12,   SPRPOS+8*15
	

;**************************************************************************
;*
;* NAME  ref_data
;*
;******

BUFFER		equ	$4000
BUFFER_END	equ	$5000



; eof
