;**************************************************************************
;*
;* FILE  dmatime.asm
;* Copyright (c) 2009 Daniel Kahlin <daniel@kahlin.net>
;* Written by Daniel Kahlin <daniel@kahlin.net>
;* $Id$
;*
;* DESCRIPTION
;*   DMA timing analysis
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
	MAC	nopalign
	ds.b	[4+{1}-[. & 3]]&3,$ea
	ENDM

DMA_LENGTH	equ	5
CPU_LENGTH	equ	10
BUF_LENGTH	equ	64
	
	seg.u	zp
;**************************************************************************
;*
;* zero page
;*
;******
	org	$f8
ptr_zp:
	ds.w	1
offset_zp:
	ds.b	1
dmasrc_zp:
	ds.w	1
cpusrc_zp:
	ds.w	1
pre_zp:
	ds.b	1
post_zp:
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
	lda	#<greet_msg
	ldy	#>greet_msg
	jsr	print

	lda	#1
	sta	$d03f

	lda	#$44
	sta	dmasrc_zp
	lda	#$d0
	sta	dmasrc_zp+1
	lda	#$1f
	sta	cpusrc_zp
	lda	#$d3
	sta	cpusrc_zp+1
	jsr	measure_load_sweep

	jsr	print_dma

	jsr	print_cpu	

	lda	#$44
	sta	cpusrc_zp
	lda	#$d0
	sta	cpusrc_zp+1
	jsr	measure_load_sweep

	jsr	print_cpu

	lda	#0
	sta	$d03f
	jmp	$a474

greet_msg:
	dc.b	13
	dc.b	"C64DTV DMA TIMING TEST / TLR",13
	dc.b	"----------------------------",13
	dc.b	"1: DMA $D044 -> BUF",13
	dc.b	"2: CPU $D31F -> BUF",13
	dc.b	"3: CPU $D044 -> BUF",13
	dc.b	"SYNC BY POLLING FOR $D012 TOGGLE",13,13,0

;**************************************************************************
;*
;* NAME  print_dma
;*
;* DESCRIPTION
;*   print DMA buffer contents
;*   
;******
print_dma:
	lda	#<dma1_msg
	ldy	#>dma1_msg
	jsr	print
	ldx	#0
pd_lp1:
	lda	#" "
	jsr	$ffd2
	jsr	$ffd2
	jsr	$ffd2
	jsr	$ffd2
	lda	dma_buf,x
	jsr	print_hex
	inx
	cpx	#DMA_LENGTH
	bne	pd_lp1
	lda	#13
	jsr	$ffd2
	rts
dma1_msg:
	dc.b	"  ",0


;**************************************************************************
;*
;* NAME  print_cpu
;*
;* DESCRIPTION
;*   print CPU buffer contents (+pre_zp)
;*   
;******
print_cpu:
	lda	pre_zp
	jsr	print_hex
	lda	#<cpu_msg
	ldy	#>cpu_msg
	jsr	print
	ldx	#0
pc_lp1:
	lda	#" "
	jsr	$ffd2
	lda	cpu_buf,x
	jsr	print_hex
	inx
	cpx	#CPU_LENGTH
	bne	pc_lp1
	lda	#13
	jsr	$ffd2
	rts
	
cpu_msg:
	dc.b	" --",0

;**************************************************************************
;*
;* NAME  measure_load_sweep
;*
;* DESCRIPTION
;*   measure DMA accesses.
;*   
;******
measure_load_sweep:

; clear DMA registers
	ldx	#$1f
	lda	#0
mls_lp1:
	sta	$d300,x
	dex
	bpl	mls_lp1

; setup consecutive reads from a single register into the buffer 
	lda	dmasrc_zp
	sta	$d300
	lda	dmasrc_zp+1
	sta	$d301
	lda	#$80
	sta	$d302
	lda	#<dma_buf
	sta	$d303
	lda	#>dma_buf
	sta	$d304
	lda	#$40
	sta	$d305
	lda	#1
	sta	$d308		; dest step
	lda	#DMA_LENGTH
	sta	$d30a		; dma length

; clear measurement buffers.
	lda	#0
	ldx	#BUF_LENGTH
mls_lp2:
	sta	cpu_buf-1,x
	sta	dma_buf-1,x
	dex
	bne	mls_lp2

; perform sweep
	lda	#0
	sta	offset_zp
mls_lp3:
	jsr	measure_load
	ldx	offset_zp
	lda	post_zp
	sta	cpu_buf,x
	inx	
	stx	offset_zp
	cpx	#CPU_LENGTH
	bne	mls_lp3
	rts


;**************************************************************************
;*
;* NAME  measure_load
;*
;* DESCRIPTION
;*   measure DMA accesses.
;*   
;******
measure_load:
	sei

; generate speed code
	jsr	generate_load

; find stable point
	jsr	wait_vb
	ds.b	18,$ea
ml_lp1:
	ds.b	18,$ea
	dec	$d020
	inc	$d020
	lda	$d012		; 4
	cmp	$d012		; 4
	beq	ml_skp1		; 3(2)
ml_skp1:
	cmp	#$20
	bne	ml_lp1
	if	[>[.]]!=[>ml_lp1]
	echo	"page crossing in stable point"
	err
	endif

; set burst mode
	sac	$99
	lda	#%00000011
	sac	$00

; perform test
	inc	$d020
	lda	#%00001101
	jsr	speed_code
	dec	$d020	
	stx	pre_zp
	sta	post_zp

; restore skip and burst 
	sac	$99
	lda	#%00000000
	sac	$00
	cli
	rts

	
;**************************************************************************
;*
;* NAME  generate_load
;*
;* DESCRIPTION
;*   generate load measurement code:	
;*
;*     NOP
;*     LDX <cpusrc>
;*     NOP
;*     STA $D31F ; start DMA
;*     [NOP; NOP; NOP; NOP] * offset_zp times.
;*     NOP
;*     LDA <cpusrc>
;*     RTS
;*   
;******
generate_load:
	ldy	#0
	lda	#<speed_code
	sta	ptr_zp
	lda	#>speed_code
	sta	ptr_zp+1
	
	lda	#$ae		; LDX <abs>
	jsr	gnl_push_load

	lda	#$ea
	sta	(ptr_zp),y
	iny
	lda	#$8d		; STA <abs>
	sta	(ptr_zp),y
	iny
	lda	#<$d31f
	sta	(ptr_zp),y
	iny
	lda	#>$d31f
	sta	(ptr_zp),y
	iny

	lda	offset_zp
	beq	gnl_skp1
	asl
	asl
	tax
	lda	#$ea
gnl_lp1:
	sta	(ptr_zp),y
	iny
	dex
	bne	gnl_lp1
gnl_skp1:

	lda	#$ad		; LDA <abs>
	jsr	gnl_push_load

	lda	#$60		; RTS
	sta	(ptr_zp),y
	rts

	
gnl_push_load:
	pha
	lda	#$ea
	sta	(ptr_zp),y
	iny
	pla
	sta	(ptr_zp),y
	iny
	lda	cpusrc_zp
	sta	(ptr_zp),y
	iny
	lda	cpusrc_zp+1
	sta	(ptr_zp),y
	iny
	rts

;**************************************************************************
;*
;* NAME  wait_vb
;*
;* DESCRIPTION
;*   wait for vertical blanking
;*   
;******
wait_vb:
wv_lp1:
	lda	$d011
	bpl	wv_lp1
wv_lp2:
	lda	$d011
	bmi	wv_lp2
	rts

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

		
end_code	equ	.
	seg.u	bss
	org	end_code
;**************************************************************************
;*
;* SECTION  bss
;*
;******
	align	256
cpu_buf:
	ds.b	BUF_LENGTH
	align	256
dma_buf:
	ds.b	BUF_LENGTH
	align	256
speed_code:
	echo	.

; eof
