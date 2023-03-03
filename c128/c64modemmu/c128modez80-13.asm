; This is a c128 mode test to see if in z80 mode the mmu registers $ff00-$ff04 are accessable through in/out.
;
; test to be confirmed on real hardware
;
; colors:
;   black   = was not able to switch on the z80
;   white   = got z80 switched on, but no z80 bios present
;   cyan    = z80 on, z80 bios present in c128 mode, NONE of the $ff00-$ff04 registers are available through in/out
;   violet  = z80 on, z80 bios present in c128 mode, ONLY the $ff00 register is readable through in/out
;   blue    = z80 on, z80 bios present in c128 mode, ONLY the $ff00 register is writable through in/out
;   yellow  = z80 on, z80 bios present in c128 mode, ONLY the $ff00 register is readable AND writable through in/out
;   brown   = z80 on, z80 bios present in c128 mode, ONLY $ff01-$ff04 registers are available through in/out
;   pink    = z80 on, z80 bios present in c128 mode, the $ff00 register is readable and all of the $ff01-$ff04 registers are available through in/out
;   grey    = z80 on, z80 bios present in c128 mode, the $ff00 register is writable and all of the $ff01-$ff04 registers are available through in/out
;   l. blue = z80 on, z80 bios present in c128 mode, the $ff00 register is readable and writable and all of the $ff01-$ff04 registers are available through in/out
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
 
!binary "c128modez80-13.bin"
