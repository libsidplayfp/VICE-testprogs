; This is a c64 mode test to see if the z80 can be used in c64 mode.
;
; test confirmed on real hardware
;
; colors:
;   black  = was not able to switch on the z80
;   white  = got z80 switched on, but no z80 bios present
;   cyan   = z80 on, z80 bios present in c128 mode, but could not get into c64 mode
;   violet = z80 on, z80 bios present in c128 mode, got to c64 mode, but did not have access to c64 mode basic rom, and no z80 bios present either
;   green  = z80 on, z80 bios present in c128 mode, got to c64 mode, basic rom present, no z80 bios
;   yellow = z80 on, z80 bios present in c128 mode, got to c64 mode, basic rom not present, z80 bios is present
;   pink   = z80 on, z80 bios present in c128 mode, got to c64 mode, basic rom and z80 bios present
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

; bank in bank 0 and make everything ram, also bank out I/O
	lda #$3f
	sta $ff00

	lda #$00

; zero out the ram locations 'behind' where the z80 bios will be scanned
	sta $048d
	sta $048e
	sta $048f

; zero out the ram locations 'behind' where the c64 mode basic will be scanned
	sta $a004
	sta $a005
	sta $a006

; zero out the ram location 'behind' where the mmu bank version register is
	sta $d50b

; bank in bank 0 and make everything ram, and bank I/O back in
	lda #$3e
	sta $ff00

; change the border color to black
	lda #$00
	sta $d020

; set $00 and $01 in preparation for switching to c64 mode
	lda #$37
	sta $01
	lda #$2f
	sta $00

; jump to $2000
	jmp $2000

*=$2000
 
!binary "z80-00.bin"
