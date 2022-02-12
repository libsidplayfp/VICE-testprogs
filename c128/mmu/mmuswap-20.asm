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
	cpy #$aa
	beq passed_zp
	cpy #$55
	beq passed_sp
	ldx #3
	cpy #$33
	beq failed
	ldx #10
	bne failed

passed_zp:
	lda #$04
	sta $d506
	ldx #0	
loop_zp:
	lda ok_zp_msg,x
	beq passed
	sta $402,x
	inx
	jmp loop_zp

passed_sp:
	lda #$04
	sta $d506
	ldx #0	
loop_sp:
	lda ok_sp_msg,x
	beq passed
	sta $402,x
	inx
	jmp loop_sp
passed:
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
ok_zp_msg:
	!scr "test passed, zero page takes priority" 
	!byte 0
ok_sp_msg:
	!scr "test passed, stack page takes priority" 
	!byte 0
