; This is a c64 mode mmu test to see what is read in $a080 when c64 basic rom is mapped in and p0 is being mapped to page $a0.
;
; test to be confirmed on real hardware
;
; colors:
;   white  = p0 is read at $a080, meaning the zero page is read instead of rom, p0 translation has priority over rom
;   cyan   = rom is read at $a080, rom has priority over p0 translation
;   black  = something is wrong with same bank backward p0 translation in c128 mode
;   violet = somehow ram underneath the rom was read instead of the rom or the zero page
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

; put #$55 in $80 in bank 0
	lda #$55
	sta $80

; put #$55 in $a080 in bank 0
	lda #$aa
	sta $a080
	
; remap zero page to $3000 in bank 0
	lda #$00
	sta $d508
	lda #$a0
	sta $d507

; read value from $a080 (should be #$55)
	lda $a080
	cmp #$55
	beq testc64mode

; for some reason the read was not #$55
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
	lda $a080
	cmp #$55
	beq we_got_p0
	cmp #$aa
	beq we_got_ram

	ldx #$03

setborder:
	stx $d020
	clc
l0:
	bcc l0

we_got_p0:
	ldx #$01
	bne setborder

we_got_ram:
	ldx #$04
	bne setborder
