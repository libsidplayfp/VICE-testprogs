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
	sei

	ldx #$3e
	stx $ff00

	jmp $5000

*=$5000
 
!binary "audio-io-c128-z80.bin"
