; pc64-sbciy.asm: specialized opcode test - Public Domain
; converted for the 1541-Testsuite by Wolfram Sang (Ninja/The Dreams)
; original PC64-Testsuite by Wolfgang Lorenz

		#include "1541-tests.inc"

		* = $0300

		.start_test
		ldx #$40
		stx $1c0e

		lda #%00011011
		sta db
		lda #%11000110
		sta ab
		lda #%10110001
		sta xb
		lda #%01101100
		sta yb
		lda #0
		sta pb
		tsx
		stx sb

		lda #0
		sta db
		sta ab
		sta yb
		lda #<da
tmp_zp1		= $2c
		sta tmp_zp1
		lda #>da
		sta tmp_zp1+1

next		lda pb
		and #%00001000
		bne decmode
		lda db
		sta da
		sta dr
		sta cmd0+1
		and #$7f
		sta cmd1+1
		clc
		lda pb
		and #1
		beq no_c
		sec
no_c		php
		lda ab
cmd0		sbc #0
		sta ar
		lda pb
		ora #%00110000
		and #%00111100
		bcc no_c1
		ora #1
no_c1		tax
		lda ab
		and #$7f
		plp
cmd1		sbc #0
		bpl neg
		txa
		and #1
		beq cont
set		txa
		ora #%01000000
		tax
		jmp cont
neg		txa
		and #1
		beq set
cont		lda ar
		cmp #0
		bne nozero
		txa
		ora #%00000010
		tax
nozero		lda ar
		bpl noneg
		txa
		ora #%10000000
		tax
noneg		stx pr
		jmp deccont

decmode
		lda db
		sta da
		sta dr
		and #$0f
		sta l0+1
		lda pb
		ora #%00110000
		and #%00111100
		tax
		lda pb
		lsr
		lda ab
		and #$0f
l0		sbc #0
		ldy #$00
		bcs l1
		sec
		sbc #$06
		and #$0f
		ldy #$08
l1		sta ar
		sty l3+1
		lda db
		and #$f0
		ora l3+1
		sta l3+1
		lda ab
		and #$f0
		sec
l3		sbc #0
		php
		inx
		bcs l5
		sec
		sbc #$60
		dex
l5		and #$f0
		ora ar
		sta ar
		plp
		bvc nov
		php
		txa
		ora #%01000000
		tax
		plp
nov		bpl non
		txa
		ora #%10000000
		tax
non		lda pb
		lsr
		lda ab
		sbc db
		bne noz
		txa
		ora #%00000010
		tax
noz		stx pr

deccont		lda xb
		sta xr

		lda yb
		sta yr

		lda sb
		sta sr

		ldx sb
		txs
		lda pb
		pha
		lda ab
		ldx xb
		ldy yb
		plp

cmd		sbc (tmp_zp1),y

		php
		cld
		sta aa
		stx xa
		sty ya
		pla
		sta pa
		tsx
		stx sa
		jsr check

		inc tmp_zp1
		bne noinc
		inc tmp_zp1+1
noinc		lda yb
		bne nodec
		dec tmp_zp1+1
nodec		dec yb

		clc
		lda db
		adc #17
		sta db
		bcc jmpnext
		lda #0
		sta db
		clc
		lda ab
		adc #17
		sta ab
		bcc jmpnext
		lda #0
		sta ab
		inc pb
		beq nonext
jmpnext		jmp next
nonext

		lda #0
test_exit
		sta test_result
		ldx #$c0
		stx $1c0e
		cli
		.end_test

db		.byte 0
ab		.byte 0
xb		.byte 0
yb		.byte 0
pb		.byte 0
sb		.byte 0
da		.byte 0
aa		.byte 0
xa		.byte 0
ya		.byte 0
pa		.byte 0
sa		.byte 0
dr		.byte 0
ar		.byte 0
xr		.byte 0
yr		.byte 0
pr		.byte 0
sr		.byte 0


check
		lda da
		cmp dr
		bne error
		lda aa
		cmp ar
		bne error
		lda xa
		cmp xr
		bne error
		lda ya
		cmp yr
		bne error
		lda pa
		cmp pr
		bne error
		lda sa
		cmp sr
		bne error
		rts

error
		pla
		pla
error_nopla
		lda pb
		sta test_errcode
errcode		lda #$ff
		jmp test_exit
