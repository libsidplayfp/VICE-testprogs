;**************************************************************************
;*
;* FILE  blittertest.asm
;* Copyright (c) 2007 Daniel Kahlin <daniel@kahlin.net>
;* Written by Daniel Kahlin <daniel@kahlin.net>
;* $Id: blittertest.asm,v 1.8 2007-05-28 07:23:16 tlr Exp $
;*
;* DESCRIPTION
;*   Blitter regression tests
;*
;******
	processor 6502

	
	MAC	sac
	dc.b	$32,{1}
	ENDM
	MAC	sir
	dc.b	$42,{1}
	ENDM
	MAC	bra
_TMPBRA	set	{1}-2-.
	if	_TMPBRA < -128 || _TMPBRA > 127
	ECHO 	"Branch to long!"
	ERR
	endif
	dc.b	$12,_TMPBRA
	ENDM

CMD_ENDCODE	equ	$00
CMD_BLITINIT	equ	$01
CMD_BLITREG	equ	$02
CMD_DOBLIT	equ	$03
CMD_PRINTSTR	equ	$10
CMD_INLINE	equ	$11
CMD_JMPNZ	equ	$12
CMD_BEGINTEST	equ	$13

	MAC	BEGINTEST
	dc.b	CMD_BEGINTEST
	ENDM
	MAC	PRINTSTR
	dc.b	CMD_PRINTSTR
	dc.b	{1}
	dc.b	0
	ENDM
	MAC	BLITINIT
	dc.b	CMD_BLITINIT,{1}
	ENDM
	MAC	BLITREG
	dc.b	CMD_BLITREG,{1}&$1f,{2}
	ENDM
	MAC	DOBLIT
	dc.b	CMD_DOBLIT
	ENDM
	MAC	INLINE
	dc.b	CMD_INLINE
	ENDM
	MAC	ENDINLINE
	jsr	endinline
	ENDM
	MAC	JMPNZ
	dc.b	CMD_JMPNZ
	dc.w	{1}
	ENDM
	MAC	ENDCODE
	dc.b	CMD_ENDCODE
	ENDM

	seg.u	zp
	org	$fb
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
	ldx	#<test_tab
	ldy	#>test_tab
	jsr	run_test
;	jsr	test_frac

	IFCONST	RECORD_MODE
	jsr	print_refrange
	ENDIF
	jmp	$a474

msg:	
	dc.b	147
	IFCONST	DTV2
	dc.b	"DTV2 BLITTER TEST / TLR'07",13,13,0
	ELSE
	IFCONST	DTV3
	dc.b	"DTV3 BLITTER TEST / TLR'07",13,13,0
	ELSE
	dc.b	"DTV2/3 BLITTER TEST RECORDER / TLR'07",13,13,0
	ENDIF
	ENDIF
	
;**************************************************************************
;*
;* NAME  print
;*
;* DESCRIPTION
;*   output string
;*   
;******
print:
	sta	ptr_zp
	sty	ptr_zp+1
	ldy	#0
prt_lp1:
	lda	(ptr_zp),y
	beq	prt_ex1
	jsr	$ffd2
	iny
	bne	prt_lp1
	inc	ptr_zp+1
	jmp	prt_lp1
prt_ex1:
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
	clc
	adc	#"0"
	cmp	#"9"+1
	bcc	ph_skp2
	adc	#"A"-("9"+1)-1
ph_skp2:
	jmp	$ffd2


;**************************************************************************
;*
;* NAME  set_tptr, fetch_tptr
;*
;* DESCRIPTION
;*   handle test data
;*
;******
set_tptr:
	stx	ft_sm1+1
	sty	ft_sm1+2
	rts
fetch_tptr:
ft_sm1:
	lda	$1234
	php
	inc	ft_sm1+1
	bne	ft_ex1
	inc	ft_sm1+2
ft_ex1:
	plp
	rts
		
;**************************************************************************
;*
;* NAME  run_test
;*
;* DESCRIPTION
;*
;******
run_test:
	jsr	set_tptr
	lda	#1
	sta	$d03f
		
rt_lp1:
	sei
	jsr	fetch_tptr
	ldx	#0
rt_lp2:
	cmp	jmptab,x
	beq	rt_found
	inx
	inx
	inx
	cpx	#jmptab_len
	bne	rt_lp2
rt_found:
	lda	jmptab+1,x
	sta	rt_sm1+1
	lda	jmptab+2,x
	sta	rt_sm1+2
rt_sm1:
	jsr	rt_sm1
	bra	rt_lp1

jmptab:
	dc.b	CMD_BEGINTEST
	dc.w	cmd_begintest
	dc.b	CMD_ENDCODE
	dc.w	cmd_endcode
	dc.b	CMD_PRINTSTR
	dc.w	cmd_printstr
	dc.b	CMD_BLITINIT
	dc.w	cmd_blitinit
	dc.b	CMD_BLITREG
	dc.w	cmd_blitreg
	dc.b	CMD_DOBLIT
	dc.w	cmd_doblit
	dc.b	CMD_INLINE
	dc.w	cmd_inline
	dc.b	CMD_JMPNZ
	dc.w	cmd_jmpnz
jmptab_len	equ	.-jmptab	

cmd_endcode:
	lda	#0
	sta	$d03f
	cli
	pla
	pla
	rts

cmd_begintest:
	lda	#<msg
	ldy	#>msg
	jmp	print

cmd_printstr:
cps_lp1:
	jsr	fetch_tptr
	jsr	$ffd2
	bne	cps_lp1
	rts

cmd_blitinit:
	jsr	fetch_tptr
	cmp	#1
	bne	cbi_skp1
	jsr	wipe_blit
cbi_skp1:
	jsr	prepare_buf
	rts

cmd_blitreg:
	jsr	fetch_tptr
	tax
	jsr	fetch_tptr
	sta	softblit_regs,x
	sta	$d320,x
	rts
		
cmd_inline:
	lda	ft_sm1+1
	sta	cil_sm1+1
	lda	ft_sm1+2
	sta	cil_sm1+2
cil_sm1:
	jmp	cil_sm1
endinline:
	php
	pla
	sta	cond_st
	pla
	clc
	adc	#1
	tax
	pla
	adc	#0
	tay
	jsr	set_tptr
	rts
cond_st:
	dc.b	0

cmd_jmpnz:
	jsr	fetch_tptr
	tax
	jsr	fetch_tptr
	tay
	lda	cond_st
	pha
	plp
	beq	cjnz_ex1
	jsr	set_tptr
cjnz_ex1:
	rts


cmd_doblit:
; perform blit operation and print result
	jsr	perform_blit
	
	lda	#<blit_msg
	ldy	#>blit_msg
	jsr	print
	lda	#>realbuf
	jsr	print_tab

	jsr	handle_reference

	IFNCONST RECORD_MODE
	lda	#<ref_msg
	ldy	#>ref_msg
	jsr	print
	lda	#>destbuf
	jsr	print_tab

	ldx	#0
cdb_lp1:
	lda	realbuf,x
	cmp	destbuf,x
	bne	cdb_skp1
	inx
	bne	cdb_lp1
	lda	#<ok_msg
	ldy	#>ok_msg
	bra	cdb_skp2
cdb_skp1:
	lda	#<mismatch_msg
	ldy	#>mismatch_msg
cdb_skp2:
	jsr	print
	cli
cdb_lp2:
	jsr	$ffe4
	beq	cdb_lp2
	ENDIF
	rts

blit_msg:
	dc.b	13,"BLIT:",13,0
ref_msg:
	dc.b	13,"REFERENCE:",13,0
ok_msg:
	dc.b	13,"OK.",0
mismatch_msg:
	dc.b	13,"MISMATCH!",0

;**************************************************************************
;*
;* NAME  print_tab
;*
;* DESCRIPTION
;*   print test table data
;*   
;******
print_tab:
	sta	ptr_zp+1
	ldy	#0
	sty	ptr_zp
	ldx	#0
pt_lp1:
	lda	(ptr_zp),y
	cmp	#STATE_XX
	bne	pt_skp1
	lda	#"X"
	jsr	$ffd2
	jsr	$ffd2
	bra	pt_skp3
pt_skp1:
	cmp	#STATE_UU
	bne	pt_skp2
	lda	#"-"
	jsr	$ffd2
	jsr	$ffd2
	bra	pt_skp3
pt_skp2:
	jsr	print_hex
pt_skp3:				
	inx
	cpx	#8
	bne	pt_skp4
	ldx	#0
	lda	#13
	dc.b	$2c
pt_skp4:
	lda	#" "
	jsr	$ffd2
	iny
	cpy	#64
	bne	pt_lp1
	rts


;**************************************************************************
;*
;* NAME  test_tab
;*
;* DESCRIPTION
;*   blitter test
;*   
;******
test_tab:
	BEGINTEST
	PRINTSTR "FORWARD TRANSFER"
	BLITINIT 1
	BLITREG	$d320,0		; Src A LSB
	BLITREG	$d328,0		; Src B LSB
	BLITREG	$d330,0		; Dest LSB
	BLITREG	$d323,1		; Src A Modulo LSB
	BLITREG	$d32b,1		; Src B Modulo LSB
	BLITREG	$d333,1		; Dest Modulo LSB
	BLITREG	$d327,$10	; Src A Frac Step
	BLITREG	$d32f,$10	; Src B Frac Step
	BLITREG	$d337,$10	; Dest Frac Step
	BLITREG	$d338,16	; Blit Length
	BLITREG	$d33b,%00000001	; Disable B
	BLITREG	$d33e,%00011000	; Minterm=011 (OR), Shift = 0
	BLITREG	$d33a,%00001011
	DOBLIT

	BEGINTEST
	PRINTSTR "REVERSE DEST TRANSFER"
	BLITINIT 1
	BLITREG	$d320,0		; Src A LSB
	BLITREG	$d330,15	; Dest LSB
	BLITREG	$d323,1		; Src A Modulo LSB
	BLITREG	$d333,1		; Dest Modulo LSB
	BLITREG	$d327,$10	; Src A Frac Step
	BLITREG	$d337,$10	; Dest Frac Step
	BLITREG	$d338,16	; Blit Length
	BLITREG	$d33b,%00000001	; Disable B
	BLITREG	$d33e,%00011000	; Minterm=011 (OR), Shift = 0
	BLITREG	$d33a,%00000011
	DOBLIT

	BEGINTEST
	PRINTSTR "REVERSE SRC TRANSFER"
	BLITINIT 1
	BLITREG	$d320,15	; Src A LSB
	BLITREG	$d330,0		; Dest LSB
	BLITREG	$d323,1		; Src A Modulo LSB
	BLITREG	$d333,1		; Dest Modulo LSB
	BLITREG	$d327,$10	; Src A Frac Step
	BLITREG	$d337,$10	; Dest Frac Step
	BLITREG	$d338,16	; Blit Length
	BLITREG	$d33b,%00000001	; Disable B
	BLITREG	$d33e,%00011000	; Minterm=011 (OR), Shift = 0
	BLITREG	$d33a,%00001001
	DOBLIT
	
	BEGINTEST
	PRINTSTR "DEST CONTINUE"
	BLITINIT 0
	BLITREG	$d320,0		; Src A LSB
	BLITREG	$d323,1		; Src A Modulo LSB
	BLITREG	$d333,1		; Dest Modulo LSB
	BLITREG	$d327,$10	; Src A Frac Step
	BLITREG	$d337,$10	; Dest Frac Step
	BLITREG	$d338,16	; Blit Length
	BLITREG	$d33b,%00000001	; Disable B
	BLITREG	$d33e,%00011000	; Minterm=011 (OR), Shift = 0
	BLITREG	$d33f,%00001000
	BLITREG	$d33a,%00001011
	DOBLIT

	BEGINTEST
	PRINTSTR "SRC CONTINUE"
	BLITINIT 0
	BLITREG	$d330,0		; Dest LSB
	BLITREG	$d323,1		; Src A Modulo LSB
	BLITREG	$d333,1		; Dest Modulo LSB
	BLITREG	$d327,$10	; Src A Frac Step
	BLITREG	$d337,$10	; Dest Frac Step
	BLITREG	$d338,16	; Blit Length
	BLITREG	$d33b,%00000001	; Disable B
	BLITREG	$d33e,%00011000	; Minterm=011 (OR), Shift = 0
	BLITREG	$d33f,%00000010
	BLITREG	$d33a,%00001011
	DOBLIT

	BEGINTEST
	PRINTSTR "DEST STEP=$20 LL=63"
	BLITINIT 1
	BLITREG	$d320,0		; Src A LSB
	BLITREG	$d330,0		; Dest LSB
	BLITREG	$d323,1		; Src A Modulo LSB
	BLITREG	$d333,1		; Dest Modulo LSB
	BLITREG	$d335,63	; Dest Line Length LSB
	BLITREG	$d327,$10	; Src A Frac Step
	BLITREG	$d337,$20	; Dest Frac Step
	BLITREG	$d338,16	; Blit Length
	BLITREG	$d33b,%00000001	; Disable B
	BLITREG	$d33e,%00011000	; Minterm=011 (OR), Shift = 0
	BLITREG	$d33a,%00001011
	DOBLIT

	BEGINTEST
	PRINTSTR "DEST STEP=$00 LL=63"
	BLITINIT 1
	BLITREG	$d320,0		; Src A LSB
	BLITREG	$d330,0		; Dest LSB
	BLITREG	$d323,1		; Src A Modulo LSB
	BLITREG	$d333,1		; Dest Modulo LSB
	BLITREG	$d327,$10	; Src A Frac Step
	BLITREG	$d335,63	; Dest Line Length LSB
	BLITREG	$d337,$00	; Dest Frac Step
	BLITREG	$d338,16	; Blit Length
	BLITREG	$d33b,%00000001	; Disable B
	BLITREG	$d33e,%00011000	; Minterm=011 (OR), Shift = 0
	BLITREG	$d33a,%00001011
	DOBLIT

	BEGINTEST
	PRINTSTR "SRC STEP=$20 LL=63"
	BLITINIT 1
	BLITREG	$d320,0		; Src A LSB
	BLITREG	$d330,0		; Dest LSB
	BLITREG	$d323,1		; Src A Modulo LSB
	BLITREG	$d333,1		; Dest Modulo LSB
	BLITREG	$d325,63	; Src A Line Length LSB
	BLITREG	$d327,$20	; Src A Frac Step
	BLITREG	$d337,$10	; Dest Frac Step
	BLITREG	$d338,16	; Blit Length
	BLITREG	$d33b,%00000001	; Disable B
	BLITREG	$d33e,%00011000	; Minterm=011 (OR), Shift = 0
	BLITREG	$d33a,%00001011
	DOBLIT

	BEGINTEST
	PRINTSTR "SRC STEP=$00 LL=63"
	BLITINIT 1
	BLITREG	$d320,0		; Src A LSB
	BLITREG	$d330,0		; Dest LSB
	BLITREG	$d323,1		; Src A Modulo LSB
	BLITREG	$d333,1		; Dest Modulo LSB
	BLITREG	$d325,63	; Src A Line Length LSB
	BLITREG	$d327,$00	; Src A Frac Step
	BLITREG	$d337,$10	; Dest Frac Step
	BLITREG	$d338,16	; Blit Length
	BLITREG	$d33b,%00000001	; Disable B
	BLITREG	$d33e,%00011000	; Minterm=011 (OR), Shift = 0
	BLITREG	$d33a,%00001011
	DOBLIT

	BEGINTEST
	PRINTSTR "DEST LL=0 MOD=0"
	BLITINIT 1
	BLITREG	$d320,0		; Src A LSB
	BLITREG	$d330,0		; Dest LSB
	BLITREG	$d323,1		; Src A Modulo LSB
	BLITREG	$d333,0		; Dest Modulo LSB
	BLITREG	$d335,0		; Dest Line Length LSB
	BLITREG	$d327,$10	; Src A Frac Step
	BLITREG	$d337,$10	; Dest Frac Step
	BLITREG	$d338,16	; Blit Length
	BLITREG	$d33b,%00000001	; Disable B
	BLITREG	$d33e,%00011000	; Minterm=011 (OR), Shift = 0
	BLITREG	$d33a,%00001011
	DOBLIT

	BEGINTEST
	PRINTSTR "DEST LL=0 MOD=1"
	BLITINIT 1
	BLITREG	$d320,0		; Src A LSB
	BLITREG	$d330,0		; Dest LSB
	BLITREG	$d323,1		; Src A Modulo LSB
	BLITREG	$d333,1		; Dest Modulo LSB
	BLITREG	$d335,0		; Dest Line Length LSB
	BLITREG	$d327,$10	; Src A Frac Step
	BLITREG	$d337,$10	; Dest Frac Step
	BLITREG	$d338,16	; Blit Length
	BLITREG	$d33b,%00000001	; Disable B
	BLITREG	$d33e,%00011000	; Minterm=011 (OR), Shift = 0
	BLITREG	$d33a,%00001011
	DOBLIT

	BEGINTEST
	PRINTSTR "DEST LL=1 MOD=1"
	BLITINIT 1
	BLITREG	$d320,0		; Src A LSB
	BLITREG	$d330,0		; Dest LSB
	BLITREG	$d323,1		; Src A Modulo LSB
	BLITREG	$d333,1		; Dest Modulo LSB
	BLITREG	$d335,1		; Dest Line Length LSB
	BLITREG	$d327,$10	; Src A Frac Step
	BLITREG	$d337,$10	; Dest Frac Step
	BLITREG	$d338,16	; Blit Length
	BLITREG	$d33b,%00000001	; Disable B
	BLITREG	$d33e,%00011000	; Minterm=011 (OR), Shift = 0
	BLITREG	$d33a,%00001011
	DOBLIT

	BEGINTEST
	PRINTSTR "DEST LL=2 MOD=2"
	BLITINIT 1
	BLITREG	$d320,0		; Src A LSB
	BLITREG	$d330,0		; Dest LSB
	BLITREG	$d323,1		; Src A Modulo LSB
	BLITREG	$d333,2		; Dest Modulo LSB
	BLITREG	$d335,2		; Dest Line Length LSB
	BLITREG	$d327,$10	; Src A Frac Step
	BLITREG	$d337,$10	; Dest Frac Step
	BLITREG	$d338,16	; Blit Length
	BLITREG	$d33b,%00000001	; Disable B
	BLITREG	$d33e,%00011000	; Minterm=011 (OR), Shift = 0
	BLITREG	$d33a,%00001011
	DOBLIT

	BEGINTEST
	PRINTSTR "DEST LL=2 MOD=0"
	BLITINIT 1
	BLITREG	$d320,0		; Src A LSB
	BLITREG	$d330,0		; Dest LSB
	BLITREG	$d323,1		; Src A Modulo LSB
	BLITREG	$d333,0		; Dest Modulo LSB
	BLITREG	$d335,2		; Dest Line Length LSB
	BLITREG	$d327,$10	; Src A Frac Step
	BLITREG	$d337,$10	; Dest Frac Step
	BLITREG	$d338,16	; Blit Length
	BLITREG	$d33b,%00000001	; Disable B
	BLITREG	$d33e,%00011000	; Minterm=011 (OR), Shift = 0
	BLITREG	$d33a,%00001011
	DOBLIT

	INLINE
	lda	#%00011000
	sta	ft_shift
	ENDINLINE
tt_lp01:
	BEGINTEST
	PRINTSTR "SRC SHIFT=$"
	INLINE
	lda	ft_shift
	and	#7
	jsr	print_hex
	ENDINLINE
	PRINTSTR " LL=63"
	BLITINIT 1
	BLITREG	$d320,0		; Src A LSB
	BLITREG	$d330,0		; Dest LSB
	BLITREG	$d323,1		; Src A Modulo LSB
	BLITREG	$d325,63	; Src A Line Length LSB
	BLITREG	$d333,1		; Dest Modulo LSB
	BLITREG	$d327,$10	; Src A Frac Step
	BLITREG	$d337,$10	; Dest Frac Step
	BLITREG	$d338,64	; Blit Length
	BLITREG	$d33b,%00000001	; Disable B
ft_shift	equ	.+2
	BLITREG	$d33e,%00011000	; Minterm=011 (OR), Shift = 0
	BLITREG	$d33a,%00001011
	DOBLIT
	INLINE
	inc	ft_shift
	lda	ft_shift
	and	#7
	cmp	#0
	ENDINLINE
	JMPNZ	tt_lp01

	INLINE
	lda	#%00011000
	sta	ft_shift2
	ENDINLINE
tt_lp02:
	BEGINTEST
	PRINTSTR "SRC SHIFT=$"
	INLINE
	lda	ft_shift2
	and	#7
	jsr	print_hex
	ENDINLINE
	PRINTSTR " LL=31"
	BLITINIT 1
	BLITREG	$d320,0		; Src A LSB
	BLITREG	$d330,0		; Dest LSB
	BLITREG	$d323,1		; Src A Modulo LSB
	BLITREG	$d325,31	; Src A Line Length LSB
	BLITREG	$d333,1		; Dest Modulo LSB
	BLITREG	$d327,$10	; Src A Frac Step
	BLITREG	$d337,$10	; Dest Frac Step
	BLITREG	$d338,64	; Blit Length
	BLITREG	$d33b,%00000001	; Disable B
ft_shift2	equ	.+2
	BLITREG	$d33e,%00011000	; Minterm=011 (OR), Shift = 0
	BLITREG	$d33a,%00001011
	DOBLIT
	INLINE
	inc	ft_shift2
	lda	ft_shift2
	and	#7
	cmp	#0
	ENDINLINE
	JMPNZ	tt_lp02

	INLINE
	lda	#$0f
	sta	sft_frac
	ENDINLINE
tt_lp1:
	BEGINTEST
	PRINTSTR "SRC FRAC=$"
	INLINE
	lda	sft_frac
	jsr	print_hex
	ENDINLINE
	PRINTSTR " LL=63"
	BLITINIT 1
	BLITREG	$d320,0		; Src A LSB
	BLITREG	$d330,0		; Dest LSB
	BLITREG	$d323,1		; Src A Modulo LSB
	BLITREG	$d325,63	; Src A Line Length LSB
	BLITREG	$d333,1		; Dest Modulo LSB
sft_frac	equ	.+2
	BLITREG	$d327,$0f	; Src A Frac Step
	BLITREG	$d337,$10	; Dest Frac Step
	BLITREG	$d338,64	; Blit Length
	BLITREG	$d33b,%00000001	; Disable B
	BLITREG	$d33e,%00011000	; Minterm=011 (OR), Shift = 0
	BLITREG	$d33a,%00001011
	DOBLIT
	INLINE
	dec	sft_frac
	lda	sft_frac
	cmp	#$ff
	ENDINLINE
	JMPNZ	tt_lp1
	
	INLINE
	lda	#$0f
	sta	dft_frac
	ENDINLINE
tt_lp2:
	BEGINTEST
	PRINTSTR "DEST FRAC=$"
	INLINE
	lda	dft_frac
	jsr	print_hex
	ENDINLINE
	PRINTSTR " LL=63"
	BLITINIT 1
	BLITREG	$d320,0		; Src A LSB
	BLITREG	$d330,0		; Dest LSB
	BLITREG	$d323,1		; Src A Modulo LSB
	BLITREG	$d333,1		; Dest Modulo LSB
	BLITREG	$d335,63	; Dest Line Length LSB
	BLITREG	$d327,$10	; Src A Frac Step
dft_frac	equ	.+2
	BLITREG	$d337,$0f	; Dest Frac Step
	BLITREG	$d338,64	; Blit Length
	BLITREG	$d33b,%00000001	; Disable B
	BLITREG	$d33e,%00011000	; Minterm=011 (OR), Shift = 0
	BLITREG	$d33a,%00001011
	DOBLIT
	INLINE
	dec	dft_frac
	lda	dft_frac
	cmp	#$ff
	ENDINLINE
	JMPNZ	tt_lp2

	INLINE
	lda	#$0f
	sta	sft2_frac
	ENDINLINE
tt_lp3:
	BEGINTEST
	PRINTSTR "SRC FRAC=$"
	INLINE
	lda	sft2_frac
	jsr	print_hex
	ENDINLINE
	PRINTSTR " LL=31 MOD=2"
	BLITINIT 1
	BLITREG	$d320,0		; Src A LSB
	BLITREG	$d330,0		; Dest LSB
	BLITREG	$d323,2		; Src A Modulo LSB
	BLITREG	$d325,31	; Src A Line Length LSB
	BLITREG	$d333,1		; Dest Modulo LSB
sft2_frac	equ	.+2
	BLITREG	$d327,$0f	; Src A Frac Step
	BLITREG	$d337,$10	; Dest Frac Step
	BLITREG	$d338,64	; Blit Length
	BLITREG	$d33b,%00000001	; Disable B
	BLITREG	$d33e,%00011000	; Minterm=011 (OR), Shift = 0
	BLITREG	$d33a,%00001011
	DOBLIT
	INLINE
	dec	sft2_frac
	lda	sft2_frac
	cmp	#$ff
	ENDINLINE
	JMPNZ	tt_lp3
	
	INLINE
	lda	#$0f
	sta	dft2_frac
	ENDINLINE
tt_lp4:
	BEGINTEST
	PRINTSTR "DEST FRAC=$"
	INLINE
	lda	dft2_frac
	jsr	print_hex
	ENDINLINE
	PRINTSTR " LL=31 MOD=2"
	BLITINIT 1
	BLITREG	$d320,0		; Src A LSB
	BLITREG	$d330,0		; Dest LSB
	BLITREG	$d323,1		; Src A Modulo LSB
	BLITREG	$d333,2		; Dest Modulo LSB
	BLITREG	$d335,31	; Dest Line Length LSB
	BLITREG	$d327,$10	; Src A Frac Step
dft2_frac	equ	.+2
	BLITREG	$d337,$0f	; Dest Frac Step
	BLITREG	$d338,64	; Blit Length
	BLITREG	$d33b,%00000001	; Disable B
	BLITREG	$d33e,%00011000	; Minterm=011 (OR), Shift = 0
	BLITREG	$d33a,%00001011
	DOBLIT
	INLINE
	dec	dft2_frac
	lda	dft2_frac
	cmp	#$ff
	ENDINLINE
	JMPNZ	tt_lp4

	ENDCODE

;**************************************************************************
;*
;* NAME  handle_reference
;*
;* DESCRIPTION
;*   record or play back reference data
;*   
;******
handle_reference:
	ldx	#63
hr_lp1:
	IFCONST	RECORD_MODE
	lda	realbuf,x
hr_sm1:
	sta	reference,x
	ELSE	;RECORD_MODE
hr_sm1:
	lda	reference,x
	sta	destbuf,x
	ENDIF	;RECORD_MODE
	dex
	bpl	hr_lp1
	lda	hr_sm1+1
	clc
	adc	#$40
	sta	hr_sm1+1
	bcc	hr_ex1
	inc	hr_sm1+2
hr_ex1:
	rts

	IFCONST	RECORD_MODE
print_refrange:
	lda	#<rec_msg
	ldy	#>rec_msg
	jsr	print
	lda	#>reference
	jsr	print_hex
	lda	#<reference
	jsr	print_hex
	lda	#"-"
	jsr	$ffd2
	lda	#"$"
	jsr	$ffd2
	lda	hr_sm1+2
	jsr	print_hex
	lda	hr_sm1+1
	jsr	print_hex
	lda	#13
	jsr	$ffd2
	rts
rec_msg:
	dc.b	13,"RECORDED DATA AT $",0
	ENDIF
	
;**************************************************************************
;*
;* NAME  wipe_blit, prepare_buf, perform_blit
;*
;* DESCRIPTION
;*   handle blitter.
;*   
;******
wipe_blit:
	ldx	#$1f
	lda	#0
wb_lp1:
	sta	softblit_regs,x
	sta	$d320,x
	dex
	bpl	wb_lp1
	lda	#>srcbuf_a
	sta	$d321
	sta	softblit_regs+$01
	lda	#>srcbuf_b
	sta	$d329
	sta	softblit_regs+$09
	lda	#>destbuf
	sta	$d331
	sta	softblit_regs+$11
	lda	#$00
	sta	$d322
	sta	softblit_regs+$02
	sta	$d32a
	sta	softblit_regs+$0a
	sta	$d332	
	sta	softblit_regs+$12
	rts

STATE_XX	equ	$fe
STATE_UU	equ	$ff
	
prepare_buf:
	ldx	#0
pb_lp1:
	lda	#STATE_XX
	sta	srcbuf_a,x
	sta	srcbuf_a_head,x
	sta	srcbuf_a_tail,x
	sta	srcbuf_b,x
	sta	srcbuf_b_head,x
	sta	srcbuf_b_tail,x
	lda	#STATE_UU
	sta	destbuf,x
	lda	#0
	sta	destbuf_head,x
	sta	destbuf_tail,x
	inx
	bne	pb_lp1

	ldx	#0
pb_lp2:
	txa
	sta	srcbuf_a,x
	clc
	adc	#$80
	sta	srcbuf_b,x
	inx
	cpx	#$40
	bne	pb_lp2
	rts
		
perform_blit:
pd_lp2:
	lda	$d33f
	lsr
	bcs	pd_lp2

	ldy	#0
pd_lp3:
	lda	destbuf,y
	sta	realbuf,y
	iny
	bne	pd_lp3
		
	jsr	prepare_buf

; 	jsr	do_softblit

	rts

;**************************************************************************
;*
;* NAME  do_softblit
;*
;* DESCRIPTION
;*   software emulated blitter
;*   
;******

;**************************************************************************
;*
;* SECTION  reference data
;*
;******
	IFCONST	RECORD_MODE
	align	256
	echo	"refstore",.
reference:
	ds.b	$4000,$7b
	ELSE	;RECORD_MODE
reference:
	IFCONST DTV2
	incbin	"blitref_dtv2.bin"
	ENDIF	;DTV2
	IFCONST DTV3
	incbin	"blitref_dtv3.bin"
	ENDIF	;DTV3
	ENDIF	;RECORD_MODE
	
end_code	equ	.
	seg.u	bss1
	org	end_code
;**************************************************************************
;*
;* SECTION  bss
;*
;******
softblit_regs:
	ds.b	$20
	
	seg.u	bss2
	org	$c000	
;**************************************************************************
;*
;* SECTION  bss2
;*
;******
srcbuf_a_head:
	ds.b	256
srcbuf_a:
	ds.b	256
srcbuf_a_tail:
	ds.b	256
	ds.b	256

srcbuf_b_head:
	ds.b	256
srcbuf_b:
	ds.b	256
srcbuf_b_tail:
	ds.b	256
	ds.b	256
	
destbuf_head:
	ds.b	256
destbuf:
	ds.b	256
destbuf_tail:
	ds.b	256
	ds.b	256

realbuf_head:
	ds.b	256
realbuf:
	ds.b	256
realbuf_tail:
	ds.b	256
	ds.b	256
; eof
