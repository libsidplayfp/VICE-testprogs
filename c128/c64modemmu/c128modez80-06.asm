; This is a c128 mode test to see if the z80 vicii color memory memory mapping is present when ram bank 1 is mapped in
;
; test to be confirmed on real hardware
;
; colors:
;   black  = was not able to switch on the z80
;   white  = got z80 switched on, but no z80 bios present
;   cyan   = z80 on, z80 bios present in c128 mode, $1000-$13ff memory mapping present in bank 1
;   violet = z80 on, z80 bios present in c128 mode, $1000-$13ff memory mapping NOT present in bank 1
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

; copy z80 code from bank 0 into bank 1
	ldx #$00
z80copyloop:
	jsr setbank0
	lda $2000,x
	jsr setbank1
	sta $2000,x
	jsr setbank0
	lda $2100,x
	jsr setbank1
	sta $2100,x
	jsr setbank0
	lda $2200,x
	jsr setbank1
	sta $2200,x
	jsr setbank0
	lda $2300,x
	jsr setbank1
	sta $2300,x
	jsr setbank0
	lda $2400,x
	jsr setbank1
	sta $2400,x
	jsr setbank0
	lda $2500,x
	jsr setbank1
	sta $2500,x
	jsr setbank0
	lda $2600,x
	jsr setbank1
	sta $2600,x
	jsr setbank0
	lda $2700,x
	jsr setbank1
	sta $2700,x
	inx
	bne z80copyloop
	jsr setbank0

; no shared memory
	lda #$00
	sta $d506

; change the border color to black
	lda #$00
	sta $d020

; jump to $2000 in bank 0
	jmp $2000

; set bank 0
setbank0:
	ldy #$3e
	sty $ff00
	rts

; set bank 1
setbank1:
	ldy #$7e
	sty $ff00
	rts

*=$2000
 
!binary "c128modez80-06.bin"
