; When the zero page and then the stack page are relocated to
; page $30 in bank 0, do we get the zero page or the stack
; page in page $30 ?
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
	lda #$00
	sta $d506 ; no shared memory
	lda #$aa
	sta $20   ; store #$aa in zero page in bank 0
	lda #$55
	sta $0120 ; store #$55 in stack page in bank 0
	lda #$33
	sta $3020 ; store #$33 in page $30 in bank 0
	lda #$30
	sta $d507 ; relocate zero page to $30xx in bank 0
	sta $d509 ; relocate stack page to $30xx in bank 0
	ldy $3020 ; page $30 in Y
	ldx #0
	cpy #$aa
	beq failed
	ldx #1
	cpy #$55
	beq failed
	ldx #3
	cpy #$33
	beq failed
	ldx #10
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
