; When the zero page in shared memory is relocated to page $30 in
; bank 1, and you read the zp in bank 0, do you read page $30 in bank 1 ?
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
	lda #$0e
	sta $d506 ; top and bottom shared memory 8KB
	lda #$aa
	sta $80   ; store #$aa in zero page in bank 0
	lda #$55
	sta $3080 ; store #$55 in $3080 in bank 0
	lda #$3f
	sta $ff00 ; bank 0 all ram
	ldx #$00
loop:
	lda put_byte_in_bank1,x
	sta $e000,x
	inx
	bne loop
	jsr $e000 ; store #$33 in $3080 in bank 1
	lda #$00
	sta $ff00 ; map in I/O, bank 0
	lda #$01
	sta $d508
	lda #$30
	sta $d507 ; relocate zero page to $30xx in bank 1
	lda $80
	ldx #$00
	stx $d508
	ldx #$00
	stx $d507 ; put zero page back to $00xx in bank 0
	ldx #0
	cmp #$aa
	beq failed
	cmp #$55
	beq passed
	ldx #3
	cmp #$33
	beq failed
	ldx #4
	beq failed

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
	lda #$33
	sta $3080 ; store #$33 in $3080 bank 1
	lda #$3f
	sta $ff00 ; bank 0 all ram
	rts
