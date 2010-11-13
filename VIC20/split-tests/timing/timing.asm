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
cycle_zp:
	ds.b	1
test_num_zp:
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

	lda	#<measure_msg
	ldy	#>measure_msg
	jsr	$cb1e
	rts

measure_msg:
	dc.b	13,"R=$D011,C=$00...",0

show_params:
	lda	$d3
	sec
	sbc	#13
	tay
	lda	reg_under_test+1
	jsr	update_hex
	lda	reg_under_test
	jsr	update_hex

	lda	$d3
	sec
	sbc	#5
	tay
	lda	cycle_zp
	jmp	update_hex
;	rts

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
	lda	#0
	sta	cycle_zp
	sta	test_num_zp
	jsr	setup_test

	lda	$9001
	clc
	adc	#4*10
	sta	raster_line

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

	lda	cycle_zp
	jsr	delay
	tax

	lda	$900f
	eor	#$f7
	sta	$900f
	eor	#$f7
	sta	$900f

	txa
	ldx	cycle_zp
target_buf	equ	.+1
	sta	BUFFER,x

	
	ldx	#0
	ldy	guard_zp
	jsr	update_guard

; cosmetic print out
	jsr	show_params

; increase cycle
	inc	cycle_zp
	bne	tp_skp1

	inc	test_num_zp
	lda	test_num_zp
	cmp	#NUM_TESTS
	bne	tp_skp1

	lda	#0
	sta	enable_zp
	inc	test_done
	bne	tp_ex1

tp_skp1:
	jsr	setup_test

tp_ex1:

	rts

aa:
	dc.b	0


setup_test:
	lda	test_num_zp
	asl
	tax
; X=test_num_zp * 2
	lda	buftab,x
	sta	target_buf
	lda	buftab+1,x
	sta	target_buf+1
	lda	regtab,x
	sta	reg_under_test
	lda	regtab+1,x
	sta	reg_under_test+1
	rts

	
NUM_TESTS	equ	3
buftab:
	dc.w	BUFFER+$0000
	dc.w	BUFFER+$0100
	dc.w	BUFFER+$0200
regtab:
	dc.w	$9003,$9004,$9100



	align	256
delay:
	eor	#$ff
	lsr
	sta	dl_sm1+1
	bcc	dl_skp1
dl_skp1:
	clv
dl_sm1:
	bvc	dl_skp1
	ds.b	127,$ea
;******
; start of test
reg_under_test	equ	.+1
	lda	$ffff
	rts


BUFFER	equ	$1800
BUFFER_END	equ	$1b00

; eof
