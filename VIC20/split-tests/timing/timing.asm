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

	seg.u	zp
;**************************************************************************
;*
;* SECTION  zero page
;*
;******
	org	$00
enable_zp:
	ds.b	1
guard_zp:
	ds.b	1


;**************************************************************************
;*
;* common startup and raster code
;*
;******
HAVE_TEST_RESULT	equ	1
HAVE_STABILITY_GUARD	equ	1
;HAVE_TEST_CONTROLLER	equ	1
	include	"../common/startup.asm"

	include	"../common/scandump.asm"


;**************************************************************************
;*
;* NAME  test_present
;*   
;******
test_present:
	jsr	show_info

	rts

;**************************************************************************
;*
;* NAME  test_result
;*
;******
test_result:
	lda	#<done_msg
	ldy	#>done_msg
	jsr	$cb1e

	lda	#<stability_msg
	ldy	#>stability_msg
	jsr	$cb1e

	ldx	#0
	jsr	check_guard
	cmp	#1
	beq	tr_skp1

	tax
	lda	#0
	jsr	$ddcd
	
	lda	#<failed_msg
	ldy	#>failed_msg
	jsr	$cb1e
	jmp	tr_skp2

tr_skp1:
	lda	#<passed_msg
	ldy	#>passed_msg
	jsr	$cb1e
tr_skp2:

	lda	#<result_msg
	ldy	#>result_msg
	jsr	$cb1e

	ldx	#<filename
	ldy	#>filename
	lda	#FILENAME_LEN
	jsr	$ffbd
	jsr	save_file
	
	rts

done_msg:
	dc.b	"DONE",13,0

stability_msg:
	dc.b	13,"STABILITY: ",0
passed_msg:
	dc.b	"PASSED",13,0
failed_msg:
	dc.b	", FAILED!",13,0

result_msg:
	dc.b	13,13,"(RESULT AT $4000-$4500)",0


filename:
	dc.b	"TMDUMP"
FILENAME_LEN	equ	.-filename

;**************************************************************************
;*
;* NAME  test_prepare
;*
;******
test_prepare:
	lda	#1
	sta	enable_zp
	rts

;**************************************************************************
;*
;* NAME  test_perform
;*
;******
test_perform:
	lda	$9114
	sta	guard_zp
	lda	enable_zp
	beq	tp_ex1

	
	lda	$900f
	eor	#$f7
	sta	$900f
	eor	#$f7
	sta	$900f
	inc	aa
	bne	skp
	inc	test_done
	lda	#0
	sta	enable_zp
skp:
	
	ldx	#0
	ldy	guard_zp
	jsr	update_guard

	jsr	check_guard
	sta	$1e00+21
	lda	#6
	sta	$9600+21
tp_ex1:

	rts

aa:
	dc.b	0

BUFFER	equ	$1800
BUFFER_END	equ	$1900

; eof
