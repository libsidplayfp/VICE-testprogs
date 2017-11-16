*=$0801

basic: !by $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00


; counter ($0400) results
; $00: pure ram $2000 bank 0 is wrong
; $01: pure ram $8000 bank 0 is wrong
; $02: pure ram $a000 bank 0 is wrong
; $03: pure ram $c000 bank 0 is wrong
; $04: pure ram $d000 bank 0 is wrong
; $05: pure ram $e000 bank 0 is wrong
; $06: pure ram $f000 bank 0 is wrong
; $07: pure ram $2000 bank 1 is wrong
; $08: pure ram $8000 bank 1 is wrong
; $09: pure ram $a000 bank 1 is wrong
; $0a: pure ram $c000 bank 1 is wrong
; $0b: pure ram $d000 bank 1 is wrong
; $0c: pure ram $e000 bank 1 is wrong
; $0d: pure ram $f000 bank 1 is wrong
; $0e: pure ram $2000 bank 2 is wrong
; $0f: pure ram $8000 bank 2 is wrong
; $10: pure ram $a000 bank 2 is wrong
; $11: pure ram $c000 bank 2 is wrong
; $12: pure ram $d000 bank 2 is wrong
; $13: pure ram $e000 bank 2 is wrong
; $14: pure ram $f000 bank 2 is wrong
; $15: pure ram $2000 bank 3 is wrong
; $16: pure ram $8000 bank 3 is wrong
; $17: pure ram $a000 bank 3 is wrong
; $18: pure ram $c000 bank 3 is wrong
; $19: pure ram $d000 bank 3 is wrong
; $1a: pure ram $e000 bank 3 is wrong
; $1b: pure ram $f000 bank 3 is wrong
; $1c: pure ram $0200 bank 0 is wrong
; $1d: pure ram $0600 bank 0 is wrong
; $1e: pure ram $0f00 bank 0 is wrong
; $1f: pure ram $0200 bank 1 is wrong
; $20: pure ram $0200 bank 2 is wrong
; $21: pure ram $0200 bank 3 is wrong
; $22: pure ram $0600 bank 1 is wrong
; $23: pure ram $0600 bank 2 is wrong
; $24: pure ram $0600 bank 3 is wrong
; $25: pure ram $0f00 bank 1 is wrong
; $26: pure ram $0f00 bank 2 is wrong
; $27: pure ram $0f00 bank 3 is wrong
; $28: ram under basic ($a000) bank 0 is wrong
; $29: ram under basic ($a000) bank 1 is wrong
; $2a: ram under basic ($a000) bank 2 is wrong
; $2b: ram under basic ($a000) bank 3 is wrong
; $2c: ram under kernal ($e000) bank 0 is wrong
; $2d: ram under kernal ($e000) bank 1 is wrong
; $2e: ram under kernal ($e000) bank 2 is wrong
; $2f: ram under kernal ($e000) bank 3 is wrong
; $30: all ok

start:
	sei
	ldx #$00
	stx $0400	; good compares counter

; check pure high ram first
	lda #$30
	sta $01
	jsr bank_0_0
	lda #$11
	jsr store_high
	jsr bank_0_1
	lda #$22
	jsr store_high
	jsr bank_0_2
	lda #$33
	jsr store_high
	jsr bank_0_3
	lda #$44
	jsr store_high
	jsr bank_0_0
	lda #$11
	jsr check_high
	cmp #$ff
	beq end
	jsr bank_0_1
	lda #$22
	jsr check_high
	cmp #$ff
	beq end
	jsr bank_0_2
	lda #$33
	jsr check_high
	cmp #$ff
	beq end
	jsr bank_0_3
	lda #$44
	jsr check_high
	cmp #$ff
	bne check_low_banks
end:
	ldx #$37
	stx $01
	ldx #$00
	stx $d100
	ldy #5
	ldx #0
	lda $0400
	cmp #$30
	beq store_result
	ldy #2
	ldx #$ff
store_result:
	sty $d020
	stx $d7ff
	cli
	rts

check_low_banks:
	lda #$37
	sta $01
	jsr bank_0_0
	ldx #$00
copy_loop:
	lda store_low_bank,x
	sta $2000,x
	lda fetch_low_bank,x
	sta $3000,x
	inx
	cpx #$10
	bne copy_loop
	lda #$20
	sta $0200		; store $20 at address $0200 in bank 0
	sta $0600		; store $20 at address $0600 in bank 0
	sta $0f00		; store $20 at address $0f00 in bank 0
	ldx #$02
	jsr store_low_x	; store $30, $40, $50 at address $0200 in banks 1, 2 and 3
	ldx #$06
	jsr store_low_x	; store $30, $40, $50 at address $0600 in banks 1, 2 and 3
	ldx #$0f
	jsr store_low_x	; store $30, $40, $50 at address $0f00 in banks 1, 2 and 3
	lda #$20
	cmp $0200
	bne end
	inc $0400
	cmp $0600
	bne end
	inc $0400
	cmp $0f00
	bne end
	inc $0400
	ldx #$02
	jsr compare_low_x	; compare bytes at address $0200 in banks 1, 2 and 3
	cmp #$ff
	beq end
	ldx #$06
	jsr compare_low_x	; compare bytes at address $0600 in banks 1, 2 and 3
	cmp #$ff
	beq end
	ldx #$0f
	jsr compare_low_x	; compare bytes at address $0f00 in banks 1, 2 and 3
	jsr compare_high_basic
	cmp #$ff
	bne do_kernal
	jmp end
do_kernal:
	jsr compare_high_kernal
	jmp end

compare_high_basic:
	ldy #$10
	ldx #$00
	stx $d100
	sty $a000
	iny
	ldx #$40
	stx $d100
	sty $a000
	iny
	ldx #$80
	stx $d100
	sty $a000
	iny
	ldx #$c0
	stx $d100
	sty $a000
	ldy #$10
	ldx #$00
	stx $d100
	lda #$30
	sta $01
	cpy $a000
	bne end_basic
	inc $0400
	iny
	lda #$37
	sta $01
	ldx #$40
	stx $d100
	lda #$30
	sta $01
	cpy $a000
	bne end_basic
	inc $0400
	iny
	lda #$37
	sta $01
	ldx #$80
	stx $d100
	lda #$30
	sta $01
	cpy $a000
	bne end_basic
	inc $0400
	iny
	lda #$37
	sta $01
	ldx #$c0
	stx $d100
	lda #$30
	sta $01
	cpy $a000
	bne end_basic
	inc $0400
	lda #$00
	rts
end_basic:
	lda #$ff
	rts

compare_high_kernal:
	lda #$37
	sta $01
	ldy #$10
	ldx #$00
	stx $d100
	sty $e000
	iny
	ldx #$40
	stx $d100
	sty $e000
	iny
	ldx #$80
	stx $d100
	sty $e000
	iny
	ldx #$c0
	stx $d100
	sty $e000
	ldy #$10
	ldx #$00
	stx $d100
	lda #$30
	sta $01
	cpy $e000
	bne end_kernal
	inc $0400
	iny
	lda #$37
	sta $01
	ldx #$40
	stx $d100
	lda #$30
	sta $01
	cpy $e000
	bne end_kernal
	inc $0400
	iny
	lda #$37
	sta $01
	ldx #$80
	stx $d100
	lda #$30
	sta $01
	cpy $e000
	bne end_kernal
	inc $0400
	iny
	lda #$37
	sta $01
	ldx #$c0
	stx $d100
	lda #$30
	sta $01
	cpy $e000
	bne end_kernal
	inc $0400
	lda #$00
	rts
end_kernal:
	lda #$ff
	rts

; compare low bank values
; reg x high byte of address to get from
compare_low_x:
	ldy #$01
	jsr $3000	; get byte from address $xx00 in bank 1
	cmp #$30
	bne fail_compare
	inc $0400
	ldy #$02
	jsr $3000	; get byte from address $xx00 in bank 2
	cmp #$40
	bne fail_compare
	inc $0400
	ldy #$03
	jsr $3000	; get byte from address $xx00 in bank 3
	cmp #$50
	bne fail_compare
	inc $0400
	lda #$00
	rts
fail_compare:
	lda #$ff
	rts

; store low bank values
; reg x high byte of address to store at
store_low_x:
	lda #$30
	ldy #$01
	jsr $2000	; store $30 at address $xx00 in bank 1
	lda #$40
	ldy #$02
	jsr $2000	; store $40 at address $xx00 in bank 2
	lda #$50
	ldy #$03
	jmp $2000	; store $50 at address $xx00 in bank 3

; reg_x is the bank value to use
change_bank:
	ldy $01
	lda #$37
	sta $01
	stx $d100
	sty $01
	rts

bank_0_0:
	ldx #$00
	jmp change_bank

bank_0_1:
	ldx #$40
	jmp change_bank

bank_0_2:
	ldx #$80
	jmp change_bank

bank_0_3:
	ldx #$c0
	jmp change_bank

check_high:
	cmp $2000
	bne error_high
	inc $0400
	cmp $8000
	bne error_high
	inc $0400
	cmp $a000
	bne error_high
	inc $0400
	cmp $c000
	bne error_high
	inc $0400
	cmp $d000
	bne error_high
	inc $0400
	cmp $e000
	bne error_high
	inc $0400
	cmp $f000
	bne error_high
	inc $0400
	lda #$00
	rts
error_high:
	lda #$ff
	rts

store_high:
	sta $2000
	sta $8000
	sta $a000
	sta $c000
	sta $d000
	sta $e000
	sta $f000
	rts

; store a byte in low bank, needs to be placed at $2000 and called there
; reg_x is high byte of address
; reg_y is bank value
; reg_a is byte to store
store_low_bank:
	stx $2008		; $2000-$2002
	sty $d100		; $2003-$2005
	sta $ff00		; $2006-$2008
	ldy #$00		; $2009-$200A
	sty $d100		; $200B-$200D
	rts			; $200E

; fetch a byte from low bank, needs to be placed at $3000 and called there
; reg_x is high byte of address
; reg_y is bank value
; reg_a will be the byte fetched
fetch_low_bank:
	stx $3008		; $3000-$3002
	sty $d100		; $3003-$3005
	lda $ff00		; $3006-$3008
	ldy #$00		; $3009-$300A
	sty $d100		; $300B-$300D
	rts			; $300E
