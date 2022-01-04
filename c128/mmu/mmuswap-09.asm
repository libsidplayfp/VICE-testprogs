; When the zero page is relocated to I/O or ROM space using the MMU,
; only the RAM under I/O or ROM space is remapped.
;
; The ROM or I/O still overlays in memory and does not cause back-translation.
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
	lda #$aa
	sta $10   ; store in real zero page
	lda #$55
	sta $d010 ; store in 'soon to become' zero page
	ldx $ff00
	lda #$3f
	sta $ff00 ; make everything RAM
	lda #$33
	sta $d010 ; store in RAM under 'soon to become zero page'
	stx $ff00 ; restore mmu config
	lda #$d0
	sta $d507 ; relocate zero page to $d0xx
	lda $10
	cmp #$33  ; expecting $33
	beq seems_ok
	ldx #03
	cmp #$55  ; see if it's $55
	beq failed
	ldx #04
	cmp #$aa  ; see if it's $aa
	beq failed
	ldx #06
	jmp failed
seems_ok:
	lda $d010
	cmp #$55  ; expecting $55
	beq passed
	ldx #07
	cmp #$33  ; see if it's $33
	beq failed
	ldx #0
	cmp #$aa  ; see if it's $aa
	beq failed
	ldx #1
	jmp failed

passed:
	ldy #0
	sty $d507
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
	sty $d507
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
