; This is a c64 mode mmu test to see if same bank p0 backward translation is used in c64 mode.
;
; test to be confirmed on real hardware
;
; colors:
;   white = same bank backward p0 translation used in c64 mode
;   cyan  = same bank backward p0 translation not used in c64 mode
;   black = something is wrong with same bank forward p0 translation in c128 mode
;   violet = something is wrong with backward p0 translation in c64 mode
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

; make $0000-$1fff  shared memory
	lda #$06
	sta $d506

; bank in bank 0 and make everything ram
	lda #$3e
	sta $ff00

; put #$55 in $80 in bank 0
	lda #$55
	sta $80

; put #$aa in $3080 in bank 0
	lda #$aa
	sta $3080
	
; remap zero page to $3000 in bank 0
	lda #$00
	sta $d508
	lda #$30
	sta $d507

; read value from $3080 (should be #$55)
	lda $3080
	cmp #$55
	beq testc64mode

; for some reason the read was not #$aa
	lda #$00
	sta $d020
	lda #$ff
	sta $d7ff
	jmp *

testc64mode:

; copy test into bank 0 at $8000
	ldx #$00
loop0:
	lda test,x
	sta $8000,x
	inx
	bne loop0

; copy c64switch code to bank 0 at $4000
	ldx #$00
loops0:
	lda c64switch,x
	sta $4000,x
	inx
	bne loops0

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

; test in bank 0
test:
	!byte  $09,$80,$25,$80,$c3,$c2,$cD,$38,$30

	stx $d016

	sei
	lda $3080
	cmp #$55
	beq p0backwardmapping
	cmp #$aa
	beq nop0backwardmapping

	lda #$04
	sta $d020
	lda #$00
	sta $d7ff
	clc
l0:
	bcc l0

p0backwardmapping:
	lda #$01
	sta $d020
	lda #$ff
	sta $d7ff
	clc
	bcc l0

nop0backwardmapping:
	lda #$03
	sta $d020
	lda #$ff
	sta $d7ff
	clc
	bcc l0
