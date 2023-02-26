; This is a c64 mode test to see which vicii color map the z80 can access in c64 mode when the current vicii color map bank has been set to bank 0 in c128 mode.
;
; test confirmed on real hardware
;
; colors:
;   black  = was not able to switch on the z80
;   white  = got z80 switched on, but no z80 bios present
;   cyan   = z80 on, z80 bios present in c128 mode, but could not get into c64 mode
;   violet = z80 on, z80 bios present in c128 mode, got to c64 mode, no access to vicii color map at all
;   blue   = z80 on, z80 bios present in c128 mode, got to c64 mode, access to vicii color map bank 0
;   green  = z80 on, z80 bios present in c128 mode, got to c64 mode, access to vicii color map bank 1
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

; make sure vicii color memory bank 1 is mapped in
	lda $01
	ora #$03
	sta $01

; fill vicii color memory with '5'
	lda #$05
	jsr fillit

; make sure vicii color memory bank 0 is mapped in
	lda $01
	and #$fc
	sta $01

; fill vicii color memory with 'a'
	lda #$0a
	jsr fillit

; set $00 and $01 in preparation for switching to c64 mode, and make sure vicii color memory bank 0 is the current one
	lda #$36
	sta $01
	lda #$2f
	sta $00

; jump to $2000
	jmp $2000


; fill in vicii color memory with a value
fillit:
	ldx #$00
fill_loop:
	sta $d800,x
	sta $d900,x
	sta $da00,x
	sta $db00,x
	inx
	bne fill_loop
	rts

*=$2000
 
!binary "c64modez80-04.bin"
