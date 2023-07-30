; RAMLink memory mapping tests for C64
; by Roberto Muscedere (rmusced@uwindsor.ca)

; Various tests to see if the RAMLink is mapped correctly
; A good result has a green border and 0 is written to $d7ff
; A bad result hasa red border and the test number is written to $d7ff

; do not press restore during this test

.text	;segment

testnum	= $ff
vary	= $f9
count   = $fa
cksumi  = $02
cksumsl = $04
cksumsh = $24

ikernal = 8
ibasic  = 9
ikernals = 10
ikernalr = 11
iram  = 12
iaxxx0 = 13
iaxxx1 = 14
i8xxx0 = 15
i8xxx1 = 16

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

	jsr rloff

.(
; since $e000-ffff is a kernal, checksum it and save value for comparisons later
	lda #ikernal
	sta cksumi
	lda #$e0
	ldx #$20
	jsr summem
.)

.(
; since $a000-bfff is basic, checksum it and save value for comparisons later
	lda #ibasic
	sta cksumi
	lda #$a0
	ldx #$20
	jsr summem
.)

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

; read it back to make sure nothing is there from $1000-ffff

	lda #$10
	sta $fc

	ldx #$100-$10
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

; RLOFF

.(
; since $e000-ffff is 00s, checksum it and save value for comparisons later
	lda #iram
	sta cksumi
	lda #$e0
	ldx #$20
	jsr summem
.)

.(
; vary $1 and checksum $e000-$ffff
	jsr sume

; make sure all RAM sections are the same
	ldx #0
	ldy #iram
	jsr compsum
	ldy #1
	jsr compsum
	ldy #4
	jsr compsum
	iny
	jsr compsum

; make sure all ROM sections are the same
	ldx #2
	ldy #ikernal
	jsr compsum
	ldy #3
	jsr compsum
	ldy #6
	jsr compsum
	iny
	jsr compsum
.)

.(
; vary $1 and checksum $a000-$bfff
	jsr suma

; make sure all RAM sections are the same
	ldx #0
	ldy #iram
	jsr compsum
	ldy #1
	jsr compsum
	iny
	jsr compsum
	ldy #4
	jsr compsum
	iny
	jsr compsum
	iny
	jsr compsum

; make sure all ROM sections are the same
	ldx #3
	ldy #ibasic
	jsr compsum
	ldy #7
	jsr compsum
.)

.(
; vary $1 and checksum $8000-$9fff
	jsr sum8

; make sure all RAM sections are the same
	ldx #0
	ldy #iram
	jsr compsum
	ldy #7
loop
	jsr compsum
	dey
	bne loop
.)

; RLON
	jsr rlon

.(
; vary $1 and checksum $e000-$ffff
	jsr sume

; make sure all RAM sections are the same
	ldx #0
	ldy #1
	jsr compsum
	ldy #4
	jsr compsum
	iny
	jsr compsum

; make sure it isn't the same as the main kernal
	ldy #ikernal
	jsr ncompsum

; save for later
	ldy #ikernalr
	jsr copysum

; make sure all ROM sections are the same
	ldx #2
	ldy #3
	jsr compsum
	ldy #6
	jsr compsum
	iny
	jsr compsum

; make sure it isn't the same as the main kernal
	ldy #ikernal
	jsr ncompsum

; save for later
	ldy #ikernals
	jsr copysum

; make sure both kernals aren't the same
	ldx #0
	jsr ncompsum

	jsr holetest
.)

.(
; vary $1 and checksum $a000-$bfff
	jsr suma

; make sure all RAM sections are RAM and the same
	ldx #0
	ldy #iram
	jsr compsum
	ldy #1
	jsr compsum
	iny
	jsr compsum
	ldy #4
	jsr compsum
	iny
	jsr compsum
	iny
	jsr compsum

; make sure all ROM sections are the same and BASIC
	ldx #3
	ldy #ibasic
	jsr compsum
	ldy #7
	jsr compsum
.)

.(
; vary $1 and checksum $8000-$9fff
	jsr sum8

; make sure all RAM sections are RAM and the same
	ldx #0
	ldy #iram
	jsr compsum
	ldy #7
loop
	jsr compsum
	dey
	bne loop

.)

; RLON8
	jsr rlon8

.(
; vary $1 and checksum $e000-$ffff
	jsr sume

	ldx #0
; make sure it is the same kernal as before
	ldy #ikernalr
	jsr compsum
; make sure all RAM sections are the same
	ldy #1
	jsr compsum
	ldy #4
	jsr compsum
	iny
	jsr compsum

	ldx #2
; make sure it is the same kernal as before
	ldy #ikernals
	jsr compsum
; make sure all ROM sections are the same
	ldy #3
	jsr compsum
	ldy #6
	jsr compsum
	iny
	jsr compsum

	jsr holetest
.)

.(
; vary $1 and checksum $8000-$9fff
	jsr sum8

	ldx #0
; make sure it is not RAM
	ldy #iram
	jsr ncompsum
; make sure it is the same
	ldy #7
loop
	jsr compsum
	dey
	bne loop

; save for later
	ldy #i8xxx0
	jsr copysum
.)

.(
; vary $1 and checksum $a000-$bfff
	jsr suma

	ldx #0
; make sure it isn't basic
	ldy #ibasic
	jsr ncompsum
; make sure all sections are the same
	ldy #7
loop
	jsr compsum
	dey
	bne loop

; save for later

	ldy #iaxxx0
	jsr copysum
.)

	lda #$37
	sta 1

	inc $df42

.(
; vary $1 and checksum $e000-$ffff
	jsr sume

	ldx #0
; make sure it is the same kernal as before
	ldy #ikernalr
	jsr compsum
; make sure all RAM sections are the same
	ldy #1
	jsr compsum
	ldy #4
	jsr compsum
	iny
	jsr compsum

	ldx #2
; make sure it is the same kernal as before
	ldy #ikernals
	jsr compsum
; make sure all ROM sections are the same
	ldy #3
	jsr compsum
	ldy #6
	jsr compsum
	iny
	jsr compsum

	jsr holetest
.)

.(
; vary $1 and checksum $8000-$9fff
	jsr sum8

	ldx #0
; make sure it isn't RAM
	ldy #iram
	jsr ncompsum
; make sure it isn't the other overlay
	ldy #i8xxx0
	jsr ncompsum
; make sure it is the same and not RAM
	ldy #7
loop
	jsr compsum
	dey
	bne loop

; save for later

	ldy #i8xxx1
	jsr copysum
.)

.(
; vary $1 and checksum $a000-$bfff
	jsr suma

	ldx #0
; make sure it isn't basic
	ldy #ibasic
	jsr ncompsum
; make sure it isn't the other overlay
	ldy #iaxxx0
	jsr ncompsum
; make sure all sections are the same
	ldy #7
loop
	jsr compsum
	dey
	bne loop

; save for later

	ldy #iaxxx1
	jsr copysum
.)

	lda #$37
	sta 1

	dec $df42

.(
; vary $1 and checksum $e000-$ffff
	jsr sume

	ldx #0
; make sure it is the same kernal as before
	ldy #ikernalr
	jsr compsum
; make sure all RAM sections are the same
	ldy #1
	jsr compsum
	ldy #4
	jsr compsum
	iny
	jsr compsum

	ldx #2
; make sure it is the same kernal as before
	ldy #ikernals
	jsr compsum
; make sure all ROM sections are the same
	ldy #3
	jsr compsum
	ldy #6
	jsr compsum
	iny
	jsr compsum

	jsr holetest
.)

.(
; vary $1 and checksum $8000-$9fff
	jsr sum8

	ldx #0
; make sure it is the first overlay
	ldy #i8xxx0
	jsr compsum
; make sure it is the same
	ldy #7
loop
	jsr compsum
	dey
	bne loop
.)

.(
; vary $1 and checksum $a000-$bfff
	jsr suma

	ldx #0
; make sure it is the first overlay
	ldy #iaxxx0
	jsr compsum
; make sure all sections are the same
	ldy #7
loop
	jsr compsum
	dey
	bne loop
.)

	jsr rloff8

.(
; vary $1 and checksum $e000-$ffff
	jsr sume

	ldx #0
; make sure it is the same kernal as before
	ldy #ikernalr
	jsr compsum
; make sure all RAM sections are the same
	ldy #1
	jsr compsum
	ldy #4
	jsr compsum
	iny
	jsr compsum

	ldx #2
; make sure it is the same kernal as before
	ldy #ikernals
	jsr compsum
; make sure all ROM sections are the same
	ldy #3
	jsr compsum
	ldy #6
	jsr compsum
	iny
	jsr compsum

	jsr holetest
.)

.(
; vary $1 and checksum $a000-$bfff
	jsr suma

; make sure all RAM sections are RAM and the same
	ldx #0
	ldy #iram
	jsr compsum
	ldy #1
	jsr compsum
	iny
	jsr compsum
	ldy #4
	jsr compsum
	iny
	jsr compsum
	iny
	jsr compsum

; make sure all ROM sections are the same and BASIC
	ldx #3
	ldy #ibasic
	jsr compsum
	ldy #7
	jsr compsum
.)

.(
; vary $1 and checksum $8000-$9fff
	jsr sum8

; make sure all RAM sections are RAM and the same
	ldx #0
	ldy #iram
	jsr compsum
	ldy #7
loop
	jsr compsum
	dey
	bne loop
.)

	jsr rloff

.(
; vary $1 and checksum $e000-$ffff
	jsr sume

; make sure all RAM sections are the same
	ldx #0
	ldy #iram
	jsr compsum
	ldy #1
	jsr compsum
	ldy #4
	jsr compsum
	iny
	jsr compsum

; make sure all ROM sections are the same
	ldx #2
	ldy #ikernal
	jsr compsum
	ldy #3
	jsr compsum
	ldy #6
	jsr compsum
	iny
	jsr compsum
.)

.(
; vary $1 and checksum $a000-$bfff
	jsr suma

; make sure all RAM sections are the same
	ldx #0
	ldy #iram
	jsr compsum
	ldy #1
	jsr compsum
	iny
	jsr compsum
	ldy #4
	jsr compsum
	iny
	jsr compsum
	iny
	jsr compsum

; make sure all ROM sections are the same
	ldx #3
	ldy #ibasic
	jsr compsum
	ldy #7
	jsr compsum
.)

.(
; vary $1 and checksum $8000-$9fff
	jsr sum8

; make sure all RAM sections are the same
	ldx #0
	ldy #iram
	jsr compsum
	ldy #7
loop
	jsr compsum
	dey
	bne loop
.)

	lda #$37
	sta 1

	jmp good

sum8
	lda #$80
	ldx #$20
;	bne sume0
	bne sumvary

suma
	lda #$a0
	ldx #$20
;	bne sume0
	bne sumvary

sume
	lda #$e0
sume0
	ldx #$20

sumvary
.(
	sta loc+1
	stx size+1
	lda #0
	sta cksumi
	lda #$30
	sta vary
loop
	lda vary
	sta 1
loc
	lda #$e0
size
	ldx #$20
	jsr summem
	inc vary
	lda vary
	cmp #$38
	bne loop
	rts
.)

summem
.(
	stx count
	sta $fc
	lda #0
	tay
	tax
	clc
loop1
	adc ($fb),y
	bcc loop2
	inx
loop2
	iny
	bne loop1
	inc $fc
	dec count
	bne loop1

	ldy cksumi
	sta cksumsl,y
	stx cksumsh,y
	inc cksumi
	rts
.)


rlon8
	lda 1
	pha
	lda #$37
	sta 1
	sta $df60
	pla
	sta 1
	rts

rloff8
	lda 1
	pha
	lda #$37
	sta 1
	sta $df70
	pla
	sta 1
	rts

rlon
	lda 1
	pha
	lda #$37
	sta 1
	sta $df7e
	pla
	sta 1
	rts

rloff
	lda 1
	pha
	lda #$37
	sta 1
	sta $df7f
	pla
	sta 1
	rts

newtest
	pha
	txa
	pha
	tya
	pha
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
	pla
	tay
	pla
	tax
	pla
	rts

; make sure there as a RAM hole at $ff00-$ff0f and $fff0-$ffff when
;  RL is on and RAM is mapped (RAM is already 00s)
holetest
.(
; check RAM for 00s, replace with 80s after
	jsr newtest
	lda #$30
	sta 1
	ldy #15
loop
	lda $ff00,y
	bne fail
	lda $fff0,y
	bne fail
	lda #$80
	sta $ff00,y
	sta $fff0,y
	dey
	bpl loop

; check ROM to make sure it isn't ALL 80s, replace with 00s after
	lda #$37
	sta 1
	ldx #16
	ldy #15
loop0
	lda $ff00,y
	cmp #$80
	bne loop1
	dex
loop1
	lda #$00
	sta $ff00,y
	dey
	bpl loop0
	cpx #0
	beq fail

	ldx #16
	ldy #15
loop2
	lda $fff0,y
	cmp #$80
	bne loop3
	dex
loop3
	lda #$00
	sta $fff0,y
	dey
	bpl loop2
	cpx #0
	beq fail
	rts	
.)

; copy x checksum to y
copysum
	lda cksumsl,x
	sta cksumsl,y
	lda cksumsh,x
	sta cksumsh,y
	rts

; compare if x checksum is the same as y
compsum
	jsr newtest
	lda cksumsl,x
	cmp cksumsl,y
	bne fail
	lda cksumsh,x
	cmp cksumsh,y
	bne fail
	rts

; compare if x checksum is not the same as y
ncompsum
.(
	jsr newtest
	lda cksumsl,x
	cmp cksumsl,y
	bne leave
	lda cksumsh,x
	cmp cksumsh,y
	beq fail
leave
	rts
.)

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
