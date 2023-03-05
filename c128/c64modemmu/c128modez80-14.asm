; This is a c128 mode z80 test to see what happens if we set map the zero page to page $40, and we access that memory with in/out,
; do we get the page $40 or the zero page, or the z80 bios.
;
; test confirmed on real hardware
;
; colors:
;   black  = was not able to switch on the z80
;   white  = got z80 switched on, but no z80 bios present
;   green  = z80 on, z80 bios present in c128 mode, we get the zero page
;   violet = z80 on, z80 bios present in c128 mode, we get page $40
;   blue   = z80 in, z80 bios present in c128 mode, we get the z80 bios
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

; put #$55 in $80
	lda #$55
	sta $80

; put #$aa in $4080
	lda #$aa
	sta $4080

; change the border color to black
	lda #$00
	sta $d020

; jump to $2000
	jmp $2000

*=$2000
 
!binary "c128modez80-14.bin"
