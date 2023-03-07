; This is a c128 mode z80 test to see what we get if we access $04xx through i/o using in/out when the mmu i/o bit is off,
; do we get $04xx bios, do we get $04xx ram or do we get $d4xx ram.
;
; test confirmed on real hardware
;
; colors:
;   black  = was not able to switch on the z80
;   white  = got z80 switched on, but no z80 bios present
;   cyan   = z80 on, z80 bios present in c128 mode, we got $04xx BIOS
;   violet = z80 on, z80 bios present in c128 mode, we got $04xx RAM
;   green  = z80 on, z80 bios present in c128 mode, we got $d4xx RAM
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

; bank in bank 0 and bank out I/O
	lda #$3f
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

; put #$66 in $d48d ram
	lda #$66
	sta $d48d

; put #$99 in $d48e ram
	lda #$99
	sta $d48e

; put #$cc in $d48f ram
	lda #$cc
	sta $d48f

; bank in bank 0 and bank in I/O
	lda #$3e
	sta $ff00

; change the border color to black
	lda #$00
	sta $d020

; jump to $2000
	jmp $2000

*=$2000
 
!binary "c128modez80-17.bin"
