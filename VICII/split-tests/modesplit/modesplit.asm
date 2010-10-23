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

LINE		equ	56

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
	include	"../common/startup.asm"


;**************************************************************************
;*
;* NAME  test_present
;*   
;******
test_present:
	lda	#14
	sta	646
	sta	$d020
	lda	#6
	sta	$d021

	lda	#<label_msg
	ldy	#>label_msg
	jsr	$ab1e

	lda	#1
	sta	646

	lda	#NAME_POS
	sta	$d3
	lda	#<name_msg
	ldy	#>name_msg
	jsr	$ab1e
	
	lda	#CONF_POS
	sta	$d3
	lda	#0
	ldx	cycles_per_line
	jsr	$bdcd
	
	inc	$d3
	lda	#1
	ldx	num_lines
	jsr	$bdcd

	rts

NAME_POS	equ	2
CONF_POS	equ	32
name_msg:
	dc.b	"modesplit",29,"r02",0
label_msg:
	dc.b	147,"0123456789012345678901234567890123456789",19,0


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



;**************************************************************************
;*
;* NAME  adjust_timing
;*   
;******
adjust_timing:
	ldx	cycles_per_line
	lda	time2-63,x
	sta	tm1_zp
	lda	time3-63,x
	sta	tm2_zp
	
	lda	#<test_start
	sta	ptr_zp
	lda	#>test_start
	sta	ptr_zp+1
	ldx	#>[test_end-test_start+255]
at_lp1:
	ldy	#0
	lda	#$d8		; cld
	cmp	(ptr_zp),y
	bne	at_skp1
	iny
	cmp	(ptr_zp),y
	bne	at_skp1
	dey
	lda	tm1_zp
	sta	(ptr_zp),y
	iny
	lda	tm2_zp
	sta	(ptr_zp),y
at_skp1:
	inc	ptr_zp
	bne	at_lp1
	inc	ptr_zp+1
	dex
	bne	at_lp1

	rts

; eor #$00 (2),  bit $ea (3),  nop; nop (4)
time2:
	dc.b	$49, $24, $ea
time3:
	dc.b	$00, $ea, $ea

	
;******
; end of line marker
	mac	EOL
	ds.b	2,$d8
	endm
	
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

	ldx	#0
	ldy	guard_zp+0
	jsr	update_guard
	inx
	ldy	guard_zp+1
	jsr	update_guard


	lda	#1
	sta	$d81c
	sta	$d81d
	sta	$d81e

	ldx	#0
	jsr	check_guard
	tay
	lda	#"A"
	cpy	#1
	beq	tp_skp1
	ora	#"0"
	cpy	#9+1
	bcc	tp_skp1
	lda	#"!"
tp_skp1:
	sta	$041c,x

	ldx	#1
	jsr	check_guard
	tay
	lda	#"B"
	cpy	#1
	beq	tp_skp2
	ora	#"0"
	cpy	#9+1
	bcc	tp_skp1
	lda	#"!"
tp_skp2:
	sta	$041c,x

	lda	#"-"
	ldy	guard_count+0
	cpy	#1
	bne	tp_skp3
	ldy	guard_count+1
	cpy	#1
	bne	tp_skp3
	ldy	guard_last_cycle+0
	cpy	guard_last_cycle+1
	bne	tp_skp3
	lda	#"+"
tp_skp3:
	sta	$041e
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
