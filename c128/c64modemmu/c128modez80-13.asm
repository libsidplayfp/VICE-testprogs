; This test might need to be revised, DO NOT USE THIS TEST FOR NOW!!!
;
; This is a c128 mode test to see if in z80 mode the mmu PCRA, PCRB, PCRC and PCRD are accessable through memory access to $ff01-$ff04.
;
; test to be confirmed on real hardware
;
; colors:
;   black  = was not able to switch on the z80
;   white  = got z80 switched on, but no z80 bios present
;   cyan   = z80 on, z80 bios present in c128 mode, NONE of the $ff01-$ff04 mmu registers work
;   violet = z80 on, z80 bios present in c128 mode, SOME of the $ff01-$ff04 mmu registers work
;   green  = z80 on, z80 bios present in c128 mode, ALL of the $ff01-$ff04 mmu registers work
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
