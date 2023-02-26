; This is a c128 mode test to see which vicii color memory bank the z80 can access.
;
; test confirmed on real hardware
;
; colors:
;   black  = was not able to switch on the z80
;   white  = got z80 switched on, but no z80 bios present
;   green  = z80 on, z80 bios present in c128 mode, $1000-$13ff AND $d800-$dbff current vicii color memory bank
;   violet = z80 on, z80 bios present in c128 mode, $1000-$13ff vicii color memory bank 1, $d800-$dbff vicii color memory bank 0
;   blue   = z80 on, z80 bios present in c128 mode, $1000-$13ff vicii color memory bank 0, $d800-$dbff vicii color memory bank 1
;   yellow = z80 on, z80 bios present in c128 mode, $1000-$13ff AND $d800-$dbff vicii color memory bank 1
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

; bank in bank 0 and bank in I/O
	lda #$00
	sta $ff00

; make sure bank 1 vicii color memory is mapped in
	lda $01
	ora #$03
	sta $01

; fill vicii color memory with data
	ldx #$00
fill_loop:
	txa
	sta $d800,x
	sta $d900,x
	sta $da00,x
	sta $db00,x
	inx
	bne fill_loop

; change the vicii color memory bank to bank 0
	lda $01
	and #$fc
	sta $01

; change the border color to black
	lda #$00
	sta $d020

; jump to $2000
	jmp $2000

*=$2000
 
!binary "c128modez80-04.bin"
