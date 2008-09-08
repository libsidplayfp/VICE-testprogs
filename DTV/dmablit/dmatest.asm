;**************************************************************************
;*
;* FILE  dmatest.asm
;* Copyright (c) 2007 Daniel Kahlin <daniel@kahlin.net>
;* Written by Daniel Kahlin <daniel@kahlin.net>
;* $Id: dmatest.asm,v 1.6 2007-05-11 19:11:17 tlr Exp $
;*
;* DESCRIPTION
;*   DMA controller regression tests
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
	dc.b	$12,{1}-2-.
	ENDM

	MAC	DMAREG
	dc.b	{1}&$ff,{2}
	ENDM
	MAC	DMAEND
	dc.b	$ff,0
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
	jsr	dma_test

	jmp	$a474

msg:	
	dc.b	147
	dc.b	"DTV2/3 DMA TEST / TLR'07",13,13,0
	
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
;* NAME  dma_test
;*
;* DESCRIPTION
;*
;******
dma_test:
	lda	#1
	sta	$d03f
	ldx	#<test_tab
	ldy	#>test_tab
	jsr	set_tptr
		
dt_lp1:
	lda	#<msg
	ldy	#>msg
	jsr	print

	jsr	fetch_tptr
	beq	dt_ex1
	tax
	
dt_lp3:
	jsr	fetch_tptr
	jsr	$ffd2
	bne	dt_lp3


	sei
 	cpx	#$02
	beq	dt_skp2
	jsr	wipe_dma
dt_skp2:
	jsr	perform_dma
	
	cli

	lda	#<dma_msg
	ldy	#>dma_msg
	jsr	print
	lda	#>realbuf
	jsr	print_tab

	lda	#<ref_msg
	ldy	#>ref_msg
	jsr	print
	lda	#>destbuf
	jsr	print_tab

	ldx	#0
dt_lp4:
	lda	realbuf,x
	cmp	destbuf,x
	bne	dt_skp1
	inx
	bne	dt_lp4
	lda	#<ok_msg
	ldy	#>ok_msg
	bra	dt_skp3
dt_skp1:
	lda	#<mismatch_msg
	ldy	#>mismatch_msg
dt_skp3:
	jsr	print
	
dt_lp2:
	jsr	$ffe4
	beq	dt_lp2

	jmp	dt_lp1
dt_ex1:
	lda	#0
	sta	$d03f
	rts

dma_msg:
	dc.b	13,"DMA:",13,0
ref_msg:
	dc.b	13,"REFERENCE:",13,0
ok_msg:
	dc.b	13,"OK.",0
mismatch_msg:
	dc.b	13,"MISMATCH!",0

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

test_tab:
	dc.b	1
	dc.b	"FORWARD TRANSFER",0
	DMAREG	$d300,0		; Src LSB
	DMAREG	$d303,0		; Dest LSB
	DMAREG	$d306,1		; Source Step
	DMAREG	$d308,1		; Dest Step
	DMAREG	$d30a,16	; DMA Length
	DMAREG	$d31f,%00001101
	DMAEND

	dc.b	1
	dc.b	"REVERSE DEST TRANSFER",0
	DMAREG	$d300,0		; Src LSB
	DMAREG	$d303,15	; Dest LSB
	DMAREG	$d306,1		; Source Step
	DMAREG	$d308,1		; Dest Step
	DMAREG	$d30a,16	; DMA Length
	DMAREG	$d31f,%00000101
	DMAEND

	dc.b	1
	dc.b	"REVERSE SRC TRANSFER",0
	DMAREG	$d300,15	; Src LSB
	DMAREG	$d303,0		; Dest LSB
	DMAREG	$d306,1		; Source Step
	DMAREG	$d308,1		; Dest Step
	DMAREG	$d30a,16	; DMA Length
	DMAREG	$d31f,%00001001
	DMAEND

	dc.b	1
	dc.b	"DEST STEP=2",0
	DMAREG	$d300,0		; Src LSB
	DMAREG	$d303,0		; Dest LSB
	DMAREG	$d306,1		; Source Step
	DMAREG	$d308,2		; Dest Step
	DMAREG	$d30a,16	; DMA Length
	DMAREG	$d31f,%00001101
	DMAEND

	dc.b	1
	dc.b	"DEST STEP=0",0
	DMAREG	$d300,0		; Src LSB
	DMAREG	$d303,0		; Dest LSB
	DMAREG	$d306,1		; Source Step
	DMAREG	$d308,0		; Dest Step
	DMAREG	$d30a,16	; DMA Length
	DMAREG	$d31f,%00001101
	DMAEND

	dc.b	1
	dc.b	"SRC STEP=2",0
	DMAREG	$d300,0		; Src LSB
	DMAREG	$d303,0		; Dest LSB
	DMAREG	$d306,2		; Source Step
	DMAREG	$d308,1		; Dest Step
	DMAREG	$d30a,16	; DMA Length
	DMAREG	$d31f,%00001101
	DMAEND

	dc.b	1
	dc.b	"SRC STEP=0",0
	DMAREG	$d300,0		; Src LSB
	DMAREG	$d303,0		; Dest LSB
	DMAREG	$d306,0		; Source Step
	DMAREG	$d308,1		; Dest Step
	DMAREG	$d30a,16	; DMA Length
	DMAREG	$d31f,%00001101
	DMAEND

	dc.b	1
	dc.b	"DEST LL=0, MOD=0",0
	DMAREG	$d300,0		; Src LSB
	DMAREG	$d303,0		; Dest LSB
	DMAREG	$d306,1		; Source Step
	DMAREG	$d308,1		; Dest Step
	DMAREG	$d30a,16	; DMA Length
	DMAREG	$d30e,0		; Dest Modulo
	DMAREG	$d312,0		; Dest line length
	DMAREG	$d31e,%00000010
	DMAREG	$d31f,%00001101
	DMAEND

	dc.b	1
	dc.b	"DEST LL=0, MOD=1",0
	DMAREG	$d300,0		; Src LSB
	DMAREG	$d303,0		; Dest LSB
	DMAREG	$d306,1		; Source Step
	DMAREG	$d308,1		; Dest Step
	DMAREG	$d30a,16	; DMA Length
	DMAREG	$d30e,1		; Dest Modulo
	DMAREG	$d312,0		; Dest line length
	DMAREG	$d31e,%00000010
	DMAREG	$d31f,%00001101
	DMAEND

	dc.b	1
	dc.b	"DEST LL=1, MOD=1",0
	DMAREG	$d300,0		; Src LSB
	DMAREG	$d303,0		; Dest LSB
	DMAREG	$d306,1		; Source Step
	DMAREG	$d308,1		; Dest Step
	DMAREG	$d30a,16	; DMA Length
	DMAREG	$d30e,1		; Dest Modulo
	DMAREG	$d312,1		; Dest line length
	DMAREG	$d31e,%00000010
	DMAREG	$d31f,%00001101
	DMAEND

	dc.b	1
	dc.b	"DEST LL=2, MOD=2",0
	DMAREG	$d300,0		; Src LSB
	DMAREG	$d303,0		; Dest LSB
	DMAREG	$d306,1		; Source Step
	DMAREG	$d308,1		; Dest Step
	DMAREG	$d30a,16	; DMA Length
	DMAREG	$d30e,2		; Dest Modulo
	DMAREG	$d312,2		; Dest line length
	DMAREG	$d31e,%00000010
	DMAREG	$d31f,%00001101
	DMAEND

	dc.b	1
	dc.b	"DEST LL=2, MOD=0",0
	DMAREG	$d300,0		; Src LSB
	DMAREG	$d303,0		; Dest LSB
	DMAREG	$d306,1		; Source Step
	DMAREG	$d308,1		; Dest Step
	DMAREG	$d30a,16	; DMA Length
	DMAREG	$d30e,0		; Dest Modulo
	DMAREG	$d312,2		; Dest line length
	DMAREG	$d31e,%00000010
	DMAREG	$d31f,%00001101
	DMAEND

	dc.b	1
	dc.b	"DEST STEP=2, LL=3, MOD=5",0
	DMAREG	$d300,0		; Src LSB
	DMAREG	$d303,0		; Dest LSB
	DMAREG	$d306,1		; Source Step
	DMAREG	$d308,2		; Dest Step
	DMAREG	$d30a,16	; DMA Length
	DMAREG	$d30e,5		; Dest Modulo
	DMAREG	$d312,3		; Dest line length
	DMAREG	$d31e,%00000010
	DMAREG	$d31f,%00001101
	DMAEND

	dc.b	1
	dc.b	"DEST STEP=2, LL=3, MOD=5, SWAP",0
	DMAREG	$d300,0		; Src LSB
	DMAREG	$d301,>destbuf	; Src MidSB
	DMAREG	$d303,0		; Dest LSB
	DMAREG	$d304,>srcbuf	; Dest MidSB
	DMAREG	$d306,1		; Source Step
	DMAREG	$d308,2		; Dest Step
	DMAREG	$d30a,16	; DMA Length
	DMAREG	$d30e,5		; Dest Modulo
	DMAREG	$d312,3		; Dest line length
	DMAREG	$d31e,%00000010
	DMAREG	$d31f,%00001111
	DMAEND
	
	dc.b	1
	dc.b	"FORWARD TRANSFER",0
	DMAREG	$d300,0		; Src LSB
	DMAREG	$d303,0		; Dest LSB
	DMAREG	$d306,1		; Source Step
	DMAREG	$d308,1		; Dest Step
	DMAREG	$d30a,16	; DMA Length
	DMAREG	$d31f,%00001101
	DMAEND

	dc.b	2
	dc.b	"SRC CONTINUE",0
	DMAREG	$d303,0		; Dest LSB
	DMAREG	$d306,1		; Source Step
	DMAREG	$d308,1		; Dest Step
	DMAREG	$d30a,16	; DMA Length
	DMAREG	$d31d,%00000010 
	DMAREG	$d31f,%00001101
	DMAEND

	dc.b	2
	dc.b	"DEST CONTINUE",0
	DMAREG	$d306,1		; Source Step
	DMAREG	$d308,1		; Dest Step
	DMAREG	$d30a,16	; DMA Length
	DMAREG	$d31d,%00001000 
	DMAREG	$d31f,%00001101
	DMAEND

	dc.b	0

	
;**************************************************************************
;*
;* NAME  soft_dma
;*
;* DESCRIPTION
;*   emulate dma controller in software.
;*   
;******
wipe_dma:
	ldx	#$1f
	lda	#0
wd_lp1:
	sta	softdma_regs,x
	sta	$d300,x
	dex
	bpl	wd_lp1
	lda	#>srcbuf
	sta	$d301
	sta	softdma_regs+$01
	lda	#>destbuf
	sta	$d304
	sta	softdma_regs+$04
	lda	#$40
	sta	$d302
	sta	softdma_regs+$02
	sta	$d305	
	sta	softdma_regs+$05
	rts

STATE_XX	equ	$fe
STATE_UU	equ	$ff
	
prepare_buf:
	ldx	#0
pb_lp1:
	txa
	sta	srcbuf,x
	lda	#STATE_XX
	sta	srcbuf_head,x
	sta	srcbuf_tail,x
	lda	#STATE_UU
	sta	destbuf,x
	lda	#0
	sta	destbuf_head,x
	sta	destbuf_tail,x
	inx
	bne	pb_lp1

	lda	#STATE_XX
	sta	srcbuf+$fe
	sta	srcbuf+$ff
	rts
		
perform_dma:
	jsr	prepare_buf
	
pd_lp1:
	jsr	fetch_tptr
	bmi	pd_skp1
	tax
	jsr	fetch_tptr
	sta	softdma_regs,x
	sta	$d300,x
	bra	pd_lp1
pd_skp1:
	jsr	fetch_tptr

pd_lp2:
	lda	$d31f
	lsr
	bcs	pd_lp2

	ldy	#0
pd_lp3:
	lda	destbuf,y
	sta	realbuf,y
	iny
	bne	pd_lp3
		
	jsr	prepare_buf

 	jsr	do_softdma

	rts

do_softdma:
	lda	softdma_regs+$1d
	and	#%00000010	; Src Continue?
	bne	dsd_skp7
	lda	softdma_regs+$00
	sta	dmasrc
dsd_skp7:
	lda	softdma_regs+$1d
	and	#%00001000	; Dest Continue?
	bne	dsd_skp8
	lda	softdma_regs+$03
	sta	dmadest
dsd_skp8:
	lda	softdma_regs+$0a
	sta	dmalen
	lda	softdma_regs+$10
	sta	dmasrcll
	lda	softdma_regs+$12
	sta	dmadestll

dsd_lp1:
; transfer data
	lda	softdma_regs+$1f
	and	#%00000010
	bne	dsd_skp55
 	ldx	dmasrc
	lda	srcbuf,x
 	ldx	dmadest
	sta	destbuf,x
	bra	dsd_skp56
dsd_skp55:
 	ldx	dmadest
	lda	srcbuf,x
 	ldx	dmasrc
	sta	destbuf,x
dsd_skp56:

; update internal dma source address
	lda	softdma_regs+$1e
	and	#%00000001
	beq	dsd_skp11
	lda	dmasrcll
	bne	dsd_skp11
	lda	softdma_regs+$10 ; Src Line Length
	sta	dmasrcll
	lda	dmasrc
	clc
	adc	softdma_regs+$0c ; Src Modulo
	bra	dsd_skp2
dsd_skp11:
	dec	dmasrcll
	lda	softdma_regs+$1f
	and	#%00000100
	beq	dsd_skp1
	lda	dmasrc
	clc
	adc	softdma_regs+$06
	bra	dsd_skp2
dsd_skp1:
	lda	dmasrc
	sec
	sbc	softdma_regs+$06
dsd_skp2:
	sta	dmasrc

; update internal dma destination address
	lda	softdma_regs+$1e
	and	#%00000010
	beq	dsd_skp33
	lda	dmadestll
	bne	dsd_skp33
	lda	softdma_regs+$12 ; Dest Line Length
	sta	dmadestll
	lda	dmadest
	clc
	adc	softdma_regs+$0e ; Dest Modulo
	bra	dsd_skp4
dsd_skp33:
	dec	dmadestll
	lda	softdma_regs+$1f
	and	#%00001000
	beq	dsd_skp3
	lda	dmadest
	clc
	adc	softdma_regs+$08
	bra	dsd_skp4
dsd_skp3:
	lda	dmadest
	sec
	sbc	softdma_regs+$08
dsd_skp4:
	sta	dmadest


	
; check if done
	dec	dmalen
	beq	dsd_ex1
	jmp	dsd_lp1
dsd_ex1:
	rts
	

end_code	equ	.
	seg.u	bss1
	org	end_code
softdma_regs:
	ds.b	$20
dmasrc:
	ds.b	3
dmadest:
	ds.b	3
dmalen:
	ds.b	2
dmasrcll:
	ds.b	2
dmadestll:
	ds.b	2
	
	seg.u	bss2
	org	$c000	
srcbuf_head:
	ds.b	256
srcbuf:
	ds.b	256
srcbuf_tail:
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
