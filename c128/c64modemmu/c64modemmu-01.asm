; This is a c64 mode mmu test to see if shared memory is used in c64 mode.
;
; test confirmed on real hardware
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
	sei

; make $0000-$1fff  shared memory
	lda #$06
	sta $d506

	; bank in bank 0 and make everything ram
	lda #$3e
	sta $ff00

; copy test into bank 0 at $8000
	ldx #$00
loop0:
	lda test,x
	sta $8000,x
	inx
	bne loop0

; copy 'ok' test byte into bank 0 at $3000
     lda #$05
	sta $3000

; copy 'ok' debug byte into bank 0 at $3001
     lda #$00
	sta $3001

; copy c64switch code to bank 0 at $4000
	ldx #$00
loops0:
	lda c64switch,x
	sta $4000,x
	inx
	bne loops0

; bank in bank 1 and make everything ram
	lda #$7e
	sta $ff00

; copy test into bank 1 at $8000
	ldx #$00
loop1:
	lda test,x
	sta $8000,x
	inx
	bne loop1

; copy 'fail' test byte into bank 1 at $3000
     lda #$02
	sta $3000

; copy 'fail' debug byte into bank 1 at $3001
     lda #$00
	sta $3001

; copy c64switch code to bank 1 at $4000
	ldx #$00
loops1:
	lda c64switch,x
	sta $4000,x
	inx
	bne loops1

; make $0000-$3fff  shared memory
	lda #$07
	sta $d506

; set $00 and $01 in preparation for switching to c64 mode
	lda #$37
	sta $01
	lda #$2f
	sta $00

; jump to $4000
	jmp $4000

; switch on c64 mode, located at $4000 in both banks
c64switch:
	lda #$f7
	sta $d505

; jump to reset vector to start c64 rom

	jmp ($fffc)

; test in bank 0 and bank 1
test:
	!byte  $09,$80,$25,$80,$c3,$c2,$cD,$38,$30

	stx $d016
	jsr $fda3
	jsr $fd50
	jsr $fd15
	jsr $ff5b
	cli
	jsr $e453
	jsr $e3bf
	jsr $e422
	ldx #$fb
	txs
	lda $3000
	sta $d020
	lda $3001
	sta $d7ff
	jmp *
