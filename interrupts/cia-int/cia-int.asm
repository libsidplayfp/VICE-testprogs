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
test_zp:
	ds.b	1
irq_zp:
	ds.b	1
time_zp:
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
	dc.b	13,13,13
	dc.b	"DC0C: A4 XX A9 09 28 60",13
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

; make LDA $A9xx return xx.
	ldx	#0
tpp_lp2:
	txa
	sta	$a900,x
	inx
	bne	tpp_lp2
	
	inc	$01

; initial test sequencer
	lda	#0
	sta	test_zp

	lda	#$ff
	sta	$dc02
	sta	$dc03
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
	sta	$dd0d
	lda	$dc0d
	lda	$dd0d

	ldx	test_zp
	jsr	do_test

	ldx	test_zp
	inx
	cpx	#3
	bne	tp_skp1
	ldx	#0
tp_skp1:
	stx	test_zp

	dec	$d020

	jmp	test_perform	; test forever
;	rts

scrtab_l:
	dc.b	<[$0400+40*3]
	dc.b	<[$0400+40*7]
	dc.b	<[$0400+40*11]
scrtab_h:
	dc.b	>[$0400+40*3]
	dc.b	>[$0400+40*7]
	dc.b	>[$0400+40*11]
addrtab:
	dc.b	$0c
	dc.b	$0b
	dc.b	$0c
convtab:
	dc.b	$ea		; NOP
	dc.b	$ea		; NOP
	dc.b	$98		; TYA
offstab:
	dc.b	SEQTAB1
	dc.b	SEQTAB2
	dc.b	SEQTAB3
	
seqtab:
SEQTAB1	equ	.-seqtab
	dc.b	$0c,$a9		; LDA #<imm>
	dc.b	$0d,%10000010	; timer B IRQ
	dc.b	$0e,$60		; RTS
	dc.b	$ff

SEQTAB2	equ	.-seqtab
	dc.b	$0f,%00000000	; TOD clock mode
	dc.b	$0b,$0d		; ORA <abs>
	dc.b	$0c,$a9		; LDA #<imm>
	dc.b	$0d,%10000010	; timer B IRQ
	dc.b	$0e,$60		; RTS
	dc.b	$ff

SEQTAB3	equ	.-seqtab
	dc.b	$0c,$ac		; LDY <abs>
	dc.b	$0d,%10000010	; timer B IRQ
	dc.b	$0e,$a9		;
;	dc.b	$0f,%10000000	; ORA #<imm> or PHP 
	dc.b	$10,$28		; PLP
	dc.b	$11,$60		; RTS
	dc.b	$ff

	
do_test:
	lda	scrtab_l,x
	sta	ptr_zp
	lda	scrtab_h,x
	sta	ptr_zp+1
	lda	addrtab,x
	sta	dt_sm1+1
	lda	convtab,x
	sta	dt_sm2

; set up test parameters
	ldy	offstab,x
dt_lp0:
	lda	seqtab,y
	bmi	dt_skp1
	sta	dt_sm0+1
	lda	seqtab+1,y
dt_sm0:
	sta	$dc00
	iny
	iny
	bne	dt_lp0
dt_skp1:

	ldy	#0
dt_lp1:
	sty	cnt_zp

	lda	#255
	sta	$dd04
	ldx	#0
	stx	$dd05
	sty	$dc06
	stx	$dc07
	stx	irq_zp
	stx	time_zp
	txa
	bit	$dc0d
	cli
	ldy	#%00011001
;-------------------------------
; Test start
;-------------------------------
	sty	$dd0e		; measurement
	sty	$dc0f
dt_sm1:
	jsr	$dc0c
	sei
	bit	$dc0d
;-------------------------------
; Test end
;-------------------------------
dt_sm2:
	nop
	ldy	cnt_zp
	cmp	#0
	bne	dt_skp2
	lda	#"-"
dt_skp2:
	sta	(ptr_zp),y
	tya
	clc
	adc	#40
	tay
	lda	time_zp
	eor	#$7f
	clc
	sbc	#16
	ldx	irq_zp
	bne	dt_skp3
	lda	#"-"
dt_skp3:
	sta	(ptr_zp),y

	ldy	cnt_zp
	iny
	cpy	#24
	bne	dt_lp1
	rts

irq:
	ldx	$dd04
	bit	$dc0d
	stx	time_zp
	inc	irq_zp
	rti

end:
; eof
