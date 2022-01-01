;-----------------------------------------------------------------
;
; The MMU-zeropage-register is only updated after
; P0H ($d507) is set, d508 is latched (setting d508 only changes
; zeropage-page after P0L ($d507) has been set)
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


	sei
; first init the test	

	; set zeropage to bank0
	lda #0  
	sta $d508
	; set zeropage to adr $100
	lda #1
	sta $d507

; now read the P0H	
	lda $d508
	and #$f     ; only check the lo-nibble because of a VICE-bug
	cmp #0
	bne failed
	
;---
; now the test starts

	; set zeropage to bank1
	lda #1
	sta $d508
		 	
; now read P0H 
; the lo-nibble should be still 0, because P0L is not set!
	lda $d508
	and #$f     ; only check the lo-nibble because of a VICE-bug
	cmp #0
	bne failed
	
	; set zeropage to adr $100
	lda #1
	sta $d507
	; now the zeropage is at $10100

; now read P0H again
; the lo-nibble should be 1 now
	lda $d508
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
