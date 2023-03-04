; This is a c128 mode test to see what we get if in z80 mode we in/out to an address that has no device at that address in the i/o-space,
; do we get the ram/rom at that address, do we get what the vicii left on the bus, or do we get a static value.
;
; test confirmed on real hardware
;
; colors:
;   black   = was not able to switch on the z80
;   white   = got z80 switched on, but no z80 bios present
;   green   = z80 on, z80 bios present in c128 mode, we get RAM at the address from in/out
;   violet  = z80 on, z80 bios present in c128 mode, we get a static value
;   blue    = z80 on, z80 bios present in c128 mode, we get whatever the vicii left on the bus
;   red     = something went very wrong during the test
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
	lda #$3e
	sta $ff00

; change the border color to black
	lda #$00
	sta $d020

; jump to $2000
	jmp $2000

*=$2000
 
!binary "c128modez80-12.bin"
