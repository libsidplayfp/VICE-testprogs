; RAMLink memory mapping tests for C128
; by Roberto Muscedere (rmusced@uwindsor.ca)

; Various tests to see if the RAMLink is mapped correctly
; A good result has a green border and 0 is written to $d7ff
; A bad result hasa red border and 1 is written to $d7ff

; do not press restore during this test

.text	;segment

vary    = $f9
count   = $fa
cksumi  = $02
cksumsl = $04
cksumsh = $24

irandom	= 0
ikernal	= 1
ibasic	= 2
ikernals	= 3
ieditor	= 4
i8xxx0	= 5
i8xxx1	= 6
ifkernal	= 7
ifkernals	= 8

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

.(
	ldy #0
fill
	tya
	sta $405,y
	sta $505,y
	sta $605,y
	cpy #$e3
	bcs fill0
	sta $705,y
fill0
	iny
	bne fill
.)

; Test only RAM, so RAMLink shouldn't be mapped (this test hiram function)
	jsr newtest

	sei

; Use bottom 16K as shared RAM
	lda #7
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

; RAMLINK OFF, do the ram tests
	jsr rloff

.(
; Do basic RAM test
; set all RAM from $4000-$FEFF in bank 0 to "00"
; set all RAM from $4000-$FEFF in bank 1 to "01"

	lda #$40
	sta $fc

	ldx #256-64
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
	ldy $fc		; skip $ff00-$ff05
	cpy #$ff
	bne fill0
	ldy #5
	.byt $2c
fill0
	ldy #0
	dex
	bne fill

; read it back the banks to make sure nothing else is there from $4000-ffff

	lda #$40
	sta $fc

	ldx #256-64
	ldy #0

comp0
	sta $ff03
	lda ($fb),y
	bne comp2
	sta $ff04
	lda ($fb),y
	cmp #1
	bne comp2
	iny
	bne comp0
	inc $fc
	ldy $fc		; skip $ff00-$ff05
	cpy #$ff
	bne comp1
	ldy #5
	.byt $2c
comp1
	ldy #0
	dex
	bne comp0
	beq comp3
comp2
	jmp fail
comp3
.)

.(
; see if we have the international keyboard code at $fc80 by looking at $c014
;  if it is $fc, then it is an international machine
	jsr newtest
	lda #0
	sta $ff00

	ldy $c014
	cpy #$fc
	bne fcheck9

; on international roms, make sure there isn't $ff's from $fd00-$feff in the kernal
	tax
	tay
fcheck0
	lda $fd00,y
	cmp #$ff
	bne fcheck1
	inx
	beq fcheck8
fcheck1
	iny
	bne fcheck0

	ldx #0
	
fcheck2
	lda $fe00,y
	cmp #$ff
	bne fcheck3
	inx
	beq fcheck8
fcheck3
	iny
	bne fcheck2

; make sure there isn't 00's from $ff05-$ff0f in the kernal
fcheck6
	ldy #5
	ldx #0
fcheck4
	lda $ff00,y
	bne fcheck5
	inx
	cpx #11
	beq fcheck8
fcheck5
	iny
	cpy #$10
	bne fcheck4
	beq fcheck9
fcheck8
	jmp fail
fcheck9
.)

.(
; since $e000-ffff is a kernal, checksum it and save value for comparisons later
	lda #ikernal
	sta cksumi
	lda #$e0
	ldx #$20
	ldy #$00	; All ROMS
	jsr summem
.)

.(
; since $8000-bfff is basic, checksum it and save value for comparisons later
	lda #ibasic
	sta cksumi
	lda #$80
	ldx #$40
	ldy #$00	; All ROMS
	jsr summem
.)

.(
; since $c000-cfff is editor, checksum it and save value for comparisons later
	lda #ieditor
	sta cksumi
	lda #$c0
	ldx #$10
	ldy #$00	; All ROMS
	jsr summem
.)

; check RAM and ROMs
	ldy #ikernal
	jsr checkall

; make sure there is nothing in the function rom areas
	jsr checkjunk8
	jsr checkjunkm

.(
; since $e000-ffff in function ROM is a discontinuous main kernal,
;  checksum it and save value for comparisons later
	lda #ifkernal
	sta cksumi
	ldy #$20	; All ROMS
	jsr sumfem
	jsr checkfem
.)

; RLON
	jsr rlon

.(
; since $e000-ffff is the switched kernal, checksum it and save value for comparisons later
	lda #ikernals
	sta cksumi
	lda #$e0
	ldx #$20
	ldy #$00	; All ROMS
	jsr summem
.)

; make sure it isn't the same as the main kernal
	ldx #ikernals
	ldy #ikernal
	jsr ncompsum

; check RAM and ROMs
	ldy #ikernals
	jsr checkall

; make sure there is nothing in the function rom areas
	jsr checkjunk8
	jsr checkjunks

.(
; since $e000-ffff in function ROM is a discontinuous switched kernal,
;  checksum it and save value for comparisons later
	lda #ifkernals
	sta cksumi
	ldy #$20	; All ROMS
	jsr sumfes
	jsr checkfes
.)

; RLON8
	jsr rlon8

; check RAM and ROMs
	ldy #ikernals
	jsr checkall

; make sure there is nothing in the function rom areas above $c000
	jsr checkjunks

	jsr checkfes

.(
; since $8000-bfff is ramlink, checksum it and save value for comparisons later
	lda #i8xxx0
	sta cksumi
	lda #$80
	ldx #$40
	ldy #$08	; External $8000
	jsr summem
.)

; make sure it isn't the same as basic
	ldx #i8xxx0
	ldy #ibasic
	jsr ncompsum

.(
; vary MMU and check $8000-$bfff to see if ramlink bank0 in ext func
	ldy #i8xxx0
	jsr check8
.)

; RL BANK 2
	lda #0
	sta $ff00
	inc $df42

; check RAM and ROMs
	ldy #ikernals
	jsr checkall

; make sure there is nothing in the function rom areas above $c000
	jsr checkjunks

	jsr checkfes
.(
; since $8000-bfff is ramlink, checksum it and save value for comparisons later
	lda #i8xxx1
	sta cksumi
	lda #$80
	ldx #$40
	ldy #$08	; External $8000
	jsr summem
.)

; make sure it isn't the same as basic
	ldx #i8xxx1
	ldy #ibasic
	jsr ncompsum

; make sure it isn't the same as ramlink bank 1
	ldx #i8xxx1
	ldy #i8xxx0
	jsr ncompsum

.(
; vary MMU and check $8000-$bfff to see if ramlink bank1 in ext func
	ldy #i8xxx1
	jsr check8
.)

; RL BANK 1
	lda #0
	sta $ff00
	dec $df42

; check RAM and ROMs
	ldy #ikernals
	jsr checkall

; make sure there is nothing in the function rom areas above $c000
	jsr checkjunks

	jsr checkfes
.(
; vary MMU and check $8000-$bfff to see if ramlink bank0 in ext func
	ldy #i8xxx0
	jsr check8
.)

; RLOFF8
	jsr rloff8

; check RAM and ROMs
	ldy #ikernals
	jsr checkall

; make sure there is nothing in the function rom areas
	jsr checkjunk8
	jsr checkjunks

	jsr checkfes

; RLOFF

	jsr rloff

; check RAM and ROMs
	ldy #ikernal
	jsr checkall

; make sure there is nothing in the function rom areas
	jsr checkjunkm

	jsr checkfem

	jmp good

checkall

.(
; vary MMU and check $e000-$ffff to see which kernal (provided by caller)
	ldx #2
	jsr checkx
.)

.(
; vary MMU and check $8000-$bfff to see if basic
	ldy #ibasic
	ldx #0
	jsr checkx
.)

.(
; vary MMU and check $c000-$cfff to see if editor
	ldy #ieditor
	ldx #1
	jsr checkx
.)

; check RAM is always mapped
	jmp checkram
; follow thru...

checkram
	lda #$80
	ldx #$40
	ldy #$0c
	jsr checkxr

	lda #$c0
	ldx #$10
	ldy #$30
	jsr checkxr

	lda #$e0
	ldx #$20
	ldy #$30
	
checkxr
.(
	sta loc+1
	stx len+1
	sty comp1+1
	sty comp2+1
	lda #$7f
	sta vary
again
	lda vary
	tax
comp1
	and #$30
comp2
	cmp #$30
	bne skip
	stx $ff00
loc
	ldy #$e0
len
	ldx #$1f
	jsr checkgr
skip
	dec vary
	bpl again
	rts
.)

checkfem
.(
	lda #$7f
	sta vary

again
	lda vary
	tay
comp
	and #$10	; check ROM and FUNCTION
	bne skip
	lda #irandom
	sta cksumi

	jsr sumfem
	ldx #irandom
	ldy #ifkernal
	jsr compsum
skip
	dec vary
	bpl again
	rts
.)

checkfes
.(
	lda #$7f
	sta vary

again
	lda vary
	tay
comp
	and #$10	; check ROM and FUNCTION
	bne skip
	lda #irandom
	sta cksumi

	jsr sumfes
	ldx #irandom
	ldy #ifkernals
	jsr compsum
skip
	dec vary
	bpl again
	rts
.)

sumfem
	ldx #0
	lda #7
	bne sumfe

sumfes
	ldx #7
	lda #9

sumfe
.(
	sty $ff00
	sta comp3+1

	ldy cksumi
	lda #0
	sta cksumsl,y
	sta cksumsh,y

loop0
	txa
	pha

	lda valfloc,x
	sta $fc
	lda valflen,x
	sta count
	lda valfsty,x
	sta comp1+1
	lda valfcpy,x
	sta comp2+1

	ldy cksumi
	lda cksumsl,y
	ldx cksumsh,y
comp1
	ldy #$00
loop1
	clc
	adc ($fb),y
	bcc loop2
	inx
loop2
	iny
comp2
	cpy #$00
	bne loop1
	inc $fc
	dec count
	bne loop1

	ldy cksumi
	sta cksumsl,y
	stx cksumsh,y

	pla
	tax

	inx
comp3
	cpx #7
	bne loop0
	rts
.)

; 0-6 for main kernal
; 7-8 for switched kernal
;              0   1   2   3   4   5   6   7   8
valfloc	.byt $e0,$ed,$f7,$f7,$f8,$ff,$ff,$e0,$ff
valflen	.byt $0b,$0a,$01,$01,$05,$01,$01,$1f,$01
valfsty .byt $00,$00,$00,$b0,$00,$10,$60,$00,$10
valfcpy .byt $00,$00,$a0,$00,$00,$50,$f0,$00,$f0

check8
.(
	sty against+1
	lda #$7f
	sta vary

again
	lda vary
	tay
comp
	and #$0c
	cmp #$08
	bne skip
	lda #irandom
	sta cksumi
loc
	lda #$80
len
	ldx #$40
	jsr summem
	ldx #irandom
against
	ldy #i8xxx0
	jsr compsum
skip
	dec vary
	bpl again
	rts
.)

checkx
.(
	sty against+1
	lda valkloc,x
	sta loc+1
	lda valklen,x
	sta len+1
	lda valkmsk,x
	sta comp+1
	lda #$7f
	sta vary

again
	lda vary
	tay
comp
	and #$30
	bne skip
	lda #irandom
	sta cksumi
loc
	lda #$e0
len
	ldx #$20
	jsr summem
	ldx #irandom
against
	ldy #ikernal
	jsr compsum
skip
	dec vary
	bpl again
	rts
.)

valkloc	.byt $80,$c0,$e0
valklen	.byt $40,$10,$20
valkmsk	.byt $0c,$30,$30

summem
.(
	sty $ff00
	stx count
	sta $fc
	lda #0
	tay
	tax
loop1
	clc
	adc ($fb),y
	bcc loop2
	inx
loop2
	iny
	bne loop1
	inc $fc
	ldy $fc		; skip $ff00-$ff05
	cpy #$ff
	bne loop3
	ldy #5
	.byt $2c
loop3
	ldy #0
	dec count
	bne loop1

	ldy cksumi
	sta cksumsl,y
	stx cksumsh,y
	inc cksumi
	rts
.)

checkjunkm
	ldx #8
	.byt $2c
checkjunks
	ldx #4
.(
loop
	txa
	pha
	jsr junkx
	pla
	tax
	dex
	bne loop
        rts
.)

checkjunk8
	ldx #0

junkx
.(
	lda valjloc,x
	sta loc+1
	lda valjlen,x
	sta len+1
	lda valjmsk,x
	sta comp1+1
	lda valjcmp,x
	sta comp2+1
	lda valjsty,x
	sta junkmemy+1
	lda valjcpy,x
	sta junkmems+1
	stx index+1
	jsr passx
; patch to check for internal ROM as well
index
	ldx #0
	lda valjcm2,x
	sta comp2+1
passx
	lda #$7f
	sta vary

again
	lda vary
	tay
comp1
	and #$30
comp2
	cmp #$20
	bne skip
loc
	lda #$e0
len
	ldx #$20
	jsr junkmem
skip
	dec vary
	bpl again
	rts
.)

; 8-1 for main kernal
; 4-1 for switched kernal
;              0   1   2   3   4   5   6   7   8
valjloc	.byt $80,$c0,$d0,$ff,$ff,$eb,$f7,$fd,$ff
valjlen	.byt $40,$10,$10,$01,$01,$02,$01,$02,$01
valjmsk	.byt $0c,$30,$31,$30,$30,$30,$30,$30,$30
valjcmp	.byt $08,$20,$21,$20,$20,$20,$20,$20,$20	; external ROM
valjcm2	.byt $04,$10,$11,$10,$10,$10,$10,$10,$10	; internal ROM
valjsty .byt $00,$00,$00,$05,$f0,$00,$a0,$00,$50
valjcpy .byt $00,$00,$00,$10,$00,$00,$b0,$00,$60

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
	bne fail
	iny
	bne loop
	inc $fc
	ldy $fc		; skip $ff00-$ff05
	cpy #$ff
	bne loop3
	ldy #5
	.byt $2c
loop3
	ldy #0
	dex
	bne loop
.)
	rts

junkmem
.(
	jsr newtest
	sty $ff00
	stx count
	sta $fc
+junkmemy
	ldy #0
loop1
	ldx #0
	lda ($fb),y
loop2
	cmp ($fb),y
	bne loop3
	dex
	bne loop2
	beq fail
loop3
	iny
+junkmems
	cpy #$00
	bne loop1
	inc $fc
	dec count
	bne loop1
	rts
.)

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
	
rlon8
	lda $ff00
	pha
	and #254
	sta $ff00
	sta $df60
	pla
	sta $ff00
	rts

rloff8
	lda $ff00
	pha
	and #254
	sta $ff00
	sta $df70
	pla
	sta $ff00
	rts

rlon
	lda $ff00
	pha
	and #254
	sta $ff00
	sta $df7e
	pla
	sta $ff00
	rts

rloff
	lda $ff00
	pha
	and #254
	sta $ff00
	sta $df7f
	pla
	sta $ff00
	rts

newtest
	pha
	txa
	pha

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

	pla
	tax
	pla
	rts
