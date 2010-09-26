;**************************************************************************
;*
;* FILE  cia-int.asm
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

	jsr	test_prepare
	
	jsr	test_perform

enda:
	jmp	enda
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
	dc.w	nmi_entry,0,irq

sa_fl1:
nmi_entry:
	sei
	lda	#$37
	sta	$01
	jmp	$fe66

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

	lda	646
	ldx	#0
tpr_lp1:
	sta	$d800,x
	sta	$d900,x
	sta	$da00,x
	sta	$dae8,x
	inx
	bne	tpr_lp1
	
	rts

greet_msg:
	dc.b	147,"CIA-INT / TLR",13,13,0
	

;**************************************************************************
;*
;* NAME  test_result
;*   
;******
test_result:
	lda	#<done_msg
	ldy	#>done_msg
	jsr	$ab1e

	rts

done_msg:
	dc.b	"DONE",13,13,0


	
;**************************************************************************
;*
;* NAME  test_prepare
;*   
;******
test_prepare:
	rts

	
;**************************************************************************
;*
;* NAME  test_preform
;*   
;******
test_perform:
; stay away from bad lines
tp_lp00:
	lda	$d011
	bmi	tp_lp00
tp_lp01:
	lda	$d011
	bpl	tp_lp01
; just below the visible screen here
	
	inc	$d020
	lda	#$7f
	sta	$dc0d
	lda	$dc0d

	ldy	#0
tp_lp1:
	lda	#$a9
	sta	$dc0c
	lda	#$60
	sta	$dc0e
	sty	$dc06
	ldx	#0
	stx	$dc07
	lda	#%10000010	; timer B IRQ
	sta	$dc0d
	bit	$dc0d
	cli
	lda	#%00011001
	sta	$dc0f
	jsr	$dc0c
	sei
	bit	$dc0d
	sta	$0400+40*1,y
	txa
	sta	$0400+40*2,y
	iny
	cpy	#40
	bne	tp_lp1
	dec	$d020

	jmp	test_perform	; test forever
;	rts

irq:
	bit	$dc0d
	inx
	rti


; eof
