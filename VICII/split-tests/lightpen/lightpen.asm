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
enable_zp:
	ds.b	1
cycle_zp:
	ds.b	1

;**************************************************************************
;*
;* common startup and raster code
;*
;******
HAVE_TEST_RESULT	equ	1
;HAVE_STABILITY_GUARD	equ	1
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
	dc.b	147,"LIGHTPEN R03 / TLR",13,13
	dc.b	"TIMING: ",0
cycles_line_msg:
	dc.b	" CYCLES/LINE, ",0
lines_msg:
	dc.b	" LINES",13,13
	dc.b	"MEASURING $D011 AT CYCLE $00...",0

show_params:
	lda	$d3
	sec
	sbc	#18
	tay
	lda	pt_sm1+1
	jsr	update_hex

	lda	$d3
	sec
	sbc	#5
	tay
	lda	cycle_zp
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

	lda	#0
tr_lp1:
	sta	cnt_zp
	ldx	cnt_zp
	lda	ref_data,x
	sta	rptr_zp
	lda	ref_data+1,x
	sta	rptr_zp+1
	beq	tr_ex1

	lda	#<BUFFER
	sta	ptr_zp
	lda	#>BUFFER
	sta	ptr_zp+1

; check for matches
	ldx	#5
	ldy	#0
tr_lp2:
	lda	(ptr_zp),y
	cmp	(rptr_zp),y
	bne	tr_mismatch	;Z=1
	iny
	bne	tr_lp2
	inc	ptr_zp+1
	inc	rptr_zp+1
	dex
	bne	tr_lp2
	jmp	tr_match

tr_mismatch:
	lda	cnt_zp
	clc
	adc	#4
	jmp	tr_lp1

tr_match:
	lda	#5
	sta	$d020
	
	lda	#<matches_msg
	ldy	#>matches_msg
	jsr	$ab1e

	ldx	cnt_zp
	lda	ref_data+2,x
	ldy	ref_data+3,x
	jsr	$ab1e

	lda	#<matches2_msg
	ldy	#>matches2_msg
	jsr	$ab1e

	jmp	tr_ex2
	
tr_ex1:
	lda	#15
	sta	$d020
	lda	#<nomatches_msg
	ldy	#>nomatches_msg
	jsr	$ab1e

tr_ex2:
	lda	#<result_msg
	ldy	#>result_msg
	jsr	$ab1e


	rts

done_msg:
	dc.b	"DONE",13,13,0

matches_msg:
	dc.b	5,"> MATCHES ",0
matches2_msg:
	dc.b	" <",154,0

nomatches_msg:
	dc.b	5,"> NO MATCHES! <",154,0

result_msg:
	dc.b	13,13,"(RESULT AT $4000-$4500)",0

	
;**************************************************************************
;*
;* NAME  test_prepare
;*   
;******
test_prepare:
	lda	#%11111111
	sta	$dc00
	lda	#%00000000
	sta	$dc02
	lda	#%11111111
	sta	$dc01
	sta	$dc03
	lda	#$0f
	sta	$d019		; clear interrupts

	lda	#0
	sta	enable_zp
	sta	cycle_zp

;	lda	#$1b | (>LINE << 7)
	lda	#$9b
	sta	$d011
	lda	num_lines
	sec
	sbc	#4
;	lda	#<LINE
	sta	$d012

	rts

	
;**************************************************************************
;*
;* NAME  test_perform
;*   
;******
test_perform:
	lda	enable_zp
	beq	pt_ex1

	ds.b	4,$ea

	lda	cycle_zp
	jsr	delay
	inc	$d020
	dec	$d020

	ldx	cycle_zp
pt_sm2:
	sta	BUFFER,x
	lda	$d019
	and	#$0f
	sta	BUFFER+$0400,x
	lda	#$0f
	sta	$d019		; clear interrupts

; cosmetic print out
	jsr	show_params

; increase cycle
	inc	cycle_zp
	bne	pt_skp1
	inc	pt_sm1+1
	inc	pt_sm2+2
pt_skp1:
	lda	pt_sm1+1
	cmp	#$15
	bne	pt_ex1

	lda	#$60
	sta	test_perform
	sta	test_done
pt_ex1:
	lda	enable_zp
	eor	#1
	sta	enable_zp

	rts

	align	256
delay:
	eor	#$ff
	lsr
	sta	dl_sm1+1
	bcc	dl_skp1
dl_skp1:
	if	1
; fixes cycle glitch for values $fe and $ff
	clv
dl_sm1:
	bvc	dl_skp1
	else
; has cycle glitch for values $fe and $ff
	nop
dl_sm1:
	bne	dl_skp1
	endif
	ds.b	127,$ea
;******
; start of test
	ldx	#%00000000
	stx	$dc01
pt_sm1:
	lda	$d011
	ldx	#%11111111
	stx	$dc01
	rts

BUFFER	equ	$4000



;**************************************************************************
;*
;* NAME  ref_data
;*   
;******
ref_data:
	dc.w	tab6567,msg6567
	dc.w	tab6569r1,msg6569r1
	dc.w	tab6569r3r4,msg6569r3r4
	dc.w	tab6572r1,msg6572r1
	dc.w	tab8562r4,msg8562r4
	dc.w	tab8564,msg8564
	dc.w	tab8564r5,msg8564r5
	dc.w	tab8565r2,msg8565r2
	dc.w	tabdtv3pal,msgdtv3pal
	dc.w	0
;---
msg6567:
	dc.b	"6567",0
tab6567:
	incbin	"dump6567.bin"
;---
msg6569r1:
	dc.b	"6569R1",0
tab6569r1:
	incbin	"dump6569r1.bin"
;---
msg6569r3r4:
	dc.b	"6569R3/R4",0
tab6569r3r4:
	incbin	"dump6569.bin"
;---
msg6572r1:
	dc.b	"6572R1",0
tab6572r1:
	incbin	"dump6572.bin"
;---
msg8562r4:
	dc.b	"8562R4",0
tab8562r4:
	incbin	"dump8562r4.bin"
;---
msg8564:
	dc.b	"8564",0
tab8564:
	incbin	"dump8564.bin"
;---
msg8564r5:
	dc.b	"8564R5",0
tab8564r5:
	incbin	"dump8564r5.bin"
;---
msg8565r2:
	dc.b	"8565R2",0
tab8565r2:
	incbin	"dump8565.bin"
;---
msgdtv3pal:
	dc.b	"DTV3 PAL",0
tabdtv3pal:
	incbin	"dumpdtv3.bin"
;---

; eof
