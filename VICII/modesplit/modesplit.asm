;**************************************************************************
;*
;* FILE  modesplit.asm
;* Copyright (c) 2010 Daniel Kahlin <daniel@kahlin.net>
;* Written by Daniel Kahlin <daniel@kahlin.net>
;*
;* DESCRIPTION
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
	rts

;**************************************************************************
;*
;* NAME  test_prepare
;*   
;******
label:
	dc.b	"0123456789012345678901234567890123456789"

test_prepare:

; set up screen
	ldx	#0
prt_lp1:
	lda	#$5f
	sta	$0400,x
	sta	$0500,x
	sta	$0600,x
	sta	$06e8,x
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
	sta	$0400-1,x
	dex
	bne	prt_lp2

	lda	#$17
	sta	$d018	

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
prt_lp3:
	ldy	#0
	lda	#$d8		; cld
	cmp	(ptr_zp),y
	bne	prt_skp1
	iny
	cmp	(ptr_zp),y
	bne	prt_skp1
	dey
	lda	tm1_zp
	sta	(ptr_zp),y
	iny
	lda	tm2_zp
	sta	(ptr_zp),y
prt_skp1:
	inc	ptr_zp
	bne	prt_lp3
	inc	ptr_zp+1
	dex
	bne	prt_lp3
	
	rts


; eor #$00 (2),  bit $ea (3),  nop; nop (4)
time2:
	dc.b	$49, $24, $ea
time3:
	dc.b	$00, $ea, $ea

	
;******
; end of line marker
	mac	EOL
	ds.b	2,$d8
	endm
	
;******
; One 8 char high chunk
	mac	CHUNK
	ldy	#$08
	bne	.+4
.lp1:
	ds.b	9,$ea
	sty	$d016
	lda	#7
	sta	$d021
	lda	#6
	sta	$d021
	ds.b	7,$ea
	EOL

	jsr	{1}

	ldx	#$1b
	stx	$d011
	sty	$d016
	ds.b	1,$ea
	EOL

	iny
	cpy	#$10
	bne	.lp1
	endm
	
	align	256
test_start:
test_perform:
	ds.b	6,$ea
; start 1
	CHUNK 	section1
; start 2
	CHUNK 	section2
; start 3
	CHUNK 	section3
; end
	bit	$ea
	ds.b	4,$ea	
	lda	#$1b
	sta	$d011
	lda	#$08
	sta	$d016
	lda	#7
	sta	$d021
	lda	#6
	sta	$d021
	rts

	align	256


;**************************************************************************
;*
;* NAME  section1
;*   
;******
section1:
	repeat	6
	EOL
	ds.b	2,$ea
	ldx	#$1b
	stx	$d011
	sty	$d016
	tya
	ora	#%00010000
	sta	$d016		; mc
	ldx	#$5b		; illegal text
	stx	$d011
	ldx	#$3b		; bitmap
	stx	$d011
	and	#%11101111
	sta	$d016		; hires
	ldx	#$7b
	stx	$d011		; illegal bitmap1
	ldx	#$5b
	stx	$d011		; ECM
	ds.b	3,$ea
	bit	$ea
	repend
	rts

;**************************************************************************
;*
;* NAME  section2
;*   
;******
section2:
	repeat	6
	EOL
	ds.b	2,$ea
	ldx	#$1b
	stx	$d011
	sty	$d016

	ldx	#$5b
	stx	$d011
	ldx	#$1b
	stx	$d011
	ds.b	16,$ea
	bit	$ea
	repend
	rts

;**************************************************************************
;*
;* NAME  section3
;*   
;******
section3:
	repeat	6
	EOL
	ds.b	2,$ea
	ldx	#$1b
	stx	$d011
	sty	$d016
	tya
	ora	#%00010000
	sta	$d016
	and	#%11101111
	sta	$d016
	ds.b	15,$ea
	bit	$ea
	repend
	rts

test_end:

; eof
