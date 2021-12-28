; When the zero page is relocated using the MMU, the areas swap
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
	ldy $d507
	lda #$aa
	sta $80   ; store in real zero page
	lda #$55
	sta $3080 ; store in 'soon to become' zero page
	lda #$30
	sta $d507 ; relocate zero page to $38xx
	lda $80
	cmp #$55  ; expecting $55
	bne failed
	lda $3080
	cmp #$aa  ; expecting $aa
	bne failed

passed:
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
	sty $d507
	jmp *

failed:
	ldx #0	
-	
	lda error_msg,x
	beq +
	sta $402,x
	inx
	jmp -
+
	lda #10
	sta $d020
	lda #$ff
	sta $d7ff
	sty $d507
	jmp *	

error_msg:
	!scr "test failed" 
	!byte 0
ok_msg:	
	!scr "test passed" 
	!byte 0
