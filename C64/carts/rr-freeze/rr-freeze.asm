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
	org	$0334
tab_selected:
	ds.b	1
de01_selected:
	ds.b	1
de00_pre_frz:
	ds.b	1
de00_post_frz:
	ds.b	1

de00_pre:
	ds.b	1
de01_pre:
	ds.b	1
de00_post:
	ds.b	1
de01_post:
	ds.b	1

	org	$0800
BUFFER:
areas_post_rst:
	ds.b	NUM_AREAS
banks_post_rst:
	ds.b	NUM_BANKS*NUM_AREAS*2
areas_post_cnf:
	ds.b	NUM_AREAS
banks_post_cnf:
	ds.b	NUM_BANKS*NUM_AREAS*2
areas_post_frz:
	ds.b	NUM_AREAS
banks_post_frz:
	ds.b	NUM_BANKS*NUM_AREAS*2
areas_post_ack:
	ds.b	NUM_AREAS
banks_post_ack:
	ds.b	NUM_BANKS*NUM_AREAS*2
BUFFER_END:


	org	$0e00
code_area:
	ds.b	$0200


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

	jsr	prefill_ram
	jsr	install_code


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
	dc.b	147,"RR-FREEZE R05 / TLR",13,13
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
;* NAME  prefill_ram
;*
;* DESCRIPTION
;*   Prepare ram with dummy pattern.
;*
;******
prefill_ram:

;******
;* prefill ram area with $aa
	ldy	#0
	sty	ptr_zp
	ldx	#8
	stx	ptr_zp+1
	lda	#$aa
pf_lp1:
	sta	(ptr_zp),y
	iny
	bne	pf_lp1
	dex
	bne	pf_lp1

	rts


;**************************************************************************
;*
;* NAME  install_code
;*
;* DESCRIPTION
;*   Install the ram part of our code.
;*
;******
install_code:
	ldx	#0
ic_lp1:
	lda	ram_code_st,x
	sta	ram_code,x
	if	RAM_CODE_LEN > $0100
	lda	ram_code_st+$0100,x
	sta	ram_code+$0100,x
	endif
	inx
	bne	ic_lp1

	rts


;**************************************************************************
;*
;* NAME  ram_code
;*
;* DESCRIPTION
;*   Code to be run from ram
;*
;******
ram_code_st:
	rorg	code_area
ram_code:

prepare_cartram:
;******
;* enumerate banks in ram in reverse
	ldx	#NUM_BANKS-1
prc_lp1:
	lda	bank_tab,x
	ora	#%00100011
	sta	$de00

	lda	#$9e
	jsr	tag_section
	lda	#$9f
	jsr	tag_section

	dex
	bpl	prc_lp1
	
	lda	#%00000000
	sta	$de00
	rts

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
NUM_BANKS	equ	8

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


;**************************************************************************
;*
;* NAME  scan_areas, scan_areas_int
;*
;* DESCRIPTION
;*   Scan the mappable regions to find what is mapped there.
;*   IN: X/Y=pointer to area table.
;*
;******
scan_areas:
	php
	sei
	stx	dst_zp
	sty	dst_zp+1
	jsr	scan_areas_int
	ldy	#NUM_AREAS-1
sar_lp1:
	lda	banks_zp,y
	sta	(dst_zp),y
	dey
	bpl	sar_lp1
	plp
	rts

scan_areas_int:
	ldx	#0
sai_lp1:
	lda	area_tab,x
	jsr	verify_section
	sta	banks_zp,x
	inx
	cpx	#NUM_AREAS
	bne	sai_lp1
	rts


;*******
;* Areas to scan
area_tab:
	dc.b	$9e
	dc.b	$be
	dc.b	$de
	dc.b	$df
	dc.b	$fe
NUM_AREAS	equ	5


;**************************************************************************
;*
;* NAME  scan_banks, scan_banks_int
;*
;* DESCRIPTION
;*   Scan the mappable regions of all banks, ROM and RAM to find what is
;*   mapped there.
;*   IN: X/Y=pointer to bank table.
;*
;******
scan_banks:
	php
	sei
	stx	dst_zp
	sty	dst_zp+1
	pha
	ora	#%00100000	; RAM
	jsr	scan_banks_int
	pla
	and	#%11011111	; ROM
	jsr	scan_banks_int
	plp
	rts
	
scan_banks_int:
	sta	mode_zp
	ldx	#0
sca_lp1:
	lda	bank_tab,x
	ora	mode_zp
	sta	$de00

	txa
	pha
	jsr	scan_areas_int
	
	ldy	#0
	ldx	#0
sca_lp2:
	lda	banks_zp,x
	sta	(dst_zp),y
	tya
	clc
	adc	#NUM_BANKS
	tay
	inx
	cpx	#NUM_AREAS
	bne	sca_lp2
	
	pla
	tax

	inc	dst_zp
	bne	sca_skp1
	inc	dst_zp+1
sca_skp1:
	inx
	cpx	#NUM_BANKS
	bne	sca_lp1

	lda	#%00000000
	sta	$de00

	lda	dst_zp
	clc
	adc	#NUM_AREAS*NUM_BANKS-NUM_BANKS
	sta	dst_zp
	bcc	sca_skp2
	inc	dst_zp+1
sca_skp2:
	rts


;**************************************************************************
;*
;* NAME  wait_freeze
;*
;* DESCRIPTION
;*   Wait for freeze
;*
;******
wait_freeze:
; set "random" mapping (bank 5 in ROM)
	lda	#%10001000
	sta	$de00
; kill cartridge
	ora	#%00000100
	sta	$de00
wf_lp1:
	jmp	wf_lp1

	
;**************************************************************************
;*
;* NAME  freeze_entry
;*
;* DESCRIPTION
;*   Freeze entry point
;*
;******
freeze_entry:
	sei
	cld
	ldx	#$ff
	txs

	ldx	#<areas_post_frz
	ldy	#>areas_post_frz
	jsr	scan_areas

; read registers de00/de01
	lda	$de00
	sta	de00_post
	lda	$de01
	sta	de01_post

	lda	#%00000000
	ldx	#<banks_post_frz
	ldy	#>banks_post_frz
	jsr	scan_banks

; ack freeze
	lda	#%01100000	; RR-RAM at $8000, ack freeze
	sta	$de00
	lda	#%00100000	; RR-RAM at $8000
	sta	$de00

	ldx	#<areas_post_ack
	ldy	#>areas_post_ack
	jsr	scan_areas

	lda	#%00000000
	ldx	#<banks_post_ack
	ldy	#>banks_post_ack
	jsr	scan_banks

; exit kernal rom and enter normal rom
	lda	#$37
	sta	$01
	lda	#$2f
	sta	$00

	lda	#%00000000	; Normal conf, RR-ROM at $8000
	sta	$de00
	jmp	continue_test
	
	rend
RAM_CODE_LEN	equ	.-ram_code_st


	
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

	jsr	prepare_cartram

	ldx	#<areas_post_rst
	ldy	#>areas_post_rst
	jsr	scan_areas
	lda	#<rst_msg
	ldy	#>rst_msg
	jsr	print_str
	ldx	#<areas_post_rst
	ldy	#>areas_post_rst
	jsr	print_areas

	lda	#%00000000
	ldx	#<banks_post_rst
	ldy	#>banks_post_rst
	jsr	scan_banks
	ldx	#<banks_post_rst
	ldy	#>banks_post_rst
	jsr	print_banks

; initial setup of RR-mode
	lda	de01_selected
	sta	$de01

	lda	$de00
	sta	de00_pre
	lda	$de01
	sta	de01_pre

	ldx	#<areas_post_cnf
	ldy	#>areas_post_cnf
	jsr	scan_areas
	lda	#<cnfd_msg
	ldy	#>cnfd_msg
	jsr	print_str
	ldx	#<areas_post_cnf
	ldy	#>areas_post_cnf
	jsr	print_areas

	lda	#%00000000
	ldx	#<banks_post_cnf
	ldy	#>banks_post_cnf
	jsr	scan_banks
	ldx	#<banks_post_cnf
	ldy	#>banks_post_cnf
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
	jmp	wait_freeze


freeze_msg:
	dc.b	13,"PRESS THE FREEZE BUTTON PLEASE...",0


;******
;* continue after freezing
continue_test:
; clear cursor and line
	inc	$cc		; disable cursor
	ldy	$d3
	lda	#$20
ct_lp1:
	sta	($d1),y
	dey
	bpl	ct_lp1
	iny
	sty	$d3		; x-pos
	sty	$cf		; cursor not in the inverted state
	
	if	0
	lda	#145		; cursor up
	jsr	$ffd2
	endif
	
; present state
	lda	#<frz_msg
	ldy	#>frz_msg
	jsr	print_str
	ldx	#<areas_post_frz
	ldy	#>areas_post_frz
	jsr	print_areas
	ldx	#<banks_post_frz
	ldy	#>banks_post_frz
	jsr	print_banks

	lda	#<ackd_msg
	ldy	#>ackd_msg
	jsr	print_str
	ldx	#<areas_post_ack
	ldy	#>areas_post_ack
	jsr	print_areas
	ldx	#<banks_post_ack
	ldy	#>banks_post_ack
	jsr	print_banks
	
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

	ldx	#<dumpname
	ldy	#>dumpname
	lda	#DUMPNAME_LEN
	jsr	$ffbd
	jsr	save_file
ct_lp2:
	jmp	ct_lp2


rst_msg:
	dc.b	13,13,18,"RST",146,"  ",0
cnfd_msg:
	dc.b	18,"CNFD",146," ",0
frz_msg:
	dc.b	18,"FRZ",146,"  ",0
ackd_msg:
	dc.b	18,"ACKD",146," ",0


dumpname:
	dc.b	"RR-FRZ"
DUMPNAME_LEN	equ	.-dumpname

;**************************************************************************
;*
;* NAME  print_areas
;*
;* DESCRIPTION
;*   Print out which areas were visible in a previous scan
;*
;*   IN: X/Y=pointer to area table.
;*
;******
print_areas:
	stx	dst_zp
	sty	dst_zp+1

	ldy	#0
pas_lp1:
	lda	area_tab,y
	jsr	print_hex
	lda	#":"
	jsr	$ffd2

	tya
	pha
	lda	(dst_zp),y
	jsr	print_tag
	pla
	tay
	
	jsr	print_space
	iny
	cpy	#NUM_AREAS
	bne	pas_lp1

	jmp	print_cr
;	rts


;**************************************************************************
;*
;* NAME  print_banks
;*
;* DESCRIPTION
;*   Print out n areas for which banks are present and print out.
;*   IN: X/Y=pointer to bank table.
;*
;******
print_banks:
	stx	dst_zp
	sty	dst_zp+1
	jsr	print_banks_int
	; fall through
print_banks_int:
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
	cpy	#NUM_BANKS
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
	cpx	#NUM_AREAS
	bne	pbs_lp1

	jmp	print_cr
;	rts



;**************************************************************************
;*
;* NAME  print_tag
;*
;* DESCRIPTION
;*   Print a char describing where the tag in Acc is located.
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
	jsr	print_str
sf_lp1:
	jsr	$ffe4
	cmp	#"N"
	beq	sf_ex1
	cmp	#"Y"
	bne	sf_lp1

	lda	#<filename_msg
	ldy	#>filename_msg
	jsr	print_str
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
	ldx	#<BUFFER
	ldy	#>BUFFER
	stx	sa_zp
	sty	sa_zp+1
	lda	#sa_zp
	ldx	#<BUFFER_END
	ldy	#>BUFFER_END
	jsr	$ffd8

	lda	#<ok_msg
	ldy	#>ok_msg
	jsr	print_str

	lda	#<again_msg
	ldy	#>again_msg
	jsr	print_str
	jmp	sf_lp1
sf_ex1:
	lda	#<ok_msg
	ldy	#>ok_msg
	jsr	print_str
	rts

save_to_disk_msg:
	dc.b	"SAVE TO DISK? ",0
again_msg:
	dc.b	13,"SAVE AGAIN? ",0
filename_msg:
	dc.b	13,"FILENAME: ",0
ok_msg:
	dc.b	13,"OK",13,0

NAMEBUF_LEN	equ	32
namebuf		equ	$0120



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
