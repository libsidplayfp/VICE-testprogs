start=$0840

basicHeader=1 

!ifdef basicHeader {
; 10 SYS2061
*=$0801
	!byte  $0c,$08,$0a,$00,$9e,$32,$30,$36,$31,$00,$00,$00
*=$080d 
	jmp start
}
*=start
	sei
	lda #14		; switch text to lower case
	jsr $ffd2

	lda #$35	; only I/O at $d000-$dfff, the rest is ram
	sta $01

	lda #$00	; z80 nop
	sta $1000
	lda #$31	; z80 ld sp,#$fe00
	sta $1001
	lda #$00
	sta $1002
	lda #$fe
	sta $1003
	lda #$c3	; z80 jp $0145
	sta $1004
	lda #$45
	sta $1005
	lda #$01
	sta $1006

; switch to z80, it will start execution at z80 $0000 (6510 $1000)
	lda #$00
	sta $de00
	nop

*=$1100
 
!binary "audio-io-c64-z80.bin"
