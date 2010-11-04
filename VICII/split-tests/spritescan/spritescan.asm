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
enable_zp:
	ds.b	1
xpos0_zp:
	ds.b	1
xpos1_zp:
	ds.b	1
xposmsb_zp:
	ds.b	1
bufptr_zp:
	ds.w	1
msbmask0_zp:
	ds.b	1
msbmask1_zp:
	ds.b	1
bit_zp:
	ds.b	1
tptr_zp:
	ds.w	1
offs_zp:
	ds.b	1
	
;**************************************************************************
;*
;* common startup and raster code
;*
;******
HAVE_TEST_RESULT	equ	1
;HAVE_STABILITY_GUARD	equ	1
HAVE_TEST_CONTROLLER	equ	1
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
	sta	enable_zp

; clear sprite area
	ldx	#$80
tpr_lp1:
	sta	$3f80-1,x
	dex
	bne	tpr_lp1
	
; setup initial raster line
	lda	#$1b | (>LINE << 7)
	sta	$d011
	lda	#<LINE
	sta	$d012

	rts


;**************************************************************************
;*
;* NAME  test_controller
;*
;******
test_controller:

tc_lp1:
	jsr	get_seq
	asl
	tax
	lda	tc_tab,x
	sta	tc_sm1+1
	lda	tc_tab+1,x
	sta	tc_sm1+2
tc_sm1:
	jsr	tc_sm1
	jmp	tc_lp1

cmd_exit:
	pla
	pla
	inc	test_done
	rts

CMD_END		equ	$00
CMD_CLEAR	equ	$01
CMD_CLEAR_PASS	equ	$02
CMD_PATTERN	equ	$03
CMD_PASS	equ	$04
CMD_ACCUMULATE	equ	$05
tc_tab:
	dc.w	cmd_exit
	dc.w	cmd_clear
	dc.w	cmd_clear_pass
	dc.w	cmd_pattern
	dc.w	cmd_pass
	dc.w	cmd_accumulate

	
;**************************************************************************
;*
;* NAME  test_perform
;*
;******
test_perform:
	lda	enable_zp
	bne	tp_skp1
	jmp	pt_ex1
tp_skp1:

	ldx	#0
tp_lp1:
	inc	$d020
	lda	sprtab,x
tp_sm1:
SM_SUT_YREG	equ	.+1
	sta	$d001
SM_SUP_YREG	equ	.+1
	sta	$d009

	lda	xpos0_zp
SM_SUT_XREG	equ	.+1
	sta	$d000
	lda	xpos1_zp
SM_SUP_XREG	equ	.+1
	sta	$d008
	lda	xposmsb_zp
	sta	$d010

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
	beq	tp_skp3
	lda	bit_zp
tp_skp3:
	sta	$d021
	ldy	xpos0_zp
	ora	(bufptr_zp),y
	sta	(bufptr_zp),y
	lda	#6
	sta	$d021
	
	inc	xpos0_zp
	bne	tp_skp4
	lda	msbmask0_zp
	eor	xposmsb_zp
	sta	xposmsb_zp
	inc	bufptr_zp+1
tp_skp4:

	inc	xpos1_zp
	bne	tp_skp5
	lda	msbmask1_zp
	eor	xposmsb_zp
	sta	xposmsb_zp
tp_skp5:
	
	inx
	cpx	#16
	bne	tp_lp1

	lda	xpos0_zp
	bne	pt_ex1
	lda	xposmsb_zp
	and	msbmask0_zp
	bne	pt_ex1

	lda	#0
	sta	enable_zp
pt_ex1:
	rts


;**************************************************************************
;*
;* NAME  setup_test
;*
;******
cmd_clear_pass:
	lda	#%00000001
	sta	bit_zp
	lda	#<CORR_BUF
	sta	tptr_zp
	lda	#>CORR_BUF
	sta	tptr_zp+1
	jmp	ccl_common

cmd_clear:
	jsr	get_seq
	sta	tptr_zp
	jsr	get_seq
	sta	tptr_zp+1

ccl_common:
	ldx	#2
	ldy	#0
	tya
ccl_lp1:
	sta	(tptr_zp),y
	iny
	bne	ccl_lp1
	inc	tptr_zp+1
	dex
	bne	ccl_lp1

	rts

cmd_pattern:
	jsr	get_seq
	sta	offs_zp

	ldy	#0
cpt_lp1:
	jsr	get_seq
	sta	$3f80+3*2,y
	sta	$3f80+3*10,y
	sta	$3f80+3*18,y
	iny
	cpy	#6
	bne	cpt_lp1

	ldy	#0
cpt_lp2:
	jsr	get_seq
	sta	$3fc0+3*2,y
	sta	$3fc0+3*10,y
	sta	$3fc0+3*18,y
	iny
	cpy	#6
	bne	cpt_lp2

	rts

cmd_pass:

; sprite under test
	jsr	get_seq
	tay
	lda	bittab,y
	sta	msbmask0_zp
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
	jsr	get_seq
	tay
	lda	bittab,y
	sta	msbmask1_zp
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

; setup sprite enables
	lda	msbmask0_zp
	ora	msbmask1_zp
	sta	$d015

; setup sprite positions
	lda	#0
	sta	xpos0_zp
	sta	xpos1_zp
	sta	xposmsb_zp

	lda	xpos1_zp
	sec
	sbc	offs_zp
	sta	xpos1_zp
	bcs	st_skp2
; toggle msb
	lda	msbmask1_zp
	eor	xposmsb_zp
	sta	xposmsb_zp
st_skp2:

; setup pointer
	lda	#<CORR_BUF
	sta	bufptr_zp
	lda	#>CORR_BUF
	sta	bufptr_zp+1

; run test
	inc	enable_zp
st_lp1:
	lda	enable_zp
	bne	st_lp1

; update mask for the next pass
	asl	bit_zp

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

cmd_accumulate:
	jsr	get_seq
	sta	tptr_zp
	jsr	get_seq
	sta	tptr_zp+1
	jsr	get_seq
	sta	bit_zp
	
	lda	#<CORR_BUF
	sta	bufptr_zp
	lda	#>CORR_BUF
	sta	bufptr_zp+1
; accumulate result
	ldx	#2
	ldy	#0
cac_lp1:
	lda	(bufptr_zp),y
	beq	cac_skp1
	lda	bit_zp
cac_skp1:
	ora	(tptr_zp),y
	sta	(tptr_zp),y
	iny
	bne	cac_lp1
	inc	bufptr_zp+1
	inc	tptr_zp+1
	dex
	bne	cac_lp1
	
	rts

	
get_seq:
	inc	gs_sm1+1
	bne	gs_skp1
	inc	gs_sm1+2
gs_skp1:
gs_sm1:
	lda	seq-1
	rts

	
	mac	CLEAR
	dc.b	CMD_CLEAR
	dc.w	{1}		;BUFFER
	endm
	mac	CLEAR_PASS
	dc.b	CMD_CLEAR_PASS
	endm
	mac	PASS
	dc.b	CMD_PASS
	dc.b	{1}		;SUT
	dc.b	{2}		;SUP
	endm
	mac	ACCUMULATE
	dc.b	CMD_ACCUMULATE
	dc.w	{1}		;BUFFER
	dc.b	{2}		;mask
	endm
	mac	ENDE
	dc.b	CMD_END
	endm

seq:
	CLEAR	BUFFER+$0000
	dc.b	CMD_PATTERN	;PATTERN
	dc.b	0		;offset
	dc.b	%10000000,%00000000,%00000000 ;SUT #0
	dc.b	%10000000,%00000000,%00000000 ;SUT #1
	dc.b	%10000000,%00000000,%00000000 ;SUP #0
	dc.b	%10000000,%00000000,%00000000 ;SUP #1
	CLEAR_PASS
	PASS	0,4
	PASS	0,5
	PASS	0,6
	ACCUMULATE BUFFER+$0000,%00000001

	CLEAR	BUFFER+$0200
	CLEAR_PASS
	PASS	1,5
	PASS	1,6
	PASS	1,7
	ACCUMULATE BUFFER+$0200,%00000001
	ENDE
	
	
SPLITPOS1	equ	SPRPOS+2
postab1:
	dc.b	SPLITPOS1+8*0, SPLITPOS1+8*1, SPLITPOS1+8*2, SPLITPOS1+8*3
	dc.b	SPLITPOS1+8*4, SPLITPOS1+8*5, SPLITPOS1+8*6, SPLITPOS1+8*7
	dc.b	SPLITPOS1+8*8, SPLITPOS1+8*9, SPLITPOS1+8*10,SPLITPOS1+8*11
	dc.b	SPLITPOS1+8*12,SPLITPOS1+8*13,SPLITPOS1+8*14,SPLITPOS1+8*15
SPLITPOS2	equ	SPRPOS+5
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

CORR_BUF	equ	$3000

	
BUFFER		equ	$4000
BUFFER_END	equ	$5000



; eof
