; This is a c64 mode mmu test to see what happens when p0 and p1 are mapped to the same target page in bank 0, what is read in p0 and p1.
;
; test to be confirmed on real hardware
;

; colors:
;   black  = #$33 in p0, #$33 in p1
;   white  = #$33 in p0, #$55 in p1
;   cyan   = #$33 in p0, #$aa in p1
;   violet = #$55 in p0, #$33 in p1
; drk blue = #$55 in p0, #$55 in p1
;   yellow = #$55 in p0, #$aa in p1
;   brown  = #$aa in p0, #$33 in p1
;   pink   = #$aa in p0, #$55 in p1
;   grey   = #$aa in p0, #$aa in p1
; lte blue = something unexpected in p0 or p1
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
	
; put #$33 in $3020 in bank 0
	lda #$33
	sta $3020

; remap zero page to $3000 in bank 0
	lda #$00
	sta $d508
	lda #$30
	sta $d507

; remap stack page to $3000 in bank 0
	lda #$00
	sta $d50a
	lda #$30
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
	!byte  $09,$80,$25,$80,$c3,$c2,$cD,$38,$30

	stx $d016

	sei
	lda $20
	cmp #$aa
	beq got_p0_aa
	cmp #$55
	beq got_p0_55
	cmp #$33
	beq got_p0_33
     bne wtf

got_p0_aa:
	lda $120
	cmp #$aa
	beq got_p0_aa_p1_aa
	cmp #$55
	beq got_p0_aa_p1_55
	cmp #$33
	beq got_p0_aa_p1_33
	bne wtf

got_p0_55:
	lda $120
	cmp #$aa
	beq got_p0_55_p1_aa
	cmp #$55
	beq got_p0_55_p1_55
	cmp #$33
	beq got_p0_55_p1_33
	bne wtf

got_p0_33:
	lda $120
	cmp #$aa
	beq got_p0_33_p1_aa
	cmp #$55
	beq got_p0_33_p1_55
	cmp #$33
	beq got_p0_33_p1_33

wtf:
	ldx #14

setborder:
	stx $d020
	clc
l0:
	bcc l0

got_p0_aa_p1_aa:
	ldx #12
	bne setborder

got_p0_aa_p1_55:
	ldx #10
	bne setborder

got_p0_aa_p1_33:
	ldx #9
	bne setborder

got_p0_55_p1_aa:
	ldx #7
	bne setborder

got_p0_55_p1_55:
	ldx #6
	bne setborder

got_p0_55_p1_33:
	ldx #4
	bne setborder

got_p0_33_p1_aa:
	ldx #3
	bne setborder

got_p0_33_p1_55
	ldx #1
	bne setborder

got_p0_33_p1_33
	ldx #0
	beq setborder
