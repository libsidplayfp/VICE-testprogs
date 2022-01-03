; When the zero page is relocated to a RAM page using the MMU, does it swap to bank 1 as well
;
; Test will not reach passed, it will produce different border colors for different situations
;
; Test not yet confirmed on real hardware
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
	lda #$00
	sta $ff00 ; make sure I/O is mapped in
	lda #$04
	sta $d506 ; shared low, 1kb
	lda #$aa
	sta $80   ; store in real zero page
	lda #$55
	sta $3080 ; store in page 30 bank 0
	lda #$0e
	sta $d506 ; shared hi/low, 8kb
	lda #$3f
	sta $ff00 ; bank 0, all ram
	ldx #$00
loop1:
	lda set_byte_in_bank_1,x
	sta $e000,x
	inx
	bne loop1
	jsr $e000
	lda #$00
	sta $ff00 ; bank 0, I/O mapped in
	lda #$01
	sta $d508 ; relocate zero page bank to bank 1
	lda #$30
	sta $d507 ; relocate zero page to page 30 (bank 1)
	lda #$3f
	sta $ff00 ; bank 0, all ram
	ldx #$00
loop2:
	lda get_byte_from_bank_1,x
	sta $e000,x
	inx
	bne loop2
	jsr $e000 ; $3080 bank 1 in Y
	lda #$00
	sta $ff00 ; bank 0, I/O mapped in
	lda $3080 ; $3080 bank 0 in A
	cmp #$33
	beq bank_0_33
	cmp #$55
	beq bank_0_55
	cmp #$aa
	beq bank_0_aa
	ldx #10
	bne failed
bank_0_33:
	ldx #0
	cpy #$33
	beq failed
	ldx #1
	cpy #$55
	beq failed
	ldx #3
	cpy #$aa
	beq failed
	ldx #10
	bne failed
bank_0_55:
	ldx #4
	cpy #$33
	beq failed
	ldx #6
	cpy #$55
	beq failed
	ldx #7
	cpy #$aa
	beq failed
	ldx #10
	bne failed
bank_0_aa:
	ldx #14
	cpy #$33
	beq failed
	ldx #15
	cpy #$55
	beq failed
	ldx #8
	cpy #$aa
	beq failed
	ldx #10
	bne failed

passed:
	ldy #$00
	sty $d508
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
	ldy #$00
	sty $d508
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

set_byte_in_bank_1:
	lda #$7f
	sta $ff00 ; bank 1, all ram
	lda #$33
	sta $3080 ; store in page 30, bank 1
	lda #$3f
	sta $ff00 ; bank 0, all ram
	rts

get_byte_from_bank_1:
	lda #$7f
	sta $ff00 ; bank 1, all ram
	ldy $3080 ; page 30, bank 1 in Y
	lda #$3f
	sta $ff00 ; bank 0, all ram
	rts
