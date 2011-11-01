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
		lda #$20
		sta p2
lp		ldy #0
-		lda (p1),y
		jsr set
		iny
		bne -
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

		lda #8
		sta p1
		ldy #0
-		tya
		and #$80
		jsr set
		jsr set
		iny
		bne -
		dec p1
		bne -
		rts

regs		.byte 1024/9-1		;  0 horiz total
		.byte 80		;  1 horiz display
		.byte 95		;  2 horiz sync
		.byte $0f		;  3 sync size
		.byte 524/16-1		;  4 vert total
		.byte 524 // 16		;  5 vert fine
		.byte 30		;  6 vert display
		.byte 31		;  7 vert sync
		.byte 3			;  8 interlace
		.byte 16-1		;  9 character height
		.byte $60		; 10 cursor start
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
		.byte $89		; 22 horiz total, display stop
		.byte 31		; 23 vertical display stop
		.byte $00		; 24 reverse, vertical scroll
		.byte $68		; 25 mode
		.byte $0e		; 26 fg/bg
		.byte 0			; 27 increment
		.byte $20		; 28 charset/ramsize
		.byte 7			; 29 underline
		.byte 1			; 30 word count
		.byte 0			; 31 data
		.byte 0			; 32 source
		.byte 0			; 33
		.byte 6			; 34 display begin
		.byte 6+80+2		; 35 display end
		.byte 0			; 36 refresh

set		stx $d600
-		bit $d600
		bpl -
		sta $d601
		rts

font		.binary "Lat2-Terminus16.psf",4,$1000
font2		.binary "Lat2-TerminusBoldVGA16.psf",4,$1000

