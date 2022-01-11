; When the zero page in shared memory is relocated to the zero page in
; bank 1, do they swap ?
;
; test confirmed on real hardware
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
	lda #$04
	sta $d506 ; bottom shared 1kb
	lda #$aa
	sta $80   ; store in zero page in bank 0
	lda #$01
	sta $d508 ; relocate zero page to bank 1
	lda #$00
	sta $d507 ; activate zero page mapping to zero page in bank 1
	lda #$55
	sta $80   ; store in zero page in bank 1 ??
	lda #$00
	sta $d508 ; get zero page back to bank 0
	lda #$00
	sta $d507 ; activate zero page mapping to zero page in bank 0
	ldx $80   ; zero page bank 0 in X
	lda #$01
	sta $d508 ; relocate zero page to bank 1
	lda #$00
	sta $d507 ; activate zero page mapping to zero page in bank 1
	ldy $80   ; zero page bank 1 in Y
	lda #$00
	sta $d508 ; get zero page back to bank 0
	lda #$00
	sta $d507 ; activate zero page mapping to zero page in bank 0
	cpx #$55
	beq zp_bank0_55
	cpx #$aa
	beq zp_bank0_aa
	ldx #10
	bne failed
zp_bank0_55:
	cpy #$55
	beq passed
	cpy #$aa
	beq zp_bank0_55_bank1_aa
	ldx #10
	bne failed
zp_bank0_aa:
	cpy #$55
	beq zp_bank0_aa_bank1_55
	cpy #$aa
	beq zp_bank0_aa_bank1_aa
	ldx #10
	bne failed
zp_bank0_55_bank1_aa:
	ldx #1
	bne failed
zp_bank0_aa_bank1_55:
	ldx #3
	bne failed
zp_bank0_aa_bank1_aa:
	ldx #4
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
