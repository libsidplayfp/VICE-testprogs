; This is a c128 mode z80 test to see if the $d040-$d3ff mirrors of $d000-$d03f work with the z80 in/out.
;
; test confirmed on real hardware
;
; colors:
;   black  = was not able to switch on the z80
;   white  = got z80 switched on, but no z80 bios present
;   cyan   = z80 on, z80 bios present in c128 mode, ONLY $d000-$d03f works
;   violet = z80 on, z80 bios present in c128 mode, ONLY $d040-$d0ff is a mirror of $d000-$d03f
;   green  = z80 on, z80 bios present in c128 mode, ALL of $d040-$d3ff is a mirror of $d000-$d03f
;   red    = something went very wrong during the test
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

; bank in bank 0 and bank in I/O
	lda #$3e
	sta $ff00

; no shared memory
	lda #$00
	sta $d506

; change the border color to black
	lda #$00
	sta $d020

; jump to $2000 in bank 0
	jmp $2000

*=$2000
 
!binary "c128modez80-22.bin"
