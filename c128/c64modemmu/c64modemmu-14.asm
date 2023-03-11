; This is a c64 mode mmu test to see if any of the c128 mode roms exist in c64 mode.
;
; test confirmed on real hardware
;
; colors:
;   green  = none of the c128 roms exist in c64 mode
;   blue   = one of the c128 roms exist in c64 mode
;   yellow = two of the c128 roms exist in c64 mode
;   orange = all of the c128 roms exist in c64 mode
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

; bank in bank 0 and make everything ram
	lda #$3e
	sta $ff00

; copy test into bank 0 at $8000
	ldx #$00
loop0:
	lda test,x
	sta $8000,x
	inx
	bne loop0

; bank in bank 0 and map in all c128 roms
	lda #$00
	sta $ff00

; set $00 and $01 in preparation for switching to c64 mode
	lda #$37
	sta $01
	lda #$2f
	sta $00

; set border to black in case there are c128 roms in c64 mode and we wind up in basic
	lda #$00
	sta $d020

; switch on c64 mode
c64switch:
	lda #$f7
	sta $d505

; jump to reset vector to start c64 rom

	jmp ($fffc)

; test in bank 0
test:
	!byte  $09,$80,$09,$80,$c3,$c2,$cD,$38,$30

	stx $d016

	sei
	ldx #$05
	ldy #$00
	lda $4000
	inc $4000
	cmp $4000
	bne no4000
	ldy #$ff
	inx
no4000:
	lda $8000
	inc $8000
	cmp $8000
	bne no8000
	inx
	ldy #$ff
no8000:
	lda $c000
	inc $c000
	cmp $c000
	bne noc000
	ldy #$ff
	inx
noc000:

setborder:
	stx $d020
	sty $d7ff
	clc
l0:
	bcc l0
