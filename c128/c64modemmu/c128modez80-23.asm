; This is a c128 mode z80 test to see what we get when we use in/out on $d7xx.
;
; test confirmed on real hardware
;
; colors:
;   black  = was not able to switch on the z80
;   white  = got z80 switched on, but no z80 bios present
;   cyan   = z80 on, z80 bios present in c128 mode, we got RAM at $d7xx
;   violet = z80 on, z80 bios present in c128 mode, we got z80 bios at $d7xx
;   blue   = z80 on, z80 bios present in c128 mode, we got a constant value
;   yellow = z80 on, z80 bios present in c128 mode, we got whatever the vicii leaves on the bus
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

; bank in bank 0 and bank out I/O
	lda #$3f
	sta $ff00

; put #$55 in $d700
	lda #$55
	sta $d700

; put #$aa in $d701
	lda #$aa
	sta $d701

; put #$33 in $d702
	lda #$33
	sta $d702

; bank in bank 0 and bank in I/O
	lda #$3e
	sta $ff00

; change the border color to black
	lda #$00
	sta $d020

; jump to $2000 in bank 0
	jmp $2000

*=$2000
 
!binary "c128modez80-23.bin"
