;**************************************************************************
;*
;* FILE  fetchsplit.asm
;* Copyright (c) 2010 Daniel Kahlin <daniel@kahlin.net>
;* Written by Daniel Kahlin <daniel@kahlin.net>
;*
;* DESCRIPTION
;*
;*          vbank1    vbank2    vbank3
;* bitmap0 4000-4fff 8000-8fff c000-cfff
;* bitmap1 6000-6fff a000-afff e000-efff
;* cset0   7000-77ff b000-b7ff f000-f7ff
;* cset1   7800-7bff b800-bbff f800-fbff
;* screen  7c00-7fff bc00-bfff fc00 ffff
;*
;******
	processor 6502


LINE		equ	56

	seg.u	zp
;**************************************************************************
;*
;* SECTION  zero page
;*
;******
	org	$02
ptr_zp:
	ds.w	1
offs_zp:
	ds.b	1
tm1_zp:
	ds.b	1
tm2_zp:
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
	jsr	check_time
	sta	cycles_per_line
	stx	num_lines

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

	lda	cycles_per_line
	sec
	sbc	#63
	bcc	sa_fl1		;<63, fail
	cmp	#66-63		;>=66, fail
	bcs	sa_fl1
	tax
	lda	time1,x
	sta	is_sm1+1

	jsr	test_prepare
	
	jsr	wait_vb

	lda	#$1b | (>LINE << 7)
	sta	$d011
	lda	#<LINE
	sta	$d012
	lda	#1
	sta	$d019
	sta	$d01a

	cli
	
sa_lp2:
	if	0
; be evil to timing to provoke glitches
	inx
	bpl	sa_lp2
	inc	$4080,x
	dec	$4080,x
	endif
	jmp	sa_lp2

vectors:
	dc.w	nmi_entry,0,irq_stable

sa_fl1:
nmi_entry:
	sei
	lda	#$37
	sta	$01
	jmp	$fe66

cycles_per_line:
	dc.b	0
num_lines:
	dc.b	0
time1:
	dc.b	irq_stable2_pal, irq_stable2_ntscold, irq_stable2_ntsc

;**************************************************************************
;*
;* NAME  irq_stable, irq_stable2
;*   
;******
irq_stable:
	sta	accstore	; 4
	sty	ystore		; 4
	stx	xstore		; 4
	inc	$d019		; 6
	inc	$d012		; 6
is_sm1:
	lda	#<irq_stable2_pal	; 2
	sta	$fffe		; 4
	tsx			; 2
	cli			; 2
;10 * nop for PAL (63)
;11 * nop for NTSC (65)
	ds.b	11,$ea		; 22
; guard
is_lp1:
	sei
	inc	$d020
	jmp	is_lp1	

;28 cycles for NTSC (65)
;27 cycles for NTSCOLD (64)
;26 cycles for PAL (63)
irq_stable2_ntsc:
	dc.b	$2c		; bit <abs>
irq_stable2_ntscold:
	dc.b	$24		; bit <zp>
irq_stable2_pal:
	dc.b	$ea
	jsr	twelve		; 12
	jsr	twelve		; 12
;---
	txs			; 2
	dec	$d019		; 6
	dec	$d012		; 6
	lda	#<irq_stable	; 2
	sta	$fffe		; 4	=46
	lda	$d012		; 4
	eor	$d012		; 4
	beq	is2_skp1	; 2 (3)
is2_skp1:

	jsr	test_perform
		
accstore	equ	.+1
	lda	#0
xstore	equ	.+1
	ldx	#0
ystore	equ	.+1
	ldy	#0
	rti

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
;* NAME  check_time
;*   
;* DESCRIPTION
;*   Determine number of cycles per raster line.
;*   Acc = number of cycles.
;*   X = LSB of number of raster lines.
;*   
;******
check_time:
	lda	#0
	sta	$dc0e
	jsr	wait_vb
;--- raster line 0
	lda	#$fe
	sta	$dc04
	sta	$dc05		; load timer with $fefe
	lda	#%00010001
	sta	$dc0e		; start one shot timer
ct_lp1:
	bit	$d011
	bpl	ct_lp1
;--- raster line 256
	lda	$dc05		; timer msb
	eor	#$ff		; invert
; Acc = cycles per line
;--- scan for raster wrap
ct_lp2:
	ldx	$d012
ct_lp3:
	cpx	$d012
	beq	ct_lp3
	bmi	ct_lp2
	inx
; X = number of raster lines (LSB)
twelve:
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

	lda	#<label_msg
	ldy	#>label_msg
	jsr	$ab1e

	lda	#1
	sta	646

	lda	#NAME_POS
	sta	$d3
	lda	#<name_msg
	ldy	#>name_msg
	jsr	$ab1e
	
	lda	#CONF_POS
	sta	$d3
	lda	#0
	ldx	cycles_per_line
	jsr	$bdcd
	
	inc	$d3
	lda	#1
	ldx	num_lines
	jsr	$bdcd

	rts

NAME_POS	equ	2
CONF_POS	equ	32
name_msg:
	dc.b	"FETCHSPLIT",29,"R01",0
label_msg:
	dc.b	147,"0123456789012345678901234567890123456789",19,0

;**************************************************************************
;*
;* NAME  test_prepare
;*   
;******
test_prepare:
; setup main screen
	ldx	#0
prt_lp1:
	lda	#14
	sta	$d828,x
	sta	$d900,x
	sta	$da00,x
	sta	$dae8,x
	inx
	bne	prt_lp1

	ldx	#40
prt_lp2:
	lda	$0400+40*0-1,x
	sta	$3c00+40*0-1,x
	dex
	bne	prt_lp2

	ldx	#0

; setup bitmap colors
	ldx	#40*4
prt_lp3:
	lda	#$12
	sta	$3c00+40*1-1,x
	sta	$3c00+40*5-1,x
	lda	#$00
	sta	$3c00+40*9-1,x
	lda	#$01
	sta	$3c00+40*10-1,x
	sta	$3c00+40*13-1,x
	lda	#$40
	sta	$3c00+40*17-1,x
	lda	#$41
	sta	$3c00+40*18-1,x
	sta	$3c00+40*21-1,x
	dex
	bne	prt_lp3

	
	lda	#CHAR_A
	ldx	#<[$4000+$140*1]
	ldy	#>[$4000+$140*1]
	jsr	push_bitmap
	
	lda	#CHAR_B
	ldx	#<[$6000+$140*1]
	ldy	#>[$6000+$140*1]
	jsr	push_bitmap
	
	lda	#CHAR_0
	ldx	#<[$2000+$140*2]
	ldy	#>[$2000+$140*2]
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap

	lda	#CHAR_1
	ldx	#<[$6000+$140*2]
	ldy	#>[$6000+$140*2]
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	
	lda	#CHAR_2
	ldx	#<[$a000+$140*2]
	ldy	#>[$a000+$140*2]
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	
	lda	#CHAR_3
	ldx	#<[$e000+$140*2]
	ldy	#>[$e000+$140*2]
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap

	ldx	#7
prt_lp4:
	lda	char_a,x
	sta	$7000,x
	lda	char_b,x
	sta	$7800,x
	lda	char_0,x
	sta	$3808,x
	lda	char_1,x
	sta	$7808,x
	lda	char_2,x
	sta	$b808,x
	lda	char_3,x
	sta	$f808,x
	dex
	bpl	prt_lp4

	jsr	adjust_timing
	
	lda	#0
	sta	$d022
	lda	#14
	sta	$d020
	lda	#6
	sta	$d021
	lda	#$f5
	sta	$d018

	rts
	

;**************************************************************************
;*
;* NAME  adjust_timing
;*   
;******
adjust_timing:
	lda	cycles_per_line
	sec
	sbc	#63
	tax
	lda	time2,x
	sta	tm1_zp
	lda	time3,x
	sta	tm2_zp
	
	lda	#<test_start
	sta	ptr_zp
	lda	#>test_start
	sta	ptr_zp+1
	ldx	#>[test_end-test_start+255]
at_lp1:
	ldy	#0
	lda	#$d8		; cld
	cmp	(ptr_zp),y
	bne	at_skp1
	iny
	cmp	(ptr_zp),y
	bne	at_skp1
	dey
	lda	tm1_zp
	sta	(ptr_zp),y
	iny
	lda	tm2_zp
	sta	(ptr_zp),y
at_skp1:
	inc	ptr_zp
	bne	at_lp1
	inc	ptr_zp+1
	dex
	bne	at_lp1

	rts

; eor #$00 (2),  bit $ea (3),  nop; nop (4)
time2:
	dc.b	$49, $24, $ea
time3:
	dc.b	$00, $ea, $ea

;**************************************************************************
;*
;* NAME  push_bitmap
;*   
;******
push_bitmap:
	sta	offs_zp
	stx	ptr_zp
	sty	ptr_zp+1

	ldy	#0
pbm_lp1:
	tya
	and	#7
	clc
	adc	offs_zp
	tax
	lda	chars,x
	sta	(ptr_zp),y
	iny
	bne	pbm_lp1

	inc	ptr_zp+1
pbm_lp2:
	tya
	and	#7
	clc
	adc	offs_zp
	tax
	lda	chars,x
	sta	(ptr_zp),y
	iny
	cpy	#$40
	bne	pbm_lp2
	tya
	clc
	adc	ptr_zp
	sta	ptr_zp
	bcc	pbm_ex1
	inc	ptr_zp+1
pbm_ex1:
	ldx	ptr_zp
	ldy	ptr_zp+1
	lda	offs_zp
	rts
	

chars:
char_a:
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00111100
	dc.b	%01100110
	dc.b	%01111110
	dc.b	%01100110
	dc.b	%01100110
	dc.b	%00000000
CHAR_A	equ	char_a-chars

char_b:
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%01111100
	dc.b	%01100110
	dc.b	%01111100
	dc.b	%01100110
	dc.b	%01111100
	dc.b	%00000000
CHAR_B	equ	char_b-chars

char_0:
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00111100
	dc.b	%01100110
	dc.b	%01100110
	dc.b	%01100110
	dc.b	%00111100
	dc.b	%00000000
CHAR_0	equ	char_0-chars

char_1:
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00011000
	dc.b	%00111000
	dc.b	%00011000
	dc.b	%00011000
	dc.b	%00111100
	dc.b	%00000000
CHAR_1	equ	char_1-chars

char_2:
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00111100
	dc.b	%01100110
	dc.b	%00001100
	dc.b	%00011000
	dc.b	%01111110
	dc.b	%00000000
CHAR_2	equ	char_2-chars

char_3:
	dc.b	%00000000
	dc.b	%00000000
	dc.b	%00111100
	dc.b	%01100110
	dc.b	%00001100
	dc.b	%01100110
	dc.b	%00111100
	dc.b	%00000000
CHAR_3	equ	char_3-chars


	
	align	256
test_start:
;**************************************************************************
;*
;* NAME  test_perform
;*   
;******
test_perform:
	ds.b	4,$ea
	bit	$ea
; start 0
	ldy	#$3b
	jsr	line18bm
	ldy	#$3b
	jsr	line0a
	ldy	#$3b
	jsr	line1a
	ldy	#$3b
	jsr	line0b
	ldy	#$3b
	jsr	line1b
	ldy	#$3b
	jsr	line0c
	ldy	#$3b
	jsr	line1c
	ldy	#$3b
	jsr	line2
; start 1
	ldy	#$1b
	jsr	line18txt
	ldy	#$1b
	jsr	line0a
	ldy	#$1b
	jsr	line1a
	ldy	#$1b
	jsr	line0b
	ldy	#$1b
	jsr	line1b
	ldy	#$1b
	jsr	line0c
	ldy	#$1b
	jsr	line1c
	ldy	#$1b
	jsr	line2
; start 2
	ldy	#$5b
	jsr	line18txt
	ldy	#$5b
	jsr	line0a
	ldy	#$5b
	jsr	line1a
	ldy	#$5b
	jsr	line0b
	ldy	#$5b
	jsr	line1b
	ldy	#$5b
	jsr	line0c
	ldy	#$5b
	jsr	line1c
	ldy	#$5b
	jsr	line2

	ds.b	6,$ea	
	lda	#$1b
	sta	$d011
	lda	#$f5
	sta	$d018
	lda	#7
	sta	$d021
	lda	#6
	sta	$d021
	lda	#$97
	sta	$dd00
	lda	#$3f
	sta	$dd02
	lda	#8
	sta	$d016
	rts

	align	256

line18bm:
	ds.b	6,$ea
	sty	$d011
	lda	#7
	sta	$d021
	lda	#6
	sta	$d021
	ldx	#$97
	stx	$dd00
	ldx	#$3f
	stx	$dd02
	ldx	#$f0
	stx	$d018
	ds.b	2,$ea

	jsr	line18bm_do
	jsr	line18bm_do
	jsr	line18bm_do
	jsr	line18bm_do
	jsr	line18bm_do
	jsr	line18bm_do

	ldx	#$1b
	stx	$d011
	ldx	#$f5
	stx	$d018
	ds.b	2,$ea
	bit	$ea
	rts

line18bm_do:
	ldx	#$96
	stx	$dd00
	ldx	#$3f
	stx	$dd02
	lda	#$f0
	sta	$d018
	lda	#$f8
	sta	$d018
	lda	#$f0
	sta	$d018
	lda	#$f8
	sta	$d018
	lda	#$f0
	sta	$d018
	lda	#$f8
	sta	$d018
	bit	$ea
	rts

line18txt:
	ds.b	6,$ea
	sty	$d011
	lda	#7
	sta	$d021
	lda	#6
	sta	$d021
	ldx	#$97
	stx	$dd00
	ldx	#$3f
	stx	$dd02
	ldx	#$fc
	stx	$d018
	ds.b	2,$ea

	jsr	line18txt_do
	jsr	line18txt_do
	jsr	line18txt_do
	jsr	line18txt_do
	jsr	line18txt_do
	jsr	line18txt_do

	ldx	#$1b
	stx	$d011
	ldx	#$f5
	stx	$d018
	ds.b	2,$ea
	bit	$ea
	rts

line18txt_do:
	ldx	#$96
	stx	$dd00
	ldx	#$3f
	stx	$dd02
	lda	#$fc
	sta	$d018
	lda	#$fe
	sta	$d018
	lda	#$fc
	sta	$d018
	lda	#$fe
	sta	$d018
	lda	#$fc
	sta	$d018
	lda	#$fe
	sta	$d018
	bit	$ea
	rts

line0a:
	ds.b	6,$ea
	sty	$d011
	lda	#7
	sta	$d021
	lda	#6
	sta	$d021
	ldx	#$97
	stx	$dd00
	ldx	#$3f
	stx	$dd02
	ldx	#$fe
	stx	$d018
	ds.b	2,$ea

	jsr	line0a_do
	jsr	line0a_do
	jsr	line0a_do
	jsr	line0a_do
	jsr	line0a_do
	jsr	line0a_do

	ldx	#$1b
	stx	$d011
	ldx	#$f5
	stx	$d018
	ds.b	2,$ea
	bit	$ea
	rts

line0a_do:
	ldx	#$3f
	stx	$dd02
	ldx	#$97
	stx	$dd00
	lda	#$96
	sta	$dd00
	lda	#$97
	sta	$dd00
	lda	#$95
	sta	$dd00
	lda	#$97
	sta	$dd00
	lda	#$94
	sta	$dd00
	lda	#$97
	sta	$dd00
	bit	$ea
	rts

line0b:
	ds.b	6,$ea
	sty	$d011
	lda	#7
	sta	$d021
	lda	#6
	sta	$d021
	ldx	#$97
	stx	$dd00
	ldx	#$3f
	stx	$dd02
	ldx	#$fe
	stx	$d018
	ds.b	2,$ea

	jsr	line0b_do
	jsr	line0b_do
	jsr	line0b_do
	jsr	line0b_do
	jsr	line0b_do
	jsr	line0b_do

	ldx	#$1b
	stx	$d011
	ldx	#$f5
	stx	$d018
	ds.b	2,$ea
	bit	$ea
	rts

line0b_do:
	ldx	#$3f
	stx	$dd02
	ldx	#$96
	stx	$dd00
	lda	#$95
	sta	$dd00
	lda	#$96
	sta	$dd00
	lda	#$94
	sta	$dd00
	lda	#$96
	sta	$dd00
	lda	#$97
	sta	$dd00
	lda	#$96
	sta	$dd00
	bit	$ea
	rts

line0c:
	ds.b	6,$ea
	sty	$d011
	lda	#7
	sta	$d021
	lda	#6
	sta	$d021
	ldx	#$97
	stx	$dd00
	ldx	#$3f
	stx	$dd02
	ldx	#$fe
	stx	$d018
	ds.b	2,$ea

	jsr	line0c_do
	jsr	line0c_do
	jsr	line0c_do
	jsr	line0c_do
	jsr	line0c_do
	jsr	line0c_do

	ldx	#$1b
	stx	$d011
	ldx	#$f5
	stx	$d018
	ds.b	2,$ea
	bit	$ea
	rts

line0c_do:
	ldx	#$3f
	stx	$dd02
	ldx	#$95
	stx	$dd00
	lda	#$94
	sta	$dd00
	lda	#$95
	sta	$dd00
	lda	#$97
	sta	$dd00
	lda	#$95
	sta	$dd00
	lda	#$96
	sta	$dd00
	lda	#$95
	sta	$dd00
	bit	$ea
	rts


line1a:
	ds.b	6,$ea
	sty	$d011
	lda	#7
	sta	$d021
	lda	#6
	sta	$d021
	ldx	#$97
	stx	$dd00
	ldx	#$3f
	stx	$dd02
	ldx	#$fe
	stx	$d018
	ds.b	2,$ea

	jsr	line1a_do
	jsr	line1a_do
	jsr	line1a_do
	jsr	line1a_do
	jsr	line1a_do
	jsr	line1a_do

	ldx	#$1b
	stx	$d011
	ldx	#$f5
	stx	$d018
	ds.b	2,$ea
	bit	$ea
	rts

line1a_do:
	ldx	#$94
	stx	$dd00
	ldx	#$3c
	stx	$dd02
	lda	#$3d
	sta	$dd02
	lda	#$3c
	sta	$dd02
	lda	#$3e
	sta	$dd02
	lda	#$3c
	sta	$dd02
	lda	#$3f
	sta	$dd02
	lda	#$3c
	sta	$dd02
	bit	$ea
	rts

line1b:
	ds.b	6,$ea
	sty	$d011
	lda	#7
	sta	$d021
	lda	#6
	sta	$d021
	ldx	#$97
	stx	$dd00
	ldx	#$3f
	stx	$dd02
	ldx	#$fe
	stx	$d018
	ds.b	2,$ea

	jsr	line1b_do
	jsr	line1b_do
	jsr	line1b_do
	jsr	line1b_do
	jsr	line1b_do
	jsr	line1b_do

	ldx	#$1b
	stx	$d011
	ldx	#$f5
	stx	$d018
	ds.b	2,$ea
	bit	$ea
	rts

line1b_do:
	ldx	#$94
	stx	$dd00
	ldx	#$3d
	stx	$dd02
	lda	#$3e
	sta	$dd02
	lda	#$3d
	sta	$dd02
	lda	#$3f
	sta	$dd02
	lda	#$3d
	sta	$dd02
	lda	#$3c
	sta	$dd02
	lda	#$3d
	sta	$dd02
	bit	$ea
	rts

line1c:
	ds.b	6,$ea
	sty	$d011
	lda	#7
	sta	$d021
	lda	#6
	sta	$d021
	ldx	#$97
	stx	$dd00
	ldx	#$3f
	stx	$dd02
	ldx	#$fe
	stx	$d018
	ds.b	2,$ea

	jsr	line1c_do
	jsr	line1c_do
	jsr	line1c_do
	jsr	line1c_do
	jsr	line1c_do
	jsr	line1c_do

	ldx	#$1b
	stx	$d011
	ldx	#$f5
	stx	$d018
	ds.b	2,$ea
	bit	$ea
	rts

line1c_do:
	ldx	#$94
	stx	$dd00
	ldx	#$3e
	stx	$dd02
	lda	#$3f
	sta	$dd02
	lda	#$3e
	sta	$dd02
	lda	#$3c
	sta	$dd02
	lda	#$3e
	sta	$dd02
	lda	#$3d
	sta	$dd02
	lda	#$3e
	sta	$dd02
	bit	$ea
	rts

line2:
	ds.b	6,$ea
	sty	$d011
	lda	#7
	sta	$d021
	lda	#6
	sta	$d021
	ldx	#$97
	stx	$dd00
	ldx	#$3f
	stx	$dd02
	ldx	#$fe
	stx	$d018
	ds.b	2,$ea

	jsr	line2_do
	jsr	line2_do
	jsr	line2_do
	jsr	line2_do
	jsr	line2_do
	jsr	line2_do

	ldx	#$1b
	stx	$d011
	ldx	#$f5
	stx	$d018
	ds.b	2,$ea
	bit	$ea
	rts

line2_do:
	ldx	#$97
	stx	$dd00
	ldx	#$3c
	stx	$dd02
	lda	#$3d
	sta	$dd02
	lda	#$3e
	sta	$dd02
	lda	#$3f
	sta	$dd02
	lda	#$3e
	sta	$dd02
	lda	#$3d
	sta	$dd02
	lda	#$3c
	sta	$dd02
	bit	$ea
	rts
	
test_end:

; eof
