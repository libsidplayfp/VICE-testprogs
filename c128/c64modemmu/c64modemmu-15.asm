; This is a c64 mode mmu test to see if the vicii color memory bank can be switched once in c64 mode
;
; test to be confirmed on real hardware
;
; colors:
;   black = cannot switch vicii color memory banks in c64 mode
;   white = can switch vicii color memory banks in c64 mode
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

; bank in vicii color memory bank 0
	lda $01
	and #$fc
	sta $01
	jsr clearit

; bank in vicii color memory bank 1
	lda $01
	ora #$03
	sta $01
	jsr clearit

; set $00 and $01 in preparation for switching to c64 mode
	lda #$37
	sta $01
	lda #$2f
	sta $00

; switch on c64 mode
c64switch:
	lda #$f7
	sta $d505

; jump to reset vector to start c64 rom

	jmp ($fffc)

; clear current vicii video memory bank
clearit:
	lda #$00
	tax
clear_loop:
	sta $d800,x
	sta $d900,x
	sta $da00,x
	sta $db00,x
	inx
	bne clear_loop
	rts


; test in bank 0
test:
	!byte  $09,$80,$25,$80,$c3,$c2,$cD,$38,$30

	stx $d016
	sei

; fill current vicii color memory bank
	ldx #$00
fill_loop:
	txa
	sta $d800,x
	sta $d900,x
	sta $da00,x
	sta $db00,x
	inx
	bne fill_loop

; make sure the filled data is good
	ldx #$00
check1_loop:
	lda $d800,x
	and #$0f
	sta $80
	txa
	and #$0f
	cmp $80
	bne wtf
	inx
	bne check1_loop

; change $01 bit 0 to possibly change vicii color memory banks
	lda $01
	and #$fe
	sta $01

; check if the vicii color memory bank data is now different
	ldx #$00
check0_loop:
	lda $d800,x
	and #$0f
	sta $80
	txa
	and #$0f
	cmp $80
	bne vicii_bank_changed
	inx
	bne check0_loop

; vicii color memory bank did not change, set border color to indicate this
	ldx #$00
	beq set_border

vicii_bank_changed:

; vicii color memory bank DID change, set border color to indicate this
	ldx #$01
	bne set_border

wtf:
	ldx #$03

set_border:
	stx $d020
	clc
l0:
	bcc l0
