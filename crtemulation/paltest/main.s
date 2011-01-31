
	fillvalue=$00
	
	!initmem 	fillvalue
	!cpu 6502
	!to "paltest.prg", cbm

        *= $0801
        !byte $0c,$08,$0b,$00,$9e
        !byte $32,$35,$36,$30
        !byte $00,$00,$00,$00
		 
	;-----------------------------------------------------
	*=$0a00
	
	sei	
	lda #0
	sta $d020
	sta $d021
			
	lda #$d8
	sta $d016
	lda #$3b
	sta $d011
		
	lda #$18
	sta $d018
			
	ldx #$0
lp
	lda screen,x
	sta $0400,x
	lda screen+$0100,x
	sta $0500,x
	lda screen+$0200,x
	sta $0600,x
	lda screen+$0300,x
	sta $0700,x
			
	lda colram,x
	sta $d800,x
	lda colram+$0100,x
	sta $d900,x
	lda colram+$0200,x
	sta $da00,x
	lda colram+$0300,x
	sta $db00,x
			
	inx
	bne lp
			
	jmp *
			
	*=$2000
	!bin "testpic.koa",$2000,2		
screen
	!bin "testpic.koa",$400,2+$1f40
colram		
	!bin "testpic.koa",$400,2+$1f40+$03e8		
			