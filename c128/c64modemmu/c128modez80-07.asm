; This is a c128 mode test to see if the z80 vicii color memory memory mapping is still accessable when $0000-$1fff is shared memory.
;
; test confirmed on real hardware
;
; colors:
;   black  = was not able to switch on the z80
;   white  = got z80 switched on, but no z80 bios present
;   cyan   = z80 on, z80 bios present in c128 mode, $1000-$13ff memory mapping present in shared memory
;   green  = z80 on, z80 bios present in c128 mode, $1000-$13ff memory mapping NOT present in shared memory
;   blue   = z80 on, z80 bios present in c128 mode, but something very wrong
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

; $0000-$1fff shared memory
	lda #$06
	sta $d506

; bank in bank 0 and bank in I/O
	lda #$3e
	sta $ff00

; make sure bank 1 vicii color memory is mapped in
	lda $01
	ora #$03
	sta $01

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
 
!binary "c128modez80-07.bin"
