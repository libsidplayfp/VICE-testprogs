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
		cpy #9
		bne -
-		jsr set
		iny
		cpy #16
		bne -
		lda p1
		clc
		adc #9
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
		and #$40
		jsr set
		jsr set
		jsr set
		jsr set
		iny
		bne -
		dec p1
		bne -
		rts

regs		.byte 512/9-1		;  0 horiz total
		.byte 40		;  1 horiz display
		.byte 51		;  2 horiz sync
		.byte $0f		;  3 sync size
		.byte 263/9-1		;  4 vert total
		.byte 263 // 9		;  5 vert fine
		.byte 25		;  6 vert display
		.byte 27		;  7 vert sync
		.byte 0			;  8 interlace
		.byte 9-1		;  9 character height
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
		.byte $9a		; 22 horiz total, display stop
		.byte 7			; 23 vertical display stop
		.byte $5f		; 24 reverse, vertical scroll
		.byte $58		; 25 mode
		.byte $0e		; 26 fg/bg
		.byte 0			; 27 increment
		.byte $20		; 28 charset/ramsize
		.byte 7			; 29 underline
		.byte 1			; 30 word count
		.byte 0			; 31 data
		.byte 0			; 32 source
		.byte 0			; 33
		.byte 6			; 34 display begin
		.byte 6+40+2		; 35 display end
		.byte 0			; 36 refresh

set		stx $d600
-		bit $d600
		bpl -
		sta $d601
		rts

font		.binary "default8x9.psf",4,256*9

