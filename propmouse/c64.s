
	.include "prop.inc"

	.import prop_state_x

     .export _basic_start

	screen = $0400
	comma = ','

	.code
_basic_start:
	sei

	jsr prop_init
	lda $0288
	sta $ff
:
	lda #0
	sta $fe

	lda $dc00
	pha
	jsr prop_update

	pla
	jsr printnibble

	lda #comma
	jsr printchar

	lda prop_x
	sta $d000
	jsr printbyte

	lda #comma
	jsr printchar

	lda prop_y
	sta $d001
	jsr printbyte

	lda #comma
	jsr printchar

	lda prop_err + 1
	jsr printbyte
	lda prop_err
	jsr printbyte

	lda #comma
	jsr printchar

;	jsr trace_state

	jmp :-

;trace_state:
;	ldx prop_state_x
;	lda hex,x
;	ldy pos
;	cmp ($fe),y
;	beq :+
;	inc pos
;	iny
;	sta ($fe),y
;:
;	rts

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
	.byt 0

	.rodata
hex:
	.byte "0123456789",1,2,3,4,5,6
