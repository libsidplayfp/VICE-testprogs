; When the stack page is swapped with the zero page using the MMU,
; accesses to the stack page wind up at the zero page.
; and if the zero page is told to stay in place using the MMU,
; it stays in place, so page 1 become unaccessable
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
	ldy $d509
	lda #$aa
	sta $20   ; store in zero page
	lda #$55
	sta $0120 ; store in stack page
	lda #$00
	sta $d509 ; relocate stack page to zero page
	ldx $0120
	lda $20
	cmp #$55
	beq page0_55
	cmp #$aa
	beq page0_aa
	ldx #2
	bne failed
page0_55:
	cpx #$55
	beq page0_55_page1_55
	cpx #$aa
	beq page0_55_page1_aa
	ldx #2
	bne failed
page0_aa:
	cpx #$55
	beq page0_aa_page1_55
	cpx #$aa
	beq passed
	ldx #2
	bne failed
page0_55_page1_aa:
	ldx #0
	beq failed
page0_aa_page1_55:
	ldx #1
	bne failed
page0_55_page1_55:
	ldx #3
	bne failed

passed:
	sty $d509
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
	sty $d509
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
