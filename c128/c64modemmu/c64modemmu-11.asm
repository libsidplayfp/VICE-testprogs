; This is a c64 mode mmu test to see what happens when p0 is mapped to p1 and p1 is mapped to itself, what is in p0 and p1.
;
; test confirmed on real hardware
;
; colors:
;   black  = #$55 in p0, #$55 in p1
;   white  = #$55 in p0, #$aa in p1
;   green  = #$aa in p0, #$55 in p1
;   blue   = #$aa in p0, #$aa in p1
;   yellow = something unexpected happened
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

; bank in bank 0 and make everything ram
	lda #$3e
	sta $ff00

; put #$aa in $20 in bank 0
	lda #$aa
	sta $20

; put #$55 in $120 in bank 0
	lda #$55
	sta $120
	
; remap zero page to the stack page in bank 0
	lda #$00
	sta $d508
	lda #$01
	sta $d507

; make sure the stack page maps to itself in bank 0
	lda #$00
	sta $d50a
	lda #$01
	sta $d509

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
	lda $20
	cmp #$aa
	beq got_aa
	cmp #$55
	beq got_55

wtf:
	ldx #7

setborder:
	stx $d020
	sty $d7ff
	clc
l0:
	bcc l0

got_aa:
	lda $120
	cmp #$aa
	beq got_aa_aa
	cmp #$55
	beq got_aa_55
	bne wtf

got_55:
	lda $120
	cmp #$aa
	beq got_55_aa
	cmp #$55
	beq got_55_55
	bne wtf

got_55_55:
	ldx #0
	beq setborder

got_55_aa:
	ldx #1
	bne setborder

got_aa_55:
	ldy #0
	ldx #5
	bne setborder

got_aa_aa:
	ldx #6
	bne setborder
