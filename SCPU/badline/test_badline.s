
	* = $0801

	.byte $0b, $08, $0a, $00, $9e, $32
	.byte $30, $36, $31, $00, $00, $00

	sei

	clc
	xce ; native mode

	sep #$30
	.as
	.xs

	sta $d07e ; ENABLE HARDWARE REGISTERS
	sta $d07b ; 20 MHz SCPU mode
	sta $d076 ; BASIC optimization
	sta $d07f ; DISABLE HARDWARE REGISTERS

	lda #$00
	sta $dc0e	; stop timers
	sta $dc0f

	lda #$ff
	sta $dc04	; set timers to $ffffffff
	sta $dc05
	sta $dc06
	sta $dc07

	rep #$10
	.xl

	lda #$1b	; screen on
	;lda #$00	; screen off
	sta $d011

	; always start test at the same rasterline
	lda #255
-	cmp $d012
	bne -

	lda #$59
	sta $dc0f	; reload and set timer b to count timer a underflow
	lda #$11
	sta $dc0e	; reload and start timer a, continuous mode

	ldx #0
-	txa
	sta $07e7	; Mirrored RAM
	;sta $d022	; IO
	dex
	bne -

	lda #$00
	sta $dc0e	; stop timers
	sta $dc0f

	lda #$1b	; screen on
	sta $d011

	sep #$10
	.xs

	sec
	lda #$ff
	sbc $dc04
	sta timer_count+0
	lda #$ff
	sbc $dc05
	sta timer_count+1
	lda #$ff
	sbc $dc06
	sta timer_count+2
	lda #$ff
	sbc $dc07
	sta timer_count+3

	lda timer_count+3
	ldy #0
	jsr print_hex
	lda timer_count+2
	ldy #2
	jsr print_hex
	lda timer_count+1
	ldy #4
	jsr print_hex
	lda timer_count+0
	ldy #6
	jsr print_hex

-	jmp -

timer_count
	.byte 0,0,0,0

hex
	.enc "screen"
	.text "0123456789ABCDEF"

print_hex
	pha
	lsr
	lsr
	lsr
	lsr
	tax
	lda hex,x
	sta $0400+0,y
	pla
	and #$0f
	tax
	lda hex,x
	sta $0400+1,y
	rts
