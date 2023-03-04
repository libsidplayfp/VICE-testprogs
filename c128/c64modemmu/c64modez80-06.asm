; This is a c64 mode test to see what we get if in z80 mode we in/out to an address that has no device at that address in the i/o-space,
; and in c64 mode that address has a rom at that location, do we get the ram at that address, do we get the rom, do we get what the vicii left on the bus,
; or do we get a static value.
;
; test confirmed on real hardware
;
; colors:
;   black  = was not able to switch on the z80
;   white  = got z80 switched on, but no z80 bios present
;   cyan   = z80 on, z80 bios present in c128 mode, but could not get into c64 mode
;   violet = z80 on, z80 bios present in c128 mode, got to c64 mode, we got the RAM
;   green  = z80 on, z80 bios present in c128 mode, got to c64 mode, we got the ROM
;   yellow = z80 on, z80 bios present in c128 mode, got to c64 mode, we got a static value
;   brown  = z80 on, z80 bios present in c128 mode, got to c64 mode, we got whatever the vicii left on the bus
;   red    = something went very wrong in the test
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

; bank in bank 0 and make everything ram, bank in I/O
	lda #$3e
	sta $ff00

; change the border color to black
	lda #$00
	sta $d020

; set ram at the rom locations we plan to scan in z80 c64 mode
	lda #$55
	sta $a004
	lda #$aa
	sta $a005
	lda #$33
	sta $a006

; set $00 and $01 in preparation for switching to c64 mode, all c64 roms mapped in
	lda #$37
	sta $01
	lda #$2f
	sta $00

; jump to $2000
	jmp $2000

*=$2000
 
!binary "c64modez80-06.bin"
