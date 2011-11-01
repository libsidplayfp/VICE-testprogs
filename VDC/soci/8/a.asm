;
; Written by
;  Kajtar Zsolt <soci@c64.rulez.org>
;
;    This file is part of VICE VDC test programs
;    See README for copyright notice.
;
;    This program is free software; you can redistribute it and/or modify
;    it under the terms of the GNU General Public License as published by
;    the Free Software Foundation; either version 2 of the License, or
;    (at your option) any later version.
;
;    This program is distributed in the hope that it will be useful,
;    but WITHOUT ANY WARRANTY; without even the implied warranty of
;    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;    GNU General Public License for more details.
;
;    You should have received a copy of the GNU General Public License
;    along with this program; if not, write to the Free Software
;    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
;

p1		= $fb
p2		= $fd

		*= $801
		.word sg, 2011
		.null $9e, ^start
sg		.word 0

start
		ldx #0
-		txa
		asl
		and #14
		sta p1
		asl
		asl
		asl
		asl
		ora #$10
		ora p1
		sta const,x
		inx
		bne -
		lda #11
		sta $d011
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
		lda #$ff
		sta $dc04
		sta $dc05
		lda #$20
-		bit $d600
		beq -
-		bit $d600
		bne -
		lda #$11
		sta $dc0e
		lda #$20
-		bit $d600
		beq -
-		bit $d600
		bne -
		dec $dc0e
		lda #0
		sec
		sbc $dc04
		sta p1
		lda #0
		sbc $dc05
		sta p1+1
		ldy #70
-		dey
                lda p1
		sec
		sbc #<312
		tax
		lda p1+1
		sbc #>312
		bcc +
		sta p1+1
		stx p1
		bcs -
+
		sty at+1

		ldy #0
		ldx #255
-		inx
		tya
		sec
		sbc #<312
		tay
		lda p1
		sbc #>312
		sta p1
		lda p1+1
		sbc #0
		sta p1+1
		bcs -
		stx p2

		lda #<65476
		sec
		sbc $dc04
		sta $dc04
		lda #>65476
		sbc $dc05
		sta $dc05
		lda #$20
-		bit $d600
		beq -
-		bit $d600
		bne -
		lda #$11
		sta $dc0e
		lda #<irq
		sta $314
		lda #>irq
		sta $315
		bit $dc0d
		cli
		jmp *

		.align $100
irq
                lda #$20
-		bit $d600
		bne -
		lda #$11
		sta $dc0e
		cmp (0,x)
		cmp (0,x)
		cmp (0,x)
		cmp (0,x)
		cmp (0,x)
		lda #26
		sta $d600
		ldx #200
-		lda const-1,x
		sta $d601
		lda p1
		clc
		adc p2
		sta p1
		bcs *+2

		clc
at		bcc *+8
		lda #$a9
		lda #$a9
		lda #$a9
		lda #$a9
		lda #$a9
		lda #$a9
		lda #$a9
		lda #$a9
		lda #$a9
		lda #$a9
		lda #$a9
		lda #$a9
		lda #$a9
		lda #$a9
		lda #$a9
		lda #$a9
		lda #$a9
		bit $ea
		dex
		bne -
		jmp $ea31

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

		lda #8
		sta p1
		ldy #0
-		tya
		and #$80
		ora #15
		jsr set
		jsr set
		iny
		bne -
		dec p1
		bne -
		rts

regs		.byte 512/8-1		;  0 horiz total
		.byte 40		;  1 horiz display
		.byte 55		;  2 horiz sync
		.byte $4e		;  3 sync size
		.byte 312/8-1		;  4 vert total
		.byte 312 // 8		;  5 vert fine
		.byte 25		;  6 vert display
		.byte 33		;  7 vert sync
		.byte 0			;  8 interlace
		.byte 8-1		;  9 character height
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
		.byte $17		; 25 mode
		.byte $f2		; 26 fg/bg
		.byte 0			; 27 increment
		.byte $10		; 28 charset/ramsize
		.byte 7			; 29 underline
		.byte 0			; 30 word count
		.byte 0			; 31 data
		.byte 0			; 32 source
		.byte 0			; 33
		.byte 3			; 34 display begin
		.byte 6+40+5		; 35 display end
		.byte 0			; 36 refresh

set		stx $d600
-		bit $d600
		bpl -
		sta $d601
		rts

		.align 256
const

