; pc64-bplr.asm: specialized opcode test - Public Domain
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
		lda #%00000000
		sta pb
		tsx
		stx sb

		lda #0
		sta db

		ldx #0
		lda #$02
jmp_page	= $0600
fill		sta jmp_page-$7e,x
		sta jmp_page+$82,x
		inx
		bne fill
next
		clc
		ldy cmd+2
		lda db
		bpl *+3
		dey
		adc cmd+1
		bcc *+4
		iny
		clc
		adc #2
		bcc *+3
		iny
tmp_zp1		= $2c
		sta tmp_zp1
		sty tmp_zp1+1
		ldy #0
		lda #$60
		sta (tmp_zp1),y

		lda db
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

		ldx cmd+1
		lda branch
		sta jmp_page+0,x
		lda db
		sta jmp_page+1,x

		ldx sb
		stx sr
		txs
		lda pb
		pha
		lda ab
		ldx xb
		ldy yb
		plp

cmd		jsr jmp_page+0

		php
		sta aa
		stx xa
		sty ya
		pla
		sta pa
		tsx
		stx sa
		ldy #0
		lda #$02
		sta (tmp_zp1),y
		bne noerr
berr
		dec errcode+1
		jmp error_nopla

noerr		jsr check

		inc db
		lda db
		cmp #$fe
		bne jmpnext
		lda #0
		sta db
		ldx cmd+1
		sta jmp_page+0,x
		inc cmd+1
		beq nonext
jmpnext		jmp next
nonext
		lda #$80
branch		bpl berr

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
		lda db
		sta test_errcode
errcode		lda #$ff
		jmp test_exit
