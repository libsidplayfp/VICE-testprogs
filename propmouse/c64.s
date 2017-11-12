bufferpos = $f8
readbufferpos = $f9

screen = $0400

zptemp = $fe

xbuffer = $c000
ybuffer = $c100
inbuffer = $c200

SPRITE0_DATA = $340

polllines = 8

	.include "prop.inc"

	.import prop_state_x

	.code
_start:

	sei

    ldx #0
:
    lda #$20
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    lda #$01
    sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $db00,x
    inx
    bne :-
    
    lda #$35
    sta $01
    lda #>irq
    sta $ffff
    lda #<irq
    sta $fffe
    lda #$01
    sta $d01a
    lda #$7f
    sta $dc0d
    lda #$1b
    sta $d011
    lda #$0
    sta $d012

    ldx #$3f
:
    lda MouseSprite, x
    sta SPRITE0_DATA,x
    dex
    bpl :-
    
    lda #SPRITE0_DATA / 64
    sta $7f8

    lda #0
    sta $d027
    lda #$01
    sta $d015
	
	jsr prop_init
	lda $0288
	sta $ff

    inc $d019
    lda $dc0d
    cli
	
mainloop:

    lda #$0b
    sta $d020

    ;lda $d011
    ;bmi *-3
    ;lda $d011
    ;bpl *-3

    lda #1
    sta $d020

	lda #0
	sta zptemp

	ldx bufferpos
	dex
	stx readbufferpos
	
	ldx readbufferpos
	lda inbuffer,x
	jsr printnibble

	lda #':'
	jsr printchar

	ldx readbufferpos
	lda xbuffer,x
	sta $d000
	jsr printbyte

	lda #','
	jsr printchar

	ldx readbufferpos
	lda ybuffer,x
	sta $d001
	jsr printbyte

	lda #' '
	jsr printchar

	lda prop_err + 1
	jsr printbyte
	lda prop_err
	jsr printbyte

;	lda #comma
;	jsr printchar
;	jsr trace_state

	ldx readbufferpos
	lda inbuffer,x
	and #$10
	beq doplot
    
    jmp mainloop
    
doplot:
	lda bufferpos
	sec
	sbc #41
	tax
	
	ldy #0
lp1:
	lda inbuffer,x
	and #$01
	sta $0400+(2*40),y
	lda inbuffer,x
	and #$04
	sta $0400+(3*40),y

	lda inbuffer,x
	and #$02
	sta $0400+(14*40),y
	lda inbuffer,x
	and #$08
	sta $0400+(15*40),y
	inx
	iny
	cpy #40
	bne lp1

	lda bufferpos
	sec
	sbc #41+40
	tax
	
	ldy #0
lp2:
	lda inbuffer,x
	and #$01
	sta $0400+(5*40),y
	lda inbuffer,x
	and #$04
	sta $0400+(6*40),y

	lda inbuffer,x
	and #$02
	sta $0400+(17*40),y
	lda inbuffer,x
	and #$08
	sta $0400+(18*40),y
	inx
	iny
	cpy #40
	bne lp2

	lda bufferpos
	sec
	sbc #41+40+40
	tax
	
	ldy #0
lp3:
	lda inbuffer,x
	and #$01
	sta $0400+(8*40),y
	lda inbuffer,x
	and #$04
	sta $0400+(9*40),y

	lda inbuffer,x
	and #$02
	sta $0400+(20*40),y
	lda inbuffer,x
	and #$08
	sta $0400+(21*40),y
	inx
	iny
	cpy #40
	bne lp3

	lda bufferpos
	sec
	sbc #41+40+40+40
	tax
	
	ldy #0
lp4:
	lda inbuffer,x
	and #$01
	sta $0400+(11*40),y
	lda inbuffer,x
	and #$04
	sta $0400+(12*40),y

	lda inbuffer,x
	and #$02
	sta $0400+(23*40),y
	lda inbuffer,x
	and #$08
	sta $0400+(24*40),y
	inx
	iny
	cpy #40
	bne lp4


	jmp mainloop

;trace_state:
;	ldx prop_state_x
;	lda hex,x
;	ldy pos
;	cmp (zptemp),y
;	beq :+
;	inc pos
;	iny
;	sta (zptemp),y
;:
;	rts

printbyte:
	pha
	lsr
	lsr
	lsr
	lsr
	tay
	lda hex,y
	jsr printchar
	pla
printnibble:
	and #15
	tay
	lda hex,y
	jsr printchar
	rts
printspc:
	lda #$20
printchar:
	ldy #0
	sta (zptemp),y
	inc zptemp
	rts

;-------------------------------------------------------------------------------	
irq:

    pha
    inc $d019
    inc $d020

nextline:
    ldx #1
    lda irqline,x
    sta $d012
    lda irqlineh,x
    sta $d011
    inx
    cpx #(312 / polllines)
    bne sk2
    ldx #0
sk2:
    stx nextline + 1

	ldx bufferpos
	lda $dc00
	sta inbuffer,x
	jsr prop_update

	ldx bufferpos

	lda prop_x
	;sta $d000
	sta xbuffer,x
	
	lda prop_y
	;sta $d001
	sta ybuffer,x
	
	inx
	stx bufferpos
	
    dec $d020
    pla
    rti

irqline:
    .repeat (320 / polllines), n
    .byte <(n * polllines)
    .endrepeat
irqlineh:
    .repeat (320 / polllines), n
    .byte ((>(n * polllines)) << 7) | $1b
    .endrepeat
    
;-------------------------------------------------------------------------------	
	
pos:
	.byt 0

hex:
	.byte "0123456789",1,2,3,4,5,6

MouseSprite:
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$0F
	.byte	$E0
	.byte	$00
	.byte	$0F
	.byte	$C0
	.byte	$00
	.byte	$0F
	.byte	$80
	.byte	$00
	.byte	$0F
	.byte	$C0
	.byte	$00
	.byte	$0D
	.byte	$E0
	.byte	$00
	.byte	$08
	.byte	$F0
	.byte	$00
	.byte	$00
	.byte	$78
	.byte	$00
	.byte	$00
	.byte	$3C
	.byte	$00
	.byte	$00
	.byte	$1E
	.byte	$00
	.byte	$00
	.byte	$0F
	.byte	$00
	.byte	$00
	.byte	$07
	.byte	$80
	.byte	$00
	.byte	$03
	.byte	$80
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00
	.byte	$00

