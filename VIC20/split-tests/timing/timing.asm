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

	ldx	#0
	ldy	guard_zp
	jsr	update_guard

	jsr	check_guard
	sta	$1e00+21
	lda	#6
	sta	$9600+21
tp_ex1:

	rts


BUFFER	equ	$1800
BUFFER_END	equ	$1900

; eof
