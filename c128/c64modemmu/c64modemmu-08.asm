; This is a c64 mode mmu test to see what is at the target page in bank 0 when p0 is mapped to the target page in bank 1.
;
; test confirmed on real hardware
;
; colors:
;   black  = something went wrong with p0 translation in c128 mode
;   white  = something went wrong with p0 translation in c64 mode
;   green  = we got #$aa from target page
;   violet = we got #$55 from target page
;   blue   = we got #$33 from target page
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
	
; bank in bank 1 and make everything ram
	lda #$7e
	sta $ff00

; put #$33 in $3080 in bank 1
	lda #$33
	sta $3080

; bank in bank 0 and make everything ram
	lda #$3e
	sta $ff00

; no shared memory
	lda #$00
	sta $d506

; remap zero page to $3000 in bank 1
	lda #$01
	sta $d508
	lda #$30
	sta $d507

; read value from $3080 (should be #$aa)
	lda $3080
	cmp #$aa
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
	!byte  $09,$80,$09,$80,$c3,$c2,$cD,$38,$30

	stx $d016

	sei
	ldy #$ff
	lda $3080
	cmp #$aa
	beq got_aa_3080_bank_0
	cmp #$55
	beq got_55_3080_bank_0
	cmp #$33
	beq got_33_3080_bank_0

	ldx #$01

setborder:
	stx $d020
	sty $d7ff
	clc
l0:
	bcc l0

got_aa_3080_bank_0:
	ldy #0
	ldx #5
	bne setborder

got_55_3080_bank_0:
	ldx #4
	bne setborder


got_33_3080_bank_0:
	ldx #6
	bne setborder
