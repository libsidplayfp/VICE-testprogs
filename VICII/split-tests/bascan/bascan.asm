;**************************************************************************
;*
;* FILE  lightpen.asm
;* Copyright (c) 2010 Daniel Kahlin <daniel@kahlin.net>
;* Written by Daniel Kahlin <daniel@kahlin.net>
;*
;* DESCRIPTION
;*
;******
	processor 6502

	seg.u	zp
;**************************************************************************
;*
;* SECTION  zero page
;*
;******
	org	$02
ptr_zp:
	ds.w	1
rptr_zp:
	ds.w	1
cnt_zp:
	ds.b	1	


LINE	equ	48+8*16+6
	
;**************************************************************************
;*
;* common startup and raster code
;*
;******
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

	lda	#<timing_msg
	ldy	#>timing_msg
	jsr	$ab1e
	lda	#0
	ldx	cycles_per_line
	jsr	$bdcd
	lda	#<cycles_line_msg
	ldy	#>cycles_line_msg
	jsr	$ab1e
	lda	#1
	ldx	num_lines
	jsr	$bdcd
	lda	#<lines_msg
	ldy	#>lines_msg
	jsr	$ab1e
	
	rts

timing_msg:
	dc.b	147,"BASCAN R?? / TLR",13,13
	dc.b	"TIMING: ",0
cycles_line_msg:
	dc.b	" CYCLES/LINE, ",0
lines_msg:
	dc.b	" LINES",13,13
	dc.b	"MEASURING $DC04 AT CYCLE $00...",0

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
	lda	cycle
	jmp	update_hex
;	rts
	
update_hex:
	pha
	lsr
	lsr
	lsr
	lsr
	jsr	uh_common
	pla
	and	#$0f
uh_common:
	tax
	lda	htab,x
	sta	($d1),y
	iny
	rts

htab:
	dc.b	"0123456789",1,2,3,4,5,6

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


; set device num to 8 if less than 8.
	lda	#8
	cmp	$ba
	bcc	tr_skp1
	sta	$ba
tr_skp1:


	lda	#<save_msg
	ldy	#>save_msg
	jsr	$ab1e
tr_lp1:
	jsr	$ffe4
	cmp	#"Y"
	bne	tr_lp1

	lda	#$80
	sta	$9d

	lda	#1
	ldx	$ba
	tay
	jsr	$ffba
	ldx	#<filename
	ldy	#>filename
	lda	#FILENAME_LEN
	jsr	$ffbd
	ldx	#<BUFFER
	ldy	#>BUFFER
	stx	$fb
	sty	$fc
	lda	#$fb
	ldx	#<BUFFER_END
	ldy	#>BUFFER_END
	jsr	$ffd8

	lda	#<ok_msg
	ldy	#>ok_msg
	jsr	$ab1e
	rts

done_msg:
	dc.b	"DONE",13,13,0

result_msg:
	dc.b	13,13,"(RESULT AT $4000-$4900)",0

save_msg:
	dc.b	13,13,"SAVE TO DISK? ",13,0
ok_msg:
	dc.b	13,"OK",13,0

filename:
	dc.b	"BARESULT"
FILENAME_LEN	equ	.-filename
	
;**************************************************************************
;*
;* NAME  test_prepare
;*   
;******
test_prepare:
	lda	#%00000000
	sta	$dc0e
	lda	#$ff
	sta	$dc04
	sta	$dc05

	lda	#0
	sta	test_num
	jsr	setup_test

	lda	#$1b | (>LINE << 7)
	sta	$d011
	lda	#<LINE
	sta	$d012

	rts

	
;**************************************************************************
;*
;* NAME  test_preform
;*   
;******
test_perform:
	lda	cycle
	jsr	delay
	inc	$d021
	dec	$d021
	ldx	cycle
pt_sm2:
	sta	BUFFER,x

; cosmetic print out
	jsr	show_params

; increase cycle
	inc	cycle
	bne	pt_ex1

	inc	test_num
	lda	test_num
	cmp	#NUM_TESTS
	bne	pt_skp1

	lda	#$60
	sta	test_perform
	sta	test_done
	bne	pt_ex1

pt_skp1:
	jsr	setup_test
pt_ex1:
	rts

setup_test:
	lda	test_num
	asl
	tax
; X=test_num * 2
	lda	buftab,x
	sta	pt_sm2+1
	lda	buftab+1,x
	sta	pt_sm2+2
	lda	regtab,x
	sta	curr_reg
	lda	regtab+1,x
	sta	curr_reg+1

	lda	test_num
	asl
	asl
	asl
	tax
; X=test_num * 8
	ldy	#0
st_lp1:
	lda	tailtab,x
	sta	dl_tail,y
	inx
	iny
	cpy	#8
	bne	st_lp1
	rts

	
NUM_TESTS	equ	9
buftab:
	dc.w	BUFFER+$0000
	dc.w	BUFFER+$0100
	dc.w	BUFFER+$0200
	dc.w	BUFFER+$0300
	dc.w	BUFFER+$0400
	dc.w	BUFFER+$0500
	dc.w	BUFFER+$0600
	dc.w	BUFFER+$0700
	dc.w	BUFFER+$0800
regtab:
	dc.w	$dc04,$dc05,$d012,$dc04,$dc05,$d012,$dc04,$dc05,$d012
tailtab:
; test #0
	lda	$dc04
	stx	$dc0e
	eor	#$ff
; test #1
	lda	$dc05
	stx	$dc0e
	eor	#$ff
; test #2
	lda	$d012
	stx	$dc0e
	nop
	nop
; test #3
	stx	$dc0e
	lda	$dc04
	eor	#$ff
; test #4
	stx	$dc0e
	lda	$dc05
	eor	#$ff
; test #5
	stx	$dc0e
	lda	$d012
	nop
	nop
; test #6
	sta	$dc0e,x
	lda	$dc04
	eor	#$ff
; test #7
	sta	$dc0e,x
	lda	$dc05
	eor	#$ff
; test #8
	sta	$dc0e,x
	lda	$d012
	nop
	nop

curr_reg:
	dc.w	0
test_num:
	dc.b	0
cycle:
	dc.b	0

	align	256
delay:
	ldx	#%00011001
	stx	$dc0e
	ldx	#%00000000
	eor	#$ff
	lsr
	sta	dl_sm1+1
	bcc	dl_skp1
dl_skp1:
dl_sm1:
	bne	dl_skp1
	ds.b	127,$ea
	txa
; Acc=0, X=0
dl_tail:
	stx	$dc0e
	lda	$dc04
	nop
	nop
	rts

;**************************************************************************
;*
;* NAME  ref_data
;*   
;******

BUFFER		equ	$4000
BUFFER_END	equ	$4900



; eof
