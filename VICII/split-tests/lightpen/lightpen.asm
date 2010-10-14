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
	lda	#$7f
	sta	$dc0d
	lda	$dc0d
	jsr	check_time
	sta	cycles_per_line
	stx	num_lines

	jsr	test_present
	
	sei
	lda	#$35
	sta	$01

	ldx	#6
sa_lp1:
	lda	vectors-1,x
	sta	$fffa-1,x
	dex
	bne	sa_lp1

	lda	cycles_per_line
	sec
	sbc	#63
	bcc	sa_fl1		;<63, fail
	cmp	#66-63		;>=66, fail
	bcs	sa_fl1
	tax
	lda	time1,x
	sta	is_sm1+1

	jsr	test_prepare
	
	jsr	wait_vb

;	lda	#$1b | (>LINE << 7)
	lda	#$9b
	sta	$d011
	lda	num_lines
	sec
	sbc	#4
;	lda	#<LINE
	sta	$d012
	lda	#1
	sta	$d019
	sta	$d01a

	cli
	
sa_lp2:
	if	0
; be evil to timing to provoke glitches
	inx
	bpl	sa_lp2
	inc	$4080,x
	dec	$4080,x
	endif
	lda	test_done
	beq	sa_lp2
	sei
	lda	#$37
	sta	$01
	ldx	#0
	stx	$d01a
	inx
	stx	$d019
	jsr	$fda3
	jsr	test_result
sa_lp3:
	jmp	sa_lp3
	
vectors:
	dc.w	nmi_entry,0,irq_stable

sa_fl1:
nmi_entry:
	sei
	lda	#$37
	sta	$01
	jmp	$fe66

cycles_per_line:
	dc.b	0
num_lines:
	dc.b	0
test_done:
	dc.b	0
time1:
	dc.b	irq_stable2_pal, irq_stable2_ntscold, irq_stable2_ntsc
	
;**************************************************************************
;*
;* NAME  irq_stable, irq_stable2
;*   
;******
irq_stable:
	sta	accstore	; 4
	sty	ystore		; 4
	stx	xstore		; 4
	inc	$d019		; 6
	inc	$d012		; 6
is_sm1:
	lda	#<irq_stable2_pal	; 2
	sta	$fffe		; 4
	tsx			; 2
	cli			; 2
;10 * nop for PAL (63)
;11 * nop for NTSC (65)
	ds.b	11,$ea		; 22
; guard
is_lp1:
	sei
	inc	$d020
	jmp	is_lp1	

;28 cycles for NTSC (65)
;27 cycles for NTSCOLD (64)
;26 cycles for PAL (63)
irq_stable2_ntsc:
	dc.b	$2c		; bit <abs>
irq_stable2_ntscold:
	dc.b	$24		; bit <zp>
irq_stable2_pal:
	dc.b	$ea
	jsr	twelve		; 12
	jsr	twelve		; 12
;---
	txs			; 2
	dec	$d019		; 6
	dec	$d012		; 6
	lda	#<irq_stable	; 2
	sta	$fffe		; 4	=46
	lda	$d012		; 4
	eor	$d012		; 4
	beq	is2_skp1	; 2 (3)
is2_skp1:

	jsr	test_perform
		
accstore	equ	.+1
	lda	#0
xstore	equ	.+1
	ldx	#0
ystore	equ	.+1
	ldy	#0
	rti

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
;* NAME  check_time
;*   
;* DESCRIPTION
;*   Determine number of cycles per raster line.
;*   Acc = number of cycles.
;*   X = LSB of number of raster lines.
;*   
;******
check_time:
	lda	#0
	sta	$dc0e
	jsr	wait_vb
;--- raster line 0
	lda	#$fe
	sta	$dc04
	sta	$dc05		; load timer with $fefe
	lda	#%00010001
	sta	$dc0e		; start one shot timer
ct_lp1:
	bit	$d011
	bpl	ct_lp1
;--- raster line 256
	lda	$dc05		; timer msb
	eor	#$ff		; invert
; Acc = cycles per line
;--- scan for raster wrap
ct_lp2:
	ldx	$d012
ct_lp3:
	cpx	$d012
	beq	ct_lp3
	bmi	ct_lp2
	inx
; X = number of raster lines (LSB)
twelve:
	rts

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
	dc.b	147,"LIGHTPEN R02 / TLR",13,13
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
	rts

	
;**************************************************************************
;*
;* NAME  test_preform
;*   
;******
test_perform:
	lda	enable
	beq	pt_ex1

	lda	cycle
	jsr	delay
	ldx	#%00000000
	stx	$dc01
pt_sm1:
	lda	$d011
	ldx	#%11111111
	stx	$dc01
	inc	$d020
	dec	$d020
	ldx	cycle
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
	inc	cycle
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
	lda	enable
	eor	#1
	sta	enable

	rts

cycle:
	dc.b	0
enable:
	dc.b	0

	align	256
delay:
	eor	#$ff
	lsr
	sta	dl_sm1+1
	bcc	dl_skp1
dl_skp1:
dl_sm1:
	bne	dl_skp1
	ds.b	128,$ea
	rts

BUFFER	equ	$4000



;**************************************************************************
;*
;* NAME  ref_data
;*   
;******
ref_data:
	dc.w	tab6569r1,msg6569r1
	dc.w	tab6569r3,msg6569r3
	dc.w	tab6572r1,msg6572r1
	dc.w	tab8565r2,msg8565r2
	dc.w	tabdtv3pal,msgdtv3pal
	dc.w	0
;---
msg6569r1:
	dc.b	"6569R1",0
tab6569r1:
	incbin	"dump6569r1.prg",2
;---
msg6569r3:
	dc.b	"6569R3",0
tab6569r3:
	incbin	"dump6569.prg",2
;---
msg6572r1:
	dc.b	"6572R1",0
tab6572r1:
	incbin	"dump6572.prg",2
;---
msg8565r2:
	dc.b	"8565R2",0
tab8565r2:
	incbin	"dump8565.prg",2
;---
msgdtv3pal:
	dc.b	"DTV3 PAL",0
tabdtv3pal:
	incbin	"dumpdtv3.prg",2
;---

; eof
