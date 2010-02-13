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
	lda	#$35
	sta	$01

	ldx	#6
sa_lp1:
	lda	vectors-1,x
	sta	$fffa-1,x
	dex
	bne	sa_lp1

	jsr	prepare_test

	jsr	wait_vb

	lda	#$7f
	sta	$dc0d
	lda	$dc0d
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
	inx
	bpl	sa_lp2
	inc	$4080,x
	dec	$4080,x
	endif
	jmp	sa_lp2

vectors:
	dc.w	nmi_entry,0,irq_stable

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
	lda	#<irq_stable2	; 2
	sta	$fffe		; 4
	tsx			; 2
	cli			; 2
	ds.b	13,$ea		; 24
	if	0
is_lp1:
	sei
	inc	$d020
	jmp	is_lp1	
irq_stable2:
	ds.b	13,$ea		; 26
	else
irq_stable2	equ	.-13
	endif
	txs			; 2
	dec	$d019		; 6
	dec	$d012		; 6
	lda	#<irq_stable	; 2
	sta	$fffe		; 4	=46
	lda	$d012		; 4
	eor	$d012		; 4
	beq	is2_skp1	; 2 (3)
is2_skp1:

	jsr	perform_test
		
accstore	equ	.+1
	lda	#0
xstore	equ	.+1
	ldx	#0
ystore	equ	.+1
	ldy	#0
	rti



label:
	dc.b	"0123456789012345678901234567890123456789"

prepare_test:
; setup main screen
	ldx	#0
prt_lp1:
	lda	#14
	sta	$d800,x
	sta	$d900,x
	sta	$da00,x
	sta	$dae8,x
	inx
	bne	prt_lp1

	ldx	#40
prt_lp2:
	lda	label-1,x
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
	sta	$3c00+40*11-1,x
	sta	$3c00+40*13-1,x
	lda	#$40
	sta	$3c00+40*17-1,x
	lda	#$41
	sta	$3c00+40*19-1,x
	sta	$3c00+40*21-1,x
	dex
	bne	prt_lp3

	
	lda	#CHAR_A
	ldx	#<[$4000+$140*1]
	ldy	#>[$4000+$140*1]
	jsr	push_bitmap
	jsr	push_bitmap
	
	lda	#CHAR_B
	ldx	#<[$6000+$140*1]
	ldy	#>[$6000+$140*1]
	jsr	push_bitmap
	jsr	push_bitmap
	
	lda	#CHAR_0
	ldx	#<[$2000+$140*3]
	ldy	#>[$2000+$140*3]
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap

	lda	#CHAR_1
	ldx	#<[$6000+$140*3]
	ldy	#>[$6000+$140*3]
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	
	lda	#CHAR_2
	ldx	#<[$a000+$140*3]
	ldy	#>[$a000+$140*3]
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	jsr	push_bitmap
	
	lda	#CHAR_3
	ldx	#<[$e000+$140*3]
	ldy	#>[$e000+$140*3]
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
	
	lda	#0
	sta	$d022
	lda	#14
	sta	$d020
	lda	#6
	sta	$d021
	lda	#$f5
	sta	$d018	
	rts


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
perform_test:
	ds.b	4,$ea
	bit	$ea
; start 0
	jsr	line0
	jsr	line0
	jsr	line0b
	jsr	line0b
	jsr	line0c
	jsr	line0c
	jsr	line0d
	jsr	line0d
; start 1
	jsr	line1
	jsr	line1
	jsr	line1b
	jsr	line1b
	jsr	line1c
	jsr	line1c
	jsr	line1d
	jsr	line1d
; start 2
	jsr	line2
	jsr	line2
	jsr	line2b
	jsr	line2b
	jsr	line2c
	jsr	line2c
	jsr	line2d
	jsr	line2d

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
line0:
	ds.b	6,$ea
	ldx	#$3b
	stx	$d011
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

	jsr	line0_do
	jsr	line0_do
	jsr	line0_do
	jsr	line0_do
	jsr	line0_do
	jsr	line0_do

	ldx	#$1b
	stx	$d011
	ldx	#$f5
	stx	$d018
	ds.b	2,$ea
	bit	$ea
	rts

line0_do:
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

line0b:
	ds.b	6,$ea
	ldx	#$3b
	stx	$d011
	lda	#7
	sta	$d021
	lda	#6
	sta	$d021
	ldx	#$97
	stx	$dd00
	ldx	#$3f
	stx	$dd02
	ldx	#$f8
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
	ldx	#$94
	stx	$dd00
	ldx	#$3f
	stx	$dd02
	lda	#$97
	sta	$dd00
	lda	#$96
	sta	$dd00
	lda	#$95
	sta	$dd00
	lda	#$94
	sta	$dd00
	lda	#$97
	sta	$dd00
	lda	#$96
	sta	$dd00
	bit	$ea
	rts

line0c:
	ds.b	6,$ea
	ldx	#$3b
	stx	$d011
	lda	#7
	sta	$d021
	lda	#6
	sta	$d021
	ldx	#$97
	stx	$dd00
	ldx	#$3f
	stx	$dd02
	ldx	#$f8
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
	ldx	#$94
	stx	$dd00
	ldx	#$3c
	stx	$dd02
	lda	#$3d
	sta	$dd02
	lda	#$3f
	sta	$dd02
	lda	#$3c
	sta	$dd02
	lda	#$3d
	sta	$dd02
	lda	#$3e
	sta	$dd02
	lda	#$3f
	sta	$dd02
	bit	$ea
	rts

line0d:
	ds.b	6,$ea
	ldx	#$3b
	stx	$d011
	lda	#7
	sta	$d021
	lda	#6
	sta	$d021
	ldx	#$97
	stx	$dd00
	ldx	#$3f
	stx	$dd02
	ldx	#$f8
	stx	$d018
	ds.b	2,$ea

	jsr	line0d_do
	jsr	line0d_do
	jsr	line0d_do
	jsr	line0d_do
	jsr	line0d_do
	jsr	line0d_do

	ldx	#$1b
	stx	$d011
	ldx	#$f5
	stx	$d018
	ds.b	2,$ea
	bit	$ea
	rts

line0d_do:
	ldx	#$97
	stx	$dd00
	ldx	#$3c
	stx	$dd02
	lda	#$3d
	sta	$dd02
	lda	#$3f
	sta	$dd02
	lda	#$3c
	sta	$dd02
	lda	#$3d
	sta	$dd02
	lda	#$3e
	sta	$dd02
	lda	#$3f
	sta	$dd02
	bit	$ea
	rts

	align	256
line1:
	ds.b	6,$ea
	ldx	#$1b
	stx	$d011
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

	jsr	line1_do
	jsr	line1_do
	jsr	line1_do
	jsr	line1_do
	jsr	line1_do
	jsr	line1_do

	ldx	#$1b
	stx	$d011
	ldx	#$f5
	stx	$d018
	ds.b	2,$ea
	bit	$ea
	rts

line1_do:
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

line1b:
	ds.b	6,$ea
	ldx	#$1b
	stx	$d011
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
	ldx	#$3f
	stx	$dd02
	lda	#$97
	sta	$dd00
	lda	#$96
	sta	$dd00
	lda	#$95
	sta	$dd00
	lda	#$94
	sta	$dd00
	lda	#$97
	sta	$dd00
	lda	#$96
	sta	$dd00
	bit	$ea
	rts

line1c:
	ds.b	6,$ea
	ldx	#$1b
	stx	$d011
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
	ldx	#$3c
	stx	$dd02
	lda	#$3d
	sta	$dd02
	lda	#$3f
	sta	$dd02
	lda	#$3c
	sta	$dd02
	lda	#$3d
	sta	$dd02
	lda	#$3e
	sta	$dd02
	lda	#$3f
	sta	$dd02
	bit	$ea
	rts

line1d:
	ds.b	6,$ea
	ldx	#$1b
	stx	$d011
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

	jsr	line1d_do
	jsr	line1d_do
	jsr	line1d_do
	jsr	line1d_do
	jsr	line1d_do
	jsr	line1d_do

	ldx	#$1b
	stx	$d011
	ldx	#$f5
	stx	$d018
	ds.b	2,$ea
	bit	$ea
	rts

line1d_do:
	ldx	#$97
	stx	$dd00
	ldx	#$3c
	stx	$dd02
	lda	#$3d
	sta	$dd02
	lda	#$3f
	sta	$dd02
	lda	#$3c
	sta	$dd02
	lda	#$3d
	sta	$dd02
	lda	#$3e
	sta	$dd02
	lda	#$3f
	sta	$dd02
	bit	$ea
	rts

	align	256
line2:
	ds.b	6,$ea
	ldx	#$5b
	stx	$d011
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

line2b:
	ds.b	6,$ea
	ldx	#$5b
	stx	$d011
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

	jsr	line2b_do
	jsr	line2b_do
	jsr	line2b_do
	jsr	line2b_do
	jsr	line2b_do
	jsr	line2b_do

	ldx	#$1b
	stx	$d011
	ldx	#$f5
	stx	$d018
	ds.b	2,$ea
	bit	$ea
	rts

line2b_do:
	ldx	#$94
	stx	$dd00
	ldx	#$3f
	stx	$dd02
	lda	#$97
	sta	$dd00
	lda	#$96
	sta	$dd00
	lda	#$95
	sta	$dd00
	lda	#$94
	sta	$dd00
	lda	#$97
	sta	$dd00
	lda	#$96
	sta	$dd00
	bit	$ea
	rts

line2c:
	ds.b	6,$ea
	ldx	#$5b
	stx	$d011
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

	jsr	line2c_do
	jsr	line2c_do
	jsr	line2c_do
	jsr	line2c_do
	jsr	line2c_do
	jsr	line2c_do

	ldx	#$1b
	stx	$d011
	ldx	#$f5
	stx	$d018
	ds.b	2,$ea
	bit	$ea
	rts

line2c_do:
	ldx	#$94
	stx	$dd00
	ldx	#$3c
	stx	$dd02
	lda	#$3d
	sta	$dd02
	lda	#$3f
	sta	$dd02
	lda	#$3c
	sta	$dd02
	lda	#$3d
	sta	$dd02
	lda	#$3e
	sta	$dd02
	lda	#$3f
	sta	$dd02
	bit	$ea
	rts

line2d:
	ds.b	6,$ea
	ldx	#$5b
	stx	$d011
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

	jsr	line2d_do
	jsr	line2d_do
	jsr	line2d_do
	jsr	line2d_do
	jsr	line2d_do
	jsr	line2d_do

	ldx	#$1b
	stx	$d011
	ldx	#$f5
	stx	$d018
	ds.b	2,$ea
	bit	$ea
	rts

line2d_do:
	ldx	#$97
	stx	$dd00
	ldx	#$3c
	stx	$dd02
	lda	#$3d
	sta	$dd02
	lda	#$3f
	sta	$dd02
	lda	#$3c
	sta	$dd02
	lda	#$3d
	sta	$dd02
	lda	#$3e
	sta	$dd02
	lda	#$3f
	sta	$dd02
	bit	$ea
	rts
	
; eof
