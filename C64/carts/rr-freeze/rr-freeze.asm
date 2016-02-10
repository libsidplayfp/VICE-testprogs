;**************************************************************************
;*
;* FILE  rr-freeze.asm
;* Copyright (c) 2016 Daniel Kahlin <daniel@kahlin.net>
;* Written by Daniel Kahlin <daniel@kahlin.net>
;*
;* DESCRIPTION
;*   Retro Replay freeze mode tests
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


	seg.u	bss
;**************************************************************************
;*
;* SECTION  storage
;*
;******
	org	$0800		; FIXME: shouldn't overlap
tab_selected:
	ds.b	1
de01_selected:
	ds.b	1

	org	$0800		; FIXME: shouldn't overlap
de00_pre:
	ds.b	1
de01_pre:
	ds.b	1
de00_post:
	ds.b	1
de01_post:
	ds.b	1

	org	$0800		; FIXME: shouldn't overlap
de00_store1:
	ds.b	256
de00_store2:
	ds.b	256
de00_store3:
	ds.b	256
df00_store1:
	ds.b	256
df00_store2:
	ds.b	256
df00_store3:
	ds.b	256


	seg	code
	org	$8000
;**************************************************************************
;*
;* SECTION  cartridge entry
;*
;******
	dc.w	reset_entry
	dc.w	warm_entry
	dc.b    "C"|$80,"B"|$80,"M"|$80,"8","0"


reset_entry:
warm_entry:
	sei
	cld
	ldx	#$ff
	txs
	lda	#$37
	sta	$01
	lda	#$2f
	sta	$00


	jsr	$fda3
	jsr	clone_ff87
	jsr	clone_ff8a
	jsr	$ff5b

	lda	#<greet_msg
	ldy	#>greet_msg
	jsr	print_str
	cli
	lda	#0
	sta	tab_selected
re_lp1:
	lda	#0
	sta	$d3
	lda	#<sel1_msg
	ldy	#>sel1_msg
	jsr	print_str
	ldx	tab_selected
	lda	de01_tab,x
	sta	de01_selected
	jsr	print_hex
	lda	#<sel2_msg
	ldy	#>sel2_msg
	jsr	print_str

re_lp2:
	jsr	$ffe4
	beq	re_lp2
	cmp	#13
	beq	re_done
	cmp	#"1"
	bcc	re_lp2
	cmp	#"8"+1
	bcs	re_lp2
	sec
	sbc	#"1"
	sta	tab_selected
	jmp	re_lp1

re_done:
	jmp	perform_test
	

greet_msg:
	dc.b	147,"RR-FREEZE R02 / TLR",13,13
	dc.b	"THIS PROGRAM VERIFIES THE CART STATE",13
	dc.b	"DURING FREEZING.",13,13,0

sel1_msg:
	dc.b	"$DE01=$",0
sel2_msg:
	dc.b	"  (PRESS 1-8, RETURN)",0


de01_tab:
	dc.b	%01000000	; REU-Comp=1, NoFreeze=0, AllowBank=0
	dc.b	%00000000	; REU-Comp=0, NoFreeze=0, AllowBank=0
	dc.b	%01000010	; REU-Comp=1, NoFreeze=0, AllowBank=1
	dc.b	%00000010	; REU-Comp=0, NoFreeze=0, AllowBank=1
	dc.b	%01000100	; REU-Comp=1, NoFreeze=1, AllowBank=0
	dc.b	%00000100	; REU-Comp=0, NoFreeze=1, AllowBank=0
	dc.b	%01000110	; REU-Comp=1, NoFreeze=1, AllowBank=1
	dc.b	%00000110	; REU-Comp=0, NoFreeze=1, AllowBank=1


;**************************************************************************
;*
;* NAME  perform_test, continue_test
;*
;* DESCRIPTION
;*   Do freeze test
;*
;******
perform_test:

; initial setup of RR-mode
	lda	de01_selected
	sta	$de01

	sei
	ldx	#0
	; fill buffers with $aa
	lda	#$aa
pt_lp1:
	sta	de00_store1,x
	sta	de00_store2,x
	sta	de00_store3,x
	sta	df00_store1,x
	sta	df00_store2,x
	sta	df00_store3,x
	inx
	bne	pt_lp1
	
	ldx	#PREPARE_LEN
pt_lp2:
	lda	prepare_st-1,x
	sta	prepare-1,x
	dex
	bne	pt_lp2

	jsr	prepare
	lda	$de00
	sta	de00_pre
	lda	$de01
	sta	de01_pre
	cli
	
	lda	#<freeze_msg
	ldy	#>freeze_msg
	jsr	print_str
	
; cursor on
	lda	#0
	sta	$cc
	lda	646
	sta	$d826
	sta	$d827
	
pt_lp3:
	lda	$de00
	sta	$0426
	lda	$de01
	sta	$0427
	jmp	pt_lp3

        ; prepare cartridge RAM with pattern:
        ; de10..deff gets 10 11 12 13..
        ; df00..dfff gets 10 11 12 13..
prepare_st:
	rorg	$0120
prepare:
	lda	#%00100011
	sta	$de00
	ldx	#0
prp_lp1:
	txa
	cpx	#$10
	bcc	prp_skp1
	sta	$9e00,x
prp_skp1:
	clc
	adc	#$10
	sta	$9f00,x
	inx
	bne	prp_lp1
	lda	#%00000000
	sta	$de00
	rts

	rend
PREPARE_LEN	equ	.-prepare_st


;******
;* continue after freezing
continue_test:
; clear cursor
	inc	$cc
	ldy	$d3
	lda	#$20
	sta	($d1),y

; present state
	lda	#<thank_you_msg
	ldy	#>thank_you_msg
	jsr	print_str

	lda	de00_pre
	jsr	print_hex
	jsr	print_space
	lda	de01_pre
	jsr	print_hex
	jsr	print_space
	lda	de00_post
	jsr	print_hex
	jsr	print_space
	lda	de01_post
	jsr	print_hex
	jsr	print_cr
	jsr	print_cr

	lda	#<[de00_store1+$10]
	ldy	#>[de00_store1+$10]
	jsr	dump_hex
	jsr	print_cr
	lda	#<[de00_store1+$e0]
	ldy	#>[de00_store1+$e0]
	jsr	dump_hex
	jsr	print_cr

	lda	#<[de00_store2+$10]
	ldy	#>[de00_store2+$10]
	jsr	dump_hex
	jsr	print_cr
	lda	#<[de00_store2+$e0]
	ldy	#>[de00_store2+$e0]
	jsr	dump_hex
	jsr	print_cr

	lda	#<[de00_store3+$10]
	ldy	#>[de00_store3+$10]
	jsr	dump_hex
	jsr	print_cr
	lda	#<[de00_store3+$e0]
	ldy	#>[de00_store3+$e0]
	jsr	dump_hex
	jsr	print_cr

	lda	#<[df00_store1+$10]
	ldy	#>[df00_store1+$10]
	jsr	dump_hex
	jsr	print_cr
	lda	#<[df00_store1+$e0]
	ldy	#>[df00_store1+$e0]
	jsr	dump_hex
	jsr	print_cr

	lda	#<[df00_store2+$10]
	ldy	#>[df00_store2+$10]
	jsr	dump_hex
	jsr	print_cr
	lda	#<[df00_store2+$e0]
	ldy	#>[df00_store2+$e0]
	jsr	dump_hex
	jsr	print_cr

	lda	#<[df00_store3+$10]
	ldy	#>[df00_store3+$10]
	jsr	dump_hex
	jsr	print_cr
	lda	#<[df00_store3+$e0]
	ldy	#>[df00_store3+$e0]
	jsr	dump_hex
	jsr	print_cr

	
	
ct_lp1:
	jmp	ct_lp1



freeze_msg:
	dc.b	13,13,"PRESS THE FREEZE BUTTON PLEASE...",0

thank_you_msg:
	dc.b	13,"THANK YOU.",13,13,0



;**************************************************************************
;*
;* NAME  clone_ff87
;*
;* DESCRIPTION
;*   Setup zp.
;*
;******
clone_ff87:
	lda	#0
	tay
c87_lp1:
	sta	$0002,y
	sta	$0200,y
	sta	$0300,y
	iny
	bne	c87_lp1

	lda	#$03
	sta	$b2
	lda	#$3c
	sta	$b3
	ldx	#$00
	ldy	#$a0
	jmp	$fd8c		; set membounds


;**************************************************************************
;*
;* NAME  clone_ff8a
;*
;* DESCRIPTION
;*   Clean set up of kernal vectors.
;*
;******
clone_ff8a:
	ldx	#32-1
c8a_lp1:
	lda	$fd30,x
	sta	$0314,x
	dex
	bpl	c8a_lp1
	rts


;**************************************************************************
;*
;* NAME  print_space, print_cr
;*
;* DESCRIPTION
;*   output common chars.
;*
;******
print_space:
	lda	#" "
	dc.b	$2c
print_cr:
	lda	#13
	jmp	$ffd2
;	rts


;**************************************************************************
;*
;* NAME  print_str
;*
;* DESCRIPTION
;*   Print string pointed to by Acc/Y.
;*
;******
print_str:
	sta	ptr_zp
	sty	ptr_zp+1
	ldy	#0
ps_lp1:
	lda	(ptr_zp),y
	beq	ps_ex1
	jsr	$ffd2
	iny
	bne	ps_lp1
ps_ex1:
	rts


;**************************************************************************
;*
;* NAME  print_hex
;*
;* DESCRIPTION
;*   output hex byte.
;*
;******
print_hex:
	pha
	lsr
	lsr
	lsr
	lsr
	jsr	ph_skp1
	pla
	and	#$0f
ph_skp1:
	cmp	#10
	bcc	ph_skp2
; C=1
	adc	#"A"-"0"-10-1
; C=0
ph_skp2:
	adc	#"0"
	jmp	$ffd2



;**************************************************************************
;*
;* NAME  dump_hex
;*
;* DESCRIPTION
;*   Dump 16 bytes of hex pointed to by Acc/Y.
;*
;******
dump_hex:
	sta	ptr_zp
	sty	ptr_zp+1
	ldy	#0
dh_lp1:
	lda	(ptr_zp),y
	jsr	print_hex
	lda	$c7
	eor	#$80
	sta	$c7
	iny
	cpy	#$10
	bne	dh_lp1
	rts

	
	ds.b	$9e00-.,$ff
;**************************************************************************
;*
;* SECTION  $de00 ROM
;*
;******
	rorg	$de00
start_de00rom:
control_regs:
	ds.b	$10,0		; place holder for control registers

;******
;* bank switching logic
cart_in:
	php
	pha
	lda	#%00000000
	beq	cart_common	; always taken

cart_out:
	php
cart_out_rti:
	pha
	lda	#%00000010
cart_common:
	sta	$de00
	pla
	plp
	rts
end_de00rom:
	rend

	echo	"de00rom",start_de00rom,end_de00rom

	ds.b	$9f00-.,$ff
;**************************************************************************
;*
;* SECTION  $ff00 freeze ROM
;*
;******
freeze_st:
	rorg	freeze_st-$8000+$e000
freeze_entry:
	sei
	cld
	ldx	#$ff
	txs

	; read registers de00/de01
	lda	$de00
	sta	de00_post
	lda	$de01
	sta	de01_post
	
	ldx	#0
fr_lp1:
	cpx	#$10
	bcc	fr_skp1
	; read from de00..de0f and save
	; de00_store1 contains copy of ROM or Cartridge RAM or I/O
	lda	$de00,x
	sta	de00_store1,x
	; eor value with $ff and write back
	eor	#$ff
	sta	$de00,x
        ; read from de00..de0f and save
        ; de00_store2 contains copy of ROM or (Cartridge RAM ^ $ff) or I/O
	lda	$de00,x
	sta	de00_store2,x
fr_skp1:
	lda	$df00,x
	sta	df00_store1,x
	eor	#$ff
	sta	$df00,x
	lda	$df00,x
	sta	df00_store2,x
	inx
	bne	fr_lp1

	
; ack freeze
	lda	#%01100011	; RR-RAM at $8000, RR-ROM at $e000, ack freeze
	sta	$de00
	lda	#%00100011	; RR-RAM at $8000, RR-ROM at $e000
	sta	$de00

	; read RAM from 9e00..9fff and save
	ldx	#0
fr_lp2:
	lda	$9e00,x
	sta	de00_store3,x
	lda	$9f00,x
	sta	df00_store3,x
	inx
	bne	fr_lp2


; exit kernal rom and enter normal rom
	lda	#$37
	sta	$01
	lda	#$2f
	sta	$00

	lda	#%00000011	; RR-ROM at $8000, RR-ROM at $e000
	sta	$de00
	jmp	fr_out
	rend
fr_out:
	lda	#%00000000	; Normal conf, RR-ROM at $8000
	sta	$de00

	jmp	continue_test

	ds.b	$9ffa-.,$ff
	dc.w	freeze_entry	; nmi vector
	dc.w	freeze_entry	; reset vector
	dc.w	freeze_entry	; irq vector

;**************************************************************************
;*
;* SECTION  next bank
;*
;******
	ds.b	$18000-.,$ff
; eof
