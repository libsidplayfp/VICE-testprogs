; This test might need to be revised, DO NOT USE THIS TEST FOR NOW!!!
;
; This is a c128 mode test to see if in z80 mode the mmu register 0 is writable through in/out $d500 and memory access $ff00,
; and if $ff00 access is dependent on the mmu io bit.
;
; test to be confirmed on real hardware
;
; colors:
;   black  = was not able to switch on the z80
;   white  = got z80 switched on, but no z80 bios present
;   green  = z80 on, z80 bios present in c128 mode, mmu register 0 writable through in/out $d500 ONLY
;   violet = z80 on, z80 bios present in c128 mode, mmu register 0 writable through in/out $d500 AND memory access $ff00, $ff00 DEPENDS on the mmu io bit
;   blue   = z80 on, z80 bios present in c128 mode, mmu register 0 writable through in/out $d500 AND memory access $ff00, $ff00 does NOT depend on the mmu io bit
;   yellow = something weird going on with $ff00 writes
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
