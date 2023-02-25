; This is a c64 mode test to see if the z80 can change I/O registers using both in/out AND memory access, when the I/O is mapped in.
;
; test confirmed on real hardware
;
; colors:
;   black  = was not able to switch on the z80
;   white  = got z80 switched on, but no z80 bios present
;   cyan   = z80 on, z80 bios present in c128 mode, but could not get into c64 mode
;   violet = z80 on, z80 bios present in c128 mode, got to c64 mode, able to change I/O regs through in/out only
;   green  = z80 on, z80 bios present in c128 mode, got to c64 mode, able to change I/O regs through both in/out AND memory access
;   blue   = z80 on, z80 bios present in c128 mode, got to c64 mode, not able to change I/O regs at all
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

; bank in bank 0 and make everything ram, and bank I/O in
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
 
!binary "c64modez80-01.bin"
