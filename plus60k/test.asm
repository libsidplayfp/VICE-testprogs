*=$0801

basic: !by $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00


; counter ($0400) results
; $00: pure ram $0fff is wrong
; $01: pure ram $2000 bank 0 is wrong
; $02: pure ram $8000 bank 0 is wrong
; $03: pure ram $a000 bank 0 is wrong
; $04: pure ram $c000 bank 0 is wrong
; $05: pure ram $d000 bank 0 is wrong
; $06: pure ram $e000 bank 0 is wrong
; $07: pure ram $f000 bank 0 is wrong
; $08: pure ram $2000 bank 1 is wrong
; $09: pure ram $8000 bank 1 is wrong
; $0a: pure ram $a000 bank 1 is wrong
; $0b: pure ram $c000 bank 1 is wrong
; $0c: pure ram $d000 bank 1 is wrong
; $0d: pure ram $e000 bank 1 is wrong
; $0e: pure ram $f000 bank 1 is wrong
; $0f: ram under basic ($a000) bank 0 is wrong
; $10: ram under basic ($a000) bank 1 is wrong
; $11: ram under kernal ($e000) bank 0 is wrong
; $12: ram under kernal ($e000) bank 1 is wrong
; $13: all ok

start:
	sei
	ldx #$00
	stx $0400	; good compares counter

; check pure ram first
	lda #$30
	sta $01
	ldx #$55
	ldy #$aa
	jsr bank_0
	txa
	jsr store_all
	jsr bank_1
	tya
	jsr store_all
	jsr bank_0
	cpy $0fff
	bne end
	inc $0400
	txa
	jsr check_bank
	cmp #$ff
	beq end
	jsr bank_1
	tya
	jsr check_bank
	cmp #$ff
	beq end

; check writing to basic
	ldx #$11
	ldy #$22
	lda #$37
	sta $01
	jsr bank_0
	stx $a000
	jsr bank_1
	sty $a000
	lda #$30
	sta $01
	jsr bank_0
	cpx $a000
	bne end
	inc $0400
	jsr bank_1
	cpy $a000
	bne end
	inc $0400
	jmp check_kernal

end:
	ldx #$37
	stx $01
	cli
	rts

; check writing to kernal
check_kernal:
	ldx #$11
	ldy #$22
	lda #$37
	sta $01
	jsr bank_0
	stx $e000
	jsr bank_1
	sty $e000
	lda #$30
	sta $01
	jsr bank_0
	cpx $e000
	bne end
	inc $0400
	jsr bank_1
	cpy $e000
	bne end
	inc $0400
	jmp end

bank_0:
	lda $01
	pha
	lda #$37
	sta $01
	lda #$00
	sta $d100
	pla
	sta $01
	rts

bank_1:
	lda $01
	pha
	lda #$37
	sta $01
	lda #$80
	sta $d100
	pla
	sta $01
	rts

check_bank:
	cmp $2000
	bne error_bank
	inc $0400
	cmp $8000
	bne error_bank
	inc $0400
	cmp $a000
	bne error_bank
	inc $0400
	cmp $c000
	bne error_bank
	inc $0400
	cmp $d000
	bne error_bank
	inc $0400
	cmp $e000
	bne error_bank
	inc $0400
	cmp $f000
	bne error_bank
	inc $0400
	lda #$00
	rts
error_bank:
	lda #$ff
	rts

store_all:
	sta $0fff
	sta $2000
	sta $8000
	sta $a000
	sta $c000
	sta $d000
	sta $e000
	sta $f000
	rts
