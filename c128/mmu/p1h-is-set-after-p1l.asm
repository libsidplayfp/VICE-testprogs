;-----------------------------------------------------------------
;
; The MMU-stack-register is only updated after
; P1H ($D509) is set, d50a is latched (setting d50a only changes
; stack-page after P1L ($D509) has been set)
;
; done by Bodo^Rabenauge
;  
; email bodo.hinueber@rabenauge.com 
;
; 	
;-----------------------------------------------------------------


start=$2400

;basicHeader=1 

!ifdef basicHeader {
; 10 SYS7181
*=$1c01  
	!byte  $0c,$08,$0a,$00,$9e,$37,$31,$38,$31,$00,$00,$00
*=$1c0d 
	jmp start
}
*=start

;	lda #%00000111  ; lower 16kb shared RAM	  
;	sta $d506	

	sei
; first init the test	

	; set stack to bank0
	lda #0  
	sta $d50a
	; set stack to adr $100
	lda #1
	sta $d509

; now read the P1H	
	lda $d50a
	and #$f     ; only check the lo-nibble because of a VICE-bug
	cmp #0
	bne failed
	
;---
; now the test starts

	; set stack to bank1
	lda #1
	sta $d50a
		 	
; now read P1H 
; the lo-nibble should be still 0, because P1L is not set!
	lda $d50a
	and #$f     ; only check the lo-nibble because of a VICE-bug
	cmp #0
	bne failed
	
	; set stack to adr $100
	lda #1
	sta $d509
	; now the stack is at $10100

; now read P1H again
; the lo-nibble should be 1 now
	lda $d50a
	and #$f     ; only check the lo-nibble because of a VICE-bug
	cmp #1
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