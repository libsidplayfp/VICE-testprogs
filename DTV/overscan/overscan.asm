;**************************************************************************
;*
;* FILE  overscan.asm
;* Copyright (c) 2007 Daniel Kahlin <daniel@kahlin.net>
;* Written by Daniel Kahlin <daniel@kahlin.net>
;*
;* DESCRIPTION
;*   Overscan alignment and bug test.
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
	lda	#$01
	sta	$d03f

	jsr	prepare_screen

lp1:
	lda	mode
	bne	skp1
	jsr	show_normal
	bra	skp2
skp1:
	jsr	show_overscan
skp2:

lp2:
	jsr	$ffe4
	beq	lp2
	cmp	#"N"
	beq	set_normal
	cmp	#"O"
	beq	set_overscan
	cmp	#"C"
	beq	inc_cnt
	cmp	#"X"
	beq	inc_xscroll
	bra	lp2

set_normal:
	lda	#0
	sta	mode
	jmp	lp1
set_overscan:
	lda	#1
	sta	mode
	jmp	lp1

inc_cnt:
	ldx	cnt
	inx
	cpx	#12
	bne	ic_skp1
	ldx	#0
ic_skp1:
	stx	cnt
	jmp	lp1

inc_xscroll:
	ldx	xscroll
	inx
	txa
	and	#7
	sta	xscroll
	jmp	lp1
	
mode:
	dc.b	0
cnt:
	dc.b	0
xscroll:
	dc.b	0

show_normal:
	sei
	jsr	wait_wb
; Chunky=1, No badlines=1, Color Disable=1,
; Overscan=0, HighColor=1, Border Off=1, Linear=1	
	lda	#%01110101
	sta	$d03c
; ECM=1, BMM=0, Screen=1, 25Row=1, YScroll=3 
	lda	#%01011011
	sta	$d011
	lda	#0
	sta	$d049	;Ptr B (Low)
	lda	#0
	sta	$d04a	;Ptr B (Mid)
	lda	#4
	sta	$d04b	;Ptr B (High)
	bra	show_common

show_overscan:
	sei
	jsr	wait_wb
; Chunky=1, No badlines=1, Color Disable=1,
; Overscan=1, HighColor=1, Border Off=1, Linear=1	
	lda	#%01111111
	sta	$d03c
; ECM=1, BMM=0, Screen=1, 25Row=1, YScroll=3 
	lda	#%01011011
	sta	$d011
	lda	#$f8
	sta	$d049	;Ptr B (Low)
	lda	#$ff
	sta	$d04a	;Ptr B (Mid)
	lda	#1
	sta	$d04b	;Ptr B (High)

show_common:
	lda	#8
	sta	$d04c	;Step B
; MCM=1, 40Col=1, XScroll=0
	lda	#%00011000
	ora	xscroll
	sta	$d016


	lda	#0
	sta	$d045	;Ptr A (High)
	sta	$d046	;Step A
	sta	$d038	;Mod A (Low) 
	sta	$d039	;Mod A (High) 

	ldx	#15
	lda	#0
sc_lp1:
	sta	$d200,x
	dex
	bpl	sc_lp1

	lda	#$0f
	ldx	cnt
	sta	$d204,x

	lda	#0
	sta	$d020
	sta	$07fc
	sta	$07fd
	sta	$07fe
	sta	$07ff
	cli
	rts


wait_wb:
ww_lp1:
	lda	$d011
	bpl	ww_lp1
ww_lp2:
	lda	$d011
	bmi	ww_lp2
	rts
	
		
prepare_screen:
	lda	#$02
	jsr	prepare_dma384
	jsr	clear_buf

	ldx	#23
ps_lp2:
	lda	tab1,x
	sta	line_buf,x
	lda	tab2,x
	sta	line_buf+384-24,x
	dex
	bpl	ps_lp2

	lda	#$5f
	sta	line_buf+$30
	sta	line_buf+$30+311
	sta	line_buf+$30+319
	
		
	ldy	#200
ps_lp1:
	jsr	do_dma
	dey
	bne	ps_lp1	


	lda	#$04
	jsr	prepare_dma320
	jsr	clear_buf

	lda	#$5f
	sta	line_buf
	sta	line_buf+311
	sta	line_buf+319
		
	ldy	#200
ps_lp3:
	jsr	do_dma
	dey
	bne	ps_lp3
	
	rts
	
tab1:
	dc.b	$04,$05,$06,$07,$08,$09,$0a,$0b
	dc.b	$0c,$0d,$0e,$0f
	dc.b	$04,$05,$06,$07,$08,$09,$0a,$0b
	dc.b	$0c,$0d,$0e,$0f
	
tab2:
	dc.b	$0f,$0e,$0d,$0c,$0b,$0a,$09,$08
	dc.b	$07,$06,$05,$04
	dc.b	$0f,$0e,$0d,$0c,$0b,$0a,$09,$08
	dc.b	$07,$06,$05,$04
	

prepare_dma384:
	ldx	#<384
	stx	dmatab+$0a
	ldx	#>384
	stx	dmatab+$0b
	bra	pd_common
prepare_dma320:
	ldx	#<320
	stx	dmatab+$0a
	ldx	#>320
	stx	dmatab+$0b
pd_common:
	ora	#$40
	sta	dmatab+$05
	ldx	#$1e
pd_lp1:
	lda	dmatab,x
	sta	$d300,x
	dex
	bpl	pd_lp1
	rts

do_dma:	
	lda	#%00001101
	sta	$d31f
dd_lp1:
	lda	$d31f
	lsr
	bcs	dd_lp1
	lda	#%00001000
	sta	$d31d		; dest continue
	rts

	
dmatab:
	dc.b	<line_buf,>line_buf,$40  ; $d300 src
	dc.b	0,0,0		; $d303 dest
	dc.w	1		; $d306 src step
	dc.w	1		; $d308 dest step
	dc.w	320		; $d30a dma length
	dc.w	0		; $d30c src modulo
	dc.w	0		; $d30e dest modulo
	dc.w	0		; $d310 src line len
	dc.w	0		; $d312 dest line len
	dc.b	0,0,0,0,0,0,0,0,0 ;  unused
	dc.b	0		; $d31d irq
	dc.b	%00000000	; $d31e modulo enables


clear_buf:
	ldx	#0
	txa
cb_lp1:
	sta	line_buf,x
	sta	line_buf+384-256,x
	inx
	bne	cb_lp1
	rts

line_buf:
	ds.b	384

; eof
