; The MMU register should not be mirrored.  
;
; Test done by Bodo^Rabenauge


; 10 SYS7181
*=$1c01  
	!byte  $0c,$08,$0a,$00,$9e,$37,$31,$38,$31,$00,$00,$00
*=$1c0d 

	lda #%00110011 ; disable basic
	sta $01
	
	lda #%00000111  ; lower 16kb shared RAM	  
	sta $d506	
	
; switch to bank 0   / turn ROM off / IO on
	lda #%00111110
	sta $ff00	

;----------------------------
; here is the test
	lda #$30    ; move stackpage to $3000
	sta $d509
	
	lda $d509
	cmp #$30
	bne failed
;--
	lda #$1    ; put $1 in $d5f9
	sta $d5f9	
	lda $d509  ; test if $d509 contains still $30  
	cmp #$30
	bne failed
-		
	jmp passed

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