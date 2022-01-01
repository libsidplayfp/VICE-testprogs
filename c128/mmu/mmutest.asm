; If the stack is in in shared memory
; it doesn't care if register $d50a (P1H) points to bank 0 or bank 1
;
; Test if the stack is in bank 0 and bank 1 when
; the stack is moved in shared memory, but 
; the bank for the stack was switched by register $d50a (P1H)
;
;
; Test done by Bodo^Rabenauge


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

	lda #%00110011 ; disable basic
	sta $01

	sei
; clearScreen
	ldx #250
	lda #$20
-	
	sta $400-1,x
	sta $400-1+250,x
	sta $400-1+500,x
	sta $400-1+750,x
	dex
	bne -

;----------------------------
; here is the test


; switch to bank 0  / turn ROM off / IO on
;	     %76543210
	lda #%00111110
	sta $ff00	

	lda #%00000111  ; lower 16kb shared RAM	  
	sta $d506	

	lda #$0	   
	sta $d50a  ; change stackpage to bank 0

	lda #$5
	sta $d509  ; change stackpage to $500

	ldx #5	   ; change stack pointer
	txs


; push 4 bytes into the stack in bank 0
	lda #$01 
	pha	
	lda #$02
	pha
	lda #$03 
	pha	
	lda #$04
	pha
;-----
	lda #1 
	sta $d50a ; change stackpage to bank 1

	lda #$5
	sta $d509  ; change stackpage to $500

; pull the bytes from the stack in bank 1
; the bytes must be the same 4 bytes, like the bytes which are pushed before to stack in bank 0,
; because the stack is in the shared memory.

	pla
	sta $700
	pla
	sta $701	
	pla
	sta $702
	pla
	sta $703

; read everything from stack and compare it.	
	lda #4
	cmp $700
	bne failed
	lda #3
	cmp $701
	bne failed
	lda #2
	cmp $702
	bne failed
	lda #1
	cmp $703
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
