;**************************************************************************
;*
;* FILE  ane-lax.asm
;* Copyright (c) 2011 Daniel Kahlin <daniel@kahlin.net>
;* Written by Daniel Kahlin <daniel@kahlin.net>
;*
;* DESCRIPTION
;*   Scan for ANE or LAX #<imm> behaviour.
;*
;******
	processor 6502

TEST_NAME	eqm	"ANE-LAX"
TEST_REVISION	eqm	"R01"
	
	seg.u	zp
;**************************************************************************
;*
;* SECTION  zero page
;*
;******
	org	$02
ptr_zp:
	ds.w	1
eptr_zp:
	ds.w	1
acc_zp:
	ds.b	1
x_zp:
	ds.b	1


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

	jsr	test_present
	
	sei
	jsr	test_prepare
	jsr	test_perform

	jsr	test_result
	
sa_lp1:
	jmp	sa_lp1


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
;* NAME  save_file
;*
;* DESCRIPTION
;*   Save dump file.
;*
;******
sa_zp	equ	$fb

save_file:
; set device num to 8 if less than 8.
	lda	#8
	cmp	$ba
	bcc	sf_skp1
	sta	$ba
sf_skp1:

	lda	#<save_to_disk_msg
	ldy	#>save_to_disk_msg
	jsr	$ab1e
sf_lp1:
	jsr	$ffe4
	cmp	#"N"
	beq	sf_ex1
	cmp	#"Y"
	bne	sf_lp1

	lda	#<filename_msg
	ldy	#>filename_msg
	jsr	$ab1e
	ldx	$d3
	ldy	#0
sf_lp2:
	cpy	$b7
	beq	sf_skp2
	lda	($bb),y
	jsr	$ffd2
	iny
	bne	sf_lp2		; always taken
sf_skp2:
	stx	$d3

	ldx	#<namebuf
	ldy	#>namebuf
;	lda	#NAMEBUF_LEN	; don't care
	jsr	$ffbd

	ldy	#0
sf_lp3:
	jsr	$ffcf
	sta	($bb),y
	cmp	#13
	beq	sf_skp3
	iny
	cpy	#NAMEBUF_LEN
	bne	sf_lp3
sf_skp3:
	sty	$b7

	lda	#$80
	sta	$9d
	lda	#1
	ldx	$ba
	tay
	jsr	$ffba

	lda	#$36
	sta	$01

	ldx	#<BUFFER
	ldy	#>BUFFER
	stx	sa_zp
	sty	sa_zp+1
	lda	#sa_zp
	ldx	#<BUFFER_END
	ldy	#>BUFFER_END
	jsr	$ffd8

	lda	#$37
	sta	$01

	lda	#<ok_msg
	ldy	#>ok_msg
	jsr	$ab1e

	lda	#<again_msg
	ldy	#>again_msg
	jsr	$ab1e
	jmp	sf_lp1
sf_ex1:
	lda	#<ok_msg
	ldy	#>ok_msg
	jsr	$ab1e
	rts

save_to_disk_msg:
	dc.b	13,13,"SAVE TO DISK? ",0
again_msg:
	dc.b	13,"SAVE AGAIN? ",0
filename_msg:
	dc.b	13,"FILENAME: ",0
ok_msg:
	dc.b	13,"OK",13,0
NAMEBUF_LEN	equ	32
namebuf:
	ds.b	NAMEBUF_LEN



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

	lda	#<greet_msg
	ldy	#>greet_msg
	jsr	$ab1e

	lda	#<testing_msg
	ldy	#>testing_msg
	jsr	$ab1e
	rts

greet_msg:
	dc.b	147,TEST_NAME," ",TEST_REVISION," / TLR",13,13
	dc.b	0

testing_msg:
	dc.b	13,"SCANNING ANE ($8B) & LAX ($AB)...",0
	
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
	dc.b	"DONE",13,0

result_msg:
	dc.b	13,13,"(RESULT AT $2FC0-$C000)",0

filename:
	dc.b	"ALRESULT"
FILENAME_LEN	equ	.-filename
	
;**************************************************************************
;*
;* NAME  test_prepare
;*
;******
test_prepare:
; setup info area
	ldx	#0
	txa
tpr_lp1:
	sta	BUFFER,x
	inx
	bne	tpr_lp1

	ldx	#IDENT_LEN
tpr_lp2:
	lda	ident-1,x
	sta	BUFFER-1,x
	dex
	bne	tpr_lp2

	rts

ident:
	dc.b	TEST_NAME," ",TEST_REVISION
IDENT_LEN	equ	.-ident
	
	
;**************************************************************************
;*
;* NAME  test_perform
;*
;******
test_perform:
	lda	#$0b
	sta	$d011
	lda	$dd00
	and	#%11111100
	sta	$dd00
	lda	#0
	sta	$f9ff
	sta	$ffff
	jsr	wait_vb
	
	lda	#<BUFFER_RES
	sta	ptr_zp
	lda	#>BUFFER_RES
	sta	ptr_zp+1

	lda	#$8b		;ANE #<imm>
	jsr	run_tests
	lda	#$ab		;LAX #<imm>
	jsr	run_tests


	lda	#14
	sta	$d020
	lda	#$1b
	sta	$d011
	lda	$dd00
	ora	#%00000011
	sta	$dd00
	rts

run_tests:
	sta	iut_op
	lda	#$ff
	jsr	run_test
	lda	#0
	jsr	run_test
	lda	#$5a
	jsr	run_test
	lda	#$a5
	jsr	run_test
	rts


ACC_STRIDE	equ	3
X_STRIDE	equ	5
SCAN_LEN	equ	$1200

run_test:
	sta	iut_op+1
	lda	#0
	sta	acc_zp
	lda	#0
	sta	x_zp
	lda	ptr_zp
	clc
	adc	#<SCAN_LEN
	sta	eptr_zp
	lda	ptr_zp+1
	adc	#>SCAN_LEN
	sta	eptr_zp+1

rt_lp1:
	jsr	iut

	ldy	#0
	sta	(ptr_zp),y
	sta	$d020
	lda	acc_zp
	clc
	adc	#ACC_STRIDE
	sta	acc_zp
	lda	x_zp
	clc
	adc	#X_STRIDE
	sta	x_zp

	inc	ptr_zp
	bne	rt_skp1
	inc	ptr_zp+1
rt_skp1:
	lda	ptr_zp
	cmp	eptr_zp
	lda	ptr_zp+1
	sbc	eptr_zp+1
	bcc	rt_lp1

	rts


iut:
	lda	acc_zp
	ldx	x_zp
iut_op:	dc.b	$8b,0		;ane #<imm>
	rts

	
;**************************************************************************
;*
;* NAME  ref_data
;*
;******

BUFFER		equ	$2fc0
BUFFER_RES	equ	$3000
BUFFER_END	equ	BUFFER_RES+SCAN_LEN*8

	echo	BUFFER,BUFFER_END

; eof
