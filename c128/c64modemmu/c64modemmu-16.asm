; This is a c64 mode mmu test to see which vicii color memory bank is used in c64 mode when having vicii color memory bank 0 mapped in.
;
; test to be confirmed on real hardware
;
; colors:
;   black = vicii color memory bank 0
;   green = vicii color memory bank 1
;   cyan  = something weird is going on with vicii color memory
;
; Test made by Marco van den Heuvel


start=$1c40

basicHeader=1 

!ifdef basicHeader {
; 10 SYS7181
*=$1c01
	!byte  $0c,$08,$0a,$00,$9e,$37,$31,$38,$31,$00,$00,$00
*=$1c0d 
	jmp start
}
*=start
; clear the screen
	lda #$93
	jsr $ffd2

	sei

; no shared memory
	lda #$00
	sta $d506

; bank in bank 0 and make everything ram, and bank in I/O
	lda #$3e
	sta $ff00

; copy test into bank 0 at $8000
	ldx #$00
loop0:
	lda test,x
	sta $8000,x
	inx
	bne loop0

; bank in vicii color memory bank 0 and fill it with 5's
	lda $01
	and #$fc
	sta $01
	lda #$05
	jsr fillit

; bank in vicii color memory bank 1 and fill it with a's
	lda $01
	ora #$03
	sta $01
	lda #$0a
	jsr fillit

; set $00 and $01 in preparation for switching to c64 mode, but bank in vicii color memory map bank 0
	lda #$36
	sta $01
	lda #$2f
	sta $00

; switch on c64 mode
c64switch:
	lda #$f7
	sta $d505

; jump to reset vector to start c64 rom

	jmp ($fffc)

; fill current vicii video memory bank with value in register a
fillit:
	ldx #$00
fill_loop:
	sta $d800,x
	sta $d900,x
	sta $da00,x
	sta $db00,x
	inx
	bne fill_loop
	rts


; test in bank 0
test:
	!byte  $09,$80,$25,$80,$c3,$c2,$cD,$38,$30

	stx $d016
	sei

; check what is in the current vicii color memory
	lda $d800
	and #$0f
	sta $80
	ldx #$01
check_loop:
	lda $d800,x
	and #$0f
	cmp $80
	bne wtf
	inx
	bne check_loop

; is the value in $d800-$d8ff '#$05' ?
	cmp #$05
	beq bank0

; is the value in $d800-$d8ff '#$0a' ?
	cmp #$0a
	beq bank1

wtf:
	ldx #$03
	ldy #$ff
	bne set_border

bank0:
	ldy #$ff
	ldx #$00
	beq set_border

bank1:
	ldx #$05
	ldy #$00

set_border:
	stx $d020
	sty $d7ff

	clc
l0:
	bcc l0
