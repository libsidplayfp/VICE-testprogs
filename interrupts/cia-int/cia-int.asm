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
	dc.b	147,"CIA-INT / TLR",13,13
	dc.b	"DC0C: A9 XX 60",13
	dc.b	13,13,13
	dc.b	"DC0B: 0D A9 XX 60",13
	dc.b	0
	

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
	lda	#$34
	sta	$01

; make LDA $xxA9 mostly return xx.
	ldx	#0
	stx	$00a9
	inx
	stx	$01a9
	inx
	stx	$02a9
	inx
	stx	$03a9
	
	ldx	#>[end+$ff]
tpp_lp1:
	stx	tpp_sm1+2
tpp_sm1:
	stx.w	$00a9
	inx
	bne	tpp_lp1
	
	inc	$01
	
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

	ldx	#<[$0400+40*3]
	ldy	#>[$0400+40*3]
	lda	#$0c
	jsr	do_test

	ldx	#<[$0400+40*7]
	ldy	#>[$0400+40*7]
	lda	#$0b
	jsr	do_test

	dec	$d020

	jmp	test_perform	; test forever
;	rts


do_test:
	sta	dt_sm1+1
	stx	ptr_zp
	sty	ptr_zp+1
	
	ldy	#0
dt_lp1:
	sty	cnt_zp
	lda	#$0d		;ORA #<abs>
	sta	$dc0b
	lda	#$a9		;LDA #<imm>
	sta	$dc0c
	lda	#%10000010	; timer B IRQ
	sta	$dc0d
	lda	#$60		;RTS
	sta	$dc0e
	sty	$dc06
	ldx	#0
	stx	$dc07
	txa
	bit	$dc0d
	cli
	ldy	#%00011001
	sty	$dc0f
dt_sm1:
	jsr	$dc0b
	sei
	bit	$dc0d
	ldy	cnt_zp
	sta	(ptr_zp),y
	tya
	clc
	adc	#40
	tay
	txa
	sta	(ptr_zp),y

	ldy	cnt_zp
	iny
	cpy	#24
	bne	dt_lp1
	rts

irq:
	bit	$dc0d
	inx
	rti

end:
; eof
