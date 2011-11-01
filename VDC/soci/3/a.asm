
p1		= $fb

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
		sei
		lda #11
		sta $d011
		ldx #13
		lda #$00
		jsr set
lop
		lda #$20
-		bit $d600
		beq -
-		bit $d600
		bne -
		ldx #13
		lda #1
		jsr set
		ldx #26
		lda #$f4
		jsr set
		ldy #255
ee
		cmp (0,x)
		cmp (0,x)
		cmp (0,x)
		cmp (0,x)
		cmp (0,x)
		cmp (0,x)
		cmp (0,x)
                dey
		bne ee
		cmp (0,x)
		cmp (0,x)
		cmp (0,x)
		cmp (0,x)
		bit $ea
		ldx #13
		lda #0
		jsr set
		ldx #26
		lda #$f2
		jsr set
		jmp lop

		rts

charset		sei
		lda #7
		sta $01
		lda #<$d000
		sta p1
		lda #>$d000
		sta p1+1
		ldx #18
		lda #0
		jsr set
		inx
		lda #0
		jsr set

		ldx #31
lp		ldy #0
-		lsr $01
		lda (p1),y
		rol $01
		jsr set
		jsr set
		jsr set
		iny
		cpy #8
		blt -
-		jsr set
		iny
		cpy #16
		blt -

		lda p1
		clc
		adc #8
		sta p1
		bcc lp
		inc p1+1
		lda p1+1
		cmp #$e0
		bne lp
		cli
		rts

screen
		ldx #18
		lda #$40
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
		lda #$50
		jsr set
		inx
		lda #0
		jsr set

		ldx #31

		lda #16
		sta p1
		ldy #0
-		tya
		ora #15
		jsr set
		iny
		bne -
		dec p1
		bne -
		rts

regs		.byte 512/8-1		;  0 horiz total
		.byte 32		;  1 horiz display
		.byte 52		;  2 horiz sync
		.byte $4e		;  3 sync size
		.byte 312/24-1		;  4 vert total
		.byte 312 // 24 +1	;  5 vert fine
		.byte 8			;  6 vert display
		.byte 13		;  7 vert sync
		.byte 0			;  8 interlace
		.byte 24-1		;  9 character height
		.byte $40		; 10 cursor start
		.byte 31		; 11 cursor end
		.byte >$4000		; 12 display start
		.byte <$4000		; 13
		.byte >$4000		; 14 cursor
		.byte <$4000		; 15
		.byte 0			; 16 light pen vert
		.byte 0			; 17 light pen horiz
		.byte 0			; 18 update horiz
		.byte 0			; 19
		.byte >$5000		; 20 attrib start
		.byte <$5000		; 21
		.byte $89		; 22 horiz total, display stop
		.byte 31		; 23 vertical display stop
		.byte $00		; 24 reverse, vertical scroll
		.byte $57		; 25 mode
		.byte $f2		; 26 fg/bg
		.byte 0			; 27 increment
		.byte $10		; 28 charset/ramsize
		.byte 7			; 29 underline
		.byte 0			; 30 word count
		.byte 0			; 31 data
		.byte 0			; 32 source
		.byte 0			; 33
		.byte 6			; 34 display begin
		.byte 6+32+2		; 35 display end
		.byte 0			; 36 refresh

set		stx $d600
-		bit $d600
		bpl -
		sta $d601
		rts
                
