;**************************************************************************
;*
;* FILE  startup.asm 
;* Copyright (c) 2010 Daniel Kahlin <daniel@kahlin.net>
;* Written by Daniel Kahlin <daniel@kahlin.net>
;*
;* DESCRIPTION
;*
;******
	processor 6502

	seg	code
	org	$1001
;**************************************************************************
;*
;* Basic line!
;*
;******
start_of_line:
	dc.w	end_line
	dc.w	0
	dc.b	$9e,"4117 /T.L.R/",0
;	        0 SYS4117 /T.L.R/
end_line:
	dc.w	0

;**************************************************************************
;*
;* NAME  startofcode
;*
;******
startofcode:
	sei
	lda	#$7f
	sta	$912e
	sta	$912d
	jsr	check_time
	sta	cycles_per_line
	stx	num_lines
	jsr	calc_frame_time
	
	jsr	test_present

	sei
	lda	#<irq_stable
	sta	$0314
	lda	#>irq_stable
	sta	$0315

	ifconst	HAVE_STABILITY_GUARD
	jsr	start_guard
	endif

	jsr	test_prepare

	lda	cycles_per_frame
	sec
	sbc	#TIMING_ADJUST
	sta	adjust
	
	lda	$9001
	clc
	adc	#4*10
soc_lp1:
	cmp	$9004
	bne	soc_lp1
	lda	cycles_per_frame
	sec
	sbc	#2
	sta	$9124
	lda	cycles_per_frame+1
	sbc	#0
	sta	$9125
	lda	#%11000000
	sta	$912e
	lda	#%01000000
	sta	$912b
	cli
	
soc_lp2:
	inx
	txa
	beq	soc_lp2
	stx	$9400
	lsr	$9400
	asl	$94ff,x
	jmp	soc_lp2

cycles_per_line:
	dc.b	0
num_lines:
	dc.b	0
cycles_per_frame:
	dc.w	0
adjust:
	dc.b	0
	ifconst HAVE_TEST_RESULT
test_done:
	dc.b	0
	endif

;**************************************************************************
;*
;* NAME  irq_stable
;*   
;******
TIMING_ADJUST	equ	48
irq_stable:
	lda	adjust
	sec
	sbc	$9124
	sta	is_time
	clv
is_time	equ	.+1
	bvc	is_time
	dc.b	$a2,$a2,$a2,$a2,$a2,$a2,$24,$ea
	tax
	inc	$1e00,x
	
	lda	$900f
	eor	#$f7
	sta	$900f
	eor	#$f7
	sta	$900f
	
;	jsr	test_perform	

	jmp	$eb18


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
	lda	#%11000000
	sta	$912e
	lda	#%01000000
	sta	$912b
;--- wait vb
ct_lp1:
	lda	$9004
	beq	ct_lp1
ct_lp2:
	lda	$9004
	bne	ct_lp2
;--- raster line 0
	lda	#$fe
	sta	$9124
	sta	$9125		; load timer with $fefe
;	lda	#%00010001
;	sta	$dc0e		; start one shot timer
ct_lp3:
	bit	$9004
	bpl	ct_lp3
;--- raster line 256
	lda	$9125		; timer msb
	eor	#$ff		; invert
; Acc = cycles per line
;--- scan for raster wrap
	pha

ct_lp4:
	ldy	$9003
	ldx	$9004
ct_lp5:
	tya
	ldy	$9003
	cpx	$9004
	beq	ct_lp5
	inx
	cpx	$9004
	beq	ct_lp4
	dex
	asl
	txa
	rol
	tax
	inx

	pla
; X = number of raster lines (LSB)

	rts

;**************************************************************************
;*
;* NAME  calc_frame_time
;*   
;* DESCRIPTION
;*   Calculate the number of cycles per frame
;*   
;******
calc_frame_time:
	lda	#0
	tay
	ldx	cycles_per_line
cft_lp1:
	clc
	adc	num_lines
	bcc	cft_skp1
	iny
cft_skp1:
	iny
	dex
	bne	cft_lp1
	sta	cycles_per_frame
	sty	cycles_per_frame+1
	rts


	ifconst	HAVE_STABILITY_GUARD
;**************************************************************************
;*
;* NAME  start_guard
;*
;* DESCRIPTION
;*   Setup a stability guard timer that counts cycles per line.
;*   It will be check to be the same value at the same spot in the raster
;*   routine each IRQ.
;*
;******
MAX_GUARD_CYCLES	equ	71
MAX_GUARDS		equ	4
start_guard:

; clear guard buffer
	lda	#0
	ldx	#MAX_GUARD_CYCLES
sg_lp1:
	sta	guard-1,x
	dex
	bne	sg_lp1
	sta	guard_count

; clear guard counters
	ldx	#MAX_GUARDS
sg_lp2:
	sta	guard_count-1,x
	sta	guard_last_cycle,x
	dex
	bne	sg_lp2

; setup and start guard timer
	if	0
	ldx	#%00000000
	stx	$dc0f
	ldy	cycles_per_line
	dey
	sty	$dc06
	stx	$dc07
	lda	#%00010001
	sta	$dc0f
	endif

	rts

;**************************************************************************
;*
;* NAME  update_guard
;*
;* DESCRIPTION
;*   Update guard counts.
;*   IN: Y=cycle, X=guard# (0-3)
;*
;******
update_guard:
	cpy	cycles_per_line ; >= cycles_per_line
	bcs	ug_fl1		; yes, fault!
	tya
	sta	guard_last_cycle,x
	lda	guard_mask,x
	and	guard,y
	bne	ug_ex1
	lda	guard_mask,x
	ora	guard,y
	sta	guard,y
	inc	guard_count,x
ug_ex1:
	rts
ug_fl1:
	lda	#$80
	ora	guard_count,x
	sta	guard_count,x
	rts

guard_mask:
	dc.b	%00000001
	dc.b	%00000010
	dc.b	%00000100
	dc.b	%00001000
	
guard_count:
	ds.b	MAX_GUARDS
guard_last_cycle:
	ds.b	MAX_GUARDS
guard:
	ds.b	MAX_GUARD_CYCLES

;**************************************************************************
;*
;* NAME  check_guard
;*
;* DESCRIPTION
;*   Check guard counts.
;*   IN: X=guard# (0-3)
;*   
;******
check_guard:
	lda	guard_count,x
	rts

	endif	;HAVE_STABILITY_GUARD

; eof
