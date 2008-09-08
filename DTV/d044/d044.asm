;**************************************************************************
;*
;* FILE  d044.asm 
;* Copyright (c) 2008 Daniel Kahlin <daniel@kahlin.net>
;* Written by Daniel Kahlin <daniel@kahlin.net>
;* $Id: rastertest.asm,v 1.8 2006-07-07 17:19:45 tlr Exp $
;*
;* DESCRIPTION
;*   $d044 read and write test.
;*
;******
	processor 6502

	include	"macros.i"

TARGET_BUFFER	equ	$4000
TARGET_SPACING	equ	$80
TARGET_REF	equ	$c000
CYCLE_START	equ	$00
CYCLE_STOP	equ	$ff
SCAN_LENGTH	equ	72


RASTER_POS	equ	220


DEBUG		equ	1
	
;Macro to enable next interrupt within this one
	mac	FORK
	pla
	pla
	jsr	update
	cli
	endm
	
; setup segments
	seg.u	zp
	org	$02
ptr_zp:
	ds.w	1
irq_cycle_zp:
	ds.b	1	
cptr_zp:
	ds.w	1
tmp2_zp:
	ds.b	1

	org	$fb
tmp_zp:
	ds.b	1
line_zp:
	ds.b	1

	seg	code
	org	$0801

;**************************************************************************
;*
;* Sysline
;*
;******
StartOfFile:
	dc.w	EndLine
SumStart:
	dc.w	0
	dc.b	$9e,"2069 /T.L.R/",0
;	        0 SYS2069 /T.L.R/
EndLine:
	dc.w	0
;**************************************************************************
;*
;* Start of the program! 
;*
;******
SysAddress:
	jsr	$ff5b
	lda	#<start_msg
	ldy	#>start_msg
	jsr	$ab1e
	sei
	lda	#$05
	sta	$01

; setup PAL/NTSC flag
	jsr	check_pal
	lda	#0
	rol
	sta	pal_flag

	dec	$01
; clear buffer
	ldy	#$c0
	ldx	#0
	lda	#$ff
sa_lp1:
sa_sm1:
	sta	TARGET_BUFFER,x
	inx
	bne	sa_lp1
	inc	sa_sm1+2
	dey
	bne	sa_lp1

	lda	#<TARGET_REF
	sta	ptr_zp
	lda	#>TARGET_REF
	sta	ptr_zp+1
	lda	#$00
	sta	irq_cycle_zp
sa_lp2:

	jsr	calculate_ref
	ldy	#SCAN_LENGTH-1
sa_lp3:
	lda	ref_buffer,y
	sta	(ptr_zp),y
	dey
	bpl	sa_lp3

	lda	ptr_zp
	clc
	adc	#<TARGET_SPACING
	sta	ptr_zp
	bcc	sa_skp1
	inc	ptr_zp+1
sa_skp1:
	inc	irq_cycle_zp
	bpl	sa_lp2
	
	inc	$01

; prepare info matrix
	jsr	clear_info_matrix
	
; setup interrupts
	jsr	initsystem
	jsr	initinterrupt
	cli

	lda	#<[TARGET_BUFFER+CYCLE_START*TARGET_SPACING]
	sta	ptr_zp
	lda	#>[TARGET_BUFFER+CYCLE_START*TARGET_SPACING]
	sta	ptr_zp+1
	lda	#CYCLE_START
	sta	irq_cycle_zp

mainloop:
;*** set new interrupt point
	jsr	wait_vb
	lda	irq_cycle_zp
	sta	$d044
	jsr	clear_scan_buffer

;*** check for interrupt
	jsr	wait_vb
	lda	#0
	sta	irq_occurred_flag
	jsr	wait_vb
	lda	irq_occurred_flag
	beq	ml_skp3

;*** run measurement
	jsr	start_scan
ml_lp1:
	lda	run_measurement_flag
	bne	ml_lp1

;*** fill into buffer
	ldy	#SCAN_LENGTH-1
ml_lp2:
	lda	scan_buffer,y
	sta	(ptr_zp),y
	dey
	bpl	ml_lp2

	lda	#"*"	
	bra	ml_skp4

;*** IRQ timed out
ml_skp3:
	lda	#"-"

;*** update pointers
ml_skp4:
	pha
	jsr	calculate_ref
	ldy	#2
	ldx	#SCAN_LENGTH-1
ml_lp3:
	lda	scan_buffer,x
	cmp	ref_buffer,x
	bne	ml_skp6
	dex
	bpl	ml_lp3
	ldy	#5
ml_skp6:
	pla
	ldx	irq_cycle_zp
	jsr	plot_matrix

	lda	ptr_zp
	clc
	adc	#<TARGET_SPACING
	sta	ptr_zp
	bcc	ml_skp1
	inc	ptr_zp+1
ml_skp1:
	inc	irq_cycle_zp
	lda	irq_cycle_zp
	cmp	#[CYCLE_STOP+1]&$ff
	bne	mainloop

	sei
done:	
	bra	done

start_msg:
	dc.b	5,13,13,13,13,13,13,13,13,13,13
	dc.b	"$D044 READ/WRITE TIMING TEST / TLR",13
	dc.b	13
	dc.b	"SETS $D044 TO $00-$FF AND READS IT IN",13
	dc.b	"IRQ FOR 72 CYCLE SHIFTS.",13
	dc.b	"*=IRQ/-=NO IRQ   RED=INCORRECT.",13
	dc.b	13
	dc.b	"$4000-$C000 MEASURE BUFFER   (EVERY $80",13
	dc.b	"$C000-$0000 REFERENCE BUFFER  BYTES)",13
	dc.b	"(ALL $FF'S MEANS NO IRQ OCCURRED)",13
	dc.b	0

run_measurement_flag:
	dc.b	0
irq_occurred_flag:
	dc.b	0
pal_flag:
	dc.b	0

	ds.b	50	
;**************************************************************************
;*
;* stop timers
;*
;******
initsystem:
	lda	#0
	sta	$dc0e
	sta	$dc0f
	lda	#$7f
	sta	$dc0d
	lda	$dc0d
	rts

;**************************************************************************
;*
;* wait for vertical blanking
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
;* NAME  check_pal
;*
;* DESCRIPTION
;*   Check if pal.
;*   C=1 means pal
;*
;*   
;******
check_pal:
;Wait for the negative part of the screen
cp_lp1:
	lda	$d011
	bmi	cp_lp1
cp_lp2:
	lda	$d011
	bpl	cp_lp2
;check for pal
cp_lp3:
	lda	$d012
	cmp	#$20
	beq	cp_ex1		; C=1
	lda	$d011
	bmi	cp_lp3
	clc
cp_ex1:
	rts

;**************************************************************************
;*
;* Init interrupt
;*
;******
initinterrupt:
	lda	#0
	sta	line_zp

	lda	#$1b
	sta	$d011

	lda	#<nmi_entry
	sta	$fffa
	lda	#>nmi_entry
	sta	$fffb
	 
	lda	#>interrupt
	sta	$ffff
	jsr	update

	jsr	wait_vb
	lda	#1
	sta	$d03f
	
	lda	#$40		;IRQ in cycle 64 (default)
	sta	$d044
	lda	#%00100010	;No badlines, Border Off
	sta	$d03c
	sac	#$99
	lda	#%00000001	;Burst disabled, Skip internal cycles
	sac	#$00
	jsr	wait_vb
	lda	#1
	sta	$d01a
	sta	$d019

	cli
	rts


nmi_entry:
	lda	#$07
	sta	$01
	jmp	($fffa)
	
;**************************************************************************
;*
;* Stable interrupt handler
;* PART1
;*
;******
        START_SAMEPAGE  "stable ints"
interrupt:
;* push Acc, X and Y *
	pha
	txa
	pha
	tya
	pha

;* ack int *
	lda	#1
	sta	$d019

;* set new int for the next scan line *
int_sm1:
	lda	#0
	sta	$d012
	lda	#<interrupt2
	sta	$fffe
	cli		;enable ints
	ldx	#6	; 2
int_lp1:	
	dex		; 1	3*6+2 = 20
	bne	int_lp1	; 2
;* during this... the next int should occur *
	ds.b	12,$ea		; PAL=10 cycles, NTSC=12 cycles

	if	DEBUG
;* major fuck up *
	sei
int_lp2:
	inc	$d021
	jmp	int_lp2
	else
	endif

;**************************************************************************
;*
;* Stable interrupt handler
;* PART2
;*
;******
interrupt2:
        END_SAMEPAGE
;* pop this int *
	pla	;pop status
	pla	;pop retaddr
	pla	;pop retaddr2

;* ack int *
	lda	#1
	sta	$d019

;* now we are syncronized *
selfmodJSR:
	jsr	selfmodJSR

;* set up new interrupt *
	jsr	update
 
	pla
	tay
	pla
	tax
	pla
	rti


;**************************************************************************
;*
;* update the next raster line
;*
;******
update:
	lda	line_zp
	inc	line_zp
	asl
	asl
	tax
	ldy	InterruptTab,x
	sty	$d012
	iny
	sty	int_sm1+1	
	lda	InterruptTab+1,x
	bmi	ud_skp1
	and	#1
	sta	tmp_zp
	lda	$d011
	and	#$7f
	ora	tmp_zp
	sta	$d011
	
	lda	InterruptTab+2,x
	sta	selfmodJSR+1
	lda	InterruptTab+3,x
	sta	selfmodJSR+2

	lda	#<interrupt
	sta	$fffe
	rts

ud_skp1:
	lda	#0
	sta	line_zp
	jmp	update



;**************************************************************************
;*
;* data
;*
;******
InterruptTab:
	dc.w	RASTER_POS,rast_indicate
	dc.w	RASTER_POS+5,rast_measure
	dc.w	RASTER_POS+11,rast_indicate
	dc.w	-1


;**************************************************************************
;*
;* raster code
;*
;******
rast_measure:
rm_sm1:
	bra	rm_dly
rm_dly:
	ds.b	SCAN_LENGTH-1,$ea
	ldy	$d044
	dec	$d021
	inc	$d021
	lda	#SCAN_LENGTH-1
	sec
	sbc	rm_sm1+1
	tax
	tya
	sta	scan_buffer,x
	lda	rm_sm1+1
	beq	rm_ex1
	dec	rm_sm1+1
	rts
rm_ex1:
	sta	run_measurement_flag
	rts

rast_indicate:
	dec	$d021
	dec	$d021
	dec	$d021
	dec	$d021
	inc	$d021
	inc	$d021
	inc	$d021
	inc	$d021
	lda	#1
	sta	irq_occurred_flag
	rts	

clear_scan_buffer:
	ldx	#SCAN_LENGTH-1
	lda	#$ff
csb_lp1:
	sta	scan_buffer,x
	dex
	bpl	csb_lp1
	rts

start_scan:
	lda	#SCAN_LENGTH-1
	sta	rm_sm1+1
	sta	run_measurement_flag
	rts

scan_buffer:
	ds.b	SCAN_LENGTH

;**************************************************************************
;*
;* SECTION  reference generation
;*
;******
calculate_ref:
 	lda	irq_cycle_zp	
	and	#$7f
	cmp	#64+1
	bcs	cr_fl1
	jsr	check_hole
	bcs	cr_fl1
	
	ldx	#$1d
cr_lp1:
	jsr	ref_add
	dex
	bne	cr_lp1

	ldx	#0
cr_lp2:
	sta	ref_buffer,x
	jsr	ref_add
	inx
	cpx	#SCAN_LENGTH
	bne	cr_lp2
	rts		

	
cr_fl1:
	ldx	#SCAN_LENGTH-1
	lda	#$ff
cr_lp3:
	sta	ref_buffer,x
	dex
	bpl	cr_lp3
	rts

ref_add:
	clc
	adc	#1
	and	#$7f
	cmp	#65
	beq	ra_ex1
	jsr	check_hole
	ora	#$80
	rts
ra_ex1:
	lda	#$80
	rts
	
			
check_hole:
	ldy	pal_flag
	beq	ch_ex1
	cmp	#54
	beq	ch_ex2
	cmp	#55
	beq	ch_ex2
ch_ex1:
	clc
	rts
ch_ex2:
	lda	#56
	sec
	rts

ref_buffer:
	ds.b	SCAN_LENGTH
	
	
	
;**************************************************************************
;*
;* SECTION  information matrix
;*
;******
clear_info_matrix
	ldx	#0
cim_lp1:
	lda	#"."
	ldy	#1
	jsr	plot_matrix
	inx
	bne	cim_lp1
	rts

plot_matrix:
	pha
	txa
	and	#$e0
	sta	cptr_zp
	lsr
	lsr
	clc
	adc	cptr_zp
	sta	cptr_zp
	lda	#0
	adc	#$d8
	sta	cptr_zp+1
	txa
	and	#$1f
	sta	tmp2_zp
pm_skp1:
	tya
	ldy	tmp2_zp
	sta	(cptr_zp),y
	lda	cptr_zp+1
	sec
	sbc	#$d8-$04
	sta	cptr_zp+1
	pla
	sta	(cptr_zp),y
	rts
; eof






