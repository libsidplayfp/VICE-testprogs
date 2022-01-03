; When both page pointers point to the same page, where does the reverse
; pointer mechanism point to?
;	(answer: real hw says it's the stack)
; And where do we find page 2? In both pages 0 and 1?
;	(answer: real hw says yes)
;
; Test confirmed on real hardware
;
; Test made by Marco Baye

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

	lda #$00	; roms and i/o
	sta $ff00
	lda #$04	; bottom 1k shared (system default anyway)
	sta $d506

	lda #$55	; $55 to zp
	sta $80
	lda #$aa	; $aa to stack
	sta $0180
	lda #$33	; $33 to page 2
	sta $0280

	lda #$00	; relocate zero page to 0:02xx
	sta $d508
	lda #$02	; activate relocation
	sta $d507

	ldx #0		; first result is expected to be 33 aa 55 (zp  and p2 swapped)
	lda $80
	cmp #$33
	bne failed
	ldx #1
	lda $0180
	cmp #$aa
	bne failed
	ldx #3
	lda $0280
	cmp #$55
	bne failed

	lda #$00	; now relocate stack to 0:02xx as well
	sta $d50a
	lda #$02	; activate relocation
	sta $d509

	ldx #14		; second result is expected to be 33 33 aa  (p2, p2, stack)
	lda $80
	cmp #$33
	bne failed
	ldx #4
	lda $0180
	cmp #$33
	bne failed
	ldx #6
	lda $0280
	cmp #$aa
	bne failed

	; relocate zp again to make sure result does not depend on  order of operations:
	lda #$00	; relocate zero page to 0:02xx
	sta $d508
	lda #$02	; activate relocation
	sta $d507

	ldx #7		; third result is again expected to be 33 33  aa (p2, p2, stack)
	lda $80
	cmp #$33
	bne failed
	ldx #8
	lda $0180
	cmp #$33
	bne failed
	ldx #9
	lda $0280
	cmp #$aa
	bne failed
passed:
	ldx #0
-	lda ok_msg, x
	beq +
	sta $0402, x
	inx
	jmp -
+	lda #5
	sta $d020
	lda #$00
	sta $d7ff
	jmp *

failed:
	ldy #0	
-	lda error_msg, y
	beq +
	sta $402, y
	iny
	jmp -
+	stx $d020
	lda #$ff
	sta $d7ff
	jmp *	

error_msg:
	!scr "test failed" 
	!byte 0
ok_msg:	
	!scr "test passed" 
	!byte 0
