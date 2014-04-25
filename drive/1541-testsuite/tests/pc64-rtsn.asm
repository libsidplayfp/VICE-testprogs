; pc64-rtsn.asm: specialized opcode test - Public Domain
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

		tsx
		stx saves+1
		ldx #0
stack		= $0100
save		lda stack,x
tmp_page	= $0500
		sta tmp_page,x
		inx
		bne save

next		lda db
		sta da
		sta dr

		lda ab
		sta ar

		lda xb
		sta xr

		lda yb
		sta yr

		lda pb
		ora #%00110000
		sta pr

		lda sb
		clc
		adc #2
		sta sr

		ldx sb
		txs
		lda #<cont-1
		inx
		sta stack,x
		lda #>cont-1
		inx
		sta stack,x
		lda pb
		pha
		lda ab
		ldx xb
		ldy yb
		plp

cmd		rts

cont		php
		cld
		sta aa
		stx xa
		sty ya
		pla
		sta pa
		tsx
		stx sa
		jsr check

		inc sb
		inc pb
		beq nonext
jmpnext		jmp next
nonext

saves		ldx #0
		txs
		ldx #0
restore		lda tmp_page,x
		sta stack,x
		inx
		bne restore

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


check		lda da
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
		sta test_exit - 1
		jmp saves
