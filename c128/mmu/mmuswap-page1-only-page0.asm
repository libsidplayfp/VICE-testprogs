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
	sta $20   ; store in 'soon to become' stack page (or still zero page)
	lda #$55
	sta $0120 ; store in real stack page
	lda #$00
	sta $d509 ; relocate stack page to zero page
	lda $20
	ldx #10
	cmp #$aa  ; expecting $aa
	bne failed
	ldx #04
	lda $0120
	cmp #$aa  ; expecting $aa
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

