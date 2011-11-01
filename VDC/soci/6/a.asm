
p1		= $fb
p2		= $fd

		*= $801
		.word sg, 2011
		.null $9e, ^start
sg		.word 0

start
		ldx #0
-		lda regs,x
		jsr set
		inx
		cpx #37
		blt -
		jsr charset
		jsr screen
		jsr attrib
		rts

charset
		lda #<font
		sta p1
		lda #>font
		sta p1+1
		ldx #18
		lda #$20
		jsr set
		inx
		lda #0
		jsr set

		ldx #31
		lda #0
		sta p2
lp		ldy #0
-		lda (p1),y
		eor #255
		jsr set
		iny
		cpy #12
		bne -
		jsr set
		jsr set
		jsr set
		jsr set
		lda p1
		clc
		adc #12
		sta p1
		bcc *+4
		inc p1+1
		dec p2
		bne lp
		rts

screen
		ldx #18
		lda #$10
		jsr set
		inx
		lda #0
		jsr set

		ldx #31

		lda #16
		sta p1
		ldy #0
-		tya
		jsr set
		iny
		bne -
		dec p1
		bne -
		rts
attrib
		ldx #18
		lda #$00
		jsr set
		inx
		lda #0
		jsr set

		ldx #31

		lda #4
		sta p1
		ldy #0
-		tya
		and #$0f
		jsr set
		jsr set
		jsr set
		jsr set
		iny
		bne -
		dec p1
		bne -
		rts

regs		.byte 512/6-1		;  0 horiz total
		.byte 64		;  1 horiz display
		.byte 76		;  2 horiz sync
		.byte $0f		;  3 sync size
		.byte 263/12-1		;  4 vert total
		.byte 263 // 12		;  5 vert fine
		.byte 18		;  6 vert display
		.byte 20		;  7 vert sync
		.byte 0			;  8 interlace
		.byte 12-1		;  9 character height
		.byte $20		; 10 cursor start
		.byte 31		; 11 cursor end
		.byte >$1000		; 12 display start
		.byte <$1000		; 13
		.byte >$1020		; 14 cursor
		.byte <$1020		; 15
		.byte 0			; 16 light pen vert
		.byte 0			; 17 light pen horiz
		.byte 0			; 18 update horiz
		.byte 0			; 19
		.byte >$0000		; 20 attrib start
		.byte <$0000		; 21
		.byte $69		; 22 horiz total, display stop
		.byte 11		; 23 vertical display stop
		.byte $5f		; 24 reverse, vertical scroll
		.byte $55		; 25 mode
		.byte $0e		; 26 fg/bg
		.byte 0			; 27 increment
		.byte $20		; 28 charset/ramsize
		.byte 7			; 29 underline
		.byte 1			; 30 word count
		.byte 0			; 31 data
		.byte 0			; 32 source
		.byte 0			; 33
		.byte 6			; 34 display begin
		.byte 6+64+2		; 35 display end
		.byte 0			; 36 refresh

set		stx $d600
-		bit $d600
		bpl -
		sta $d601
		rts

font		.binary "Lat2-Terminus12x6.psf",32,256*12

