;**************************************************************************
;*
;* FILE  modesplit.asm
;* Copyright (c) 2010 Daniel Kahlin <daniel@kahlin.net>
;* Written by Daniel Kahlin <daniel@kahlin.net>
;*
;* DESCRIPTION
;*
;******
	processor 6502

SCREENSHOTEXIT  equ 1
	
LINE		equ	56
TEST_NAME	eqm	"modesplit"
TEST_REVISION	eqm	"r03"
LABEL_LOWERCASE	equ	1

	seg.u	zp
;**************************************************************************
;*
;* SECTION  zero page
;*
;******
	org	$02
ptr_zp:
	ds.w	1
tm1_zp:
	ds.b	1
tm2_zp:
	ds.b	1
guard_zp:
	ds.b	2

;**************************************************************************
;*
;* common startup and raster code
;*
;******
HAVE_STABILITY_GUARD	equ	1
HAVE_ADJUST		equ	1
	include	"../common/startup.asm"

	include	"../common/onescreen.asm"

;**************************************************************************
;*
;* NAME  test_present
;*
;******
test_present:
	jsr	show_label_bar
	rts


;**************************************************************************
;*
;* NAME  test_prepare
;*
;******
test_prepare:

; set up screen
	ldx	#0
prt_lp1:
	lda	#$5f
	sta	$0428,x
	sta	$0500,x
	sta	$0600,x
	sta	$06e8,x
	lda	#14
	sta	$d828,x
	sta	$d900,x
	sta	$da00,x
	sta	$dae8,x
	inx
	bne	prt_lp1

	jsr	adjust_timing

	lda	#$17
	sta	$d018	

	lda	#$1b | (>LINE << 7)
	sta	$d011
	lda	#<LINE
	sta	$d012
	rts

	
;******
; One 8 char high chunk
	mac	CHUNK
	ldy	#$08
	bne	.+4
.lp1:
	ds.b	9,$ea
	sty	$d016
	lda	#7
	sta	$d021
	lda	#6
	sta	$d021
	ds.b	7,$ea
	EOL

	jsr	{1}

	ldx	#$1b
	stx	$d011
	sty	$d016
	ds.b	1,$ea
	EOL

	iny
	cpy	#$10
	bne	.lp1
	endm
	
	align	256
test_start:
;**************************************************************************
;*
;* NAME  test_perform
;*
;******
test_perform:
	lda	$dc06
	sta	guard_zp+0
	bit	$ea
	ds.b	1,$ea
; start 1
	CHUNK 	section1
; start 2
	CHUNK 	section2
; start 3
	CHUNK 	section3
; end
	bit	$ea
	ds.b	4,$ea	
	lda	#$1b
	sta	$d011
	lda	#$08
	sta	$d016
	lda	#7
	sta	$d021
	lda	#6
	sta	$d021
	ds.b	7,$ea
	EOL
	lda	$dc06
	sta	guard_zp+1


	ldx	#1
tp_lp1:
	ldy	guard_zp,x
	jsr	update_guard
	dex
	bpl	tp_lp1

	jsr	show_guards
	rts

	align	256


;**************************************************************************
;*
;* NAME  section1
;*
;******
section1:
	repeat	6
	EOL
	ds.b	2,$ea
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
	ds.b	3,$ea
	bit	$ea
	repend
	rts

;**************************************************************************
;*
;* NAME  section2
;*
;******
section2:
	repeat	6
	EOL
	ds.b	2,$ea
	ldx	#$1b
	stx	$d011
	sty	$d016

	ldx	#$5b
	stx	$d011
	ldx	#$1b
	stx	$d011
	ds.b	16,$ea
	bit	$ea
	repend
	rts

;**************************************************************************
;*
;* NAME  section3
;*
;******
section3:
	repeat	6
	EOL
	ds.b	2,$ea
	ldx	#$1b
	stx	$d011
	sty	$d016
	tya
	ora	#%00010000
	sta	$d016
	and	#%11101111
	sta	$d016
	ds.b	15,$ea
	bit	$ea
	repend
	rts

test_end:

; eof
