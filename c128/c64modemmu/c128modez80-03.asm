; This is a c128 mode test to see if the z80 can access the vicii color memory at both $d800 through in/out AND $1000 through memory access.
;
; test to be confirmed on real hardware
;
; colors:
;   black  = was not able to switch on the z80
;   white  = got z80 switched on, but no z80 bios present
;   cyan   = z80 on, z80 bios present in c128 mode, vicii color memory not accessable at all
;   violet = z80 on, z80 bios present in c128 mode, only $1000-$13ff can be used to access the vicii color memory using memory access
;   blue   = z80 on, z80 bios present in c128 mode, only $d800-$dbff can be used to access the vicii color memory using in/out
;   yellow = z80 on, z80 bios present in c128 mode, $1000-$13ff can be used through in/out AND $d800-$dbff can be used through
;                                                   memory access to access the vicii color memory
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
	lda #$00
	sta $ff00

; fill vicii color memory with data
	ldx #$00
fill_loop:
	txa
	sta $d800,x
	sta $d900,x
	sta $da00,x
	sta $db00,x
	inx
	bne fill_loop

; change the border color to black
	lda #$00
	sta $d020

; jump to $2000
	jmp $2000

*=$2000
 
!binary "c128modez80-03.bin"
