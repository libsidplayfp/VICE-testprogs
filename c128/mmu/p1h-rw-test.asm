;-----------------------------------------------------------------
;
; Only the lo nibble of P1H ($D50A) can be set.
; The hi nibble is always $f 
;
; done by Bodo^Rabenauge
;  
; email bodo.hinueber@rabenauge.com 
;
; 	
;-----------------------------------------------------------------

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

	lda #%00000111  ; lower 16kb shared RAM	  
	sta $d506	

	sei

	; set stack to bank1
	lda #$11
	sta $d50a
	; set stack to adr $100
	lda #1
	sta $d509

; now read P1H	
	lda $d50a
	cmp #$f1
	beq passed
			
;----------------------------
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
	jmp *	

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

error_msg:
	!scr "test failed" 
	!byte 0
ok_msg:	
	!scr "test passed" 
	!byte 0
