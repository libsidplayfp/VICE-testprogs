*=$2000

real	= 1
charram	= $9005
;charram	= $900f
stackpointersave	= $0270

bottomgraphic1 = $a000
bottomgraphic2 = $a100
bottomgraphic3 = $a200
bottomgraphic4 = $a300

colorram1 = $7e00
colorram2 = $7f00

groff	ldx	stackpointersave
	txs
	ldx	#$00
looprsbt	lda	bottomgraphic1,x
	sta	$00,x
	lda	bottomgraphic2,x
	sta	$0100,x
	lda	$0200,x
	tay
	lda	bottomgraphic3,x
	sta	$0200,x
	tya
	sta	bottomgraphic3,x
	lda	$0300,x
	tay
	lda	bottomgraphic4,x
	sta	$0300,x
	tya
	sta	bottomgraphic4,x
	inx
	bne	looprsbt	

	lda	#$f7
	sta	$9120
	lda	#$82
	sta	$911e	; enable NMIs (Restore key)
	jsr	$e518	; Initialize Video-Controller
	cli
	lda	#$00	
	sta	$c6	; clear keyboard buffer
	rts

grontab
.	byte	$82,$14,$18,$34

gron
; install IRQ and switch to graphics mode (create video-RAM charmap)
	sei
	lda	#$7f
	sta	$911e	; disable NMIs (Restore key)
	ldx	#00
loopcpbt	lda	$00,x
	sta	bottomgraphic1,x
	lda	$0100,x
	sta	bottomgraphic2,x
	lda	$0200,x
	tay
	lda	bottomgraphic3,x
	sta	$0200,x
	tya
	sta	bottomgraphic3,x
	lda	$0300,x
	tay
	lda	bottomgraphic4,x
	sta	$0300,x
	tya
	sta	bottomgraphic4,x
colcopy	lda	colorram1,x
	sta	$9400,x
	lsr
	lsr
	lsr
	lsr
	sta	$9538,x
	cpx	#$38
	bcs	col2skip
	lda	colorram2,x
	sta	$9500,x
	lsr
	lsr
	lsr
	lsr
	sta	$9638,x
col2skip	inx
	bne	loopcpbt

; vorwaerts Charmap hier
;	ldx	#$00	; already set to 0 from last loop
	clc
charmap	txa
	sta	$11e8,x	; Line 21o (0-15)
	adc	#$28
	sta	$0210,x	; Line 23e (40-63)
	adc	#$18
	sta	$0240,x	; Line 25e (64-87)
	adc	#$10
	sta	$1030,x	; Line 03o (80-103)
	sta	$1180,x	; Line 17o (80-103)
	adc	#$18
	sta	$1060,x	; Line 05o (104-127)
	sta	$11b0,x	; Line 19o (104-127)
	adc	#$10
	sta	$1210,x	; Line 23o (120-143)
	adc	#$08
	sta	$1090,x	; Line 07o (128-151)
	adc	#$10
	sta	$1240,x	; Line 25o (144-167)
	adc	#$08
	sta	$10c0,x	; Line 09o (152-175)
	adc	#$18
	sta	$10f0,x	; Line 11o (192-212)
	adc	#$18
	sta	$1120,x	; Line 13o (200-223)
	adc	#$18
	sta	$1150,x	; Line 15o (224-247)
	inx
	cpx	#$18
	bne	charmap
	ldx	#$40	; Line 21o chars
	stx	$11e0
	inx
	stx	$11e1
	ldx	#$45
	stx	$11e2
	inx
	stx	$11e3
	inx
	stx	$11e4
	ldx	#$4b
	stx	$11e5
	inx
	stx	$11e6
	inx
	stx	$11e7
	ldy	#$f8
charlp	tya
	sta	$0158,y	; Line 25e Chars 248-255
	iny
	bne	charlp

; rueckwaerts Charmap hier
;	ldy	#$00	; already 0
	ldx	#$27
	clc
charmap2	txa
	sta 	$1018,y	; Line 02o (39-16)
	sta 	$1078,y	; Line 06o (39-16)
	sta 	$10d8,y	; Line 10o (39-16)
	sta 	$1138,y	; Line 14o (39-16)
	sta 	$1198,y	; Line 18o (39-16)
	sta 	$11f8,y	; Line 22o (39-16)
	sta 	$1258,y	; Line 26o (39-16)
	adc	#$18
	sta 	$1000,y	; Line 01o (63-40)
	sta 	$1048,y	; Line 04o (63-40)
	sta 	$10a8,y	; Line 08o (63-40)
	sta 	$1108,y	; Line 12o (63-40)
	sta 	$1168,y	; Line 16o (63-40)
	sta 	$11c8,y	; Line 20o (63-40)
	sta 	$1228,y	; Line 24o (63-40)
	dex
	iny
	cpy	#$18
	bne	charmap2

	tsx
	stx	stackpointersave	; save stackpointer

	ldx #$ff
	txs

show	inx
	lda	grontab,x
	sta	$9000,x
	cpx	#$03
	bne	show
	lda	#$20
	sta	$900e
	lda	#$1b
	sta	$900f
	
ifdef	real
	ldx	#131	; make sure next command really STARTS at line #131 and not SOMEWHERE in it
else
	ldx	#130	; make sure next command really STARTS at line #130 and not SOMEWHERE in it
endif
raster0	cpx	$9004
	bne	raster0
	ldx	#$0f	; wait for this raster line (times 2)
raster1	cpx	$9004
	bne	raster1	; 3 cycles - at this stage, the inaccuracy is 7 clock cycles
			;            the processor is in this place 2 to 9 cycles
			;            after $9004 has changed
	ldy	#9	; 2 cycles
	bit	$24	; 3 cycles
raster2
	ldx	$9004	; 4 cycles	
	txa		; 2 cycles
	nop		; 2 cycles
	nop		; 2 cycles
	nop		; 2 cycles
	ldx	#21	; 2 cycles
minus11	dex		; 2 cycles * 21 = 42 cycles
	bne	minus11	; 3 cycles * 21 - 1 = 62 cycles - first spend some time (so that the whole
	cmp	$9004	; 4 cycles                        loop will be 2 raster lines)
	bcs	plus21	; 3 cycles (-1 on when carry clear) save one cycle if $9004 changed too late
plus21	dey		; 2 cycles
	bne	raster2	; 3 cycles (2 on last)
			; now it is fully synchronized
			; 6 cycles have passed since last $9004 change
			; and we are on line 17

	pha		; waste
	pla		; 13
	lda       ($00,x)	; cycles
	ldx	#$c8	; pre-load charram-register

lbl	
keyoff	lda	#$ef
	sta	$9120
	lda	$9121
	cmp	#$fe
	bne	grcont
	jmp	groff	

grcont
upd0_4e	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

	ldy	#$c8
	sty	charram	

	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

upd4_21e1	lda	#$00
	sta	$02
	lda	#$00
	sta	$03
	lda	#$00
	sta	$04
	lda	#$00
	sta	$05
	lda	#$00
	sta	$06
	lda	#$00
	sta	$07
	lda	#$00
	sta	$08
	lda	#$00
	sta	$09
	lda	#$00
	sta	$0A
	lda	#$00
	sta	$0B
	lda	#$00
	sta	$0C
	lda	#$00
	sta	$0D
	lda	#$00
	sta	$0E
	lda	#$00
	sta	$0F

	stx	charram

upd1_6e	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	sta	$FF
	lda	#$00
	sta	$FE
	lda	#$00
	sta	$FD
	lda	#$00
	sta	$FC
	lda	#$00
	sta	$FB
	lda	#$00
	sta	$FA
	lda	#$00
	sta	$F9
	lda	#$00
	sta	$F8
	lda	#$00
	sta	$F7
	lda	#$00
	sta	$F6
	lda	#$00
	sta	$F5
	lda	#$00
	sta	$F4
	lda	#$00
	sta	$F3
	lda	#$00
	sta	$F2
	lda	#$00
	sta	$F1
	lda	#$00
	sta	$F0
	lda	#$00
	sta	$EF
	lda	#$00
	sta	$EE
	lda	#$00
	sta	$ED
	lda	#$00
	sta	$EC
	lda	#$00
	sta	$EB
	lda	#$00
	sta	$EA
	lda	#$00
	sta	$E9
	lda	#$00
	sta	$E8
	lda	#$00
	sta	$E7
	lda	#$00
	sta	$E6
	lda	#$00
	sta	$E5
	lda	#$00
	sta	$E4
	lda	#$00
	sta	$E3
	lda	#$00
	sta	$E2
	lda	#$00
	sta	$E1
	lda	#$00
	sta	$E0
	lda	#$00
	sta	$DF
	lda	#$00
	sta	$DE
	lda	#$00
	sta	$DD
	lda	#$00
	sta	$DC
	lda	#$00
	sta	$DB
	lda	#$00
	sta	$DA
	lda	#$00
	sta	$D9
	lda	#$00
	sta	$D8

	ldy	#$c8
	sty	charram

	lda	#$00
	sta	$D7
	lda	#$00
	sta	$D6
	lda	#$00
	sta	$D5
	lda	#$00
	sta	$D4
	lda	#$00
	sta	$D3
	lda	#$00
	sta	$D2
	lda	#$00
	sta	$D1
	lda	#$00
	sta	$D0
	lda	#$00
	sta	$CF
	lda	#$00
	sta	$CE
	lda	#$00
	sta	$CD
	lda	#$00
	sta	$CC
	lda	#$00
	sta	$CB
	lda	#$00
	sta	$CA
	lda	#$00
	sta	$C9
	lda	#$00
	sta	$C8
	lda	#$00
	sta	$C7
	lda	#$00
	sta	$C6
	lda	#$00
	sta	$C5
	lda	#$00
	sta	$C4
	lda	#$00
	sta	$C3
	lda	#$00
	sta	$C2
	lda	#$00
	sta	$C1
	lda	#$00
	sta	$C0
	lda	#$00
	sta	$BF
	lda	#$00
	sta	$BE
	lda	#$00
	sta	$BD
	lda	#$00
	sta	$BC
	lda	#$00
	sta	$BB
	lda	#$00
	sta	$BA
	lda	#$00
	sta	$B9
	lda	#$00
	sta	$B8
	lda	#$00
	sta	$B7
	lda	#$00
	sta	$B6
	lda	#$00
	sta	$B5
	lda	#$00
	sta	$B4
	lda	#$00
	sta	$B3
	lda	#$00
	sta	$B2
	lda	#$00
	sta	$B1
	lda	#$00
	sta	$B0
	lda	#$00
	sta	$AF
	lda	#$00
	sta	$AE
	lda	#$00
	sta	$AD
	lda	#$00
	sta	$AC
	lda	#$00
	sta	$AB
	lda	#$00
	sta	$AA
	lda	#$00
	sta	$A9
	lda	#$00
	sta	$A8
	lda	#$00
	sta	$A7
	lda	#$00
	sta	$A6
	lda	#$00
	sta	$A5
	lda	#$00
	sta	$A4
	lda	#$00
	sta	$A3
	lda	#$00
	sta	$A2
	lda	#$00
	sta	$A1
	lda	#$00
	sta	$A0
	lda	#$00
	sta	$9F
	lda	#$00
	sta	$9E
	lda	#00
	sta	$9D
	lda	#$00
	sta	$9C
	lda	#$00
	sta	$9B
	lda	#$00
	sta	$9A
	lda	#$00
	sta	$99
	lda	#$00
	sta	$98
	lda	#$00
	sta	$97
	lda	#$00
	sta	$96
	lda	#$00
	sta	$95
	lda	#$00
	sta	$94
	lda	#$00
	sta	$93
	lda	#$00
	sta	$92
	lda	#$00
	sta	$91
	lda	#$00
	sta	$90
	lda	#$00
	sta	$8F
	lda	#$00
	sta	$8E
	lda	#$00
	sta	$8D
	lda	#$00
	sta	$8C
	lda	#$00
	sta	$8B
	lda	#$00
	sta	$8A
	lda	#$00
	sta	$89
	lda	#$00
	sta	$88
	lda	#$00
	sta	$87
	lda	#$00
	sta	$86
	lda	#$00
	sta	$85
	lda	#$00
	sta	$84
	lda	#$00
	sta	$83
	lda	#$00
	sta	$82
	lda	#$00
	sta	$81
	lda	#$00
	sta	$80

upd4_21e2	lda	#$00
	sta	$10
	lda	#$00
	sta	$11
	lda	#$00
	sta	$12
	lda	#$00
	sta	$13
	lda	#$00
	sta	$14
	lda	#$00
	sta	$15
	lda	#$00
	sta	$16
	lda	#$00
	sta	$17
	lda	#$00
	sta	$18
	lda	#$00
	sta	$19
	lda	#$00
	sta	$1A
	lda	#$00
	sta	$1B
	lda	#$00
	sta	$1C
	lda	#$00
	sta	$1D

	stx	charram

upd0_8e	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

	ldy	#$ce
	sty	charram

	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

upd4_21e3	lda	#$00
	sta	$1E
	lda	#$00
	sta	$1F
	lda	#$00
	sta	$20
	lda	#$00
	sta	$21
	lda	#$00
	sta	$22
	lda	#$00
	sta	$23
	lda	#$00
	sta	$24
	lda	#$00
	sta	$25
	lda	#$00
	sta	$26
	lda	#$00
	sta	$27
	lda	#$00
	sta	$28
	lda	#$00
	sta	$29
	lda	#$00
	sta	$2A
	lda	#$00
	sta	$2B
	
	stx	charram

upd1_10e	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	sta	$FF
	lda	#$00
	sta	$FE
	lda	#$00
	sta	$FD
	lda	#$00
	sta	$FC
	lda	#$00
	sta	$FB
	lda	#$00
	sta	$FA
	lda	#$00
	sta	$F9
	lda	#$00
	sta	$F8
	lda	#$00
	sta	$F7
	lda	#$00
	sta	$F6
	lda	#$00
	sta	$F5
	lda	#$00
	sta	$F4
	lda	#$00
	sta	$F3
	lda	#$00
	sta	$F2
	lda	#$00
	sta	$F1
	lda	#$00
	sta	$F0
	lda	#$00
	sta	$EF
	lda	#$00
	sta	$EE
	lda	#$00
	sta	$ED
	lda	#$00
	sta	$EC
	lda	#$00
	sta	$EB
	lda	#$00
	sta	$EA
	lda	#$00
	sta	$E9
	lda	#$00
	sta	$E8
	lda	#$00
	sta	$E7
	lda	#$00
	sta	$E6
	lda	#$00
	sta	$E5
	lda	#$00
	sta	$E4
	lda	#$00
	sta	$E3
	lda	#$00
	sta	$E2
	lda	#$00
	sta	$E1
	lda	#$00
	sta	$E0
	lda	#$00
	sta	$DF
	lda	#$00
	sta	$DE
	lda	#$00
	sta	$DD
	lda	#$00
	sta	$DC
	lda	#$00
	sta	$DB
	lda	#$00
	sta	$DA
	lda	#$00
	sta	$D9
	lda	#$00
	sta	$D8

	ldy	#$ce
	sty	charram

	lda	#$00
	sta	$D7
	lda	#$00
	sta	$D6
	lda	#$00
	sta	$D5
	lda	#$00
	sta	$D4
	lda	#$00
	sta	$D3
	lda	#$00
	sta	$D2
	lda	#$00
	sta	$D1
	lda	#$00
	sta	$D0
	lda	#$00
	sta	$CF
	lda	#$00
	sta	$CE
	lda	#$00
	sta	$CD
	lda	#$00
	sta	$CC
	lda	#$00
	sta	$CB
	lda	#$00
	sta	$CA
	lda	#$00
	sta	$C9
	lda	#$00
	sta	$C8
	lda	#$00
	sta	$C7
	lda	#$00
	sta	$C6
	lda	#$00
	sta	$C5
	lda	#$00
	sta	$C4
	lda	#$00
	sta	$C3
	lda	#$00
	sta	$C2
	lda	#$00
	sta	$C1
	lda	#$00
	sta	$C0
	lda	#$00
	sta	$BF
	lda	#$00
	sta	$BE
	lda	#$00
	sta	$BD
	lda	#$00
	sta	$BC
	lda	#$00
	sta	$BB
	lda	#$00
	sta	$BA
	lda	#$00
	sta	$B9
	lda	#$00
	sta	$B8
	lda	#$00
	sta	$B7
	lda	#$00
	sta	$B6
	lda	#$00
	sta	$B5
	lda	#$00
	sta	$B4
	lda	#$00
	sta	$B3
	lda	#$00
	sta	$B2
	lda	#$00
	sta	$B1
	lda	#$00
	sta	$B0
	lda	#$00
	sta	$AF
	lda	#$00
	sta	$AE
	lda	#$00
	sta	$AD
	lda	#$00
	sta	$AC
	lda	#$00
	sta	$AB
	lda	#$00
	sta	$AA
	lda	#$00
	sta	$A9
	lda	#$00
	sta	$A8
	lda	#$00
	sta	$A7
	lda	#$00
	sta	$A6
	lda	#$00
	sta	$A5
	lda	#$00
	sta	$A4
	lda	#$00
	sta	$A3
	lda	#$00
	sta	$A2
	lda	#$00
	sta	$A1
	lda	#$00
	sta	$A0
	lda	#$00
	sta	$9F
	lda	#$00
	sta	$9E
	lda	#00
	sta	$9D
	lda	#$00
	sta	$9C
	lda	#$00
	sta	$9B
	lda	#$00
	sta	$9A
	lda	#$00
	sta	$99
	lda	#$00
	sta	$98
	lda	#$00
	sta	$97
	lda	#$00
	sta	$96
	lda	#$00
	sta	$95
	lda	#$00
	sta	$94
	lda	#$00
	sta	$93
	lda	#$00
	sta	$92
	lda	#$00
	sta	$91
	lda	#$00
	sta	$90
	lda	#$00
	sta	$8F
	lda	#$00
	sta	$8E
	lda	#$00
	sta	$8D
	lda	#$00
	sta	$8C
	lda	#$00
	sta	$8B
	lda	#$00
	sta	$8A
	lda	#$00
	sta	$89
	lda	#$00
	sta	$88
	lda	#$00
	sta	$87
	lda	#$00
	sta	$86
	lda	#$00
	sta	$85
	lda	#$00
	sta	$84
	lda	#$00
	sta	$83
	lda	#$00
	sta	$82
	lda	#$00
	sta	$81
	lda	#$00
	sta	$80

upd4_21e4	lda	#$00
	sta	$2C
	lda	#$00
	sta	$2D
	lda	#$00
	sta	$2E
	lda	#$00
	sta	$2F
	lda	#$00
	sta	$30
	lda	#$00
	sta	$31
	lda	#$00
	sta	$32
	lda	#$00
	sta	$33
	lda	#$00
	sta	$34
	lda	#$00
	sta	$35
	lda	#$00
	sta	$36
	lda	#$00
	sta	$37
	lda	#$00
	sta	$38
	lda	#$00
	sta	$39

	stx	charram

upd0_12e	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

	ldy	#$ce
	sty	charram

	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

upd4_21e5	lda	#$00
	sta	$3A
	lda	#$00
	sta	$3B
	lda	#$00
	sta	$3C
	lda	#$00
	sta	$3D
	lda	#$00
	sta	$3E
	lda	#$00
	sta	$3F
	lda	#$00
	sta	$40
	lda	#$00
	sta	$41
	lda	#$00
	sta	$42
	lda	#$00
	sta	$43
	lda	#$00
	sta	$44
	lda	#$00
	sta	$45
	lda	#$00
	sta	$46
	lda	#$00
	sta	$47	

	stx	charram

upd1_14e	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	sta	$FF
	lda	#$00
	sta	$FE
	lda	#$00
	sta	$FD
	lda	#$00
	sta	$FC
	lda	#$00
	sta	$FB
	lda	#$00
	sta	$FA
	lda	#$00
	sta	$F9
	lda	#$00
	sta	$F8
	lda	#$00
	sta	$F7
	lda	#$00
	sta	$F6
	lda	#$00
	sta	$F5
	lda	#$00
	sta	$F4
	lda	#$00
	sta	$F3
	lda	#$00
	sta	$F2
	lda	#$00
	sta	$F1
	lda	#$00
	sta	$F0
	lda	#$00
	sta	$EF
	lda	#$00
	sta	$EE
	lda	#$00
	sta	$ED
	lda	#$00
	sta	$EC
	lda	#$00
	sta	$EB
	lda	#$00
	sta	$EA
	lda	#$00
	sta	$E9
	lda	#$00
	sta	$E8
	lda	#$00
	sta	$E7
	lda	#$00
	sta	$E6
	lda	#$00
	sta	$E5
	lda	#$00
	sta	$E4
	lda	#$00
	sta	$E3
	lda	#$00
	sta	$E2
	lda	#$00
	sta	$E1
	lda	#$00
	sta	$E0
	lda	#$00
	sta	$DF
	lda	#$00
	sta	$DE
	lda	#$00
	sta	$DD
	lda	#$00
	sta	$DC
	lda	#$00
	sta	$DB
	lda	#$00
	sta	$DA
	lda	#$00
	sta	$D9
	lda	#$00
	sta	$D8
	
	ldy	#$ce
	sty	charram
	
	lda	#$00
	sta	$D7
	lda	#$00
	sta	$D6
	lda	#$00
	sta	$D5
	lda	#$00
	sta	$D4
	lda	#$00
	sta	$D3
	lda	#$00
	sta	$D2
	lda	#$00
	sta	$D1
	lda	#$00
	sta	$D0
	lda	#$00
	sta	$CF
	lda	#$00
	sta	$CE
	lda	#$00
	sta	$CD
	lda	#$00
	sta	$CC
	lda	#$00
	sta	$CB
	lda	#$00
	sta	$CA
	lda	#$00
	sta	$C9
	lda	#$00
	sta	$C8
	lda	#$00
	sta	$C7
	lda	#$00
	sta	$C6
	lda	#$00
	sta	$C5
	lda	#$00
	sta	$C4
	lda	#$00
	sta	$C3
	lda	#$00
	sta	$C2
	lda	#$00
	sta	$C1
	lda	#$00
	sta	$C0
	lda	#$00
	sta	$BF
	lda	#$00
	sta	$BE
	lda	#$00
	sta	$BD
	lda	#$00
	sta	$BC
	lda	#$00
	sta	$BB
	lda	#$00
	sta	$BA
	lda	#$00
	sta	$B9
	lda	#$00
	sta	$B8
	lda	#$00
	sta	$B7
	lda	#$00
	sta	$B6
	lda	#$00
	sta	$B5
	lda	#$00
	sta	$B4
	lda	#$00
	sta	$B3
	lda	#$00
	sta	$B2
	lda	#$00
	sta	$B1
	lda	#$00
	sta	$B0
	lda	#$00
	sta	$AF
	lda	#$00
	sta	$AE
	lda	#$00
	sta	$AD
	lda	#$00
	sta	$AC
	lda	#$00
	sta	$AB
	lda	#$00
	sta	$AA
	lda	#$00
	sta	$A9
	lda	#$00
	sta	$A8
	lda	#$00
	sta	$A7
	lda	#$00
	sta	$A6
	lda	#$00
	sta	$A5
	lda	#$00
	sta	$A4
	lda	#$00
	sta	$A3
	lda	#$00
	sta	$A2
	lda	#$00
	sta	$A1
	lda	#$00
	sta	$A0
	lda	#$00
	sta	$9F
	lda	#$00
	sta	$9E
	lda	#00
	sta	$9D
	lda	#$00
	sta	$9C
	lda	#$00
	sta	$9B
	lda	#$00
	sta	$9A
	lda	#$00
	sta	$99
	lda	#$00
	sta	$98
	lda	#$00
	sta	$97
	lda	#$00
	sta	$96
	lda	#$00
	sta	$95
	lda	#$00
	sta	$94
	lda	#$00
	sta	$93
	lda	#$00
	sta	$92
	lda	#$00
	sta	$91
	lda	#$00
	sta	$90
	lda	#$00
	sta	$8F
	lda	#$00
	sta	$8E
	lda	#$00
	sta	$8D
	lda	#$00
	sta	$8C
	lda	#$00
	sta	$8B
	lda	#$00
	sta	$8A
	lda	#$00
	sta	$89
	lda	#$00
	sta	$88
	lda	#$00
	sta	$87
	lda	#$00
	sta	$86
	lda	#$00
	sta	$85
	lda	#$00
	sta	$84
	lda	#$00
	sta	$83
	lda	#$00
	sta	$82
	lda	#$00
	sta	$81
	lda	#$00
	sta	$80

upd4_21e6	lda	#$00
	sta	$48
	lda	#$00
	sta	$49
	lda	#$00
	sta	$4A
	lda	#$00
	sta	$4B
	lda	#$00
	sta	$4C
	lda	#$00
	sta	$4D
	lda	#$00
	sta	$4E
	lda	#$00
	sta	$4F
	lda	#$00
	sta	$50
	lda	#$00
	sta	$51
	lda	#$00
	sta	$52
	lda	#$00
	sta	$53
	lda	#$00
	sta	$54
	lda	#$00
	sta	$55

	stx	charram

upd0_16e	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

	ldy	#$ce
	sty	charram

	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

upd4_21e7	lda	#$00
	sta	$56
	lda	#$00
	sta	$57
	lda	#$00
	sta	$58
	lda	#$00
	sta	$59
	lda	#$00
	sta	$5A
	lda	#$00
	sta	$5B
	lda	#$00
	sta	$5C
	lda	#$00
	sta	$5D
	lda	#$00
	sta	$5E
	lda	#$00
	sta	$5F
	lda	#$00
	sta	$60
	lda	#$00
	sta	$61
	lda	#$00
	sta	$62
	lda	#$00
	sta	$63

	stx	charram

upd1_18e	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	sta	$FF
	lda	#$00
	sta	$FE
	lda	#$00
	sta	$FD
	lda	#$00
	sta	$FC
	lda	#$00
	sta	$FB
	lda	#$00
	sta	$FA
	lda	#$00
	sta	$F9
	lda	#$00
	sta	$F8
	lda	#$00
	sta	$F7
	lda	#$00
	sta	$F6
	lda	#$00
	sta	$F5
	lda	#$00
	sta	$F4
	lda	#$00
	sta	$F3
	lda	#$00
	sta	$F2
	lda	#$00
	sta	$F1
	lda	#$00
	sta	$F0
	lda	#$00
	sta	$EF
	lda	#$00
	sta	$EE
	lda	#$00
	sta	$ED
	lda	#$00
	sta	$EC
	lda	#$00
	sta	$EB
	lda	#$00
	sta	$EA
	lda	#$00
	sta	$E9
	lda	#$00
	sta	$E8
	lda	#$00
	sta	$E7
	lda	#$00
	sta	$E6
	lda	#$00
	sta	$E5
	lda	#$00
	sta	$E4
	lda	#$00
	sta	$E3
	lda	#$00
	sta	$E2
	lda	#$00
	sta	$E1
	lda	#$00
	sta	$E0
	lda	#$00
	sta	$DF
	lda	#$00
	sta	$DE
	lda	#$00
	sta	$DD
	lda	#$00
	sta	$DC
	lda	#$00
	sta	$DB
	lda	#$00
	sta	$DA
	lda	#$00
	sta	$D9
	lda	#$00
	sta	$D8

	ldy	#$ce
	sty	charram

	lda	#$00
	sta	$D7
	lda	#$00
	sta	$D6
	lda	#$00
	sta	$D5
	lda	#$00
	sta	$D4
	lda	#$00
	sta	$D3
	lda	#$00
	sta	$D2
	lda	#$00
	sta	$D1
	lda	#$00
	sta	$D0
	lda	#$00
	sta	$CF
	lda	#$00
	sta	$CE
	lda	#$00
	sta	$CD
	lda	#$00
	sta	$CC
	lda	#$00
	sta	$CB
	lda	#$00
	sta	$CA
	lda	#$00
	sta	$C9
	lda	#$00
	sta	$C8
	lda	#$00
	sta	$C7
	lda	#$00
	sta	$C6
	lda	#$00
	sta	$C5
	lda	#$00
	sta	$C4
	lda	#$00
	sta	$C3
	lda	#$00
	sta	$C2
	lda	#$00
	sta	$C1
	lda	#$00
	sta	$C0
	lda	#$00
	sta	$BF
	lda	#$00
	sta	$BE
	lda	#$00
	sta	$BD
	lda	#$00
	sta	$BC
	lda	#$00
	sta	$BB
	lda	#$00
	sta	$BA
	lda	#$00
	sta	$B9
	lda	#$00
	sta	$B8
	lda	#$00
	sta	$B7
	lda	#$00
	sta	$B6
	lda	#$00
	sta	$B5
	lda	#$00
	sta	$B4
	lda	#$00
	sta	$B3
	lda	#$00
	sta	$B2
	lda	#$00
	sta	$B1
	lda	#$00
	sta	$B0
	lda	#$00
	sta	$AF
	lda	#$00
	sta	$AE
	lda	#$00
	sta	$AD
	lda	#$00
	sta	$AC
	lda	#$00
	sta	$AB
	lda	#$00
	sta	$AA
	lda	#$00
	sta	$A9
	lda	#$00
	sta	$A8
	lda	#$00
	sta	$A7
	lda	#$00
	sta	$A6
	lda	#$00
	sta	$A5
	lda	#$00
	sta	$A4
	lda	#$00
	sta	$A3
	lda	#$00
	sta	$A2
	lda	#$00
	sta	$A1
	lda	#$00
	sta	$A0
	lda	#$00
	sta	$9F
	lda	#$00
	sta	$9E
	lda	#00
	sta	$9D
	lda	#$00
	sta	$9C
	lda	#$00
	sta	$9B
	lda	#$00
	sta	$9A
	lda	#$00
	sta	$99
	lda	#$00
	sta	$98
	lda	#$00
	sta	$97
	lda	#$00
	sta	$96
	lda	#$00
	sta	$95
	lda	#$00
	sta	$94
	lda	#$00
	sta	$93
	lda	#$00
	sta	$92
	lda	#$00
	sta	$91
	lda	#$00
	sta	$90
	lda	#$00
	sta	$8F
	lda	#$00
	sta	$8E
	lda	#$00
	sta	$8D
	lda	#$00
	sta	$8C
	lda	#$00
	sta	$8B
	lda	#$00
	sta	$8A
	lda	#$00
	sta	$89
	lda	#$00
	sta	$88
	lda	#$00
	sta	$87
	lda	#$00
	sta	$86
	lda	#$00
	sta	$85
	lda	#$00
	sta	$84
	lda	#$00
	sta	$83
	lda	#$00
	sta	$82
	lda	#$00
	sta	$81
	lda	#$00
	sta	$80

upd4_21e8	lda	#$00
	sta	$64
	lda	#$00
	sta	$65
	lda	#$00
	sta	$66
	lda	#$00
	sta	$67
	lda	#$00
	sta	$68
	lda	#$00
	sta	$69
	lda	#$00
	sta	$6A
	lda	#$00
	sta	$6B
	lda	#$00
	sta	$6C
	lda	#$00
	sta	$6D
	lda	#$00
	sta	$6E
	lda	#$00
	sta	$6F
	lda	#$00
	sta	$70
	lda	#$00
	sta	$71

	stx	charram

upd0_20e	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

	ldy	#$ce
	sty	charram

	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

upd4_21e9	lda	#$00
	sta	$72
	lda	#$00
	sta	$73
	lda	#$00
	sta	$74
	lda	#$00
	sta	$75
	lda	#$00
	sta	$76
	lda	#$00
	sta	$77
	lda	#$00
	sta	$78
	lda	#$00
	sta	$79
	lda	#$00
	sta	$7A
	lda	#$00
	sta	$7B
	lda	#$00
	sta	$7C
	lda	#$00
	sta	$7D
	lda	#$00
	sta	$7E
	lda	#$00
	sta	$7F

	stx	charram

upd1_22e	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	sta	$FF
	lda	#$00
	sta	$FE
	lda	#$00
	sta	$FD
	lda	#$00
	sta	$FC
	lda	#$00
	sta	$FB
	lda	#$00
	sta	$FA
	lda	#$00
	sta	$F9
	lda	#$00
	sta	$F8
	lda	#$00
	sta	$F7
	lda	#$00
	sta	$F6
	lda	#$00
	sta	$F5
	lda	#$00
	sta	$F4
	lda	#$00
	sta	$F3
	lda	#$00
	sta	$F2
	lda	#$00
	sta	$F1
	lda	#$00
	sta	$F0
	lda	#$00
	sta	$EF
	lda	#$00
	sta	$EE
	lda	#$00
	sta	$ED
	lda	#$00
	sta	$EC
	lda	#$00
	sta	$EB
	lda	#$00
	sta	$EA
	lda	#$00
	sta	$E9
	lda	#$00
	sta	$E8
	lda	#$00
	sta	$E7
	lda	#$00
	sta	$E6
	lda	#$00
	sta	$E5
	lda	#$00
	sta	$E4
	lda	#$00
	sta	$E3
	lda	#$00
	sta	$E2
	lda	#$00
	sta	$E1
	lda	#$00
	sta	$E0
	lda	#$00
	sta	$DF
	lda	#$00
	sta	$DE
	lda	#$00
	sta	$DD
	lda	#$00
	sta	$DC
	lda	#$00
	sta	$DB
	lda	#$00
	sta	$DA
	lda	#$00
	sta	$D9
	lda	#$00
	sta	$D8
	
	ldy	#$c8
	sty	charram

	lda	#$00
	sta	$D7
	lda	#$00
	sta	$D6
	lda	#$00
	sta	$D5
	lda	#$00
	sta	$D4
	lda	#$00
	sta	$D3
	lda	#$00
	sta	$D2
	lda	#$00
	sta	$D1
	lda	#$00
	sta	$D0
	lda	#$00
	sta	$CF
	lda	#$00
	sta	$CE
	lda	#$00
	sta	$CD
	lda	#$00
	sta	$CC
	lda	#$00
	sta	$CB
	lda	#$00
	sta	$CA
	lda	#$00
	sta	$C9
	lda	#$00
	sta	$C8
	lda	#$00
	sta	$C7
	lda	#$00
	sta	$C6
	lda	#$00
	sta	$C5
	lda	#$00
	sta	$C4
	lda	#$00
	sta	$C3
	lda	#$00
	sta	$C2
	lda	#$00
	sta	$C1
	lda	#$00
	sta	$C0
	lda	#$00
	sta	$BF
	lda	#$00
	sta	$BE
	lda	#$00
	sta	$BD
	lda	#$00
	sta	$BC
	lda	#$00
	sta	$BB
	lda	#$00
	sta	$BA
	lda	#$00
	sta	$B9
	lda	#$00
	sta	$B8
	lda	#$00
	sta	$B7
	lda	#$00
	sta	$B6
	lda	#$00
	sta	$B5
	lda	#$00
	sta	$B4
	lda	#$00
	sta	$B3
	lda	#$00
	sta	$B2
	lda	#$00
	sta	$B1
	lda	#$00
	sta	$B0
	lda	#$00
	sta	$AF
	lda	#$00
	sta	$AE
	lda	#$00
	sta	$AD
	lda	#$00
	sta	$AC
	lda	#$00
	sta	$AB
	lda	#$00
	sta	$AA
	lda	#$00
	sta	$A9
	lda	#$00
	sta	$A8
	lda	#$00
	sta	$A7
	lda	#$00
	sta	$A6
	lda	#$00
	sta	$A5
	lda	#$00
	sta	$A4
	lda	#$00
	sta	$A3
	lda	#$00
	sta	$A2
	lda	#$00
	sta	$A1
	lda	#$00
	sta	$A0
	lda	#$00
	sta	$9F
	lda	#$00
	sta	$9E
	lda	#00
	sta	$9D
	lda	#$00
	sta	$9C
	lda	#$00
	sta	$9B
	lda	#$00
	sta	$9A
	lda	#$00
	sta	$99
	lda	#$00
	sta	$98
	lda	#$00
	sta	$97
	lda	#$00
	sta	$96
	lda	#$00
	sta	$95
	lda	#$00
	sta	$94
	lda	#$00
	sta	$93
	lda	#$00
	sta	$92
	lda	#$00
	sta	$91
	lda	#$00
	sta	$90
	lda	#$00
	sta	$8F
	lda	#$00
	sta	$8E
	lda	#$00
	sta	$8D
	lda	#$00
	sta	$8C
	lda	#$00
	sta	$8B
	lda	#$00
	sta	$8A
	lda	#$00
	sta	$89
	lda	#$00
	sta	$88
	lda	#$00
	sta	$87
	lda	#$00
	sta	$86
	lda	#$00
	sta	$85
	lda	#$00
	sta	$84
	lda	#$00
	sta	$83
	lda	#$00
	sta	$82
	lda	#$00
	sta	$81
	lda	#$00
	sta	$80
	
upd4_21ea	lda	#$00
	sta	$0200
	lda	#$00
	sta	$0201
	lda	#$00
	sta	$0202
	lda	#$00
	sta	$0203
	lda	#$00
	sta	$0204
	lda	#$00
	sta	$0205
	lda	#$00
	sta	$0206
	lda	#$00
	sta	$0207
	lda	#$00
	sta	$0208
	lda	#$00
	sta	$0209
	lda	#$00
	sta	$020A
	nop
	nop
	
	stx	charram

upd0_24e	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

	ldy	#$8e
	sty	charram

	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

upd4_21eb	lda	#$00
	sta	$020B
	lda	#$00
	sta	$020C
	lda	#$00
	sta	$020D
	lda	#$00
	sta	$020E
	lda	#$00
	sta	$020F
	lda	#$00
	sta	$0228
	lda	#$00
	sta	$0229
	lda	#$00
	sta	$022A
	lda	#$00
	sta	$022B
	lda	#$00
	sta	$022C
	lda	#$00
	sta	$022D
	nop
	nop
	
	stx	charram

upd1_26e	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	sta	$FF
	lda	#$00
	sta	$FE
	lda	#$00
	sta	$FD
	lda	#$00
	sta	$FC
	lda	#$00
	sta	$FB
	lda	#$00
	sta	$FA
	lda	#$00
	sta	$F9
	lda	#$00
	sta	$F8
	lda	#$00
	sta	$F7
	lda	#$00
	sta	$F6
	lda	#$00
	sta	$F5
	lda	#$00
	sta	$F4
	lda	#$00
	sta	$F3
	lda	#$00
	sta	$F2
	lda	#$00
	sta	$F1
	lda	#$00
	sta	$F0
	lda	#$00
	sta	$EF
	lda	#$00
	sta	$EE
	lda	#$00
	sta	$ED
	lda	#$00
	sta	$EC
	lda	#$00
	sta	$EB
	lda	#$00
	sta	$EA
	lda	#$00
	sta	$E9
	lda	#$00
	sta	$E8
	lda	#$00
	sta	$E7
	lda	#$00
	sta	$E6
	lda	#$00
	sta	$E5
	lda	#$00
	sta	$E4
	lda	#$00
	sta	$E3
	lda	#$00
	sta	$E2
	lda	#$00
	sta	$E1
	lda	#$00
	sta	$E0
	lda	#$00
	sta	$DF
	lda	#$00
	sta	$DE
	lda	#$00
	sta	$DD
	lda	#$00
	sta	$DC
	lda	#$00
	sta	$DB
	lda	#$00
	sta	$DA
	lda	#$00
	sta	$D9
	lda	#$00
	sta	$D8
	
	ldy	#$8e
	sty	charram
	
	lda	#$00
	sta	$D7
	lda	#$00
	sta	$D6
	lda	#$00
	sta	$D5
	lda	#$00
	sta	$D4
	lda	#$00
	sta	$D3
	lda	#$00
	sta	$D2
	lda	#$00
	sta	$D1
	lda	#$00
	sta	$D0
	lda	#$00
	sta	$CF
	lda	#$00
	sta	$CE
	lda	#$00
	sta	$CD
	lda	#$00
	sta	$CC
	lda	#$00
	sta	$CB
	lda	#$00
	sta	$CA
	lda	#$00
	sta	$C9
	lda	#$00
	sta	$C8
	lda	#$00
	sta	$C7
	lda	#$00
	sta	$C6
	lda	#$00
	sta	$C5
	lda	#$00
	sta	$C4
	lda	#$00
	sta	$C3
	lda	#$00
	sta	$C2
	lda	#$00
	sta	$C1
	lda	#$00
	sta	$C0
	lda	#$00
	sta	$BF
	lda	#$00
	sta	$BE
	lda	#$00
	sta	$BD
	lda	#$00
	sta	$BC
	lda	#$00
	sta	$BB
	lda	#$00
	sta	$BA
	lda	#$00
	sta	$B9
	lda	#$00
	sta	$B8
	lda	#$00
	sta	$B7
	lda	#$00
	sta	$B6
	lda	#$00
	sta	$B5
	lda	#$00
	sta	$B4
	lda	#$00
	sta	$B3
	lda	#$00
	sta	$B2
	lda	#$00
	sta	$B1
	lda	#$00
	sta	$B0
	lda	#$00
	sta	$AF
	lda	#$00
	sta	$AE
	lda	#$00
	sta	$AD
	lda	#$00
	sta	$AC
	lda	#$00
	sta	$AB
	lda	#$00
	sta	$AA
	lda	#$00
	sta	$A9
	lda	#$00
	sta	$A8
	lda	#$00
	sta	$A7
	lda	#$00
	sta	$A6
	lda	#$00
	sta	$A5
	lda	#$00
	sta	$A4
	lda	#$00
	sta	$A3
	lda	#$00
	sta	$A2
	lda	#$00
	sta	$A1
	lda	#$00
	sta	$A0
	lda	#$00
	sta	$9F
	lda	#$00
	sta	$9E
	lda	#00
	sta	$9D
	lda	#$00
	sta	$9C
	lda	#$00
	sta	$9B
	lda	#$00
	sta	$9A
	lda	#$00
	sta	$99
	lda	#$00
	sta	$98
	lda	#$00
	sta	$97
	lda	#$00
	sta	$96
	lda	#$00
	sta	$95
	lda	#$00
	sta	$94
	lda	#$00
	sta	$93
	lda	#$00
	sta	$92
	lda	#$00
	sta	$91
	lda	#$00
	sta	$90
	lda	#$00
	sta	$8F
	lda	#$00
	sta	$8E
	lda	#$00
	sta	$8D
	lda	#$00
	sta	$8C
	lda	#$00
	sta	$8B
	lda	#$00
	sta	$8A
	lda	#$00
	sta	$89
	lda	#$00
	sta	$88
	lda	#$00
	sta	$87
	lda	#$00
	sta	$86
	lda	#$00
	sta	$85
	lda	#$00
	sta	$84
	lda	#$00
	sta	$83
	lda	#$00
	sta	$82
	lda	#$00
	sta	$81
	lda	#$00
	sta	$80

upd4_21ec	lda	#$00
	sta	$022E
	lda	#$00
	sta	$022F
	lda	#$00
	sta	$0230
	lda	#$00
	sta	$0231
	lda	#$00
	sta	$0232
	lda	#$00
	sta	$0233
	lda	#$00
	sta	$0234
	lda	#$00
	sta	$0235
	lda	#$00
	sta	$0236
	lda	#$00
	sta	$0237
	lda	#$00
	sta	$0238
	nop
	nop

	stx	charram	

upd0_1o	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

upd1_2o	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	sta	$FF
	lda	#$00
	sta	$FE
	lda	#$00
	sta	$FD
	lda	#$00
	sta	$FC
	lda	#$00
	sta	$FB
	lda	#$00
	sta	$FA
	lda	#$00
	sta	$F9
	lda	#$00
	sta	$F8
	lda	#$00
	sta	$F7
	lda	#$00
	sta	$F6
	lda	#$00
	sta	$F5
	lda	#$00
	sta	$F4
	lda	#$00
	sta	$F3
	lda	#$00
	sta	$F2
	lda	#$00
	sta	$F1
	lda	#$00
	sta	$F0
	lda	#$00
	sta	$EF
	lda	#$00
	sta	$EE
	lda	#$00
	sta	$ED
	lda	#$00
	sta	$EC
	lda	#$00
	sta	$EB
	lda	#$00
	sta	$EA
	lda	#$00
	sta	$E9
	lda	#$00
	sta	$E8
	lda	#$00
	sta	$E7
	lda	#$00
	sta	$E6
	lda	#$00
	sta	$E5
	lda	#$00
	sta	$E4
	lda	#$00
	sta	$E3
	lda	#$00
	sta	$E2
	lda	#$00
	sta	$E1
	lda	#$00
	sta	$E0
	lda	#$00
	sta	$DF
	lda	#$00
	sta	$DE
	lda	#$00
	sta	$DD
	lda	#$00
	sta	$DC
	lda	#$00
	sta	$DB
	lda	#$00
	sta	$DA
	lda	#$00
	sta	$D9
	lda	#$00
	sta	$D8
	lda	#$00
	sta	$D7
	lda	#$00
	sta	$D6
	lda	#$00
	sta	$D5
	lda	#$00
	sta	$D4
	lda	#$00
	sta	$D3
	lda	#$00
	sta	$D2
	lda	#$00
	sta	$D1
	lda	#$00
	sta	$D0
	lda	#$00
	sta	$CF
	lda	#$00
	sta	$CE
	lda	#$00
	sta	$CD
	lda	#$00
	sta	$CC
	lda	#$00
	sta	$CB
	lda	#$00
	sta	$CA
	lda	#$00
	sta	$C9
	lda	#$00
	sta	$C8
	lda	#$00
	sta	$C7
	lda	#$00
	sta	$C6
	lda	#$00
	sta	$C5
	lda	#$00
	sta	$C4
	lda	#$00
	sta	$C3
	lda	#$00
	sta	$C2
	lda	#$00
	sta	$C1
	lda	#$00
	sta	$C0
	lda	#$00
	sta	$BF
	lda	#$00
	sta	$BE
	lda	#$00
	sta	$BD
	lda	#$00
	sta	$BC
	lda	#$00
	sta	$BB
	lda	#$00
	sta	$BA
	lda	#$00
	sta	$B9
	lda	#$00
	sta	$B8
	lda	#$00
	sta	$B7
	lda	#$00
	sta	$B6
	lda	#$00
	sta	$B5
	lda	#$00
	sta	$B4
	lda	#$00
	sta	$B3
	lda	#$00
	sta	$B2
	lda	#$00
	sta	$B1
	lda	#$00
	sta	$B0
	lda	#$00
	sta	$AF
	lda	#$00
	sta	$AE
	lda	#$00
	sta	$AD
	lda	#$00
	sta	$AC
	lda	#$00
	sta	$AB
	lda	#$00
	sta	$AA
	lda	#$00
	sta	$A9
	lda	#$00
	sta	$A8
	lda	#$00
	sta	$A7
	lda	#$00
	sta	$A6
	lda	#$00
	sta	$A5
	lda	#$00
	sta	$A4
	lda	#$00
	sta	$A3
	lda	#$00
	sta	$A2
	lda	#$00
	sta	$A1
	lda	#$00
	sta	$A0
	lda	#$00
	sta	$9F
	lda	#$00
	sta	$9E
	lda	#00
	sta	$9D
	lda	#$00
	sta	$9C
	lda	#$00
	sta	$9B
	lda	#$00
	sta	$9A
	lda	#$00
	sta	$99
	lda	#$00
	sta	$98
	lda	#$00
	sta	$97
	lda	#$00
	sta	$96
	lda	#$00
	sta	$95
	lda	#$00
	sta	$94
	lda	#$00
	sta	$93
	lda	#$00
	sta	$92
	lda	#$00
	sta	$91
	lda	#$00
	sta	$90
	lda	#$00
	sta	$8F
	lda	#$00
	sta	$8E
	lda	#$00
	sta	$8D
	lda	#$00
	sta	$8C
	lda	#$00
	sta	$8B
	lda	#$00
	sta	$8A
	lda	#$00
	sta	$89
	lda	#$00
	sta	$88
	lda	#$00
	sta	$87
	lda	#$00
	sta	$86
	lda	#$00
	sta	$85
	lda	#$00
	sta	$84
	lda	#$00
	sta	$83
	lda	#$00
	sta	$82
	lda	#$00
	sta	$81
	lda	#$00
	sta	$80

upd2_17o	lda	#$00
	sta	$1A80
	lda	#$00
	sta	$1A81
	lda	#$00
	sta	$1A82
	lda	#$00
	sta	$1A83
	lda	#$00
	sta	$1A84
	lda	#$00
	sta	$1A85
	lda	#$00
	sta	$1A86
	lda	#$00
	sta	$1A87
	lda	#$00
	sta	$1A88
	lda	#$00
	sta	$1A89
	lda	#$00
	sta	$1A8A
	lda	#$00
	sta	$1A8B
	lda	#$00
	sta	$1A8C
	lda	#$00
	sta	$1A8D
	lda	#$00
	sta	$1A8E
	lda	#$00
	sta	$1A8F
	lda	#$00
	sta	$1A90
	lda	#$00
	sta	$1A91
	lda	#$00
	sta	$1A92
	lda	#$00
	sta	$1A93
	lda	#$00
	sta	$1A94
	lda	#$00
	sta	$1A95
	lda	#$00
	sta	$1A96
	lda	#$00
	sta	$1A97
	lda	#$00
	sta	$1A98
	lda	#$00
	sta	$1A99
	lda	#$00
	sta	$1A9A
	lda	#$00
	sta	$1A9B
	lda	#$00
	sta	$1A9C
	lda	#$00
	sta	$1A9D
	lda	#$00
	sta	$1A9E
	lda	#$00
	sta	$1A9F
	lda	#$00
	sta	$1AA0
	lda	#$00
	sta	$1AA1
	lda	#$00
	sta	$1AA2
	lda	#$00
	sta	$1AA3
	lda	#$00
	sta	$1AA4
	lda	#$00
	sta	$1AA5
	lda	#$00
	sta	$1AA6
	lda	#$00
	sta	$1AA7
	lda	#$00
	sta	$1AA8
	lda	#$00
	sta	$1AA9
	lda	#$00
	sta	$1AAA
	lda	#$00
	sta	$1AAB
	lda	#$00
	sta	$1AAC
	lda	#$00
	sta	$1AAD
	lda	#$00
	sta	$1AAE
	lda	#$00
	sta	$1AAF
	lda	#$00
	sta	$1AB0
	lda	#$00
	sta	$1AB1
	lda	#$00
	sta	$1AB2
	lda	#$00
	sta	$1AB3
	lda	#$00
	sta	$1AB4
	lda	#$00
	sta	$1AB5
	lda	#$00
	sta	$1AB6
	lda	#$00
	sta	$1AB7
	lda	#$00
	sta	$1AB8
	lda	#$00
	sta	$1AB9
	lda	#$00
	sta	$1ABA
	lda	#$00
	sta	$1ABB
	lda	#$00
	sta	$1ABC
	lda	#$00
	sta	$1ABD
	lda	#$00
	sta	$1ABE
	lda	#$00
	sta	$1ABF
	lda	#$00
	sta	$1AC0
	lda	#$00
	sta	$1AC1
	lda	#$00
	sta	$1AC2
	lda	#$00
	sta	$1AC3
	lda	#$00
	sta	$1AC4
	lda	#$00
	sta	$1AC5
	lda	#$00
	sta	$1AC6
	lda	#$00
	sta	$1AC7
	lda	#$00
	sta	$1AC8
	lda	#$00
	sta	$1AC9
	lda	#$00
	sta	$1ACA
	lda	#$00
	sta	$1ACB
	lda	#$00
	sta	$1ACC
	lda	#$00
	sta	$1ACD
	lda	#$00
	sta	$1ACE
	lda	#$00
	sta	$1ACF
	lda	#$00
	sta	$1AD0
	lda	#$00
	sta	$1AD1
	lda	#$00
	sta	$1AD2
	lda	#$00
	sta	$1AD3
	lda	#$00
	sta	$1AD4
	lda	#$00
	sta	$1AD5
	lda	#$00
	sta	$1AD6
	lda	#$00
	sta	$1AD7
	lda	#$00
	sta	$1AD8
	lda	#$00
	sta	$1AD9
	lda	#$00
	sta	$1ADA
	lda	#$00
	sta	$1ADB
	lda	#$00
	sta	$1ADC
	lda	#$00
	sta	$1ADD
	lda	#$00
	sta	$1ADE
	lda	#$00
	sta	$1ADF
	lda	#$00
	sta	$1AE0
	lda	#$00
	sta	$1AE1
	lda	#$00
	sta	$1AE2
	lda	#$00
	sta	$1AE3
	lda	#$00
	sta	$1AE4
	lda	#$00
	sta	$1AE5
	lda	#$00
	sta	$1AE6
	lda	#$00
	sta	$1AE7
	lda	#$00
	sta	$1AE8
	lda	#$00
	sta	$1AE9
	lda	#$00
	sta	$1AEA
	lda	#$00
	sta	$1AEB
	lda	#$00
	sta	$1AEC
	lda	#$00
	sta	$1AED
	lda	#$00
	sta	$1AEE
	lda	#$00
	sta	$1AEF
	lda	#$00
	sta	$1AF0
	lda	#$00
	sta	$1AF1
	lda	#$00
	sta	$1AF2
	lda	#$00
	sta	$1AF3
	lda	#$00
	sta	$1AF4
	lda	#$00
	sta	$1AF5
	lda	#$00
	sta	$1AF6
	lda	#$00
	sta	$1AF7
	lda	#$00
	sta	$1AF8
	lda	#$00
	sta	$1AF9
	lda	#$00
	sta	$1AFA
	lda	#$00
	sta	$1AFB
	lda	#$00
	sta	$1AFC
	lda	#$00
	sta	$1AFD
	lda	#$00
	sta	$1AFE
	lda	#$00
	sta	$1AFF
	lda	#$00
	sta	$1B00
	lda	#$00
	sta	$1B01
	lda	#$00
	sta	$1B02
	lda	#$00
	sta	$1B03
	lda	#$00
	sta	$1B04
	lda	#$00
	sta	$1B05
	lda	#$00
	sta	$1B06
	lda	#$00
	sta	$1B07
	lda	#$00
	sta	$1B08
	lda	#$00
	sta	$1B09
	lda	#$00
	sta	$1B0A
	lda	#$00
	sta	$1B0B
	lda	#$00
	sta	$1B0C
	lda	#$00
	sta	$1B0D
	lda	#$00
	sta	$1B0E
	lda	#$00
	sta	$1B0F
	lda	#$00
	sta	$1B10
	lda	#$00
	sta	$1B11
	lda	#$00
	sta	$1B12
	lda	#$00
	sta	$1B13
	lda	#$00
	sta	$1B14
	lda	#$00
	sta	$1B15
	lda	#$00
	sta	$1B16
	lda	#$00
	sta	$1B17
	lda	#$00
	sta	$1B18
	lda	#$00
	sta	$1B19
	lda	#$00
	sta	$1B1A
	lda	#$00
	sta	$1B1B
	lda	#$00
	sta	$1B1C
	lda	#$00
	sta	$1B1D
	lda	#$00
	sta	$1B1E
	lda	#$00
	sta	$1B1F
	lda	#$00
	sta	$1B20
	lda	#$00
	sta	$1B21
	lda	#$00
	sta	$1B22
	lda	#$00
	sta	$1B23
	lda	#$00
	sta	$1B24
	lda	#$00
	sta	$1B25
	lda	#$00
	sta	$1B26
	lda	#$00
	sta	$1B27
	lda	#$00
	sta	$1B28
	lda	#$00
	sta	$1B29
	lda	#$00
	sta	$1B2A
	lda	#$00
	sta	$1B2B
	lda	#$00
	sta	$1B2C
	lda	#$00
	sta	$1B2D
	lda	#$00
	sta	$1B2E
	lda	#$00
	sta	$1B2F
	lda	#$00
	sta	$1B30
	lda	#$00
	sta	$1B31
	lda	#$00
	sta	$1B32
	lda	#$00
	sta	$1B33
	lda	#$00
	sta	$1B34
	lda	#$00
	sta	$1B35
	lda	#$00
	sta	$1B36
	lda	#$00
	sta	$1B37
	lda	#$00
	sta	$1B38
	lda	#$00
	sta	$1B39
	lda	#$00
	sta	$1B3A
	lda	#$00
	sta	$1B3B
	lda	#$00
	sta	$1B3C
	lda	#$00
	sta	$1B3D
	lda	#$00
	sta	$1B3E
	lda	#$00
	sta	$1B3F

upd3_19o	lda	#$00
	sta	$1B40
	lda	#$00
	sta	$1B41
	lda	#$00
	sta	$1B42
	lda	#$00
	sta	$1B43
	lda	#$00
	sta	$1B44
	lda	#$00
	sta	$1B45
	lda	#$00
	sta	$1B46
	lda	#$00
	sta	$1B47
	lda	#$00
	sta	$1B48
	lda	#$00
	sta	$1B49
	lda	#$00
	sta	$1B4A
	lda	#$00
	sta	$1B4B
	lda	#$00
	sta	$1B4C
	lda	#$00
	sta	$1B4D
	lda	#$00
	sta	$1B4E
	lda	#$00
	sta	$1B4F
	lda	#$00
	sta	$1B50
	lda	#$00
	sta	$1B51
	lda	#$00
	sta	$1B52
	lda	#$00
	sta	$1B53
	lda	#$00
	sta	$1B54
	lda	#$00
	sta	$1B55
	lda	#$00
	sta	$1B56
	lda	#$00
	sta	$1B57
	lda	#$00
	sta	$1B58
	lda	#$00
	sta	$1B59
	lda	#$00
	sta	$1B5A
	lda	#$00
	sta	$1B5B
	lda	#$00
	sta	$1B5C
	lda	#$00
	sta	$1B5D
	lda	#$00
	sta	$1B5E
	lda	#$00
	sta	$1B5F
	lda	#$00
	sta	$1B60
	lda	#$00
	sta	$1B61
	lda	#$00
	sta	$1B62
	lda	#$00
	sta	$1B63
	lda	#$00
	sta	$1B64
	lda	#$00
	sta	$1B65
	lda	#$00
	sta	$1B66
	lda	#$00
	sta	$1B67
	lda	#$00
	sta	$1B68
	lda	#$00
	sta	$1B69
	lda	#$00
	sta	$1B6A
	lda	#$00
	sta	$1B6B
	lda	#$00
	sta	$1B6C
	lda	#$00
	sta	$1B6D
	lda	#$00
	sta	$1B6E
	lda	#$00
	sta	$1B6F
	lda	#$00
	sta	$1B70
	lda	#$00
	sta	$1B71
	lda	#$00
	sta	$1B72
	lda	#$00
	sta	$1B73
	lda	#$00
	sta	$1B74
	lda	#$00
	sta	$1B75
	lda	#$00
	sta	$1B76
	lda	#$00
	sta	$1B77
	lda	#$00
	sta	$1B78
	lda	#$00
	sta	$1B79
	lda	#$00
	sta	$1B7A
	lda	#$00
	sta	$1B7B
	lda	#$00
	sta	$1B7C
	lda	#$00
	sta	$1B7D
	lda	#$00
	sta	$1B7E
	lda	#$00
	sta	$1B7F
	lda	#$00
	sta	$1B80
	lda	#$00
	sta	$1B81
	lda	#$00
	sta	$1B82
	lda	#$00
	sta	$1B83
	lda	#$00
	sta	$1B84
	lda	#$00
	sta	$1B85
	lda	#$00
	sta	$1B86
	lda	#$00
	sta	$1B87
	lda	#$00
	sta	$1B88
	lda	#$00
	sta	$1B89
	lda	#$00
	sta	$1B8A
	lda	#$00
	sta	$1B8B
	lda	#$00
	sta	$1B8C
	lda	#$00
	sta	$1B8D
	lda	#$00
	sta	$1B8E
	lda	#$00
	sta	$1B8F
	lda	#$00
	sta	$1B90
	lda	#$00
	sta	$1B91
	lda	#$00
	sta	$1B92
	lda	#$00
	sta	$1B93
	lda	#$00
	sta	$1B94
	lda	#$00
	sta	$1B95
	lda	#$00
	sta	$1B96
	lda	#$00
	sta	$1B97
	lda	#$00
	sta	$1B98
	lda	#$00
	sta	$1B99
	lda	#$00
	sta	$1B9A
	lda	#$00
	sta	$1B9B
	lda	#$00
	sta	$1B9C
	lda	#$00
	sta	$1B9D
	lda	#$00
	sta	$1B9E
	lda	#$00
	sta	$1B9F
	lda	#$00
	sta	$1BA0
	lda	#$00
	sta	$1BA1
	lda	#$00
	sta	$1BA2
	lda	#$00
	sta	$1BA3
	lda	#$00
	sta	$1BA4
	lda	#$00
	sta	$1BA5
	lda	#$00
	sta	$1BA6
	lda	#$00
	sta	$1BA7
	lda	#$00
	sta	$1BA8
	lda	#$00
	sta	$1BA9
	lda	#$00
	sta	$1BAA
	lda	#$00
	sta	$1BAB
	lda	#$00
	sta	$1BAC
	lda	#$00
	sta	$1BAD
	lda	#$00
	sta	$1BAE
	lda	#$00
	sta	$1BAF
	lda	#$00
	sta	$1BB0
	lda	#$00
	sta	$1BB1
	lda	#$00
	sta	$1BB2
	lda	#$00
	sta	$1BB3
	lda	#$00
	sta	$1BB4
	lda	#$00
	sta	$1BB5
	lda	#$00
	sta	$1BB6
	lda	#$00
	sta	$1BB7
	lda	#$00
	sta	$1BB8
	lda	#$00
	sta	$1BB9
	lda	#$00
	sta	$1BBA
	lda	#$00
	sta	$1BBB
	lda	#$00
	sta	$1BBC
	lda	#$00
	sta	$1BBD
	lda	#$00
	sta	$1BBE
	lda	#$00
	sta	$1BBF
	lda	#$00
	sta	$1BC0
	lda	#$00
	sta	$1BC1
	lda	#$00
	sta	$1BC2
	lda	#$00
	sta	$1BC3
	lda	#$00
	sta	$1BC4
	lda	#$00
	sta	$1BC5
	lda	#$00
	sta	$1BC6
	lda	#$00
	sta	$1BC7
	lda	#$00
	sta	$1BC8
	lda	#$00
	sta	$1BC9
	lda	#$00
	sta	$1BCA
	lda	#$00
	sta	$1BCB
	lda	#$00
	sta	$1BCC
	lda	#$00
	sta	$1BCD
	lda	#$00
	sta	$1BCE
	lda	#$00
	sta	$1BCF
	lda	#$00
	sta	$1BD0
	lda	#$00
	sta	$1BD1
	lda	#$00
	sta	$1BD2
	lda	#$00
	sta	$1BD3
	lda	#$00
	sta	$1BD4
	lda	#$00
	sta	$1BD5
	lda	#$00
	sta	$1BD6
	lda	#$00
	sta	$1BD7
	lda	#$00
	sta	$1BD8
	lda	#$00
	sta	$1BD9
	lda	#$00
	sta	$1BDA
	lda	#$00
	sta	$1BDB
	lda	#$00
	sta	$1BDC
	lda	#$00
	sta	$1BDD
	lda	#$00
	sta	$1BDE
	lda	#$00
	sta	$1BDF
	lda	#$00
	sta	$1BE0
	lda	#$00
	sta	$1BE1
	lda	#$00
	sta	$1BE2
	lda	#$00
	sta	$1BE3
	lda	#$00
	sta	$1BE4
	lda	#$00
	sta	$1BE5
	lda	#$00
	sta	$1BE6
	lda	#$00
	sta	$1BE7
	lda	#$00
	sta	$1BE8
	lda	#$00
	sta	$1BE9
	lda	#$00
	sta	$1BEA
	lda	#$00
	sta	$1BEB
	lda	#$00
	sta	$1BEC
	lda	#$00
	sta	$1BED
	lda	#$00
	sta	$1BEE
	lda	#$00
	sta	$1BEF
	lda	#$00
	sta	$1BF0
	lda	#$00
	sta	$1BF1
	lda	#$00
	sta	$1BF2
	lda	#$00
	sta	$1BF3
	lda	#$00
	sta	$1BF4
	lda	#$00
	sta	$1BF5
	lda	#$00
	sta	$1BF6
	lda	#$00
	sta	$1BF7
	lda	#$00
	sta	$1BF8
	lda	#$00
	sta	$1BF9
	lda	#$00
	sta	$1BFA
	lda	#$00
	sta	$1BFB
	lda	#$00
	sta	$1BFC
	lda	#$00
	sta	$1BFD
	lda	#$00
	sta	$1BFE
	lda	#$00
	sta	$1BFF

upd4_21o	lda	#$00
	sta	$0239
	lda	#$00
	sta	$023A
	lda	#$00
	sta	$023B
	lda	#$00
	sta	$023C
	lda	#$00
	sta	$023D
	lda	#$00
	sta	$023E
	lda	#$00
	sta	$023F
	lda	#$00
	sta	$0258
	lda	#$00
	sta	$0259
	lda	#$00
	sta	$025A
	lda	#$00
	sta	$025B
	lda	#$00
	sta	$025C
	lda	#$00
	sta	$025D
	lda	#$00
	sta	$025E
	lda	#$00
	sta	$025F
	lda	#$00
	sta	$0260
	lda	#$00
	sta	$0261
	lda	#$00
	sta	$0262
	lda	#$00
	sta	$0263
	lda	#$00
	sta	$0264
	lda	#$00
	sta	$0265
	lda	#$00
	sta	$0266
	lda	#$00
	sta	$0267
	lda	#$00
	sta	$0268
	lda	#$00
	sta	$0269
	lda	#$00
	sta	$026A
	lda	#$00
	sta	$026B
	lda	#$00
	sta	$026C
	lda	#$00
	sta	$026D
	lda	#$00
	sta	$026E
	lda	#$00
	sta	$026F

	lda	#$00
.	byte	$8d,$00,$00 ; sta	$0000
	lda	#$00
.	byte	$8d,$01,$00 ; sta	$0001

ifdef	real
	ldy	#$09
else
	ldy	#$04
endif
wait_e1	lda	($00,x)	; waste
	nop		; 8 cycles
	dey
	bne	wait_e1
	rol	$02	; waste
	ror	$02	; 10 cycles

upd0_4o	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

	ldy	#$cc
	sty	charram	

	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

upd4_21e1	lda	#$00
	sta	$02
	lda	#$00
	sta	$03
	lda	#$00
	sta	$04
	lda	#$00
	sta	$05
	lda	#$00
	sta	$06
	lda	#$00
	sta	$07
	lda	#$00
	sta	$08
	lda	#$00
	sta	$09
	lda	#$00
	sta	$0A
	lda	#$00
	sta	$0B
	lda	#$00
	sta	$0C
	lda	#$00
	sta	$0D
	lda	#$00
	sta	$0E
	lda	#$00
	sta	$0F

	stx	charram

upd1_6o	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	sta	$FF
	lda	#$00
	sta	$FE
	lda	#$00
	sta	$FD
	lda	#$00
	sta	$FC
	lda	#$00
	sta	$FB
	lda	#$00
	sta	$FA
	lda	#$00
	sta	$F9
	lda	#$00
	sta	$F8
	lda	#$00
	sta	$F7
	lda	#$00
	sta	$F6
	lda	#$00
	sta	$F5
	lda	#$00
	sta	$F4
	lda	#$00
	sta	$F3
	lda	#$00
	sta	$F2
	lda	#$00
	sta	$F1
	lda	#$00
	sta	$F0
	lda	#$00
	sta	$EF
	lda	#$00
	sta	$EE
	lda	#$00
	sta	$ED
	lda	#$00
	sta	$EC
	lda	#$00
	sta	$EB
	lda	#$00
	sta	$EA
	lda	#$00
	sta	$E9
	lda	#$00
	sta	$E8
	lda	#$00
	sta	$E7
	lda	#$00
	sta	$E6
	lda	#$00
	sta	$E5
	lda	#$00
	sta	$E4
	lda	#$00
	sta	$E3
	lda	#$00
	sta	$E2
	lda	#$00
	sta	$E1
	lda	#$00
	sta	$E0
	lda	#$00
	sta	$DF
	lda	#$00
	sta	$DE
	lda	#$00
	sta	$DD
	lda	#$00
	sta	$DC
	lda	#$00
	sta	$DB
	lda	#$00
	sta	$DA
	lda	#$00
	sta	$D9
	lda	#$00
	sta	$D8

	ldy	#$cc
	sty	charram

	lda	#$00
	sta	$D7
	lda	#$00
	sta	$D6
	lda	#$00
	sta	$D5
	lda	#$00
	sta	$D4
	lda	#$00
	sta	$D3
	lda	#$00
	sta	$D2
	lda	#$00
	sta	$D1
	lda	#$00
	sta	$D0
	lda	#$00
	sta	$CF
	lda	#$00
	sta	$CE
	lda	#$00
	sta	$CD
	lda	#$00
	sta	$CC
	lda	#$00
	sta	$CB
	lda	#$00
	sta	$CA
	lda	#$00
	sta	$C9
	lda	#$00
	sta	$C8
	lda	#$00
	sta	$C7
	lda	#$00
	sta	$C6
	lda	#$00
	sta	$C5
	lda	#$00
	sta	$C4
	lda	#$00
	sta	$C3
	lda	#$00
	sta	$C2
	lda	#$00
	sta	$C1
	lda	#$00
	sta	$C0
	lda	#$00
	sta	$BF
	lda	#$00
	sta	$BE
	lda	#$00
	sta	$BD
	lda	#$00
	sta	$BC
	lda	#$00
	sta	$BB
	lda	#$00
	sta	$BA
	lda	#$00
	sta	$B9
	lda	#$00
	sta	$B8
	lda	#$00
	sta	$B7
	lda	#$00
	sta	$B6
	lda	#$00
	sta	$B5
	lda	#$00
	sta	$B4
	lda	#$00
	sta	$B3
	lda	#$00
	sta	$B2
	lda	#$00
	sta	$B1
	lda	#$00
	sta	$B0
	lda	#$00
	sta	$AF
	lda	#$00
	sta	$AE
	lda	#$00
	sta	$AD
	lda	#$00
	sta	$AC
	lda	#$00
	sta	$AB
	lda	#$00
	sta	$AA
	lda	#$00
	sta	$A9
	lda	#$00
	sta	$A8
	lda	#$00
	sta	$A7
	lda	#$00
	sta	$A6
	lda	#$00
	sta	$A5
	lda	#$00
	sta	$A4
	lda	#$00
	sta	$A3
	lda	#$00
	sta	$A2
	lda	#$00
	sta	$A1
	lda	#$00
	sta	$A0
	lda	#$00
	sta	$9F
	lda	#$00
	sta	$9E
	lda	#00
	sta	$9D
	lda	#$00
	sta	$9C
	lda	#$00
	sta	$9B
	lda	#$00
	sta	$9A
	lda	#$00
	sta	$99
	lda	#$00
	sta	$98
	lda	#$00
	sta	$97
	lda	#$00
	sta	$96
	lda	#$00
	sta	$95
	lda	#$00
	sta	$94
	lda	#$00
	sta	$93
	lda	#$00
	sta	$92
	lda	#$00
	sta	$91
	lda	#$00
	sta	$90
	lda	#$00
	sta	$8F
	lda	#$00
	sta	$8E
	lda	#$00
	sta	$8D
	lda	#$00
	sta	$8C
	lda	#$00
	sta	$8B
	lda	#$00
	sta	$8A
	lda	#$00
	sta	$89
	lda	#$00
	sta	$88
	lda	#$00
	sta	$87
	lda	#$00
	sta	$86
	lda	#$00
	sta	$85
	lda	#$00
	sta	$84
	lda	#$00
	sta	$83
	lda	#$00
	sta	$82
	lda	#$00
	sta	$81
	lda	#$00
	sta	$80

upd4_21e2	lda	#$00
	sta	$10
	lda	#$00
	sta	$11
	lda	#$00
	sta	$12
	lda	#$00
	sta	$13
	lda	#$00
	sta	$14
	lda	#$00
	sta	$15
	lda	#$00
	sta	$16
	lda	#$00
	sta	$17
	lda	#$00
	sta	$18
	lda	#$00
	sta	$19
	lda	#$00
	sta	$1A
	lda	#$00
	sta	$1B
	lda	#$00
	sta	$1C
	lda	#$00
	sta	$1D

	stx	charram

upd0_8o	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

	ldy	#$cc
	sty	charram

	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

upd4_21e3	lda	#$00
	sta	$1E
	lda	#$00
	sta	$1F
	lda	#$00
	sta	$20
	lda	#$00
	sta	$21
	lda	#$00
	sta	$22
	lda	#$00
	sta	$23
	lda	#$00
	sta	$24
	lda	#$00
	sta	$25
	lda	#$00
	sta	$26
	lda	#$00
	sta	$27
	lda	#$00
	sta	$28
	lda	#$00
	sta	$29
	lda	#$00
	sta	$2A
	lda	#$00
	sta	$2B
	
	stx	charram

upd1_10o	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	sta	$FF
	lda	#$00
	sta	$FE
	lda	#$00
	sta	$FD
	lda	#$00
	sta	$FC
	lda	#$00
	sta	$FB
	lda	#$00
	sta	$FA
	lda	#$00
	sta	$F9
	lda	#$00
	sta	$F8
	lda	#$00
	sta	$F7
	lda	#$00
	sta	$F6
	lda	#$00
	sta	$F5
	lda	#$00
	sta	$F4
	lda	#$00
	sta	$F3
	lda	#$00
	sta	$F2
	lda	#$00
	sta	$F1
	lda	#$00
	sta	$F0
	lda	#$00
	sta	$EF
	lda	#$00
	sta	$EE
	lda	#$00
	sta	$ED
	lda	#$00
	sta	$EC
	lda	#$00
	sta	$EB
	lda	#$00
	sta	$EA
	lda	#$00
	sta	$E9
	lda	#$00
	sta	$E8
	lda	#$00
	sta	$E7
	lda	#$00
	sta	$E6
	lda	#$00
	sta	$E5
	lda	#$00
	sta	$E4
	lda	#$00
	sta	$E3
	lda	#$00
	sta	$E2
	lda	#$00
	sta	$E1
	lda	#$00
	sta	$E0
	lda	#$00
	sta	$DF
	lda	#$00
	sta	$DE
	lda	#$00
	sta	$DD
	lda	#$00
	sta	$DC
	lda	#$00
	sta	$DB
	lda	#$00
	sta	$DA
	lda	#$00
	sta	$D9
	lda	#$00
	sta	$D8

	ldy	#$cc
	sty	charram

	lda	#$00
	sta	$D7
	lda	#$00
	sta	$D6
	lda	#$00
	sta	$D5
	lda	#$00
	sta	$D4
	lda	#$00
	sta	$D3
	lda	#$00
	sta	$D2
	lda	#$00
	sta	$D1
	lda	#$00
	sta	$D0
	lda	#$00
	sta	$CF
	lda	#$00
	sta	$CE
	lda	#$00
	sta	$CD
	lda	#$00
	sta	$CC
	lda	#$00
	sta	$CB
	lda	#$00
	sta	$CA
	lda	#$00
	sta	$C9
	lda	#$00
	sta	$C8
	lda	#$00
	sta	$C7
	lda	#$00
	sta	$C6
	lda	#$00
	sta	$C5
	lda	#$00
	sta	$C4
	lda	#$00
	sta	$C3
	lda	#$00
	sta	$C2
	lda	#$00
	sta	$C1
	lda	#$00
	sta	$C0
	lda	#$00
	sta	$BF
	lda	#$00
	sta	$BE
	lda	#$00
	sta	$BD
	lda	#$00
	sta	$BC
	lda	#$00
	sta	$BB
	lda	#$00
	sta	$BA
	lda	#$00
	sta	$B9
	lda	#$00
	sta	$B8
	lda	#$00
	sta	$B7
	lda	#$00
	sta	$B6
	lda	#$00
	sta	$B5
	lda	#$00
	sta	$B4
	lda	#$00
	sta	$B3
	lda	#$00
	sta	$B2
	lda	#$00
	sta	$B1
	lda	#$00
	sta	$B0
	lda	#$00
	sta	$AF
	lda	#$00
	sta	$AE
	lda	#$00
	sta	$AD
	lda	#$00
	sta	$AC
	lda	#$00
	sta	$AB
	lda	#$00
	sta	$AA
	lda	#$00
	sta	$A9
	lda	#$00
	sta	$A8
	lda	#$00
	sta	$A7
	lda	#$00
	sta	$A6
	lda	#$00
	sta	$A5
	lda	#$00
	sta	$A4
	lda	#$00
	sta	$A3
	lda	#$00
	sta	$A2
	lda	#$00
	sta	$A1
	lda	#$00
	sta	$A0
	lda	#$00
	sta	$9F
	lda	#$00
	sta	$9E
	lda	#00
	sta	$9D
	lda	#$00
	sta	$9C
	lda	#$00
	sta	$9B
	lda	#$00
	sta	$9A
	lda	#$00
	sta	$99
	lda	#$00
	sta	$98
	lda	#$00
	sta	$97
	lda	#$00
	sta	$96
	lda	#$00
	sta	$95
	lda	#$00
	sta	$94
	lda	#$00
	sta	$93
	lda	#$00
	sta	$92
	lda	#$00
	sta	$91
	lda	#$00
	sta	$90
	lda	#$00
	sta	$8F
	lda	#$00
	sta	$8E
	lda	#$00
	sta	$8D
	lda	#$00
	sta	$8C
	lda	#$00
	sta	$8B
	lda	#$00
	sta	$8A
	lda	#$00
	sta	$89
	lda	#$00
	sta	$88
	lda	#$00
	sta	$87
	lda	#$00
	sta	$86
	lda	#$00
	sta	$85
	lda	#$00
	sta	$84
	lda	#$00
	sta	$83
	lda	#$00
	sta	$82
	lda	#$00
	sta	$81
	lda	#$00
	sta	$80

upd4_21e4	lda	#$00
	sta	$2C
	lda	#$00
	sta	$2D
	lda	#$00
	sta	$2E
	lda	#$00
	sta	$2F
	lda	#$00
	sta	$30
	lda	#$00
	sta	$31
	lda	#$00
	sta	$32
	lda	#$00
	sta	$33
	lda	#$00
	sta	$34
	lda	#$00
	sta	$35
	lda	#$00
	sta	$36
	lda	#$00
	sta	$37
	lda	#$00
	sta	$38
	lda	#$00
	sta	$39

	stx	charram

upd0_12o	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

	ldy	#$cc
	sty	charram

	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

upd4_21e5	lda	#$00
	sta	$3A
	lda	#$00
	sta	$3B
	lda	#$00
	sta	$3C
	lda	#$00
	sta	$3D
	lda	#$00
	sta	$3E
	lda	#$00
	sta	$3F
	lda	#$00
	sta	$40
	lda	#$00
	sta	$41
	lda	#$00
	sta	$42
	lda	#$00
	sta	$43
	lda	#$00
	sta	$44
	lda	#$00
	sta	$45
	lda	#$00
	sta	$46
	lda	#$00
	sta	$47	

	stx	charram

upd1_14o	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	sta	$FF
	lda	#$00
	sta	$FE
	lda	#$00
	sta	$FD
	lda	#$00
	sta	$FC
	lda	#$00
	sta	$FB
	lda	#$00
	sta	$FA
	lda	#$00
	sta	$F9
	lda	#$00
	sta	$F8
	lda	#$00
	sta	$F7
	lda	#$00
	sta	$F6
	lda	#$00
	sta	$F5
	lda	#$00
	sta	$F4
	lda	#$00
	sta	$F3
	lda	#$00
	sta	$F2
	lda	#$00
	sta	$F1
	lda	#$00
	sta	$F0
	lda	#$00
	sta	$EF
	lda	#$00
	sta	$EE
	lda	#$00
	sta	$ED
	lda	#$00
	sta	$EC
	lda	#$00
	sta	$EB
	lda	#$00
	sta	$EA
	lda	#$00
	sta	$E9
	lda	#$00
	sta	$E8
	lda	#$00
	sta	$E7
	lda	#$00
	sta	$E6
	lda	#$00
	sta	$E5
	lda	#$00
	sta	$E4
	lda	#$00
	sta	$E3
	lda	#$00
	sta	$E2
	lda	#$00
	sta	$E1
	lda	#$00
	sta	$E0
	lda	#$00
	sta	$DF
	lda	#$00
	sta	$DE
	lda	#$00
	sta	$DD
	lda	#$00
	sta	$DC
	lda	#$00
	sta	$DB
	lda	#$00
	sta	$DA
	lda	#$00
	sta	$D9
	lda	#$00
	sta	$D8
	
	ldy	#$cc
	sty	charram
	
	lda	#$00
	sta	$D7
	lda	#$00
	sta	$D6
	lda	#$00
	sta	$D5
	lda	#$00
	sta	$D4
	lda	#$00
	sta	$D3
	lda	#$00
	sta	$D2
	lda	#$00
	sta	$D1
	lda	#$00
	sta	$D0
	lda	#$00
	sta	$CF
	lda	#$00
	sta	$CE
	lda	#$00
	sta	$CD
	lda	#$00
	sta	$CC
	lda	#$00
	sta	$CB
	lda	#$00
	sta	$CA
	lda	#$00
	sta	$C9
	lda	#$00
	sta	$C8
	lda	#$00
	sta	$C7
	lda	#$00
	sta	$C6
	lda	#$00
	sta	$C5
	lda	#$00
	sta	$C4
	lda	#$00
	sta	$C3
	lda	#$00
	sta	$C2
	lda	#$00
	sta	$C1
	lda	#$00
	sta	$C0
	lda	#$00
	sta	$BF
	lda	#$00
	sta	$BE
	lda	#$00
	sta	$BD
	lda	#$00
	sta	$BC
	lda	#$00
	sta	$BB
	lda	#$00
	sta	$BA
	lda	#$00
	sta	$B9
	lda	#$00
	sta	$B8
	lda	#$00
	sta	$B7
	lda	#$00
	sta	$B6
	lda	#$00
	sta	$B5
	lda	#$00
	sta	$B4
	lda	#$00
	sta	$B3
	lda	#$00
	sta	$B2
	lda	#$00
	sta	$B1
	lda	#$00
	sta	$B0
	lda	#$00
	sta	$AF
	lda	#$00
	sta	$AE
	lda	#$00
	sta	$AD
	lda	#$00
	sta	$AC
	lda	#$00
	sta	$AB
	lda	#$00
	sta	$AA
	lda	#$00
	sta	$A9
	lda	#$00
	sta	$A8
	lda	#$00
	sta	$A7
	lda	#$00
	sta	$A6
	lda	#$00
	sta	$A5
	lda	#$00
	sta	$A4
	lda	#$00
	sta	$A3
	lda	#$00
	sta	$A2
	lda	#$00
	sta	$A1
	lda	#$00
	sta	$A0
	lda	#$00
	sta	$9F
	lda	#$00
	sta	$9E
	lda	#00
	sta	$9D
	lda	#$00
	sta	$9C
	lda	#$00
	sta	$9B
	lda	#$00
	sta	$9A
	lda	#$00
	sta	$99
	lda	#$00
	sta	$98
	lda	#$00
	sta	$97
	lda	#$00
	sta	$96
	lda	#$00
	sta	$95
	lda	#$00
	sta	$94
	lda	#$00
	sta	$93
	lda	#$00
	sta	$92
	lda	#$00
	sta	$91
	lda	#$00
	sta	$90
	lda	#$00
	sta	$8F
	lda	#$00
	sta	$8E
	lda	#$00
	sta	$8D
	lda	#$00
	sta	$8C
	lda	#$00
	sta	$8B
	lda	#$00
	sta	$8A
	lda	#$00
	sta	$89
	lda	#$00
	sta	$88
	lda	#$00
	sta	$87
	lda	#$00
	sta	$86
	lda	#$00
	sta	$85
	lda	#$00
	sta	$84
	lda	#$00
	sta	$83
	lda	#$00
	sta	$82
	lda	#$00
	sta	$81
	lda	#$00
	sta	$80

upd4_21e6	lda	#$00
	sta	$48
	lda	#$00
	sta	$49
	lda	#$00
	sta	$4A
	lda	#$00
	sta	$4B
	lda	#$00
	sta	$4C
	lda	#$00
	sta	$4D
	lda	#$00
	sta	$4E
	lda	#$00
	sta	$4F
	lda	#$00
	sta	$50
	lda	#$00
	sta	$51
	lda	#$00
	sta	$52
	lda	#$00
	sta	$53
	lda	#$00
	sta	$54
	lda	#$00
	sta	$55

	stx	charram

upd0_16o	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

	ldy	#$cc
	sty	charram

	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

upd4_21e7	lda	#$00
	sta	$56
	lda	#$00
	sta	$57
	lda	#$00
	sta	$58
	lda	#$00
	sta	$59
	lda	#$00
	sta	$5A
	lda	#$00
	sta	$5B
	lda	#$00
	sta	$5C
	lda	#$00
	sta	$5D
	lda	#$00
	sta	$5E
	lda	#$00
	sta	$5F
	lda	#$00
	sta	$60
	lda	#$00
	sta	$61
	lda	#$00
	sta	$62
	lda	#$00
	sta	$63

	stx	charram

upd1_18o	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	sta	$FF
	lda	#$00
	sta	$FE
	lda	#$00
	sta	$FD
	lda	#$00
	sta	$FC
	lda	#$00
	sta	$FB
	lda	#$00
	sta	$FA
	lda	#$00
	sta	$F9
	lda	#$00
	sta	$F8
	lda	#$00
	sta	$F7
	lda	#$00
	sta	$F6
	lda	#$00
	sta	$F5
	lda	#$00
	sta	$F4
	lda	#$00
	sta	$F3
	lda	#$00
	sta	$F2
	lda	#$00
	sta	$F1
	lda	#$00
	sta	$F0
	lda	#$00
	sta	$EF
	lda	#$00
	sta	$EE
	lda	#$00
	sta	$ED
	lda	#$00
	sta	$EC
	lda	#$00
	sta	$EB
	lda	#$00
	sta	$EA
	lda	#$00
	sta	$E9
	lda	#$00
	sta	$E8
	lda	#$00
	sta	$E7
	lda	#$00
	sta	$E6
	lda	#$00
	sta	$E5
	lda	#$00
	sta	$E4
	lda	#$00
	sta	$E3
	lda	#$00
	sta	$E2
	lda	#$00
	sta	$E1
	lda	#$00
	sta	$E0
	lda	#$00
	sta	$DF
	lda	#$00
	sta	$DE
	lda	#$00
	sta	$DD
	lda	#$00
	sta	$DC
	lda	#$00
	sta	$DB
	lda	#$00
	sta	$DA
	lda	#$00
	sta	$D9
	lda	#$00
	sta	$D8

	ldy	#$ce
	sty	charram

	lda	#$00
	sta	$D7
	lda	#$00
	sta	$D6
	lda	#$00
	sta	$D5
	lda	#$00
	sta	$D4
	lda	#$00
	sta	$D3
	lda	#$00
	sta	$D2
	lda	#$00
	sta	$D1
	lda	#$00
	sta	$D0
	lda	#$00
	sta	$CF
	lda	#$00
	sta	$CE
	lda	#$00
	sta	$CD
	lda	#$00
	sta	$CC
	lda	#$00
	sta	$CB
	lda	#$00
	sta	$CA
	lda	#$00
	sta	$C9
	lda	#$00
	sta	$C8
	lda	#$00
	sta	$C7
	lda	#$00
	sta	$C6
	lda	#$00
	sta	$C5
	lda	#$00
	sta	$C4
	lda	#$00
	sta	$C3
	lda	#$00
	sta	$C2
	lda	#$00
	sta	$C1
	lda	#$00
	sta	$C0
	lda	#$00
	sta	$BF
	lda	#$00
	sta	$BE
	lda	#$00
	sta	$BD
	lda	#$00
	sta	$BC
	lda	#$00
	sta	$BB
	lda	#$00
	sta	$BA
	lda	#$00
	sta	$B9
	lda	#$00
	sta	$B8
	lda	#$00
	sta	$B7
	lda	#$00
	sta	$B6
	lda	#$00
	sta	$B5
	lda	#$00
	sta	$B4
	lda	#$00
	sta	$B3
	lda	#$00
	sta	$B2
	lda	#$00
	sta	$B1
	lda	#$00
	sta	$B0
	lda	#$00
	sta	$AF
	lda	#$00
	sta	$AE
	lda	#$00
	sta	$AD
	lda	#$00
	sta	$AC
	lda	#$00
	sta	$AB
	lda	#$00
	sta	$AA
	lda	#$00
	sta	$A9
	lda	#$00
	sta	$A8
	lda	#$00
	sta	$A7
	lda	#$00
	sta	$A6
	lda	#$00
	sta	$A5
	lda	#$00
	sta	$A4
	lda	#$00
	sta	$A3
	lda	#$00
	sta	$A2
	lda	#$00
	sta	$A1
	lda	#$00
	sta	$A0
	lda	#$00
	sta	$9F
	lda	#$00
	sta	$9E
	lda	#00
	sta	$9D
	lda	#$00
	sta	$9C
	lda	#$00
	sta	$9B
	lda	#$00
	sta	$9A
	lda	#$00
	sta	$99
	lda	#$00
	sta	$98
	lda	#$00
	sta	$97
	lda	#$00
	sta	$96
	lda	#$00
	sta	$95
	lda	#$00
	sta	$94
	lda	#$00
	sta	$93
	lda	#$00
	sta	$92
	lda	#$00
	sta	$91
	lda	#$00
	sta	$90
	lda	#$00
	sta	$8F
	lda	#$00
	sta	$8E
	lda	#$00
	sta	$8D
	lda	#$00
	sta	$8C
	lda	#$00
	sta	$8B
	lda	#$00
	sta	$8A
	lda	#$00
	sta	$89
	lda	#$00
	sta	$88
	lda	#$00
	sta	$87
	lda	#$00
	sta	$86
	lda	#$00
	sta	$85
	lda	#$00
	sta	$84
	lda	#$00
	sta	$83
	lda	#$00
	sta	$82
	lda	#$00
	sta	$81
	lda	#$00
	sta	$80

upd4_21e8	lda	#$00
	sta	$64
	lda	#$00
	sta	$65
	lda	#$00
	sta	$66
	lda	#$00
	sta	$67
	lda	#$00
	sta	$68
	lda	#$00
	sta	$69
	lda	#$00
	sta	$6A
	lda	#$00
	sta	$6B
	lda	#$00
	sta	$6C
	lda	#$00
	sta	$6D
	lda	#$00
	sta	$6E
	lda	#$00
	sta	$6F
	lda	#$00
	sta	$70
	lda	#$00
	sta	$71

	stx	charram

upd0_20o	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

	ldy	#$ce
	sty	charram

	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

upd4_21e9	lda	#$00
	sta	$72
	lda	#$00
	sta	$73
	lda	#$00
	sta	$74
	lda	#$00
	sta	$75
	lda	#$00
	sta	$76
	lda	#$00
	sta	$77
	lda	#$00
	sta	$78
	lda	#$00
	sta	$79
	lda	#$00
	sta	$7A
	lda	#$00
	sta	$7B
	lda	#$00
	sta	$7C
	lda	#$00
	sta	$7D
	lda	#$00
	sta	$7E
	lda	#$00
	sta	$7F

	stx	charram

upd1_22o	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	sta	$FF
	lda	#$00
	sta	$FE
	lda	#$00
	sta	$FD
	lda	#$00
	sta	$FC
	lda	#$00
	sta	$FB
	lda	#$00
	sta	$FA
	lda	#$00
	sta	$F9
	lda	#$00
	sta	$F8
	lda	#$00
	sta	$F7
	lda	#$00
	sta	$F6
	lda	#$00
	sta	$F5
	lda	#$00
	sta	$F4
	lda	#$00
	sta	$F3
	lda	#$00
	sta	$F2
	lda	#$00
	sta	$F1
	lda	#$00
	sta	$F0
	lda	#$00
	sta	$EF
	lda	#$00
	sta	$EE
	lda	#$00
	sta	$ED
	lda	#$00
	sta	$EC
	lda	#$00
	sta	$EB
	lda	#$00
	sta	$EA
	lda	#$00
	sta	$E9
	lda	#$00
	sta	$E8
	lda	#$00
	sta	$E7
	lda	#$00
	sta	$E6
	lda	#$00
	sta	$E5
	lda	#$00
	sta	$E4
	lda	#$00
	sta	$E3
	lda	#$00
	sta	$E2
	lda	#$00
	sta	$E1
	lda	#$00
	sta	$E0
	lda	#$00
	sta	$DF
	lda	#$00
	sta	$DE
	lda	#$00
	sta	$DD
	lda	#$00
	sta	$DC
	lda	#$00
	sta	$DB
	lda	#$00
	sta	$DA
	lda	#$00
	sta	$D9
	lda	#$00
	sta	$D8
	
	ldy	#$c8
	sty	charram

	lda	#$00
	sta	$D7
	lda	#$00
	sta	$D6
	lda	#$00
	sta	$D5
	lda	#$00
	sta	$D4
	lda	#$00
	sta	$D3
	lda	#$00
	sta	$D2
	lda	#$00
	sta	$D1
	lda	#$00
	sta	$D0
	lda	#$00
	sta	$CF
	lda	#$00
	sta	$CE
	lda	#$00
	sta	$CD
	lda	#$00
	sta	$CC
	lda	#$00
	sta	$CB
	lda	#$00
	sta	$CA
	lda	#$00
	sta	$C9
	lda	#$00
	sta	$C8
	lda	#$00
	sta	$C7
	lda	#$00
	sta	$C6
	lda	#$00
	sta	$C5
	lda	#$00
	sta	$C4
	lda	#$00
	sta	$C3
	lda	#$00
	sta	$C2
	lda	#$00
	sta	$C1
	lda	#$00
	sta	$C0
	lda	#$00
	sta	$BF
	lda	#$00
	sta	$BE
	lda	#$00
	sta	$BD
	lda	#$00
	sta	$BC
	lda	#$00
	sta	$BB
	lda	#$00
	sta	$BA
	lda	#$00
	sta	$B9
	lda	#$00
	sta	$B8
	lda	#$00
	sta	$B7
	lda	#$00
	sta	$B6
	lda	#$00
	sta	$B5
	lda	#$00
	sta	$B4
	lda	#$00
	sta	$B3
	lda	#$00
	sta	$B2
	lda	#$00
	sta	$B1
	lda	#$00
	sta	$B0
	lda	#$00
	sta	$AF
	lda	#$00
	sta	$AE
	lda	#$00
	sta	$AD
	lda	#$00
	sta	$AC
	lda	#$00
	sta	$AB
	lda	#$00
	sta	$AA
	lda	#$00
	sta	$A9
	lda	#$00
	sta	$A8
	lda	#$00
	sta	$A7
	lda	#$00
	sta	$A6
	lda	#$00
	sta	$A5
	lda	#$00
	sta	$A4
	lda	#$00
	sta	$A3
	lda	#$00
	sta	$A2
	lda	#$00
	sta	$A1
	lda	#$00
	sta	$A0
	lda	#$00
	sta	$9F
	lda	#$00
	sta	$9E
	lda	#00
	sta	$9D
	lda	#$00
	sta	$9C
	lda	#$00
	sta	$9B
	lda	#$00
	sta	$9A
	lda	#$00
	sta	$99
	lda	#$00
	sta	$98
	lda	#$00
	sta	$97
	lda	#$00
	sta	$96
	lda	#$00
	sta	$95
	lda	#$00
	sta	$94
	lda	#$00
	sta	$93
	lda	#$00
	sta	$92
	lda	#$00
	sta	$91
	lda	#$00
	sta	$90
	lda	#$00
	sta	$8F
	lda	#$00
	sta	$8E
	lda	#$00
	sta	$8D
	lda	#$00
	sta	$8C
	lda	#$00
	sta	$8B
	lda	#$00
	sta	$8A
	lda	#$00
	sta	$89
	lda	#$00
	sta	$88
	lda	#$00
	sta	$87
	lda	#$00
	sta	$86
	lda	#$00
	sta	$85
	lda	#$00
	sta	$84
	lda	#$00
	sta	$83
	lda	#$00
	sta	$82
	lda	#$00
	sta	$81
	lda	#$00
	sta	$80
	
upd4_21ea	lda	#$00
	sta	$0200
	lda	#$00
	sta	$0201
	lda	#$00
	sta	$0202
	lda	#$00
	sta	$0203
	lda	#$00
	sta	$0204
	lda	#$00
	sta	$0205
	lda	#$00
	sta	$0206
	lda	#$00
	sta	$0207
	lda	#$00
	sta	$0208
	lda	#$00
	sta	$0209
	lda	#$00
	sta	$020A
	nop
	nop
	
	stx	charram

upd0_24o	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

	ldy	#$cd
	sty	charram

	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

upd4_21eb	lda	#$00
	sta	$020B
	lda	#$00
	sta	$020C
	lda	#$00
	sta	$020D
	lda	#$00
	sta	$020E
	lda	#$00
	sta	$020F
	lda	#$00
	sta	$0228
	lda	#$00
	sta	$0229
	lda	#$00
	sta	$022A
	lda	#$00
	sta	$022B
	lda	#$00
	sta	$022C
	lda	#$00
	sta	$022D
	nop
	nop
	
	stx	charram

upd1_26o	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	sta	$FF
	lda	#$00
	sta	$FE
	lda	#$00
	sta	$FD
	lda	#$00
	sta	$FC
	lda	#$00
	sta	$FB
	lda	#$00
	sta	$FA
	lda	#$00
	sta	$F9
	lda	#$00
	sta	$F8
	lda	#$00
	sta	$F7
	lda	#$00
	sta	$F6
	lda	#$00
	sta	$F5
	lda	#$00
	sta	$F4
	lda	#$00
	sta	$F3
	lda	#$00
	sta	$F2
	lda	#$00
	sta	$F1
	lda	#$00
	sta	$F0
	lda	#$00
	sta	$EF
	lda	#$00
	sta	$EE
	lda	#$00
	sta	$ED
	lda	#$00
	sta	$EC
	lda	#$00
	sta	$EB
	lda	#$00
	sta	$EA
	lda	#$00
	sta	$E9
	lda	#$00
	sta	$E8
	lda	#$00
	sta	$E7
	lda	#$00
	sta	$E6
	lda	#$00
	sta	$E5
	lda	#$00
	sta	$E4
	lda	#$00
	sta	$E3
	lda	#$00
	sta	$E2
	lda	#$00
	sta	$E1
	lda	#$00
	sta	$E0
	lda	#$00
	sta	$DF
	lda	#$00
	sta	$DE
	lda	#$00
	sta	$DD
	lda	#$00
	sta	$DC
	lda	#$00
	sta	$DB
	lda	#$00
	sta	$DA
	lda	#$00
	sta	$D9
	lda	#$00
	sta	$D8
	
	ldy	#$cd
	sty	charram
	
	lda	#$00
	sta	$D7
	lda	#$00
	sta	$D6
	lda	#$00
	sta	$D5
	lda	#$00
	sta	$D4
	lda	#$00
	sta	$D3
	lda	#$00
	sta	$D2
	lda	#$00
	sta	$D1
	lda	#$00
	sta	$D0
	lda	#$00
	sta	$CF
	lda	#$00
	sta	$CE
	lda	#$00
	sta	$CD
	lda	#$00
	sta	$CC
	lda	#$00
	sta	$CB
	lda	#$00
	sta	$CA
	lda	#$00
	sta	$C9
	lda	#$00
	sta	$C8
	lda	#$00
	sta	$C7
	lda	#$00
	sta	$C6
	lda	#$00
	sta	$C5
	lda	#$00
	sta	$C4
	lda	#$00
	sta	$C3
	lda	#$00
	sta	$C2
	lda	#$00
	sta	$C1
	lda	#$00
	sta	$C0
	lda	#$00
	sta	$BF
	lda	#$00
	sta	$BE
	lda	#$00
	sta	$BD
	lda	#$00
	sta	$BC
	lda	#$00
	sta	$BB
	lda	#$00
	sta	$BA
	lda	#$00
	sta	$B9
	lda	#$00
	sta	$B8
	lda	#$00
	sta	$B7
	lda	#$00
	sta	$B6
	lda	#$00
	sta	$B5
	lda	#$00
	sta	$B4
	lda	#$00
	sta	$B3
	lda	#$00
	sta	$B2
	lda	#$00
	sta	$B1
	lda	#$00
	sta	$B0
	lda	#$00
	sta	$AF
	lda	#$00
	sta	$AE
	lda	#$00
	sta	$AD
	lda	#$00
	sta	$AC
	lda	#$00
	sta	$AB
	lda	#$00
	sta	$AA
	lda	#$00
	sta	$A9
	lda	#$00
	sta	$A8
	lda	#$00
	sta	$A7
	lda	#$00
	sta	$A6
	lda	#$00
	sta	$A5
	lda	#$00
	sta	$A4
	lda	#$00
	sta	$A3
	lda	#$00
	sta	$A2
	lda	#$00
	sta	$A1
	lda	#$00
	sta	$A0
	lda	#$00
	sta	$9F
	lda	#$00
	sta	$9E
	lda	#00
	sta	$9D
	lda	#$00
	sta	$9C
	lda	#$00
	sta	$9B
	lda	#$00
	sta	$9A
	lda	#$00
	sta	$99
	lda	#$00
	sta	$98
	lda	#$00
	sta	$97
	lda	#$00
	sta	$96
	lda	#$00
	sta	$95
	lda	#$00
	sta	$94
	lda	#$00
	sta	$93
	lda	#$00
	sta	$92
	lda	#$00
	sta	$91
	lda	#$00
	sta	$90
	lda	#$00
	sta	$8F
	lda	#$00
	sta	$8E
	lda	#$00
	sta	$8D
	lda	#$00
	sta	$8C
	lda	#$00
	sta	$8B
	lda	#$00
	sta	$8A
	lda	#$00
	sta	$89
	lda	#$00
	sta	$88
	lda	#$00
	sta	$87
	lda	#$00
	sta	$86
	lda	#$00
	sta	$85
	lda	#$00
	sta	$84
	lda	#$00
	sta	$83
	lda	#$00
	sta	$82
	lda	#$00
	sta	$81
	lda	#$00
	sta	$80

upd4_21ec lda	#$00
	sta	$022E
	lda	#$00
	sta	$022F
	lda	#$00
	sta	$0230
	lda	#$00
	sta	$0231
	lda	#$00
	sta	$0232
	lda	#$00
	sta	$0233
	lda	#$00
	sta	$0234
	lda	#$00
	sta	$0235
	lda	#$00
	sta	$0236
	lda	#$00
	sta	$0237
	lda	#$00
	sta	$0238
	nop
	nop

	stx	charram	

upd0_1e	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha

upd1_2o	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	pha
	lda	#$00
	sta	$FF
	lda	#$00
	sta	$FE
	lda	#$00
	sta	$FD
	lda	#$00
	sta	$FC
	lda	#$00
	sta	$FB
	lda	#$00
	sta	$FA
	lda	#$00
	sta	$F9
	lda	#$00
	sta	$F8
	lda	#$00
	sta	$F7
	lda	#$00
	sta	$F6
	lda	#$00
	sta	$F5
	lda	#$00
	sta	$F4
	lda	#$00
	sta	$F3
	lda	#$00
	sta	$F2
	lda	#$00
	sta	$F1
	lda	#$00
	sta	$F0
	lda	#$00
	sta	$EF
	lda	#$00
	sta	$EE
	lda	#$00
	sta	$ED
	lda	#$00
	sta	$EC
	lda	#$00
	sta	$EB
	lda	#$00
	sta	$EA
	lda	#$00
	sta	$E9
	lda	#$00
	sta	$E8
	lda	#$00
	sta	$E7
	lda	#$00
	sta	$E6
	lda	#$00
	sta	$E5
	lda	#$00
	sta	$E4
	lda	#$00
	sta	$E3
	lda	#$00
	sta	$E2
	lda	#$00
	sta	$E1
	lda	#$00
	sta	$E0
	lda	#$00
	sta	$DF
	lda	#$00
	sta	$DE
	lda	#$00
	sta	$DD
	lda	#$00
	sta	$DC
	lda	#$00
	sta	$DB
	lda	#$00
	sta	$DA
	lda	#$00
	sta	$D9
	lda	#$00
	sta	$D8
	lda	#$00
	sta	$D7
	lda	#$00
	sta	$D6
	lda	#$00
	sta	$D5
	lda	#$00
	sta	$D4
	lda	#$00
	sta	$D3
	lda	#$00
	sta	$D2
	lda	#$00
	sta	$D1
	lda	#$00
	sta	$D0
	lda	#$00
	sta	$CF
	lda	#$00
	sta	$CE
	lda	#$00
	sta	$CD
	lda	#$00
	sta	$CC
	lda	#$00
	sta	$CB
	lda	#$00
	sta	$CA
	lda	#$00
	sta	$C9
	lda	#$00
	sta	$C8
	lda	#$00
	sta	$C7
	lda	#$00
	sta	$C6
	lda	#$00
	sta	$C5
	lda	#$00
	sta	$C4
	lda	#$00
	sta	$C3
	lda	#$00
	sta	$C2
	lda	#$00
	sta	$C1
	lda	#$00
	sta	$C0
	lda	#$00
	sta	$BF
	lda	#$00
	sta	$BE
	lda	#$00
	sta	$BD
	lda	#$00
	sta	$BC
	lda	#$00
	sta	$BB
	lda	#$00
	sta	$BA
	lda	#$00
	sta	$B9
	lda	#$00
	sta	$B8
	lda	#$00
	sta	$B7
	lda	#$00
	sta	$B6
	lda	#$00
	sta	$B5
	lda	#$00
	sta	$B4
	lda	#$00
	sta	$B3
	lda	#$00
	sta	$B2
	lda	#$00
	sta	$B1
	lda	#$00
	sta	$B0
	lda	#$00
	sta	$AF
	lda	#$00
	sta	$AE
	lda	#$00
	sta	$AD
	lda	#$00
	sta	$AC
	lda	#$00
	sta	$AB
	lda	#$00
	sta	$AA
	lda	#$00
	sta	$A9
	lda	#$00
	sta	$A8
	lda	#$00
	sta	$A7
	lda	#$00
	sta	$A6
	lda	#$00
	sta	$A5
	lda	#$00
	sta	$A4
	lda	#$00
	sta	$A3
	lda	#$00
	sta	$A2
	lda	#$00
	sta	$A1
	lda	#$00
	sta	$A0
	lda	#$00
	sta	$9F
	lda	#$00
	sta	$9E
	lda	#00
	sta	$9D
	lda	#$00
	sta	$9C
	lda	#$00
	sta	$9B
	lda	#$00
	sta	$9A
	lda	#$00
	sta	$99
	lda	#$00
	sta	$98
	lda	#$00
	sta	$97
	lda	#$00
	sta	$96
	lda	#$00
	sta	$95
	lda	#$00
	sta	$94
	lda	#$00
	sta	$93
	lda	#$00
	sta	$92
	lda	#$00
	sta	$91
	lda	#$00
	sta	$90
	lda	#$00
	sta	$8F
	lda	#$00
	sta	$8E
	lda	#$00
	sta	$8D
	lda	#$00
	sta	$8C
	lda	#$00
	sta	$8B
	lda	#$00
	sta	$8A
	lda	#$00
	sta	$89
	lda	#$00
	sta	$88
	lda	#$00
	sta	$87
	lda	#$00
	sta	$86
	lda	#$00
	sta	$85
	lda	#$00
	sta	$84
	lda	#$00
	sta	$83
	lda	#$00
	sta	$82
	lda	#$00
	sta	$81
	lda	#$00
	sta	$80

upd2_17e	lda	#$00
	sta	$1A80
	lda	#$00
	sta	$1A81
	lda	#$00
	sta	$1A82
	lda	#$00
	sta	$1A83
	lda	#$00
	sta	$1A84
	lda	#$00
	sta	$1A85
	lda	#$00
	sta	$1A86
	lda	#$00
	sta	$1A87
	lda	#$00
	sta	$1A88
	lda	#$00
	sta	$1A89
	lda	#$00
	sta	$1A8A
	lda	#$00
	sta	$1A8B
	lda	#$00
	sta	$1A8C
	lda	#$00
	sta	$1A8D
	lda	#$00
	sta	$1A8E
	lda	#$00
	sta	$1A8F
	lda	#$00
	sta	$1A90
	lda	#$00
	sta	$1A91
	lda	#$00
	sta	$1A92
	lda	#$00
	sta	$1A93
	lda	#$00
	sta	$1A94
	lda	#$00
	sta	$1A95
	lda	#$00
	sta	$1A96
	lda	#$00
	sta	$1A97
	lda	#$00
	sta	$1A98
	lda	#$00
	sta	$1A99
	lda	#$00
	sta	$1A9A
	lda	#$00
	sta	$1A9B
	lda	#$00
	sta	$1A9C
	lda	#$00
	sta	$1A9D
	lda	#$00
	sta	$1A9E
	lda	#$00
	sta	$1A9F
	lda	#$00
	sta	$1AA0
	lda	#$00
	sta	$1AA1
	lda	#$00
	sta	$1AA2
	lda	#$00
	sta	$1AA3
	lda	#$00
	sta	$1AA4
	lda	#$00
	sta	$1AA5
	lda	#$00
	sta	$1AA6
	lda	#$00
	sta	$1AA7
	lda	#$00
	sta	$1AA8
	lda	#$00
	sta	$1AA9
	lda	#$00
	sta	$1AAA
	lda	#$00
	sta	$1AAB
	lda	#$00
	sta	$1AAC
	lda	#$00
	sta	$1AAD
	lda	#$00
	sta	$1AAE
	lda	#$00
	sta	$1AAF
	lda	#$00
	sta	$1AB0
	lda	#$00
	sta	$1AB1
	lda	#$00
	sta	$1AB2
	lda	#$00
	sta	$1AB3
	lda	#$00
	sta	$1AB4
	lda	#$00
	sta	$1AB5
	lda	#$00
	sta	$1AB6
	lda	#$00
	sta	$1AB7
	lda	#$00
	sta	$1AB8
	lda	#$00
	sta	$1AB9
	lda	#$00
	sta	$1ABA
	lda	#$00
	sta	$1ABB
	lda	#$00
	sta	$1ABC
	lda	#$00
	sta	$1ABD
	lda	#$00
	sta	$1ABE
	lda	#$00
	sta	$1ABF
	lda	#$00
	sta	$1AC0
	lda	#$00
	sta	$1AC1
	lda	#$00
	sta	$1AC2
	lda	#$00
	sta	$1AC3
	lda	#$00
	sta	$1AC4
	lda	#$00
	sta	$1AC5
	lda	#$00
	sta	$1AC6
	lda	#$00
	sta	$1AC7
	lda	#$00
	sta	$1AC8
	lda	#$00
	sta	$1AC9
	lda	#$00
	sta	$1ACA
	lda	#$00
	sta	$1ACB
	lda	#$00
	sta	$1ACC
	lda	#$00
	sta	$1ACD
	lda	#$00
	sta	$1ACE
	lda	#$00
	sta	$1ACF
	lda	#$00
	sta	$1AD0
	lda	#$00
	sta	$1AD1
	lda	#$00
	sta	$1AD2
	lda	#$00
	sta	$1AD3
	lda	#$00
	sta	$1AD4
	lda	#$00
	sta	$1AD5
	lda	#$00
	sta	$1AD6
	lda	#$00
	sta	$1AD7
	lda	#$00
	sta	$1AD8
	lda	#$00
	sta	$1AD9
	lda	#$00
	sta	$1ADA
	lda	#$00
	sta	$1ADB
	lda	#$00
	sta	$1ADC
	lda	#$00
	sta	$1ADD
	lda	#$00
	sta	$1ADE
	lda	#$00
	sta	$1ADF
	lda	#$00
	sta	$1AE0
	lda	#$00
	sta	$1AE1
	lda	#$00
	sta	$1AE2
	lda	#$00
	sta	$1AE3
	lda	#$00
	sta	$1AE4
	lda	#$00
	sta	$1AE5
	lda	#$00
	sta	$1AE6
	lda	#$00
	sta	$1AE7
	lda	#$00
	sta	$1AE8
	lda	#$00
	sta	$1AE9
	lda	#$00
	sta	$1AEA
	lda	#$00
	sta	$1AEB
	lda	#$00
	sta	$1AEC
	lda	#$00
	sta	$1AED
	lda	#$00
	sta	$1AEE
	lda	#$00
	sta	$1AEF
	lda	#$00
	sta	$1AF0
	lda	#$00
	sta	$1AF1
	lda	#$00
	sta	$1AF2
	lda	#$00
	sta	$1AF3
	lda	#$00
	sta	$1AF4
	lda	#$00
	sta	$1AF5
	lda	#$00
	sta	$1AF6
	lda	#$00
	sta	$1AF7
	lda	#$00
	sta	$1AF8
	lda	#$00
	sta	$1AF9
	lda	#$00
	sta	$1AFA
	lda	#$00
	sta	$1AFB
	lda	#$00
	sta	$1AFC
	lda	#$00
	sta	$1AFD
	lda	#$00
	sta	$1AFE
	lda	#$00
	sta	$1AFF
	lda	#$00
	sta	$1B00
	lda	#$00
	sta	$1B01
	lda	#$00
	sta	$1B02
	lda	#$00
	sta	$1B03
	lda	#$00
	sta	$1B04
	lda	#$00
	sta	$1B05
	lda	#$00
	sta	$1B06
	lda	#$00
	sta	$1B07
	lda	#$00
	sta	$1B08
	lda	#$00
	sta	$1B09
	lda	#$00
	sta	$1B0A
	lda	#$00
	sta	$1B0B
	lda	#$00
	sta	$1B0C
	lda	#$00
	sta	$1B0D
	lda	#$00
	sta	$1B0E
	lda	#$00
	sta	$1B0F
	lda	#$00
	sta	$1B10
	lda	#$00
	sta	$1B11
	lda	#$00
	sta	$1B12
	lda	#$00
	sta	$1B13
	lda	#$00
	sta	$1B14
	lda	#$00
	sta	$1B15
	lda	#$00
	sta	$1B16
	lda	#$00
	sta	$1B17
	lda	#$00
	sta	$1B18
	lda	#$00
	sta	$1B19
	lda	#$00
	sta	$1B1A
	lda	#$00
	sta	$1B1B
	lda	#$00
	sta	$1B1C
	lda	#$00
	sta	$1B1D
	lda	#$00
	sta	$1B1E
	lda	#$00
	sta	$1B1F
	lda	#$00
	sta	$1B20
	lda	#$00
	sta	$1B21
	lda	#$00
	sta	$1B22
	lda	#$00
	sta	$1B23
	lda	#$00
	sta	$1B24
	lda	#$00
	sta	$1B25
	lda	#$00
	sta	$1B26
	lda	#$00
	sta	$1B27
	lda	#$00
	sta	$1B28
	lda	#$00
	sta	$1B29
	lda	#$00
	sta	$1B2A
	lda	#$00
	sta	$1B2B
	lda	#$00
	sta	$1B2C
	lda	#$00
	sta	$1B2D
	lda	#$00
	sta	$1B2E
	lda	#$00
	sta	$1B2F
	lda	#$00
	sta	$1B30
	lda	#$00
	sta	$1B31
	lda	#$00
	sta	$1B32
	lda	#$00
	sta	$1B33
	lda	#$00
	sta	$1B34
	lda	#$00
	sta	$1B35
	lda	#$00
	sta	$1B36
	lda	#$00
	sta	$1B37
	lda	#$00
	sta	$1B38
	lda	#$00
	sta	$1B39
	lda	#$00
	sta	$1B3A
	lda	#$00
	sta	$1B3B
	lda	#$00
	sta	$1B3C
	lda	#$00
	sta	$1B3D
	lda	#$00
	sta	$1B3E
	lda	#$00
	sta	$1B3F

upd3_19e	lda	#$00
	sta	$1B40
	lda	#$00
	sta	$1B41
	lda	#$00
	sta	$1B42
	lda	#$00
	sta	$1B43
	lda	#$00
	sta	$1B44
	lda	#$00
	sta	$1B45
	lda	#$00
	sta	$1B46
	lda	#$00
	sta	$1B47
	lda	#$00
	sta	$1B48
	lda	#$00
	sta	$1B49
	lda	#$00
	sta	$1B4A
	lda	#$00
	sta	$1B4B
	lda	#$00
	sta	$1B4C
	lda	#$00
	sta	$1B4D
	lda	#$00
	sta	$1B4E
	lda	#$00
	sta	$1B4F
	lda	#$00
	sta	$1B50
	lda	#$00
	sta	$1B51
	lda	#$00
	sta	$1B52
	lda	#$00
	sta	$1B53
	lda	#$00
	sta	$1B54
	lda	#$00
	sta	$1B55
	lda	#$00
	sta	$1B56
	lda	#$00
	sta	$1B57
	lda	#$00
	sta	$1B58
	lda	#$00
	sta	$1B59
	lda	#$00
	sta	$1B5A
	lda	#$00
	sta	$1B5B
	lda	#$00
	sta	$1B5C
	lda	#$00
	sta	$1B5D
	lda	#$00
	sta	$1B5E
	lda	#$00
	sta	$1B5F
	lda	#$00
	sta	$1B60
	lda	#$00
	sta	$1B61
	lda	#$00
	sta	$1B62
	lda	#$00
	sta	$1B63
	lda	#$00
	sta	$1B64
	lda	#$00
	sta	$1B65
	lda	#$00
	sta	$1B66
	lda	#$00
	sta	$1B67
	lda	#$00
	sta	$1B68
	lda	#$00
	sta	$1B69
	lda	#$00
	sta	$1B6A
	lda	#$00
	sta	$1B6B
	lda	#$00
	sta	$1B6C
	lda	#$00
	sta	$1B6D
	lda	#$00
	sta	$1B6E
	lda	#$00
	sta	$1B6F
	lda	#$00
	sta	$1B70
	lda	#$00
	sta	$1B71
	lda	#$00
	sta	$1B72
	lda	#$00
	sta	$1B73
	lda	#$00
	sta	$1B74
	lda	#$00
	sta	$1B75
	lda	#$00
	sta	$1B76
	lda	#$00
	sta	$1B77
	lda	#$00
	sta	$1B78
	lda	#$00
	sta	$1B79
	lda	#$00
	sta	$1B7A
	lda	#$00
	sta	$1B7B
	lda	#$00
	sta	$1B7C
	lda	#$00
	sta	$1B7D
	lda	#$00
	sta	$1B7E
	lda	#$00
	sta	$1B7F
	lda	#$00
	sta	$1B80
	lda	#$00
	sta	$1B81
	lda	#$00
	sta	$1B82
	lda	#$00
	sta	$1B83
	lda	#$00
	sta	$1B84
	lda	#$00
	sta	$1B85
	lda	#$00
	sta	$1B86
	lda	#$00
	sta	$1B87
	lda	#$00
	sta	$1B88
	lda	#$00
	sta	$1B89
	lda	#$00
	sta	$1B8A
	lda	#$00
	sta	$1B8B
	lda	#$00
	sta	$1B8C
	lda	#$00
	sta	$1B8D
	lda	#$00
	sta	$1B8E
	lda	#$00
	sta	$1B8F
	lda	#$00
	sta	$1B90
	lda	#$00
	sta	$1B91
	lda	#$00
	sta	$1B92
	lda	#$00
	sta	$1B93
	lda	#$00
	sta	$1B94
	lda	#$00
	sta	$1B95
	lda	#$00
	sta	$1B96
	lda	#$00
	sta	$1B97
	lda	#$00
	sta	$1B98
	lda	#$00
	sta	$1B99
	lda	#$00
	sta	$1B9A
	lda	#$00
	sta	$1B9B
	lda	#$00
	sta	$1B9C
	lda	#$00
	sta	$1B9D
	lda	#$00
	sta	$1B9E
	lda	#$00
	sta	$1B9F
	lda	#$00
	sta	$1BA0
	lda	#$00
	sta	$1BA1
	lda	#$00
	sta	$1BA2
	lda	#$00
	sta	$1BA3
	lda	#$00
	sta	$1BA4
	lda	#$00
	sta	$1BA5
	lda	#$00
	sta	$1BA6
	lda	#$00
	sta	$1BA7
	lda	#$00
	sta	$1BA8
	lda	#$00
	sta	$1BA9
	lda	#$00
	sta	$1BAA
	lda	#$00
	sta	$1BAB
	lda	#$00
	sta	$1BAC
	lda	#$00
	sta	$1BAD
	lda	#$00
	sta	$1BAE
	lda	#$00
	sta	$1BAF
	lda	#$00
	sta	$1BB0
	lda	#$00
	sta	$1BB1
	lda	#$00
	sta	$1BB2
	lda	#$00
	sta	$1BB3
	lda	#$00
	sta	$1BB4
	lda	#$00
	sta	$1BB5
	lda	#$00
	sta	$1BB6
	lda	#$00
	sta	$1BB7
	lda	#$00
	sta	$1BB8
	lda	#$00
	sta	$1BB9
	lda	#$00
	sta	$1BBA
	lda	#$00
	sta	$1BBB
	lda	#$00
	sta	$1BBC
	lda	#$00
	sta	$1BBD
	lda	#$00
	sta	$1BBE
	lda	#$00
	sta	$1BBF
	lda	#$00
	sta	$1BC0
	lda	#$00
	sta	$1BC1
	lda	#$00
	sta	$1BC2
	lda	#$00
	sta	$1BC3
	lda	#$00
	sta	$1BC4
	lda	#$00
	sta	$1BC5
	lda	#$00
	sta	$1BC6
	lda	#$00
	sta	$1BC7
	lda	#$00
	sta	$1BC8
	lda	#$00
	sta	$1BC9
	lda	#$00
	sta	$1BCA
	lda	#$00
	sta	$1BCB
	lda	#$00
	sta	$1BCC
	lda	#$00
	sta	$1BCD
	lda	#$00
	sta	$1BCE
	lda	#$00
	sta	$1BCF
	lda	#$00
	sta	$1BD0
	lda	#$00
	sta	$1BD1
	lda	#$00
	sta	$1BD2
	lda	#$00
	sta	$1BD3
	lda	#$00
	sta	$1BD4
	lda	#$00
	sta	$1BD5
	lda	#$00
	sta	$1BD6
	lda	#$00
	sta	$1BD7
	lda	#$00
	sta	$1BD8
	lda	#$00
	sta	$1BD9
	lda	#$00
	sta	$1BDA
	lda	#$00
	sta	$1BDB
	lda	#$00
	sta	$1BDC
	lda	#$00
	sta	$1BDD
	lda	#$00
	sta	$1BDE
	lda	#$00
	sta	$1BDF
	lda	#$00
	sta	$1BE0
	lda	#$00
	sta	$1BE1
	lda	#$00
	sta	$1BE2
	lda	#$00
	sta	$1BE3
	lda	#$00
	sta	$1BE4
	lda	#$00
	sta	$1BE5
	lda	#$00
	sta	$1BE6
	lda	#$00
	sta	$1BE7
	lda	#$00
	sta	$1BE8
	lda	#$00
	sta	$1BE9
	lda	#$00
	sta	$1BEA
	lda	#$00
	sta	$1BEB
	lda	#$00
	sta	$1BEC
	lda	#$00
	sta	$1BED
	lda	#$00
	sta	$1BEE
	lda	#$00
	sta	$1BEF
	lda	#$00
	sta	$1BF0
	lda	#$00
	sta	$1BF1
	lda	#$00
	sta	$1BF2
	lda	#$00
	sta	$1BF3
	lda	#$00
	sta	$1BF4
	lda	#$00
	sta	$1BF5
	lda	#$00
	sta	$1BF6
	lda	#$00
	sta	$1BF7
	lda	#$00
	sta	$1BF8
	lda	#$00
	sta	$1BF9
	lda	#$00
	sta	$1BFA
	lda	#$00
	sta	$1BFB
	lda	#$00
	sta	$1BFC
	lda	#$00
	sta	$1BFD
	lda	#$00
	sta	$1BFE
	lda	#$00
	sta	$1BFF

upd4_21o	lda	#$00
	sta	$0239
	lda	#$00
	sta	$023A
	lda	#$00
	sta	$023B
	lda	#$00
	sta	$023C
	lda	#$00
	sta	$023D
	lda	#$00
	sta	$023E
	lda	#$00
	sta	$023F
	lda	#$00
	sta	$0258
	lda	#$00
	sta	$0259
	lda	#$00
	sta	$025A
	lda	#$00
	sta	$025B
	lda	#$00
	sta	$025C
	lda	#$00
	sta	$025D
	lda	#$00
	sta	$025E
	lda	#$00
	sta	$025F
	lda	#$00
	sta	$0260
	lda	#$00
	sta	$0261
	lda	#$00
	sta	$0262
	lda	#$00
	sta	$0263
	lda	#$00
	sta	$0264
	lda	#$00
	sta	$0265
	lda	#$00
	sta	$0266
	lda	#$00
	sta	$0267
	lda	#$00
	sta	$0268
	lda	#$00
	sta	$0269
	lda	#$00
	sta	$026A
	lda	#$00
	sta	$026B
	lda	#$00
	sta	$026C
	lda	#$00
	sta	$026D
	lda	#$00
	sta	$026E
	lda	#$00
	sta	$026F

	lda	#$00
.	byte	$8d,$00,$00 ; sta	$0000
	lda	#$00
.	byte	$8d,$01,$00 ; sta	$0001

ifdef	real
	ldy	#$0d
else
	ldy	#$03
endif
wait_e2	lda	($00,x)	; waste
	nop		; 8 cycles
	dey
	bne	wait_e2
	rol	$02	; waste 5 cycles
	
	jmp	lbl
