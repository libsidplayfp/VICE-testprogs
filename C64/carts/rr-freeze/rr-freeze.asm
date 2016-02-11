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


;******
;* tag to place in each bank for identification by scanning
CHK_MAGIC	equ	$35
	mac	BANK_TAG
	dc.b	"BANK"
	dc.b	{1}				; page
	dc.b	{2}				; bank
	dc.b	{3}				; is_rom?
	dc.b	"B"^"A"^"N"^"K"^{1}^{2}^{3}^CHK_MAGIC	; checksum
	endm


	seg.u	zp
;**************************************************************************
;*
;* SECTION  zero page
;*
;******
	org	$02
ptr_zp:
	ds.w	1
tmp_zp:
	ds.b	1
chk_zp:
	ds.b	1
page_zp:
	ds.b	1
bank_zp:
	ds.b	1
wr_zp:
	ds.b	1
banks_zp:
	ds.b	5
dst_zp:
	ds.w	1
mode_zp:
	ds.b	1


	seg.u	bss
;**************************************************************************
;*
;* SECTION  storage
;*
;******
	org	$0800
tab_selected:
	ds.b	1
de01_selected:
	ds.b	1

de00_pre:
	ds.b	1
de01_pre:
	ds.b	1
de00_post:
	ds.b	1
de01_post:
	ds.b	1

;	org	$0900
de00_store1:
bank_store:			; should get it's own space.
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

code_area:
	ds.b	512


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
	dc.b	147,"RR-FREEZE R03 / TLR",13,13
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
	
	ldx	#0
pt_lp2:
	lda	prepare_st,x
	sta	prepare,x
	lda	prepare_st+$0100,x
	sta	prepare+$0100,x
	inx
	bne	pt_lp2

	jsr	prepare

	lda	#<rst_msg
	ldy	#>rst_msg
	jsr	print_areas
	jsr	print_cr

	lda	#%00100011	; RAM
	ldx	#<bank_store
	ldy	#>bank_store
	jsr	scan_banks
	jsr	print_banks
	lda	#%00000011	; ROM
	ldx	#<bank_store
	ldy	#>bank_store
	jsr	scan_banks
	jsr	print_banks

; initial setup of RR-mode
	lda	de01_selected
	sta	$de01

	lda	$de00
	sta	de00_pre
	lda	$de01
	sta	de01_pre

	lda	#<post_msg
	ldy	#>post_msg
	jsr	print_areas
	jsr	print_cr

	lda	#%00100011	; RAM
	ldx	#<bank_store
	ldy	#>bank_store
	jsr	scan_banks
	jsr	print_banks
	lda	#%00000011	; ROM
	ldx	#<bank_store
	ldy	#>bank_store
	jsr	scan_banks
	jsr	print_banks

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
	rorg	code_area
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

; enumerate banks in ram in reverse here!
	ldx	#7
prp_lp2:
	lda	bank_tab,x
	ora	#%00100011
	sta	$de00

	lda	#$9e
	jsr	tag_section
	lda	#$9f
	jsr	tag_section

	dex
	bpl	prp_lp2
	
	lda	#%00000000
	sta	$de00
	rts


scan_areas:
	php
	sei
	ldx	#0
sar_lp1:
	lda	area_tab,x
	jsr	verify_section
	sta	banks_zp,x
	inx
	cpx	#AREA_TAB_LEN
	bne	sar_lp1
	plp
	rts


scan_banks:
	php
	sei
	stx	dst_zp
	sty	dst_zp+1
	sta	mode_zp
	ldx	#0
sca_lp1:
	lda	bank_tab,x
	ora	mode_zp
	sta	$de00

	txa
	pha
	jsr	scan_areas
	
	ldy	#0
	ldx	#0
sca_lp2:
	lda	banks_zp,x
	sta	(dst_zp),y
	tya
	clc
	adc	#8
	tay
	inx
	cpx	#AREA_TAB_LEN
	bne	sca_lp2
	
	pla
	tax

	inc	dst_zp
	bne	sca_skp1
	inc	dst_zp+1
sca_skp1:
	inx
	cpx	#8
	bne	sca_lp1

	lda	#%00000000
	sta	$de00

	lda	dst_zp
	sec
	sbc	#8
	sta	dst_zp
	lda	dst_zp+1
	sbc	#0
	sta	dst_zp+1
	plp
	rts

;*******
;* Areas to scan
area_tab:
	dc.b	$9e
	dc.b	$be
	dc.b	$de
	dc.b	$df
	dc.b	$fe
AREA_TAB_LEN	equ	.-area_tab

;*******
;* $DE00 bank bits
bank_tab:
	dc.b	%00000000
	dc.b	%00001000
	dc.b	%00010000
	dc.b	%00011000
	dc.b	%10000000
	dc.b	%10001000
	dc.b	%10010000
	dc.b	%10011000


;**************************************************************************
;*
;* NAME  tag_section
;*
;* DESCRIPTION
;*   Write tag to ram indicating which bank is here.
;*
;*   IN: Acc=MSB, X=bank
;*   OUT: -
;*
;*     Y is preserved.
;*
;******
tag_section:
	sta	tag_page
	sta	ptr_zp+1
	lda	#$80
	sta	ptr_zp

	stx	tag_bank

	lda	#CHK_MAGIC
	sta	chk_zp
	ldy	#0
ts_lp1:
	lda	tag,y
	sta	(ptr_zp),y
	eor	chk_zp
	sta	chk_zp
	iny
	cpy	#TAG_LEN
	bne	ts_lp1
	sta	(ptr_zp),y
	rts


;*******
;* tag data
tag:
	dc.b	"BANK"
tag_page:
	dc.b	$9e				; page
tag_bank:
	dc.b	0				; bank
	dc.b	0				; is_rom?
TAG_LEN	equ	.-tag


;**************************************************************************
;*
;* NAME  verify_section
;*
;* DESCRIPTION
;*   Verify which part of the cart we are seeing.
;*
;*   IN: Acc=MSB
;*   OUT: Acc=bank_zp
;*     C=0:  bank_zp=RW000BBB (R=ROM, W=RW, B=bank), page_zp=MSB
;*     C=1:  bank_zp=$fe (page mismatch), bank_zp=$ff (no cart present here)
;*
;*     X is preserved.
;*
;******
verify_section:
	sta	ptr_zp+1
	lda	#$80
	sta	ptr_zp

	lda	#CHK_MAGIC
	sta	chk_zp
	ldy	#0
vs_lp1:
	lda	(ptr_zp),y
	cpy	#4
	bcs	vs_skp1
	cmp	tag,y
	bne	vs_fl1
vs_skp1:
	eor	chk_zp
	sta	chk_zp
	iny
	cpy	#TAG_LEN
	bne	vs_lp1
	cmp	(ptr_zp),y
	bne	vs_fl1

; check if writable
	iny
	lda	#0
	sta	wr_zp
	lda	#$aa
	sta	(ptr_zp),y
	cmp	(ptr_zp),y
	bne	vs_skp2
	lda	#$55
	sta	(ptr_zp),y
	cmp	(ptr_zp),y
	bne	vs_skp2
	inc	wr_zp
vs_skp2:

	ldy	#4
	lda	(ptr_zp),y
	sta	page_zp
	eor	ptr_zp+1
	and	#$1f
	bne	vs_fl2
	iny
	lda	(ptr_zp),y
	sta	bank_zp
	iny
	lda	(ptr_zp),y
	lsr	wr_zp
	ror
	ror
	ora	bank_zp
	sta	bank_zp
	clc
	rts

vs_fl2:
	lda	#$fe
	dc.b	$2c
vs_fl1:
	lda	#$ff
	sta	bank_zp
	sec
	rts

	echo	.
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
	lda	#<frz_msg
	ldy	#>frz_msg
	jsr	print_str
	jsr	print_areas2
	jsr	print_cr
	
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
	dc.b	13,"PRESS THE FREEZE BUTTON PLEASE...",0


rst_msg:
	dc.b	13,13,18,"RST",146,"  ",0
post_msg:
	dc.b	18,"POST",146," ",0
frz_msg:
	dc.b	13,13,18,"FRZ",146,"  ",0

	
;**************************************************************************
;*
;* NAME  print_areas, print_areas2
;*
;* DESCRIPTION
;*   Scan areas for which banks are present and print out.
;*
;*   IN: Acc/Y=leading string
;*
;******
print_areas:
	jsr	print_str
	jsr	scan_areas

print_areas2:
	ldx	#0
pas_lp1:
	lda	area_tab,x
	jsr	print_hex
	lda	#":"
	jsr	$ffd2

	lda	banks_zp,x
	jsr	print_tag

	jsr	print_space
	inx
	cpx	#AREA_TAB_LEN
	bne	pas_lp1
	rts


;**************************************************************************
;*
;* NAME  print_banks
;*
;* DESCRIPTION
;*   Print out n areas for which banks are present and print out.
;*
;******
print_banks:
	ldx	#0
pbs_lp1:
	jsr	print_space

	lda	area_tab,x
	jsr	print_hex
	lda	#":"
	jsr	$ffd2

	ldy	#0
pbs_lp2:
	tya
	pha
	lda	(dst_zp),y
	jsr	print_tag
	pla
	tay
	iny
	cpy	#8
	bne	pbs_lp2
	tya
	clc
	adc	dst_zp
	sta	dst_zp
	bcc	pbs_skp1
	inc	dst_zp+1
pbs_skp1:
	cpx	#2
	beq	pbs_skp2
	jsr	print_space
	jmp	pbs_skp3
pbs_skp2:
	jsr	print_cr
pbs_skp3:
	
	inx
	cpx	#AREA_TAB_LEN
	bne	pbs_lp1

	jmp	print_cr
;	rts



;**************************************************************************
;*
;* NAME  print_tag
;*
;* DESCRIPTION
;*   Print a char describing when the tag in Acc is located.
;*
;******
print_tag:
	tay
	jsr	print_space	; place holder for the char to be printed
	tya
	cmp	#$fe
	beq	ptg_fl1
	cmp	#$ff
	beq	ptg_fl2
	sta	tmp_zp
	tay
	bmi	ptg_rom
ptg_ram:
	and	#$0f
	ora	#$30
	bne	ptg_common	; always taken
ptg_rom:
	and	#$0f
	clc
	adc	#$01
ptg_common:
	bit	tmp_zp
	bvs	ptg_ex1
	eor	#$80
	bvc	ptg_ex1		; always taken

ptg_fl1:
	lda	#"?"
	dc.b	$2c
ptg_fl2:
	lda	#"-"
ptg_ex1:
	ldy	$d3
	dey
	sta	($d1),y
	rts

	
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

;******
;* $9e00 Tag for bank 0
	ds.b	$9e80-.,$ff
	BANK_TAG $9e,0,1

	
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

	jsr	scan_areas

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

;******
;* $9f00 Tag for bank 0
	ds.b	$9f80-.,$ff
	BANK_TAG $9f,0,1
	
	ds.b	$9ffa-.,$ff
	dc.w	freeze_entry	; nmi vector
	dc.w	freeze_entry	; reset vector
	dc.w	freeze_entry	; irq vector

;******
;* Tags for the remaining 7 banks
bank	set	1
	repeat	7
	rorg	$8000
	ds.b	$9e80-.,$ff
	BANK_TAG $9e,bank,1
	ds.b	$9f80-.,$ff
	BANK_TAG $9f,bank,1
	ds.b	$a000-.,$ff
	rend
bank	set	bank+1
	repend
	
	

; eof
