; LTK memory mapping tests for C128
; by Roberto Muscedere (rmusced@uwindsor.ca)

; Various tests to see if the LTK is mapped correctly
; A good result has a green border and 0 is written to $d7ff
; A bad result hasa red border and 1 is written to $d7ff

; do not press restore during this test
; ltk is assumed to be at $dfxx

.text	;segment

vary	= $f9
check   = $f7

	* = $1c01 - 2

	.word loadaddr

loadaddr

	.word lastline
	.word 0
	.byte $9e
	.aasc "7181"
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

; initialize screen output

	lda #$30
	sta $400
	sta $401
	sta $402
	sta $403

; Test only RAM, so LTK shouldn't be mapped (this test hiram function)
	jsr newtest

	sei

; Use bottom 8K as shared RAM
	lda #6
	sta $d506
; Bank 0, Low RAM
	lda #2
	sta $d501
; Bank 1, Low RAM
	lda #2+64
	sta $d502
; Bank 0, ALL RAM
	lda #$3f
	sta $d503
; Bank 1, ALL RAM
	lda #$7f
	sta $d504

; LTKINIT, if the system wasn't loaded, this will turn off the ROM
	jsr ltkinit
; LTKOFF, do the ram tests
	jsr ltkoff

.(
; Do basic RAM test
; set all RAM from $2000-$FEFF in bank 0 to "00"
; set all RAM from $2000-$FEFF in bank 1 to "01"

	lda #$20
	sta $fc

	ldx #256-32-1
	ldy #0
fill
	lda #0
	sta $ff03
	sta ($fb),y
	lda #1
	sta $ff04
	sta ($fb),y
	iny
	bne fill

	inc $fc
	dex
	bne fill

; read it back the banks to make sure nothing else is there from $2000-feff

	lda #$20
	sta $fc

	ldx #256-32-1
	ldy #0

comp0
	sta $ff03
	lda ($fb),y
	beq comp1
	jmp fail
comp1
	sta $ff04
	lda ($fb),y
	cmp #1
	beq comp2
	jmp fail
comp2
	iny
	bne comp0
	inc $fc
	dex
	bne comp0
.)

; LTKOFF, vary MMU and read $e000-$ffff to make sure it is RAM when
;  RAM is mapped
	jsr checker

; LTKOFF, vary MMU and make sure mapped kernal is not only $00s or $FFs
	jsr checkeo

.(
; Backup ROM from $8000-bfff to $4000-7fff in bank 0
; Backup ROM from $8000-bfff to $4000-7fff in bank 1

	ldy #0
	ldx #$40
	lda #$80
	sta $fc
	lda #$40
	sta $fe

copy0
	lda ($fb),y
; switch to bank 0
	sta $ff01
	sta ($fd),y
; switch to bank 1
	sta $ff02
	sta ($fd),y
	iny
	bne copy0
	inc $fc
	inc $fe
	dex
	bne copy0
.)

; LTKON, vary MMU and read $a000-bfff to make sure it is always BASIC when
;  mapped to ROM
	jsr ltkon
	jsr checkak

; LTKON, vary MMU and read $a000-bfff to make sure it is always RAM when
;  mapped to RAM
	jsr checkar

; LTKON, vary MMU and read $c000-$cfff to make sure it is always RAM when
;  mapped to RAM
	jsr checkcr

; LTKOFF, vary MMU and read $8000-$9fff to make sure it is always RAM when
;  mapped to RAM
	jsr ltkoff
	jsr check8r

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
; switch to bank 0
	sta $ff01
	sta ($fd),y
; switch to bank 1
	sta $ff02
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
; switch to bank 0
	sta $ff01
	sta ($fd),y
; switch to bank 1
	sta $ff02
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

; LTKON, vary MMU and read $8000-$9fff to make sure it is always $FF
	jsr check8

; LTKOFF, vary MMU and read $8000-$9fff to make sure it is always RAM
;  make sure there was no bleeding writes to RAM before
        jsr ltkoff
	jsr check8r

; LTKOFF, vary MMU and read $8000-$9fff to make sure it is isn't anything
;  we wrote to (RAM, LTKRAM)
	jsr check8o

; LTKON, vary MMU and read $e000-$ffff to make sure it is always $FF when
;  ROM is mapped
	jsr ltkon
	jsr checkek

; LTKON, vary MMU and read $e000-$ffff to make sure it is always RAM when
;  RAM is mapped
	jsr checker

; LTKOFF, vary MMU and read $e000-$ffff to make sure it is always $FF when
;  ROM is mapped
        jsr ltkoff
	jsr checkek

; LTKOFF, vary MMU and read $e000-$ffff to make sure it is always RAM when
;  RAM is mapped
	jsr checker

; Disable LTK
	jsr ltkdis

; LTKDIS, vary MMU and read $8000-$9fff is make sure it is RAM when
;  RAM is mapped
	jsr check8r

; LTKDIS, vary MMU and read $8000-$9fff to make sure it is isn't anything
;  we wrote to (RAM, LTKRAM)
	jsr check8o

; LTKDIS, vary MMU and read $e000-$ffff is make sure it is RAM when
;  RAM is mapped
	jsr checker

; LTKDIS, vary MMU and make sure mapped kernal is not $00s or $FF
	jsr checkeo

; One more time to make sure it still works after being disabled

; LTKON, vary MMU and read $8000-$9fff to make sure it is always $FF
	jsr ltkon
	jsr check8

; LTKOFF, vary MMU and read $8000-$9fff to make sure it is always zero
;  make sure there was no bleeding writes
        jsr ltkoff
	jsr check8r

; LTKOFF, vary MMU and read $8000-$9fff to make sure it is isn't anything
;  we wrote to (RAM, LTKRAM)
	jsr check8o

; LTKON, vary MMU and read $e000-$ffff to make sure it is always $FF when
;  ROM is mapped
	jsr ltkon
	jsr checkek

; LTKON, vary MMU and read $e000-$ffff to make sure it is always $00 when
;  RAM is mapped
	jsr checker

; LTKOFF, vary MMU and read $e000-$ffff to make sure it is always $FF when
;  ROM is mapped
        jsr ltkoff
	jsr checkek

; LTKOFF, vary MMU and read $e000-$ffff to make sure it is always zero when
;  RAM is mapped
	jsr checker

; Disable LTK
	jsr ltkdis

; All done!
	jmp good

;

check8
.(
	lda #$7f
	sta vary
again
	lda vary
	sta $ff00
	lda #$ff
	ldy #$80
	ldx #$20
	jsr checkg
skip
	dec vary
	bpl again
.)
	rts

check8r
.(
	lda #$7f
	sta vary
again
	lda vary
	tax
	and #$0c
	cmp #$0c
	bne skip
	stx $ff00
	ldy #$80
	ldx #$20
	jsr checkgr
skip
	dec vary
	bpl again
.)
	rts

; check $8000-$9fff to make sure it isn't anything we wrote to
check8o
.(
	lda #$7f
	sta vary

again
	lda vary
	tax
	and #$0c
	cmp #$0c
	beq skip
	stx $ff00
	ldy #$80
	ldx #$20
	jsr checko
skip
	dec vary
	bpl again
	rts
.)

checkcr
.(
	lda #$7f
	sta vary
again
	lda vary
	tax
	and #$30
	cmp #$30
	bne skip
	stx $ff00
	ldy #$c0
	ldx #$10
	jsr checkgr
skip
	dec vary
	bpl again
.)
	rts

checkar
.(
	lda #$7f
	sta vary
again
	lda vary
	tax
	and #$0c
	cmp #$0c
	bne skip
	stx $ff00
	ldy #$a0
	ldx #$20
	jsr checkgr
skip
	dec vary
	bpl again
.)
	rts

checkak
.(
	lda #$7f
	sta vary
again
	lda vary
	tax
	and #$0e
	cmp #$02
	bne skip
	stx $ff00
loop0
	jsr newtest
	ldy #0
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
skip
	dec vary
	bpl again
.)
	rts

checkeo
.(
	lda #$7f
	sta vary

again
	lda vary
	tax
	and #$30
	bne skip
	stx $ff00
	ldy #$e0
	ldx #$1f
	jsr checko
skip
	dec vary
	bpl again
	rts
.)

checko
.(
	sty $fc
	stx length+1
	jsr newtest
	ldy #0
	sty check
	sty check+1
length
	ldx #$00
loop0
	lda ($fb),y
	cmp #$00
	beq loop2
	cmp #$ff
	bne loop3
; keep track if we found 00's or ff's
loop2
	lda #1
	sta check
	bne loop5
loop4
	sta check+1
loop5
	iny
	bne loop0
	inc $fc
	dex
	bne loop0

; if we found both, the sum of the two flags should be zero
	clc
	lda check
	adc check+1
	bne loop3

	jmp fail
loop3
	rts
.)

checkek
.(
	lda #$7f
	sta vary
again
	lda vary
	tax
	and #$30
	bne skip
	stx $ff00
	lda #$ff
	ldy #$e0
	ldx #$1f
	jsr checkg
skip
	dec vary
	bpl again
	rts
.)

checker
.(
	lda #$7f
	sta vary
again
	lda vary
	tax
	and #$30
	cmp #$30
	bne skip
	stx $ff00
	ldy #$e0
	ldx #$1f
	jsr checkgr
skip
	dec vary
	bpl again
	rts
.)

checkgr
	lda #0
	bit vary
	bvc checkg
	lda #1	
checkg
.(
	sta comp+1
	sty $fc
	stx length+1

	jsr newtest
	ldy #0
length
	ldx #$0
loop
	lda ($fb),y
comp
	cmp #$00
	beq okay
	jmp fail
okay
	iny
	bne loop
	inc $fc
	dex
	bne loop
.)
	rts

ltkinit
	lda $ff00
	pha
	and #254
	sta $ff00
	lda #$30
	sta $df03
	lda #$70
	sta $df02
	bne ltkon0

ltkon
	lda $ff00
	pha
	and #254
	sta $ff00
ltkon0
	lda #$34
	sta $df03
	lda #$40
	sta $df02
	pla
	sta $ff00
	rts

ltkoff
	lda $ff00
	pha
	and #254
	sta $ff00
	lda #$34
	sta $df03
	lda #$00
	sta $df02
	pla
	sta $ff00
	rts

ltkdis
	lda $ff00
	pha
	and #254
	sta $ff00
	lda #$3c
	sta $df03
	lda #$40
	sta $df02
	lda #$ff
	sta $df04
	pla
	sta $ff00
	rts

newtest
	ldx #3
newtest0
	lda $400,x
	clc
	adc #1
	cmp #$3a
	bne newtest1
	lda #$30
	sta $400,x
	dex
	bpl newtest0
newtest1
	sta $400,x
	rts
	
good
	ldx #5
	lda #0
	beq fail1

fail
	ldx #2
	lda #1
fail1
	ldy #$00
	sty $ff00
	stx $d020
	sta $d7ff

	jmp *

