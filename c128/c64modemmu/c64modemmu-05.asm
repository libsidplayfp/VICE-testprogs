; This is a c64 mode mmu test to see which bank the zp comes from in c64 mode when bank 0 and bank 1 zp are swapped and bank 0 is the main bank
;
; test to be confirmed on real hardware
;
; colors:
;   black  = something is wrong with p0 translation in c128 mode
;   cyan   = bank 1 zp is mapped in in c64 mode
;   violet = bank 0 zp is mapped in in c64 mode
;   white  = something is very wrong in c64 mode
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

; no shared memory
	lda #$00
	sta $d506

; store #$aa in $80 in bank 0
	lda #$aa
	sta $80

; swap bank 0 and bank 1 zp
	lda #$01
	sta $d508
	lda #$00
	sta $d507

; store #$55 in $80 in bank 1
	lda #$55
	sta $80

; bank in bank 0 and make everything ram
	lda #$3e
	sta $ff00

; read value from $80 (should be #$55)
	lda $80
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
	!byte  $09,$80,$09,$80,$c3,$c2,$cD,$38,$30

	sei

; read from $80, which is mapped to $80 in bank 1, which means we should get back #$55
	lda $80
	cmp #$55
	beq bank1

; is it bank 0 $80 ?
	cmp #$aa
	beq bank0

; something else is wrong
	lda #$01
	sta $d020
	lda #$ff
	sta $d7ff
	jmp *

; we got bank 1 $3080 value
bank1:
	lda #$03
	sta $d020
	lda #$00
	sta $d7ff
	jmp *

; we got bank 0 $3080 value
bank0:
	lda #$04
	sta $d020
	lda #$00
	sta $d7ff
	jmp *
