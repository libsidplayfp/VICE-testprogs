; This is a c128 mode z80 test to see if the z80 bios depends on the mmu io bit.
;
; test to be confirmed on real hardware
;
; colors:
;   black  = was not able to switch on the z80
;   white  = got z80 switched on, but no z80 bios present
;   cyan   = z80 on, z80 bios present in c128 mode, z80 bios does NOT depend on the mmu i/o bit
;   violet = z80 on, z80 bios present in c128 mode, z80 bios DOES depend on the mmu i/o bit
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

; no shared memory
	lda #$00
	sta $d506

; bank in bank 0 and bank in I/O
	lda #$3e
	sta $ff00

; put #$55 in $048d
	lda #$55
	sta $048d

; put #$aa in $048e
	lda #$aa
	sta $048e

; put #$33 in $048f
	lda #$33
	sta $048f

; change the border color to black
	lda #$00
	sta $d020

; jump to $2000
	jmp $2000

*=$2000
 
!binary "c128modez80-15.bin"
