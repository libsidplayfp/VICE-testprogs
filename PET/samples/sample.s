; PET sample player test


	processor 6502

	org     $0401


freq 	equ $00
ptr	equ $01
ptrh	equ $02


;	basic header

	dc.b	$0b,$04,$e4,$07,$9e,$31,$30,$34,$30,$00,$00,$00,$00,$00,$00


;	init sound

	sei

	lda #$10		; enable sound
	sta $e84b

	lda #1			; carrier frequency
	sta $e848


;	init sample pointer and playback frequency

	lda #$05		; start of sample $0500
	sta ptrh
	lda #$00
	sta ptr

	lda #$15		; sample frequency (for delay loop)
	sta freq


;	sample play loop

	ldy #$00

playloop
	lda (ptr),y		; read two samples
	pha

	lsr
	lsr
	lsr
	lsr

	tax			; play high nybble first
	lda outbits,x
	sta $e84a

	ldx freq		; timing loop / even samples
.1
	dex
	bne	.1

	pla			; read low nybble
	and #$0f
	tax
	nop
	nop

	iny			; go to next sample
	bne .2

	inc ptrh		; next page in sample data
	bpl .2
	lda #$05		; loop back to $0500 when at $8000
	sta ptrh
.2

	lda outbits,x	; play low nybble
	sta $e84a

	ldx	freq		; load frequency for timing loop
.3
	dex			; timing loop / odd samples
	bne .3

	beq playloop


outbits:
	dc.b	%00000000
	dc.b	%10000000
	dc.b	%10001000
	dc.b	%10010010
	dc.b	%10101010
	dc.b	%01101101
	dc.b	%01110111
	dc.b	%01111111
	dc.b	%11111111

	org 	$0500,0

sample:
	incbin "sample.bin"
