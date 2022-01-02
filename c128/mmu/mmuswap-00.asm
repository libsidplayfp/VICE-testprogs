; When the zero page is not relocated, is bank 1 page 0 mapped to bank 0 ?
;
; test will not reach passed till it has been confirmed on real hardware
;
; test not yet confirmed on real hardware
;
; Test made by Marco van den Heuvel


start=$2400

basicHeader=1 

!ifdef basicHeader {
; 10 SYS7181
*=$1c01  
	!byte  $0c,$08,$0a,$00,$9e,$37,$31,$38,$31,$00,$00,$00
*=$1c0d 
	jmp start
}
*=start
	sei
	lda $d506
	pha
	lda $ff00
	pha
	lda #$0b  ; top 16k shared
	sta $d506
	lda #$3f  ; bank 0 all ram
	sta $ff00
	lda #$aa
	sta $80   ; store in real zero page
	ldx #$00
loop0:
	lda set_bytes_in_bank1,x
	sta $e000,x
	inx
	bne loop0
	jsr $e000
	ldx #$00
loop:
	lda get_byte_from_bank1,x
	sta $e000,x
	inx
	bne loop
	jsr $e000 ; $80 read bank 1 in Y
	lda $80   ; $80 read bank 0 in A
	cmp #$55
	beq bank_0_is_55
	cmp #$aa
	beq bank_0_is_aa
	ldx #2
	bne failed
bank_0_is_55:
	cpy #$55
	beq bank_0_is_55_bank_1_is_55
	cpy #$aa
	beq bank_0_is_55_bank_1_is_aa
	ldx #2
	bne failed
bank_0_is_aa:
	cpy #$55
	beq bank_0_is_aa_bank_1_is_55
	cpy #$aa
	beq bank_0_is_aa_bank_1_is_aa
	ldx #2
	bne failed
bank_0_is_55_bank_1_is_55:
	ldx #0
	beq failed
bank_0_is_55_bank_1_is_aa:
	ldx #1
	bne failed
bank_0_is_aa_bank_1_is_55:
	ldx #4
	bne failed
bank_0_is_aa_bank_1_is_aa:
	ldx #3
	bne failed

passed:
	pla
	sta $ff00
	pla
	sta $d506
	lda #$00
	sta $d508
	sty $d507
	ldx #0	
-	
	lda ok_msg,x
	beq +
	sta $402,x
	inx
	jmp -
+
	lda #5
	sta $d020
	lda #$00
	sta $d7ff
	jmp *

failed:
	pla
	sta $ff00
	pla
	sta $d506
	lda #$00
	sta $d508
	sty $d507
	ldy #0	
-	
	lda error_msg,y
	beq +
	sta $402,y
	iny
	jmp -
+
	stx $d020
	lda #$ff
	sta $d7ff
	jmp *	

error_msg:
	!scr "test failed" 
	!byte 0
ok_msg:	
	!scr "test passed" 
	!byte 0

get_byte_from_bank1:
	ldx #$7f ; bank 1 all ram
	stx $ff00
	ldy $80
	ldx #$3f ; bank 0 all ram
	stx $ff00
	rts

set_bytes_in_bank1:
	ldx #$7f ; bank 1 all ram
	stx $ff00
	ldx #$55
	stx $80
	ldx #$3f ; bank 0 all ram
	stx $ff00
	rts
