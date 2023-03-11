; This is a c128 mode z80 test to see what happens when we use the z80 memory access to change the ram in $0100 when z80 bios is mapped in.
;
; test confirmed on real hardware
;
; colors:
;   black  = was not able to switch on the z80
;   white  = got z80 switched on, but no z80 bios present
;   cyan   = z80 on, z80 bios present in c128 mode, when using z80 it changed NOTHING
;   violet = z80 on, z80 bios present in c128 mode, when using z80 it changed RAM at $0100 ONLY
;   green  = z80 on, z80 bios present in c128 mode, when using z80 it changed RAM at $d100 ONLY
;   yellow = z80 on, z80 bios present in c128 mode, when using z80 it changed RAM at $0100 AND $d100
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

; bank in bank 0 and bank in I/O
	lda #$3e
	sta $ff00

; no shared memory
	lda #$00
	sta $d506

; bank in bank 0 and bank out I/O
	lda #$3f
	sta $ff00

; put #$55 in $d100 ram in bank 0
	lda #$55
	sta $d100

; put #$aa in $0100 ram in bank 0
	lda #$aa
	sta $0100

; bank in bank 0 and bank in I/O
	lda #$3e
	sta $ff00

; change the border color to black
	lda #$00
	sta $d020

; jsr to $2000 in bank 0 to switch to z80
	jsr $2000

; come back from z80
	sei

; reset data 'flag' (register Y)
	ldy #$00

; bank in bank 0 and bank out I/O
	lda #$3f
	sta $ff00

; check if we have #$33 in the $0100 ram
	lda $0100
	cmp #$33
	bne check_d100

; $0100 changed, set 'flag' to 2
	ldy #$02

; check if we have #$33 in the $d100 ram
check_d100:
	lda $d100
	cmp #$33
	bne final_results

; $d100 changed, increment 'flag'
	iny

final_results:
	tya
	cmp #$03
	beq changed_0100_and_d100
	cmp #$02
	beq changed_0100
	cmp #$01
	beq changed_d100

; no changes at all
	ldx #$03
	ldy #$ff
	bne set_border

changed_0100:
	ldx #$04
	ldy #$ff
	bne set_border

changed_d100:
	ldx #$05
	ldy #$00
	beq set_border

changed_0100_and_d100:
	ldx #$07
	ldy #$ff

set_border:
	lda #$3e
	sta $ff00
	stx $d020
	sty $d7ff
	clc
l0:
	bcc l0

*=$2000
 
!binary "c128modez80-25.bin"
