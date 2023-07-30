; LTK memory mapping tests for C64
; by Roberto Muscedere (rmusced@uwindsor.ca)

; Various tests to see if the LTK is mapped correctly
; A good result has a green border and 0 is written to $d7ff
; A bad result hasa red border and the test number is written to $d7ff

; do not press restore during this test
; ltk is assumed to be at $dfxx

.text	;segment

testnum	= $ff
vary1	= $f9

	* = $801 - 2

	.word loadaddr

loadaddr

	.word lastline
	.word 0
	.byte $9e
	.aasc "2061"
	.byte 0
lastline
	.word 0

start
; clear screen
	lda #147
	jsr $ffd2
	lda #$0
	sta $fb
	sta $fd

; initialize test number and screen output
	lda #0
	sta testnum

	lda #$30
	sta $400
	sta $401
	sta $402

; Test only RAM, so LTK shouldn't be mapped (this test hiram function)
	jsr newtest

	sei

; LTKINIT, if the system wasn't loaded, this will turn off the ROM
	jsr ltkinit
; LTKOFF, do the ram tests
	jsr ltkoff

; switch to RAM only
	lda #$34
	sta 1

.(

; clear all RAM from $1000-$FFFF
	lda #$10
	sta $fc

	ldx #256-16
	ldy #0
	lda #0

fill
	sta ($fb),y
	iny
	bne fill

	inc $fc
	dex
	bne fill

; read it back to make sure nothing is there from $1000-dfff

	lda #$10
	sta $fc

	ldx #$100-$10-$20
	ldy #0

comp0
	lda ($fb),y
	beq comp1
	jmp fail
comp1
	iny
	bne comp0
	inc $fc
	dex
	bne comp0

.)

; LTKOFF, vary $1 and read $e000-$ffff to make sure it is always $00 when
;  RAM is mapped
	jsr checker

; LTKOFF, vary $1 and make sure mapped kernal is not $00s or $FF
	jsr checkeo

.(
; Backup BASIC ROM from $a000-bfff to $6000-7fff

	lda #$37
	sta 1

	ldy #0
	ldx #$20
	lda #$a0
	sta $fc
	lda #$60
	sta $fe

copy0
	lda ($fb),y
	sta ($fd),y
	iny
	bne copy0
	inc $fc
	inc $fe
	dex
	bne copy0
.)

; LTKON, vary $1 and read $a000-bfff to make sure it is always BASIC when
;  mapped to ROM
	jsr ltkon
	jsr checkak

; LTKON, vary $1 and read $a000-bfff to make sure it is always zero when
;  mapped to RAM
	jsr checkar

; LTKON, vary $1 and read $c000-$cfff to make sure it is always zero
	lda #0
	jsr checkc

; LTKOFF, vary $1 and read $8000-$9fff to make sure it is always zero
	jsr ltkoff
	lda #0
	jsr check8

.(
; LTKON, Fill $8000-$9fff with $ff
	jsr ltkon

; backup LTKDOS to $6000 and set to $FF

	ldy #0
	ldx #$20
	lda #$80
	sta $fc
	lda #$60
	sta $fe

copy0
	lda ($fb),y
	sta ($fd),y
	lda #$ff
	sta ($fb),y
	iny
	bne copy0
	inc $fc
	inc $fe
	dex
	bne copy0
.)

.(
; LTKON, Fill $e000-$ffff with $ff

; backup LTKKERN to $4000 and set to $FF

	ldy #0
	ldx #$20
	lda #$e0
	sta $fc
	lda #$40
	sta $fe

copy0
	lda ($fb),y
	sta ($fd),y
	lda #$ff
	sta ($fb),y
	iny
	bne copy0
	inc $fc
	inc $fe
	dex
	bne copy0
.)

; LTKON, vary $1 and read $8000-$9fff to make sure it is always $FF
	lda #$ff
	jsr check8

; LTKOFF, vary $1 and read $8000-$9fff to make sure it is always zero
;  make sure there was no bleeding writes to RAM
        jsr ltkoff
	lda #$00
	jsr check8

; LTKON, vary $1 and read $e000-$ffff to make sure it is always $FF when
;  ROM is mapped
	jsr ltkon
	jsr checkek

; LTKON, vary $1 and read $e000-$ffff to make sure it is always $00 when
;  RAM is mapped
	jsr checker

; LTKOFF, vary $1 and read $e000-$ffff to make sure it is always $FF when
;  ROM is mapped
        jsr ltkoff
	jsr checkek

; LTKOFF, vary $1 and read $e000-$ffff to make sure it is always zero when
;  RAM is mapped
	jsr checker

; Disable LTK
	jsr ltkdis

; LTKDIS, vary $1 and read $8000-$9fff is make sure it is zero
	lda #$00
	jsr check8

; LTKDIS, vary $1 and read $e000-$ffff is make sure it is zero when RAM
;  is mapped
	jsr checker

; LTKDIS, vary $1 and make sure mapped kernal is not $00s or $FF
	jsr checkeo

; One more time to make sure it still works after being disabled

; LTKON, vary $1 and read $8000-$9fff to make sure it is always $FF
	jsr ltkon
	lda #$ff
	jsr check8

; LTKOFF, vary $1 and read $8000-$9fff to make sure it is always zero
;  make sure there was no bleeding writes
        jsr ltkoff
	lda #$00
	jsr check8

; LTKON, vary $1 and read $e000-$ffff to make sure it is always $FF when
;  ROM is mapped
	jsr ltkon
	jsr checkek

; LTKON, vary $1 and read $e000-$ffff to make sure it is always $00 when
;  RAM is mapped
	jsr checker

; LTKOFF, vary $1 and read $e000-$ffff to make sure it is always $FF when
;  ROM is mapped
        jsr ltkoff
	jsr checkek

; LTKOFF, vary $1 and read $e000-$ffff to make sure it is always zero when
;  RAM is mapped
	jsr checker

; Disable LTK
	jsr ltkdis

; All done!
	jmp good

;

check8
.(
	sta loop4+1

	lda #$30
	sta vary1

loop0
	jsr newtest
	ldy #0
	lda vary1
	sta $1
	ldx #$20

	lda #$80
	sta $fc

loop1
	lda ($fb),y
loop4
	cmp #$00
	beq loop2
	jmp fail
loop2
	iny
	bne loop1
	inc $fc
	dex
	bne loop1

	inc vary1
	lda vary1
	cmp #$38
	bne loop0

.)
	rts

checkc
.(
	sta loop4+1

	lda #$30
	sta vary1

loop0
	jsr newtest
	ldy #0
	lda vary1
	sta $1
	ldx #$10

	lda #$c0
	sta $fc

loop1
	lda ($fb),y
loop4
	cmp #$00
	beq loop2
	jmp fail
loop2
	iny
	bne loop1
	inc $fc
	dex
	bne loop1

	inc vary1
	lda vary1
	cmp #$38
	bne loop0

.)
	rts

checkar
.(
	lda #$30
	sta vary1

loop0
	jsr newtest
	ldy #0
	lda vary1
	sta $1
	ldx #$20

	lda #$a0
	sta $fc

loop1
	lda ($fb),y
	beq loop2
	jmp fail
loop2
	iny
	bne loop1
	inc $fc
	dex
	bne loop1

loop3
	inc vary1
	lda vary1
	cmp #$33
	beq loop3
	cmp #$37
	bne loop0

.)
	rts

checkak
.(
	lda #$33
	sta vary1

loop0
	jsr newtest
	ldy #0
	lda vary1
	sta $1
	ldx #$20

	lda #$a0
	sta $fc
	lda #$60
	sta $fe

loop1
	lda ($fb),y
	cmp ($fd),y
	beq loop2
	jmp fail
loop2
	iny
	bne loop1
	inc $fc
	inc $fe
	dex
	bne loop1

	lda vary1
	adc #4
	sta vary1
	lda vary1
	cmp #$38
	bcc loop0

.)
	rts

checkeo
	lda #$32
	sta 1
	jsr checkeot

	inc 1
	jsr checkeot

	lda #$36
	sta 1
	jsr checkeot

	inc 1

;	jmp checkeot

checkeot
.(
	jsr newtest
	ldy #0
	sty vary1
	sty vary1+1
	ldx #$20
	lda #$e0
	sta $fc
loop0
	lda ($fb),y
	cmp #$00
	beq loop2
	cmp #$ff
	bne loop3
; keep track if we found 00's or ff's
loop2
	lda #1
	sta vary1
	bne loop5
loop4
	sta vary1+1
loop5
	iny
	bne loop0
	inc $fc
	dex
	bne loop0

; if we found both, the sum of the two flags should be zero
	clc
	lda vary1
	adc vary1+1
	bne loop3

	jmp fail
loop3
	rts
.)

checkek
	lda #$ff
	sta checket1+1

	lda #$32
	sta 1
	jsr checket

	inc 1
	jsr checket

	lda #$36
	sta 1
	jsr checket

	inc 1
	jmp checket

checker
	lda #$00
	sta checket1+1

	lda #$30
	sta 1
	jsr checket

	inc 1
	jsr checket

	lda #$34
	sta 1
	jsr checket

	inc 1
;	jmp checket

checket
	jsr newtest
	ldy #0
	ldx #$20
	lda #$e0
	sta $fc
checket0
	lda ($fb),y
checket1
	cmp #$00
	beq checket2
	jmp fail
checket2
	iny
	bne checket0
	inc $fc
	dex
	bne checket0
	rts

ltkinit
	lda #$30
	sta $df03
	lda #$70
	sta $df02

ltkon
	lda #$37
	sta 1
	lda #$34
	sta $df03
	lda #$40
	sta $df02
	rts

ltkoff
	lda #$37
	sta 1
	lda #$34
	sta $df03
	lda #$00
	sta $df02
	rts

ltkdis
	lda #$37
	sta 1
	lda #$3c
	sta $df03
	lda #$40
	sta $df02
	lda #$ff
	sta $df04
	rts

newtest
	inc testnum
	ldy $401
	ldx $402
	inx
	cpx #$3a
	bne newtest1
	ldx #$30
	iny
	cpy #$3a
	bne newtest2
	ldy #$30
	inc $400
newtest2
	sty $401
newtest1
	stx $402
	rts

good
	ldx #5
	lda #0
	beq fail1

fail
	ldx #2
	lda testnum
fail1
	ldy #$37
	sty $1
	stx $d020
	sta $d7ff

	jmp *

