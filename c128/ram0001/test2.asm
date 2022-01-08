; Use the zero page mapping back translation method to get the real
; value of ram $00 instead of the cpu port.
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
	sta $3000 ; store #$aa in $3000 bank 0
	lda #$55
	sta $00   ; store #$55 in cpu port $00
	lda #$30
	sta $d509 ; relocate zero page to $30xx in bank 0
	lda #$33
	sta $3000 ; store #$33 in ram $00 through back translation
	lda #$00
	sta $d509 ; relocate zero page to back to normal
	lda $3000 ; get value from $3000 in bank 0
	cmp #$aa
	bne failed
	lda $00   ; get value from cpu port $00
	cmp #$55
	bne failed
	lda #$30
	sta $d509 ; relocate zero page to $30xx in bank 0
	lda $3000 ; get value from ram $00 through back translation
	ldx #$00
	stx $d509 ; relocate zero page to back to normal
	cmp #$33
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
	jmp *

failed:
	ldy #0	
-	
	lda error_msg,y
	beq +
	sta $402,y
	iny
	jmp -
+
	ldx #10
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
