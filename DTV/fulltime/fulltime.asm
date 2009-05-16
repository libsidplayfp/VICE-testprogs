;**************************************************************************
;*
;* FILE  fulltime.asm
;* Copyright (c) 2007, 2009 Daniel Kahlin <daniel@kahlin.net>
;* Written by Daniel Kahlin <daniel@kahlin.net>
;*
;* DESCRIPTION
;*   Instruction timing regression tests
;*
;******
	processor 6502

; RECORD_REFDATA	set	1
REFDATA_STORE	equ	$7000


SKIP_CYCLE	equ	%00000001
BURST_MODE	equ	%00000010
BRANCH_TAKEN	equ	%00000100	
PAGE_CROSS	equ	%00001000	
	
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
	MAC	nopalign
	ds.b	[4+{1}-[. & 3]]&3,$ea
	ENDM

; safe areas
safe_zp		equ	$04
safe_abs	equ	$c004
safe_jmpind_ptr	equ	$c100

; this offset will be put into X and Y for indexed modes
; when page crossing is induced.
CROSS_OFFSET	equ	$fe

	seg.u	zp
	org	$ac
xtmp_zp:
	ds.b	1
ytmp_zp:
	ds.b	1
	
	org	$f8
ptr_zp:
	ds.w	1
count_zp:
	ds.b	1
tmp_zp:
	ds.b	1
stack_zp:
	ds.b	1
flags_zp:
	ds.b	1
index_zp:
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
	jsr	reset_seq	;just to be reentrant.

	ldx	#0
sa_lp1:
	jsr	get_seq
	cmp	#$ff
	beq	sa_ex1
	sta	run_mode
	jsr	get_seq
	sta	burst_align
	
	lda	#147
	jsr	$ffd2
	ldy	#0
	ldx	#17
	clc
	jsr	$fff0

sa_lp2:
	jsr	get_seq
	jsr	$ffd2
	bne	sa_lp2

	jsr	test_opcodes
	ifconst	RECORD_REFDATA
	jsr	record_refdata
	endif
sa_lp3:
	jsr	$ffe4
	beq	sa_lp3
	jmp	sa_lp1
	
sa_ex1:
	ifconst	RECORD_REFDATA
	jsr	record_done
	endif
	jmp	$a474


;**************************************************************************
;*
;* NAME  reset_seq, get_seq
;*
;* DESCRIPTION
;*   test data fetch functions
;*
;******
reset_seq:
	lda	#<test_data
	sta	gs_sm1+1
	lda	#>test_data
	sta	gs_sm1+2
	rts

get_seq:
gs_sm1:
	lda	test_data
	inc	gs_sm1+1
	bne	gs_ex1
	inc	gs_sm1+2
gs_ex1:
	rts

;**************************************************************************
;*
;* NAME  test_data
;*
;* DESCRIPTION
;*   strings and parameters for the test
;*
;******
test_data:
	dc.b	0, 0
	dc.b	"NORMAL, NO PAGE CROSS, BRANCH NOT TAKEN",0
	dc.b	BRANCH_TAKEN, 0
	dc.b	"NORMAL, NO PAGE CROSS, BRANCH TAKEN",0
	dc.b	PAGE_CROSS, 0
	dc.b	"NORMAL, PAGE CROSS, BRANCH NOT TAKEN",0
	dc.b	PAGE_CROSS | BRANCH_TAKEN, 0
	dc.b	"NORMAL, PAGE CROSS, BRANCH TAKEN",0
	dc.b	SKIP_CYCLE, 0
	dc.b	"SKIP, NO PAGE CROSS, BRANCH NOT TAKEN",0
	dc.b	BRANCH_TAKEN | SKIP_CYCLE, 0
	dc.b	"SKIP, NO PAGE CROSS, BRANCH TAKEN",0
	dc.b	PAGE_CROSS | SKIP_CYCLE, 0
	dc.b	"SKIP, PAGE CROSS, BRANCH NOT TAKEN",0
	dc.b	PAGE_CROSS | BRANCH_TAKEN | SKIP_CYCLE, 0
	dc.b	"SKIP, PAGE CROSS, BRANCH TAKEN",0
	dc.b	BURST_MODE | SKIP_CYCLE, 0
	dc.b	"BURST MODE + SKIP CYCLE, ALIGN 0",0
	dc.b	BURST_MODE | SKIP_CYCLE, 1
	dc.b	"BURST MODE + SKIP CYCLE, ALIGN 1",0
	dc.b	BURST_MODE | SKIP_CYCLE, 2
	dc.b	"BURST MODE + SKIP CYCLE, ALIGN 2",0
	dc.b	BURST_MODE | SKIP_CYCLE, 3
	dc.b	"BURST MODE + SKIP CYCLE, ALIGN 3",0
	dc.b	$ff
	

;**************************************************************************
;*
;* SECTION  instruction definitions
;*
;* DESCRIPTION
;*   instruction mode description table and jump tables to measurement
;*   routines.
;*
;******
IMP	equ	0
IMP_STACK equ	1
IMP_BRK	equ	2
IMP_RTS	equ	3
IMP_RTI	equ	4
IMM	equ	5
KIL	equ	6
ZP	equ	7
ZPX	equ	8
ZPY	equ	9
IZX	equ	10
IZY	equ	11
ABS	equ	12
ABY	equ	13
ABX	equ	14
ABS_JSR	equ	15
ABS_JMP	equ	16
IND_JMP	equ	17
REL_C	equ	18
REL_S	equ	19
REL_A	equ	20
IMM_SAC	equ	21
IMM_SIR	equ	22

modetable_nrm:
	dc.w	nrm_imp	;imp
	dc.w	nrm_imp	;imp_stack
	dc.w	nrm_brk	;imp_brk
	dc.w	nrm_rts	;imp_rts
	dc.w	nrm_rti	;imp_rti
	dc.w	nrm_imm	;imm 
	dc.w	nrm_kil	;kil
	dc.w	nrm_zp	;zp
	dc.w	nrm_zp	;zpx
	dc.w	nrm_zp	;zpy
	dc.w	nrm_zp	;izx
	dc.w	nrm_zp	;izy
	dc.w	nrm_abs	;abs
	dc.w	nrm_abs ;aby
	dc.w	nrm_abs ;abx
	dc.w	nrm_jmp	;jsr
	dc.w	nrm_jmp ;jmp
	dc.w	nrm_jmpind	;jmp_ind
	dc.w	nrm_relc	;rel_c
	dc.w	nrm_rels	;rel_s
	dc.w	nrm_rels	;rel_a
	dc.w	nrm_imm_sac	;imm_sac
	dc.w	nrm_imm_sir	;imm_sir
	
opcode_modes:
;$00-$0f
	dc.b	IMP_BRK,   IZX, KIL,  IZX, ZP,  ZP,  ZP,  ZP
	dc.b	IMP_STACK, IMM, IMP,  IMM, ABS, ABS, ABS, ABS 
;$10-$1f
	dc.b	REL_C,     IZY, REL_A,  IZY, ZPX, ZPX, ZPX, ZPX
	dc.b	IMP,       ABY, IMP,  ABY, ABX, ABX, ABX, ABX
;$20-$2f
	dc.b	ABS_JSR,   IZX, KIL,  IZX, ZP,  ZP,  ZP,  ZP
	dc.b	IMP_STACK, IMM, IMP,  IMM, ABS, ABS, ABS, ABS
;$30-$3f
	dc.b	REL_S,     IZY, IMM_SAC,  IZY, ZPX, ZPX, ZPX, ZPX
	dc.b	IMP,       ABY, IMP,  ABY, ABX, ABX, ABX, ABX
;$40-$4f
	dc.b	IMP_RTI,   IZX, IMM_SIR,  IZX, ZP,  ZP,  ZP,  ZP
	dc.b	IMP_STACK, IMM, IMP,  IMM, ABS_JMP, ABS, ABS, ABS 
;$50-$5f
 	dc.b	REL_C,     IZY, KIL,  IZY, ZPX, ZPX, ZPX, ZPX
	dc.b	IMP,       ABY, IMP,  ABY, ABX, ABX, ABX, ABX
;$60-$6f
	dc.b	IMP_RTS,   IZX, KIL,  IZX, ZP,  ZP,  ZP,  ZP
	dc.b	IMP_STACK, IMM, IMP,  IMM, IND_JMP, ABS, ABS, ABS 
;$70-$7f
 	dc.b	REL_S,     IZY, KIL,  IZY, ZPX, ZPX, ZPX, ZPX
	dc.b	IMP,       ABY, IMP,  ABY, ABX, ABX, ABX, ABX
;$80-$8f
	dc.b	IMM,       IZX, IMM,  IZX, ZP,  ZP,  ZP,  ZP
	dc.b	IMP,       IMM, IMP,  IMM, ABS, ABS, ABS, ABS
;$90-$9f
 	dc.b	REL_C,     IZY, KIL,  IZY, ZPX, ZPX, ZPY, ZPY
	dc.b	IMP,       ABY, IMP,  ABY, ABX, ABX, ABY, ABY
;$a0-$af
	dc.b	IMM,       IZX, IMM,  IZX, ZP,  ZP,  ZP,  ZP
	dc.b	IMP,       IMM, IMP,  IMM, ABS, ABS, ABS, ABS
;$b0-$bf
 	dc.b	REL_S,     IZY, KIL,  IZY, ZPX, ZPX, ZPY, ZPY
	dc.b	IMP,       ABY, IMP,  ABY, ABX, ABX, ABY, ABY
;$c0-$cf
	dc.b	IMM,       IZX, IMM,  IZX, ZP,  ZP,  ZP,  ZP
	dc.b	IMP,       IMM, IMP,  IMM, ABS, ABS, ABS, ABS
;$d0-$df
 	dc.b	REL_C,     IZY, KIL,  IZY, ZPX, ZPX, ZPX, ZPX
	dc.b	IMP,       ABY, IMP,  ABY, ABX, ABX, ABY, ABY
;$e0-$ef
	dc.b	IMM,       IZX, IMM,  IZX, ZP,  ZP,  ZP,  ZP
	dc.b	IMP,       IMM, IMP,  IMM, ABS, ABS, ABS, ABS
;$f0-$ff
 	dc.b	REL_S,     IZY, KIL,  IZY, ZPX, ZPX, ZPX, ZPX
	dc.b	IMP,       ABY, IMP,  ABY, ABX, ABX, ABX, ABX


	
;**************************************************************************
;*
;* mode selection
;*
;******
run_mode:
	dc.b	0
burst_align:
	dc.b	0
	
;**************************************************************************
;*
;* NAME  test opcodes
;*
;* DESCRIPTION
;*   handle test data
;*
;******
test_opcodes:
	sei
	lda	#$35
	sta	$01
; kill vic irqs
	lda	#$7f
	sta	$dc0d
	lda	$dc0d
; setup cia#2 timer for cycle counting
	lda	#$7f
	sta	$dd0d
	lda	$dd0d
	lda	#$00
	sta	$dd0e
	lda	#$00
	sta	$dd04
	lda	#$01
	sta	$dd05

; setup burst and skip
	lda	run_mode
	and	#%00000011
	tax
	sac	#$99
	txa
	sac	#$00	

	ldx	#0
	stx	count_zp
to_lp1:
	ldx	count_zp
	lda	opcode_modes,x
	asl
	tay
	lda	modetable_nrm,y
	sta	to_sm1+1
	lda	modetable_nrm+1,y
	sta	to_sm1+2

	lda	#"."
	ldy	#2
	jsr	plot_entry
	
	ldx	count_zp	
to_sm1:
	jsr	to_sm1

	ldx	count_zp
	sta	current_data,x
	cmp	#$ff
	bne	to_skp1
	lda	#"."
	ldy	#14
	bne	to_skp2
to_skp1:
	clc
	adc	#$30
	ldy	#5
to_skp2:
	jsr	plot_entry

	inc	count_zp
	bne	to_lp1

; restore and exit
	sac	#$99
	lda	#$00
	sac	#$00
	lda	#$37
	sta	$01
	jsr	$fda3
	cli
	rts

;**************************************************************************
;*
;* preserve/restore macros
;*
;******
	mac	PRESERVE
	tsx
	stx	stack_zp
	php
	pla
	sta	flags_zp
	pha	; dummy incase we pop
	jsr	safe_wait
	endm

	mac	RESTORE
	ldx	stack_zp
	txs
	lda	flags_zp
	pha
	plp
	tya	
	eor	#$ff
	endm

common_target:
	ldy	$dd04
common_restore:
	RESTORE
	rts	


;**************************************************************************
;*
;* NAME  nrm_kil
;*
;* DESCRIPTION
;*   undefined instructions (untested)
;*   
;******
nrm_kil:
	lda	#$ff
	rts

;**************************************************************************
;*
;* NAME  nrm_imp
;*
;* DESCRIPTION
;*   implied instructions
;*   
;******
nrm_imp:
	lda	#1
	sta	instr_len
	stx	instr_store
	jsr	make_tcode
	PRESERVE
	jmp	test_code

;**************************************************************************
;*
;* NAME  nrm_zp
;*
;* DESCRIPTION
;*   all zero page modes, calls nrm_imm
;*   
;******
nrm_zp:
	ldy	#0
	lda	run_mode
	and	#PAGE_CROSS
	beq	nzp_skp1
	ldy	#CROSS_OFFSET
nzp_skp1:
	sty	index_zp
; put a valid target addr in safe_zp / safe_zp+1
; and (safe_zp+CROSS_OFFSET)&$ff / (safe_zp+1+CROSS_OFFSET)&$ff	so we
; don't trash any unintended locations.
	lda	#<safe_abs
	sta	safe_zp
	sta	safe_zp-2
	lda	#>safe_abs
	sta	safe_zp+1
	sta	safe_zp-2+1
	lda	#safe_zp
	sta	instr_store+1
	jmp	nrm_imm

;**************************************************************************
;*
;* NAME  nrm_imm, nrm_imm_sac, nrm_imm_sir
;*
;* DESCRIPTION
;*   immediate instructions and zero page instructions
;*   
;******
;***
;immediate SAC.  Just make sure that the operand is #$00.
nrm_imm_sac:
	lda	#$00
	sta	instr_store+1
	jmp	nrm_imm
;***
;immediate SIR.  Just make sure that the operand is #$12.
nrm_imm_sir:
	lda	#$12
	sta	instr_store+1
;***
;common two byte instructions
nrm_imm:
	lda	#2
	sta	instr_len
	stx	instr_store
	jsr	make_tcode
	PRESERVE
	ldx	index_zp
	ldy	index_zp
	jmp	test_code

;**************************************************************************
;*
;* NAME  nrm_abs
;*
;* DESCRIPTION
;*   absolute memory instructions
;*   
;******
nrm_abs:
	ldy	#0
	lda	run_mode
	and	#PAGE_CROSS
	beq	nabs_skp1
	ldy	#CROSS_OFFSET
nabs_skp1:
	sty	index_zp
	lda	#3
	sta	instr_len
	stx	instr_store
	lda	#<safe_abs
	sta	instr_store+1
	lda	#>safe_abs
	sta	instr_store+2
	jsr	make_tcode
	PRESERVE
	ldx	index_zp
	ldy	index_zp
	jmp	test_code

	
;**************************************************************************
;*
;* NAME  nrm_jmp
;*
;* DESCRIPTION
;*   absolute jump instructions (JMP/JSR)
;*   
;******
nrm_jmp:
	lda	#3
	sta	instr_len
	stx	instr_store
	lda	#<common_target
	sta	instr_store+1
	lda	#>common_target
	sta	instr_store+2
	jsr	make_tcode
	PRESERVE
	jmp	test_code

;**************************************************************************
;*
;* NAME  nrm_jmpind
;*
;* DESCRIPTION
;*   indirect jump instruction measurment
;*   
;******
nrm_jmpind:
	lda	#3
	sta	instr_len
	stx	instr_store
	lda	#<common_target
	sta	safe_jmpind_ptr
	lda	#>common_target
	sta	safe_jmpind_ptr+1
	lda	#<safe_jmpind_ptr
	sta	instr_store+1
	lda	#>safe_jmpind_ptr
	sta	instr_store+2
	jsr	make_tcode
	PRESERVE
	jmp	test_code

;**************************************************************************
;*
;* NAME  nrm_brk
;*
;* DESCRIPTION
;*   brk instruction measurment
;*   
;******
nrm_brk:
	lda	#<common_target
	sta	$fffe
	lda	#>common_target
	sta	$ffff
	lda	#1
	sta	instr_len
	stx	instr_store
	jsr	make_tcode
	PRESERVE
	jmp	test_code

;**************************************************************************
;*
;* NAME  nrm_rts
;*
;* DESCRIPTION
;*   rts instruction measurment
;*   
;******
nrm_rts:
	lda	#1
	sta	instr_len
	stx	instr_store
	jsr	make_tcode
	PRESERVE
	lda	#>[common_target-1]
	pha
	lda	#<[common_target-1]
	pha
	jmp	test_code

;**************************************************************************
;*
;* NAME  nrm_rti
;*
;* DESCRIPTION
;*   rti instruction measurment
;*   
;******
nrm_rti:
	lda	#1
	sta	instr_len
	stx	instr_store
	jsr	make_tcode
	PRESERVE
	lda	#>[common_target]
	pha
	lda	#<[common_target]
	pha
	php
	jmp	test_code

;**************************************************************************
;*
;* NAME  nrm_rels, rem_relc
;*
;* DESCRIPTION
;*   branch instruction measurments
;*   
;******
;***
;branch instructions taken on flag set.
nrm_rels:
	ldy	#%00000000
	lda	run_mode
	and	#BRANCH_TAKEN
	beq	nrels_skp1
	ldy	#%11000011
nrels_skp1:
	sty	tmp_zp
	jmp	nrm_rel

;***
;branch instructions taken on flag clear.
nrm_relc:
	ldy	#%11000011
	lda	run_mode
	and	#BRANCH_TAKEN
	beq	nrelc_skp1
	ldy	#%00000000
nrelc_skp1:
	sty	tmp_zp

;***
;common for branch instructions.
nrm_rel:
	stx	instr_store
	lda	#2
	sta	instr_len
	jsr	make_tcode

	ldy	tail_offs
	lda	run_mode
	and	#PAGE_CROSS
	beq	nrel_skp1
	tya
	clc
	adc	#$40
	tay
nrel_skp1:
	tya
	sec
	sbc	instr_offs
	sec
	sbc	#2
	ldx	instr_offs
	sta	test_code+1,x
	PRESERVE
	lda	flags_zp
	and	#%00111100
	ora	tmp_zp
	pha
	plp
	jmp	test_code
	
;**************************************************************************
;*
;* NAME  code generation
;*
;* DESCRIPTION
;*   generate test code
;*   
;******
make_tcode:
	jsr	tcode_prep
	jsr	tcode_instr
	jsr	tcode_final
	rts
	
instr_store:
	dc.b	0,0,0
instr_len:
	dc.b	3
instr_offs:
	ds.b	1
tail_offs:
	ds.b	1

			
tcode_prep:
	ldy	#0
	ldx	#0
ptp_lp1:
	lda	prep_code,x
	jsr	prp_push
	inx
	cpx	#PREP_CODE_LEN
	bne	ptp_lp1
	rts

prep_code:
	php
	lda	#$11
	plp
	nop
	sta	$dd0e
PREP_CODE_LEN	equ	.-prep_code

		
tcode_instr:
	lda	run_mode
	and	#BURST_MODE
	bne	pti_burst

pti_normal:
	sty	instr_offs
	ldx	#0
pti_lp1:
	lda	instr_store,x
	jsr	prp_push
	inx
	cpx	instr_len
	bne	pti_lp1
	rts
	
pti_burst:
	ldx	burst_align
	lda	#$ea
	jmp	pti_skp1
pti_lp2:
	jsr	prp_push
pti_skp1:
	dex
	bpl	pti_lp2

	jsr	pti_normal
	
pti_lp3:
	tya
	and	#$07
	beq	pti_skp2
	lda	#$ea
	jsr	prp_push
	bne	pti_lp3
pti_skp2:
	rts
	
		
tcode_final:
	sty	tail_offs
	ldx	#0
ptf_lp1:
	lda	final_code,x
	jsr	prp_push
	inx
	cpx	#FINAL_CODE_LEN
	bne	ptf_lp1
	rts
	
final_code:
	ldy	$dd04
	jmp	common_restore
FINAL_CODE_LEN	equ	.-final_code

prp_push:
	sta	test_code,y
	sta	test_code_new_page,y
	iny
	rts

;**************************************************************************
;*
;* NAME  safe_wait
;*
;* DESCRIPTION
;*   safe_wait
;*   
;******
safe_wait:
	inc	$d020
sw_lp1:
	lda	$d011
	eor	$d012
	and	#%00000111
	bne	sw_lp1
	lda	$d012
sw_lp2:
	cmp	$d012
	beq	sw_lp2
	dec	$d020
	rts

;**************************************************************************
;*
;* NAME  plot_entry
;*
;* DESCRIPTION
;*   plot an entry in the opcode table.
;*   X=opcode, Acc=Scrcode, Y=Color
;*   
;******
plot_entry:
	stx	xtmp_zp
	sty	ytmp_zp
	pha
	txa
	and	#$0f
	sta	tmp_zp
	txa
	lsr
	lsr
	lsr
	and	#$1e
	tax
	lda	ytab,x
	sta	$d1
	sta	$f3
	lda	ytab+1,x
	sta	$d2
	clc
	adc	#$d8-$04
	sta	$f4
	tya
	ldy	tmp_zp
	sta	($f3),y
	pla
	sta	($d1),y
	ldx	xtmp_zp
	ldy	ytmp_zp
	rts

SCBASE	equ	$0400+40*0+0
ytab:
	dc.w	SCBASE+40*0,  SCBASE+40*1,  SCBASE+40*2,  SCBASE+40*3
	dc.w	SCBASE+40*4,  SCBASE+40*5,  SCBASE+40*6,  SCBASE+40*7
	dc.w	SCBASE+40*8,  SCBASE+40*9,  SCBASE+40*10, SCBASE+40*11
	dc.w	SCBASE+40*12, SCBASE+40*13, SCBASE+40*14, SCBASE+40*15

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
;* SECTION  reference data
;*
;******
	ifconst	RECORD_REFDATA
record_refdata:
	ldx	#0
rr_lp1:
	lda	current_data,x
rr_sm1:
	sta	REFDATA_STORE,x
	inx
	bne	rr_lp1
	inc	rr_sm1+2
	rts
record_done:
	lda	#<ref_msg
	ldy	#>ref_msg
	jsr	print
	lda	#>REFDATA_STORE
	jsr	print_hex
	lda	#<REFDATA_STORE
	jsr	print_hex
	lda	#"-"
	jsr	$ffd2
	lda	rr_sm1+2
	jsr	print_hex
	lda	rr_sm1+1
	jsr	print_hex
	lda	#13
	jsr	$ffd2
	rts
ref_msg:
	dc.b	13,13,"REFDATA RECORDED: ",0
	endif
			
; ref_data:
; 	incbin	"reftiming_dtv.bin"
	
end_code	equ	.
	seg.u	bss1
	org	end_code
;**************************************************************************
;*
;* SECTION  bss
;*
;******
	align	256
	ds.b	$c0
test_code:
	echo	.
	align	256
test_code_new_page:
	echo	.
	ds.b	256

; current timings
	align	256
current_data:
	ds.b	256
; eof
