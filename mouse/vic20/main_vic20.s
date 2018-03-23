
	.include "prop.inc"

	.import prop_state_x

	screen = $1e00
    colormem   = $9600
	comma = ','

	.code
basic_start:
	sei
	
	ldx #0
:
	lda #32
	sta screen,x
	sta screen+$100,x
	lda #0
    sta colormem,x
    sta colormem+$100,x
    inx
    bne :-
    
	jsr prop_init

	lda #127
	sta $9122
:
	lda $0288
	sta $ff

	lda #0
	sta $fe

	ldx $9120
	lda $911f
	lsr
	lsr
	cpx #$80
	rol
	and #$0f
	tax
	lda joy_map,x
	pha
	jsr prop_update

	pla
	jsr printnibble

	lda #comma
	jsr printchar

	lda prop_x
	jsr printbyte

	lda #comma
	jsr printchar

	lda prop_y
	jsr printbyte

	lda #comma
	jsr printchar

	lda prop_err + 1
	jsr printbyte
	lda prop_err
	jsr printbyte

	lda #comma
	jsr printchar

	jsr trace_state

	jmp :-

trace_state:
	ldx prop_state_x
	lda hex,x
	ldy pos
	cmp ($fe),y
	beq :+
	inc pos
	iny
	sta ($fe),y
:
	rts

printbyte:
	pha
	lsr
	lsr
	lsr
	lsr
	tay
	lda hex,y
	jsr printchar
	pla
printnibble:
	and #15
	tay
	lda hex,y
	jsr printchar
	rts
printspc:
	lda #$20
printchar:
	ldy #0
	sta ($fe),y
	inc $fe
	rts

pos:
	.byte 0

	.rodata

joy_map:
	.byte %0000
	.byte %1000
	.byte %0001
	.byte %1001
	.byte %0010
	.byte %1010
	.byte %0011
	.byte %1011
	.byte %0100
	.byte %1100
	.byte %0101
	.byte %1101
	.byte %0110
	.byte %1110
	.byte %0111
	.byte %1111

hex:
	.byte "0123456789",1,2,3,4,5,6
