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

;**************************************************************************
;*
;* common startup and raster code
;*
;******
HAVE_TEST_RESULT	equ	1
;HAVE_STABILITY_GUARD	equ	1
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
	rts


BUFFER	equ	$1800
BUFFER_END	equ	$1900

; eof
