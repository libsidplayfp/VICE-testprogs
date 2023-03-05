; This is a c128 mode z80 test to see what happens if we set $c000-$ffff as shared memory and we access that memory with bank 1 banked in with in/out,
; do we get the ram from bank 0 or bank 1.
;
; test confirmed on real hardware
;
; colors:
;   black  = was not able to switch on the z80
;   white  = got z80 switched on, but no z80 bios present
;   cyan   = z80 on, z80 bios present in c128 mode, we get RAM from bank 1
;   green  = z80 on, z80 bios present in c128 mode, we get RAM from bank 0
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

; set $0000-$3fff as shared memory
	lda #$07
	sta $d506

; bank in bank 1 and bank in I/O
	lda #$7e
	sta $ff00

; put #$55 in $c000 in bank 1
	lda #$55
	sta $c000

; bank in bank 0 and bank in I/O
	lda #$3e
	sta $ff00

; put #$aa in $c000 in bank 0
	lda #$aa
	sta $c000

; set $0000-$3fff and $c000-$ffff as shared memory
	lda #$0f
	sta $d506

; bank in bank 0 and bank in I/O
	lda #$7e
	sta $ff00

; change the border color to black
	lda #$00
	sta $d020

; jump to $2000
	jmp $2000

*=$2000
 
!binary "c128modez80-13.bin"
