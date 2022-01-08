; When the zero page in shared memory is relocated to page $30 in
; bank 1, and you read page $30 in bank 0, do you get the zero page,
; and if you read page $30 in bank 1, do you get the zero page ?
;
; test will not reach passed till results come in
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
	lda #$00
	sta $ff00 ; map in I/O, bank 0
	lda #$0a
	sta $d506 ; top mem shared 8kb
	lda #$aa
	sta $80   ; store #$aa in zero page in bank 0
	lda #$55
	sta $3080 ; store #$55 in $3080 in bank 0
	lda #$01
	sta $d508 ; map zero page to bank 1
	lda #$00
	sta $d507 ; activate zero page mapping to bank 1
	lda #$33
	sta $80
	lda #$00
	sta $d508 ; map zero page to bank 0
	sta $d507 ; activate zero page mapping to bank 0
	lda #$0e
	sta $d506 ; bottom and top mem shared 8kb
	lda #$3f
	sta $ff00 ; bank 0 all ram
	ldx #$00
loop:
	lda put_byte_in_bank1,x
	sta $e000,x
	inx
	bne loop
	jsr $e000 ; store #$11 in $3080 in bank 1
	lda #$00
	sta $ff00 ; map in I/O, bank 0
	lda #$01
	sta $d508
	lda #$30
	sta $d507 ; relocate zero page to $30xx in bank 1
	lda #$3f
	sta $ff00 ; bank 0 all ram
	ldx #$00
loop2:
	lda get_byte_from_bank1,x
	sta $e000,x
	inx
	bne loop2
	jsr $e000 ; $3080 in bank 1 in X
	ldy $3080 ; $3080 in bank 0 in Y
	lda #$00
	sta $ff00 ; map in I/O, bank 0
	lda #$00
	sta $d508
	lda #$00
	sta $d507 ; put zero page back to $00xx in bank 0
	cpx #$aa
	beq bank1_aa
	cpx #$33
	beq bank1_33
	cpx #$11
	beq bank1_11
	ldx #10
	bne failed
bank1_aa:
	cpy #$aa
	beq bank1_aa_bank0_aa
	cpy #$55
	beq bank1_aa_bank0_55
	cpy #$33
	beq bank1_aa_bank0_33
	ldx #10
	bne failed
bank1_33:
	cpy #$aa
	beq bank1_33_bank0_aa
	cpy #$55
	beq bank1_33_bank0_55
	cpy #$33
	beq bank1_33_bank0_33
	ldx #10
	bne failed
bank1_11:
	cpy #$aa
	beq bank1_11_bank0_aa
	cpy #$55
	beq bank1_11_bank0_55
	cpy #$33
	beq bank1_11_bank0_33
	ldx #10
	bne failed
bank1_aa_bank0_aa:
	ldx #0
	beq failed
bank1_aa_bank0_55:
	ldx #1
	bne failed
bank1_aa_bank0_33:
	ldx #3
	bne failed
bank1_33_bank0_aa:
	ldx #4
	bne failed
bank1_33_bank0_55:
	ldx #6
	bne failed
bank1_33_bank0_33
	ldx #7
	bne failed
bank1_11_bank0_aa:
	ldx #9
	bne failed
bank1_11_bank0_55:
	ldx #14
	bne failed
bank1_11_bank0_33:
	ldx #13
	bne failed

passed:
	lda #$04
	sta $d506
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
	lda #$04
	sta $d506
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

put_byte_in_bank1:
	lda #$7f
	sta $ff00 ; bank 1 all ram
	lda #$11
	sta $3080 ; store #$33 in $3080 bank 1
	lda #$3f
	sta $ff00 ; bank 0 all ram
	rts

get_byte_from_bank1:
	lda #$7f
	sta $ff00 ; bank 1 all ram
	ldx $3080 ; $3080 bank 1 in X
	lda #$3f
	sta $ff00 ; bank 0 all ram
	rts
