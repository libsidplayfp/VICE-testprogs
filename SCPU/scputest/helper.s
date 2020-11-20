
	.macro AS
	sep #$20
	.A8
	.endmacro

	.macro AL
	rep #$20
	.A16
	.endmacro

	.macro XS
	sep #$10
	.I8
	.endmacro

	.macro XL
	rep #$10
	.I16
	.endmacro

	.macro AXS
	sep #$30
	.A8
	.I8
	.endmacro

	.macro AXL
	rep #$30
	.A16
	.I16
	.endmacro

ptr = $fb
;	.segment "ZEROPAGE"
;	ptr: .byte $00, $00, $00, $00

	.segment "CODE"

	.P816
	.import _vic_pal
	.export _set_vic_pal
_set_vic_pal:
p1:	lda $d012
p2:	cmp $d012
	beq p2
	bmi p1
	ldx #1	; PAL
	cmp #55
	beq pal
	dex		; NTSC
pal:
	stx _vic_pal
	rts

	.P816
	.import _ram_banks
	.export _set_ram_banks
_set_ram_banks:
	; test all banks
	stz ptr + 0
	lda #$04
	sta ptr + 1
	stz ptr + 2

bank:
	; write data
	ldy #0
l0:
	tya
	sta [ptr],y
	iny
	bne l0

	; compare
	ldy #0
l1:
	tya
	cmp [ptr],y
	bne error
	iny
	bne l1

	; ok, next bank
	inc ptr + 2
	bne bank
error:
	lda ptr + 2
	sta _ram_banks
	rts

	.P816
	.export _set_8bit_emulation
_set_8bit_emulation:
	sec
	xce ; emulation mode
	rts

	.P816
	.export _set_8bit_native
_set_8bit_native:
	clc
	xce ; native mode
	sep #$30 ; 8bit acc & idx
	rts

	.export _call_16bit_native
_call_16bit_native:
	clc
	xce ; native mode

	; store address
	sta ptr1 + 1
	stx ptr1 + 2

	rep #$30 ; 16bit acc & idx
ptr1:
	jsr $ffff
	sep #$30 ; 8bit acc & idx
	rts
