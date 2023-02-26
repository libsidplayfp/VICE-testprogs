; This is a c64 mode test to see if the z80 can change access the vicii color map at $d800-$dbff AND $1000-$13ff through in/out.
;
; test confirmed on real hardware
;
; colors:
;   black  = was not able to switch on the z80
;   white  = got z80 switched on, but no z80 bios present
;   cyan   = z80 on, z80 bios present in c128 mode, but could not get into c64 mode
;   violet = z80 on, z80 bios present in c128 mode, got to c64 mode, no access to vicii color map at all
;   blue   = z80 on, z80 bios present in c128 mode, got to c64 mode, access to vicii color map only at $1000-$13ff
;   yellow = z80 on, z80 bios present in c128 mode, got to c64 mode, access to vicii color map only at $d800-$dbff
;   green  = z80 on, z80 bios present in c128 mode, got to c64 mode, access to vicii color map at $1000-$13ff AND $d800-$dbff
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

; bank in bank 0 and make everything ram, bank in I/O
	lda #$3e
	sta $ff00

; change the border color to black
	lda #$00
	sta $d020

; make sure vicii color memory bank 1 is mapped in
	lda $01
	ora #$03
	sta $01

; fill the vicii color memory with a pattern
	ldx #$00
fill_loop:
	txa
	sta $d800,x
	sta $d900,x
	sta $da00,x
	sta $db00,x
	inx
	bne fill_loop

; set $00 and $01 in preparation for switching to c64 mode
	lda #$37
	sta $01
	lda #$2f
	sta $00

; jump to $2000
	jmp $2000

*=$2000
 
!binary "c64modez80-03.bin"
