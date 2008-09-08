; gfxmodes
; --------
; 2007 Hannu Nuotio

; This program tests DTV GFX stuff.

; TODO: FRED, FRED2

; Memory map:
; $0400-$07f7 : screen in normal&... mode
; $0800-$09ff : font1bpp (64 chars)
; $0a00-$xxxx : code
; $xx00-$yyff : font8bpp (256 chars)
; $5c00-$5ff7 : screen memory in hires_bm&... mode
; $6000-$7ff7 : font memory in hires_bm&... mode
; Highmem:
; $020000-$02xxxx : (plane B) screen memory in chunky&... mode
; $030000-$03xxxx : (plane A) screen memory in FRED&... mode
; $040000-$04xxxx : font8bpp (256 chars)

!ct scr

; --- Macros

; SpriteLine - for easy definition of sprites
; from "ddrv.a" by Marco Baye
!macro SpriteLine .v {
!by .v>>16, (.v>>8)&255, .v&255
}


; --- Constants

sprite1x = 24
sprite1y = 50
sprite2x = 24+42*1
sprite2y = 50+25*1
sprite3x = 24+42*2
sprite3y = 50+25*2
sprite4x = 24+42*3
sprite4y = 50+25*3
sprite5x = 24+42*4
sprite5y = 50+25*4
sprite6x = 24+42*5
sprite6y = 50+25*5
sprite7x = 24+42*6
sprite7y = 50+25*6
sprite8x = 24+42*7
sprite8y = 50+25*7


; --- Variables

; - zero page

bmpptr = $f0		; zp pointer to bitmap
strptr = $39            ; zp pointer to string
tmpptr = $56		; temporary zp pointer 2
scrptr = $fb            ; zp pointer to screen
colptr = $fd            ; zp pointer to color
tmpvar = $ff            ; temporary zp variable


; --- Main 

; start of program
;*=$0801
;entry:
; BASIC stub: "1 SYS 2061"
;!by $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00

*=$0a00
mlcodeentry:

; - interrupt setup
; from "An Introduction to Programming C-64 Demos" by Puterman aka Linus Åkerlund
; http://user.tninet.se/~uxm165t/demo_programming/demo_prog/demo_prog.html
; ... + modifications
;
sei             ; interrupts off
lda #$7f
ldx #$01
sta $dc0d       ; Turn off CIA 1 interrupts
sta $dd0d       ; Turn off CIA 2 interrupts
stx $d01a       ; Turn on raster interrupts
lda #<int       ; low part of address of interrupt handler code
ldx #>int       ; high part of address of interrupt handler code
ldy #250        ; line to trigger interrupt
sta $0314       ; store in interrupt vector
stx $0315
sty $d012
lda #<nmi       ; low part of address of NMI handler code
ldx #>nmi       ; high part of address of NMI handler code
sta $0318       ; store in NMI vector
stx $0319
lda $dc0d       ; ACK CIA 1 interrupts
lda $dd0d       ; ACK CIA 2 interrupts
asl $d019       ; ACK VIC interrupts
cli             ; interrupts on

; copy character rom to font1bpp (64 chars)
ldx #0          ; 255 loops
sei             ; interrups off
lda $1
and #$fb
sta $1          ; character rom on
-       lda $d000,x     	; load from char-rom
        sta $0800,x     	; store to ram
        lda $d100,x     	; load from char-rom
        sta $0900,x     	; store to ram
        inx
        bne -

; calculate font8bpp
lda #<$d000
sta calcfontsrc
lda #>$d000
sta calcfontsrc+1
lda #<font8bpp
sta calcfontdst
lda #>font8bpp
sta calcfontdst+1
lda #0
sta tmp
---
ldy #8
--
    tya
    pha
    ldx #8
    calcfontsrc=*+1
    lda $1234
	-
	ldy #0
	rol
	bcc +
	ldy #$ff
	+
	calcfontdst=*+1
	sty $2345
	inc calcfontdst
	bne +
	inc calcfontdst+1
	+ dex
	bne -
    inc calcfontsrc
    bne +
    inc calcfontsrc+1
    + pla
    tay
    dey
    bne --
dec tmp
bne ---

lda $1
ora #$04
sta $1          ; character rom off
asl $d019       ; ACK VIC interrupts
cli             ; interrupts on

; copy font8bpp to $040000
; map $8000 to $040000
!by $32, $ee
lda #$10
!by $32, $00

lda #<font8bpp
sta copyfontsrc
lda #>font8bpp
sta copyfontsrc+1
lda #<$8000
sta copyfontdst
lda #>$8000
sta copyfontdst+1
ldy #64
-- ldx #0
- 
copyfontsrc=*+1
lda $1234,x
copyfontdst=*+1
sta $1234,x
inx
bne -
inc copyfontsrc+1
inc copyfontdst+1
dey
bne --

; map $8000 to $8000
!by $32, $ee
lda #$02
!by $32, $00

; set common sprite stuff
lda #<sprite1x
sta $d000
lda #<sprite2x
sta $d002
lda #<sprite3x
sta $d004
lda #<sprite4x
sta $d006
lda #<sprite5x
sta $d008
lda #<sprite6x
sta $d00a
lda #<sprite7x
sta $d00c
lda #<sprite8x
sta $d00e
lda #sprite1y
sta $d001
lda #sprite2y
sta $d003
lda #sprite3y
sta $d005
lda #sprite4y
sta $d007
lda #sprite5y
sta $d009
lda #sprite6y
sta $d00b
lda #sprite7y
sta $d00d
lda #sprite8y
sta $d00f
lda #(((>sprite8x)<<7) + ((>sprite7x)<<6) + ((>sprite6x)<<5) + ((>sprite5x)<<4) + ((>sprite4x)<<3) + ((>sprite3x)<<2) + ((>sprite2x)<<1) + (>sprite1x))
sta $d010
lda #$ff
sta $d015	; enable
lda #0
sta $d027
sta $d01b	; priority
sta $d01c	; MCM
sta $d01d	; x expand 
sta $d017	; y expand 


mainloop:
; disable extended registers
lda #0
sta $d03f

lda #>normal_text_msg
sta strptr+1
lda #<normal_text_msg
sta strptr
jsr show_normal_text

lda #>mc_text_msg
sta strptr+1
lda #<mc_text_msg
sta strptr
jsr show_mc_text

lda #>hires_bm_msg
sta strptr+1
lda #<hires_bm_msg
sta strptr
jsr show_hires_bitmap

lda #>mc_bm_msg
sta strptr+1
lda #<mc_bm_msg
sta strptr
jsr show_mc_bitmap

lda #>ext_text_msg
sta strptr+1
lda #<ext_text_msg
sta strptr
jsr show_ext_text

; enable extended registers
lda #1
sta $d03f

lda #>normal_text_8bpp_msg
sta strptr+1
lda #<normal_text_8bpp_msg
sta strptr
jsr show_normal_text_8bpp

lda #>mc_text_8bpp_msg
sta strptr+1
lda #<mc_text_8bpp_msg
sta strptr
jsr show_mc_text_8bpp

lda #>hires_bm_8bpp_msg
sta strptr+1
lda #<hires_bm_8bpp_msg
sta strptr
jsr show_hires_bitmap_8bpp

lda #>mc_bm_8bpp_msg
sta strptr+1
lda #<mc_bm_8bpp_msg
sta strptr
jsr show_mc_bitmap_8bpp

lda #>ext_text_8bpp_msg
sta strptr+1
lda #<ext_text_8bpp_msg
sta strptr
jsr show_ext_text_8bpp

lda #>chunky_8bpp_msg
sta strptr+1
lda #<chunky_8bpp_msg
sta strptr
jsr show_chunky_8bpp

lda #>two_plane_8bpp_msg
sta strptr+1
lda #<two_plane_8bpp_msg
sta strptr
jsr show_two_plane_8bpp

;jsr show_fred_8bpp

;jsr show_fred2_8bpp

lda #>pixel_cell_8bpp_msg
sta strptr+1
lda #<pixel_cell_8bpp_msg
sta strptr
jsr show_pixel_cell_8bpp

; disable 8BPP
lda #%00000000
sta $d03c
jmp mainloop


; --- Subroutines


; - set_sprite
; parameters:
;  colptr -> sprite location
;  tmpptr -> pointer location
;  a = color
;
set_sprite:
ldy #0
- lda sprite,y
sta (colptr),y
iny
cpy #63
bne -
lda colptr+1
sta tmp
lda colptr
ldy #6
- clc
ror tmp
ror
dey
bne -
ldy #7
- sta (tmpptr),y
dey
bpl -
rts


; - printstring_normal_text
; parameters:
;  scrptr -> screen location to print to
;  strptr -> string to print
;  x = the color of text
;  y = OR'd to char (for ext. text mode)
;  scrtocol = difference between screen & color memory
;
printstring_normal_text:
tya
sta printstring_normal_text_or
pha
; set colptr according to scrptr
lda scrptr
sta colptr
lda scrptr+1
clc
adc scrtocol
sta colptr+1
; string loop
ldy #0
- lda (strptr),y
beq +++         ; end if zero
printstring_normal_text_or=*+1
ora #5
sta (scrptr),y  ; print char
txa
sta (colptr),y  ; set color
iny
bne -           ; loop if not zero
inc strptr+1
inc scrptr+1
inc colptr+1
bne -
+++
clc
tya		; update scrptr to next char
adc scrptr
sta scrptr
bcc +
inc scrptr+1
+ pla
tay
rts             ; return


; - printstring_hires_bitmap
; parameters:
;  scrptr -> screen location to print to
;  strptr -> string to print
;  x = the color of text/background
;  scrtocol = color memory MSB
;
printstring_hires_bitmap:
tya
pha
; set colptr according to scrptr
lda scrptr
sta colptr
lda scrptr+1
sta colptr+1
ror colptr+1
ror colptr
ror colptr+1
ror colptr
ror colptr+1
ror colptr
lda colptr+1
and #$03
clc
adc scrtocol
sta colptr+1
; string loop
ldy #0
--
lda (strptr),y  ; a = char at strptr+y
beq +++         ; if char = 0, leave
sta bmpptr      ; bmpptr = char
lda #0
asl bmpptr      ; bmpptr = 2*x, c=msb
rol             ; c->a,lsb
asl bmpptr      ; bmpptr = 4*x, c=msb
rol
asl bmpptr      ; bmpptr = 8*x, c=msb
rol             ; a:bmpptr = 8*x, tmp = 0
adc #$08        ; a:bmpptr = $0800+char*8
sta bmpptr+1
txa
sta (colptr),y
tya
pha
ldy #7          ; 8 lines
-               ; line loop
        lda (bmpptr),y  ; load from char-rom
        sta (scrptr),y  ; store to screen
        dey             ; next line
	bpl -
lda #8
clc
adc scrptr      ; a = scrptr+8, c=msb
sta scrptr
bcc +
inc scrptr+1
+ 
pla
tay
iny             ; y++, -> next char
bne --
inc colptr+1
inc strptr+1
bne --
+++
pla
tay
rts             ; return


; - blit
;
blit:
; blit bmpptr to scrptr
lda bmpptr
sta $d320	; source A low
lda bmpptr+1
sta $d321	; source A middle
lda #0
sta $d322	; source A high
sta $d323	; source A modulo low
sta $d324	; source A modulo high
blitsrcalenl=*+1
lda #$12
sta $d325	; source A line length low
lda #0
sta $d326	; source A line length high
lda #$10
sta $d327	; source A step
lda #<tmp
sta $d328	; source B low
lda #>tmp
sta $d329	; source B middle
lda #0
sta $d32a	; source B high
sta $d32b	; source B modulo low
sta $d32c	; source B modulo high
blitsrcblenl=*+1
lda #$12
sta $d32d	; source B line length low
lda #0
sta $d32e	; source B line length high
lda #0
sta $d32f	; source B step
lda scrptr
sta $d330	; dest low
lda scrptr+1
sta $d331	; dest middle
lda screenh
sta $d332	; dest high
blitdestmodl=*+1
lda #$12
sta $d333	; dest modulo low
blitdestmodh=*+1
lda #$12
sta $d334	; dest modulo high
blitdestlinel=*+1
lda #$12
sta $d335	; dest line length low
lda #0
sta $d336	; dest line length high
lda #$10
sta $d337	; dest step
blitlen=*+1
lda #$12
sta $d338	; blit length low
lda #0
sta $d339	; blit length high
sta $d33b	; blit control (always)
sta $d33e	; blit control (no shift, AND)
- cmp $d33f
bne -		; wait until blitter is ready
lda #$0f
sta $d33a	; start blit (pos. directions)
rts


; - printstring_chunky
; parameters:
;  scrptr -> screen location to print to (mid:lo)
;  strptr -> string to print
;  x = bitmask for bytes in font
;  screenh = screen location hi byte
;
printstring_chunky:
stx tmp		; tmp = bitmask
tya
pha
; string loop
ldy #0
--
lda (strptr),y  ; a = char at strptr+y
beq +++         ; if char = 0, leave
sta bmpptr+1    ; bmpptr = char*256
lda #0
lsr bmpptr+1
ror
lsr bmpptr+1
ror
clc
adc #<font8bpp
sta bmpptr
clc
lda bmpptr+1
adc #>font8bpp
sta bmpptr+1	; bmpptr -> char at font8bpp
jsr blit
lda #8
clc
adc scrptr      ; a = scrptr+8, c=msb
sta scrptr
bcc +
inc scrptr+1
+ 
iny             ; y++, -> next char
bne --
inc strptr+1
bne --
+++
pla
tay
clc
lda #<(320*7)
adc scrptr
sta scrptr
lda #>(320*7)
adc scrptr+1
sta scrptr+1
rts             ; return

; - printstring_pixel_cell
; parameters:
;  scrptr -> screen location to print to (mid:lo)
;  strptr -> string to print
;  x = color
;
printstring_pixel_cell:
tya
pha
; set colptr according to scrptr
lda scrptr
sta colptr
lda scrptr+1
clc
adc scrtocol
sta colptr+1
; string loop
ldy #0
- lda (strptr),y
beq +++         ; end if zero
sta (scrptr),y  ; print char
txa
sta (colptr),y  ; set color
iny
bne -           ; loop if not zero
inc strptr+1
inc scrptr+1
inc colptr+1
bne -
+++
clc
tya		; update scrptr to next char
adc scrptr
sta scrptr
bcc +
inc scrptr+1
+ pla
tay
rts             ; return


; - printstring_two_plane
; parameters:
;  scrptr -> screen location to print to
;  strptr -> string to print
;  x = color
;
printstring_two_plane:
tya
pha
; string loop
ldy #0
--
lda (strptr),y  ; a = char at strptr+y
beq +++         ; if char = 0, leave
sta bmpptr      ; bmpptr = char
lda #0
asl bmpptr      ; bmpptr = 2*x, c=msb
rol             ; c->a,lsb
asl bmpptr      ; bmpptr = 4*x, c=msb
rol
asl bmpptr      ; bmpptr = 8*x, c=msb
rol             ; a:bmpptr = 8*x, tmp = 0
adc #$08        ; a:bmpptr = $0800+char*8
sta bmpptr+1
; set tmpptr
lda scrptr
sta tmpptr
lda scrptr+1
sta tmpptr+1
tya
pha
ldy #0          ; 8 lines
txa
sta (colptr),y  ; set color
-               ; line loop
        lda (bmpptr),y  ; load from char-rom
	sty tmp
	ldy #0
        sta (tmpptr),y  ; store to screen
	clc
	lda #<40
	adc tmpptr
	sta tmpptr
	lda #>40
	adc tmpptr+1
	sta tmpptr+1
        ldy tmp
        iny             ; next line
	cpy #8
	bne -
inc scrptr
bne +
inc scrptr+1
+ 
pla
tay
iny             ; y++, -> next char
bne --
inc strptr+1
bne --
+++
clc
pla
tay
rts             ; return


; - show_normal_text
;
show_normal_text_8bpp:
; enable 8BPP
lda #%00000100
sta $d03c
show_normal_text:
; change mode
lda #%00000011
sta $dd00
lda #%00011011
ldx #%00001000
ldy #%00010010
sta $d011
stx $d016
sty $d018
lda #$d4
sta scrtocol

; set colors
lda #$43
sta $d021

; set sprite
lda #>$07f8
sta tmpptr+1
lda #<$07f8
sta tmpptr
lda #>$0200
sta colptr+1
lda #<$0200
sta colptr
jsr set_sprite

; print text
lda #>$0400
sta scrptr+1
lda #<$0400
sta scrptr
ldx #0
ldy #0
-
jsr printstring_normal_text
inx
cpx #25
bne -
jsr getinput
rts


; - show_mc_text
;
show_mc_text_8bpp:
; enable 8BPP
lda #%00000100
sta $d03c
show_mc_text:
; change mode
lda #%00000011
sta $dd00
lda #%00011011
ldx #%00011000
ldy #%00010010
sta $d011
stx $d016
sty $d018
lda #$d4
sta scrtocol

; set colors
lda #$43
sta $d021
lda #$25
sta $d022
lda #$f7
sta $d023

; set sprite
lda #>$07f8
sta tmpptr+1
lda #<$07f8
sta tmpptr
lda #>$0200
sta colptr+1
lda #<$0200
sta colptr
jsr set_sprite

; print text
lda #>$0400
sta scrptr+1
lda #<$0400
sta scrptr
ldx #0
ldy #0
-
jsr printstring_normal_text
inx
cpx #25
bne -
jsr getinput
rts


; - show_hires_bitmap
;
show_hires_bitmap_8bpp:
; enable 8BPP
lda #%00000100
sta $d03c
show_hires_bitmap:
; change mode
lda #%00000010
sta $dd00
lda #%00111011
ldx #%00001000
ldy #%01111000
sta $d011
stx $d016
sty $d018
lda #$5c
sta scrtocol

; set sprite
lda #>$5ff8
sta tmpptr+1
lda #<$5ff8
sta tmpptr
lda #>($5c00 - 64)
sta colptr+1
lda #<($5c00 - 64)
sta colptr
jsr set_sprite

; print text
lda #>$6000
sta scrptr+1
lda #<$6000
sta scrptr
ldx #$21
ldy #0
-
jsr printstring_hires_bitmap
clc
txa
adc #$21
tax
iny
cpy #25
bne -
jsr getinput
rts


; - show_mc_bitmap
;
show_mc_bitmap_8bpp:
; enable 8BPP
lda #%00000100
sta $d03c
show_mc_bitmap:
; change mode
lda #%00000010
sta $dd00
lda #%00111011
ldx #%00011000
ldy #%01111000
sta $d011
stx $d016
sty $d018
lda #$5c
sta scrtocol

; set colors
lda #$43
sta $d021
lda #$25
sta $d022
lda #$f7
sta $d023

; set sprite
lda #>$5ff8
sta tmpptr+1
lda #<$5ff8
sta tmpptr
lda #>($5c00 - 64)
sta colptr+1
lda #<($5c00 - 64)
sta colptr
jsr set_sprite

; print text
lda #>$6000
sta scrptr+1
lda #<$6000
sta scrptr
ldx #$21
ldy #0
-
jsr printstring_hires_bitmap
clc
txa
adc #$21
tax
iny
cpy #25
bne -
jsr getinput
rts


; - show_ext_text
;
show_ext_text_8bpp:
; enable 8BPP
lda #%00000100
sta $d03c
show_ext_text:
; change mode
lda #%00000011
sta $dd00
lda #%01011011
ldx #%00001000
ldy #%00010010
sta $d011
stx $d016
sty $d018
lda #$d4
sta scrtocol

; set colors
lda #$43
sta $d021
lda #$25
sta $d022
lda #$f7
sta $d023
lda #$8e
sta $d024

; set sprite
lda #>$07f8
sta tmpptr+1
lda #<$07f8
sta tmpptr
lda #>$0200
sta colptr+1
lda #<$0200
sta colptr
jsr set_sprite

; print text
lda #>$0400
sta scrptr+1
lda #<$0400
sta scrptr
ldx #0
ldy #$00
-
jsr printstring_normal_text
tya
clc
adc #$40
tay
inx
cpx #25
bne -
jsr getinput
rts


; - show_chunky_8bpp
;
show_chunky_8bpp:
; enable 8BPP, lin.addr, colorfetch disable & chunky enable
lda #%01010101
sta $d03c
; change mode
lda #%01011011
ldx #%00011000
ldy #%00010010
sta $d011
stx $d016
sty $d018
lda #$02
sta screenh
; point countB to screen
lda #$02
ldx #$00
ldy #$08
stx $d047	; Linear Count B modulo low
stx $d048	; Linear Count B modulo high
stx $d049	; Linear Count B start low
stx $d04a	; Linear Count B start mid
sta $d04b	; Linear Count B start high
sty $d04c	; Linear Count B step

; set sprite
lda #>$07f8
sta tmpptr+1
lda #<$07f8
sta tmpptr
lda #>$0200
sta colptr+1
lda #<$0200
sta colptr
jsr set_sprite

; print text
lda #<(320-8)
sta blitdestmodl
lda #>(320-8)
sta blitdestmodh
lda #8
sta blitdestlinel
sta blitsrcalenl
sta blitsrcblenl
lda #(8*8+7)
sta blitlen
lda #>$0000
sta scrptr+1
lda #<$0000
sta scrptr
ldx #$21
ldy #0
-
jsr printstring_chunky
clc
txa
adc #$21
tax
iny
cpy #25
bne -
jsr getinput
rts


; - show_two_plane_8bpp
;
show_two_plane_8bpp:
; enable 8BPP, lin.addr
lda #%00000101
sta $d03c
; change mode
lda #%01111011
ldx #%00001000
ldy #%00010010
sta $d011
stx $d016
sty $d018
lda #$02
sta screenhb
lda #$03
sta screenha

; point countB to $03xxxx + 1
lda #$03
ldx #$00
ldy #$01
stx $d047	; Linear Count B modulo low
stx $d048	; Linear Count B modulo high
sty $d049	; Linear Count B start low
stx $d04a	; Linear Count B start mid
sta $d04b	; Linear Count B start high
sty $d04c	; Linear Count B step

; point countA to $03xxxx
lda #$03
ldx #$00
ldy #$01
stx $d038	; Linear Count A modulo low
stx $d039	; Linear Count A modulo high
stx $d03a	; Linear Count A start low
stx $d03b	; Linear Count A start mid
sta $d045	; Linear Count A start high
sty $d046	; Linear Count A step

; set sprite
lda #>$07f8
sta tmpptr+1
lda #<$07f8
sta tmpptr
lda #>$0200
sta colptr+1
lda #<$0200
sta colptr
jsr set_sprite

; print text
lda #>$4000
sta scrptr+1
lda #<$4000
sta scrptr
lda #>$d800
sta colptr+1
lda #<$d800
sta colptr
ldy #0
ldx #0
-
; map $4000 to plane b
!by $32, $dd
lda #$0c
!by $32, $00
jsr printstring_two_plane
; map $4000 to plane a
!by $32, $dd
lda #$08
!by $32, $00
jsr printstring_two_plane
clc
lda #<40*6
adc scrptr
sta scrptr
lda #>40*6
adc scrptr+1
sta scrptr+1
clc
lda #<40
adc colptr
sta colptr
lda #>40
adc colptr+1
sta colptr+1
clc
txa
adc #$21
tax
iny
cpy #25
bne -

; map $4000 to $4000
!by $32, $dd
lda #$01
!by $32, $00

jsr getinput

; zero count A
lda #$00
sta $d038	; Linear Count A modulo low
sta $d039	; Linear Count A modulo high
sta $d03a	; Linear Count A start low
sta $d03b	; Linear Count A start mid
sta $d045	; Linear Count A start high
sta $d046	; Linear Count A step
rts


; - show_pixel_cell_8bpp
;
show_pixel_cell_8bpp:
; enable 8BPP, lin.addr & chunky enable
lda #%01000101
sta $d03c
; change mode
lda #%01011011
ldx #%00011000
ldy #%00010010
sta $d011
stx $d016
sty $d018
lda #$58
sta scrtocol

; point countB to $040000
lda #$04
ldx #$00
stx $d047	; Linear Count B modulo low
stx $d048	; Linear Count B modulo high
stx $d049	; Linear Count B start low
stx $d04a	; Linear Count B start mid
sta $d04b	; Linear Count B start high
stx $d04c	; Linear Count B step

; point countA to $030000
lda #$03
ldx #$00
ldy #1
stx $d038	; Linear Count A modulo low
stx $d039	; Linear Count A modulo high
stx $d03a	; Linear Count A start low
stx $d03b	; Linear Count A start mid
sta $d045	; Linear Count A start high
sty $d046	; Linear Count A step

; set sprite
lda #>$07f8
sta tmpptr+1
lda #<$07f8
sta tmpptr
lda #>$0200
sta colptr+1
lda #<$0200
sta colptr
jsr set_sprite

; map $8000 to $030000
!by $32, $ee
lda #$0c
!by $32, $00

; print text
lda #>$8000
sta scrptr+1
lda #<$8000
sta scrptr
ldx #0
ldy #0
-
jsr printstring_pixel_cell
clc
txa
adc #$21
tax
iny
cpy #25
bne -

; map $8000 to $8000
!by $32, $ee
lda #$02
!by $32, $00

jsr getinput

; zero count A
lda #$00
sta $d038	; Linear Count A modulo low
sta $d039	; Linear Count A modulo high
sta $d03a	; Linear Count A start low
sta $d03b	; Linear Count A start mid
sta $d045	; Linear Count A start high
sta $d046	; Linear Count A step
rts


; - getinput
; returns:
;  a = action (xxxfrldu, 1 = active)
;
getinput:
lda #0
sta joycount    ; reset joyrepeat counter
-- lda #200
ldy joycount
- ;inc $d020	; flash border 
cmp $d012
bne -           ; wait until raster = rastercmp
iny             ; y++
cpy #15		; check if y >= 15
bcc getinput_j  ; if not, skip
ldy #0          ; reset joyrepeat counter
lda #$ff        ; reset lastjoy for repeat
sta lastjoy
getinput_j:
sty joycount    ; store joycount
lda $dc01       ; a = joystick 1
tax             ; save to x
eor lastjoy     ; a = joy xor lastjoy
and lastjoy     ; a = a and lastjoy
stx lastjoy     ; update lastjoy
and #$1f        ; mask + test if anything is pressed
beq --          ; if not, wait
rts             ; return (a = action)
joycount !by 0
lastjoy !by 0


; --- Interrupt routines

; - IRQ
;
int:
asl $d019       ; ACK interrupt (to re-enable it)
pla
tay
pla
tax
pla             ; pop y,x and a from stack
rti             ; return

; - NMI
;
nmi:
rti             ; return


; --- Data

; - Strings

normal_text_msg
!tx "... this is normal text mode         ,q!",0
mc_text_msg
!tx "... this is mc text mode             ,q!",0
hires_bm_msg
!tx "... this is hires bitmap mode        ,q!",0
mc_bm_msg
!tx "... this is mc bitmap mode           ,q!",0
ext_text_msg
!tx "... this is ext text mode            ,q!",0
normal_text_8bpp_msg
!tx "... this is normal text mode in 8bpp ,q!",0
mc_text_8bpp_msg
!tx "... this is mc text mode in 8bpp     ,q!",0
hires_bm_8bpp_msg
!tx "... this is hires bitmap mode in 8bpp,q!",0
mc_bm_8bpp_msg
!tx "... this is mc bitmap mode in 8bpp   ,q!",0
ext_text_8bpp_msg
!tx "... this is ext text mode in 8bpp    ,q!",0
chunky_8bpp_msg
!tx "... this is chunky mode (8bpp)       ,q!",0
two_plane_8bpp_msg
!tx "... this is two plane mode (8bpp)    ,q!",0
pixel_cell_8bpp_msg
!tx "... this is pixel cell mode (8bpp)   ,q!",0

; - Sprites

sprite
;            765432107654321076543210
+SpriteLine %#...#..###...###..####.. ;1
+SpriteLine %#...#...#...#.....#..... ;2
+SpriteLine %#...#...#...#.....#..... ;3
+SpriteLine %#...#...#...#.....###... ;4
+SpriteLine %.#.#....#...#.....#..... ;5
+SpriteLine %..#....###...###..####.. ;6
+SpriteLine %........................ ;7
+SpriteLine %........................ ;8
+SpriteLine %####...########..##...## ;9
+SpriteLine %#####..########..##...## ;10
+SpriteLine %#...##....##.....##...## ;11
+SpriteLine %#...##....##.....##...## ;12
+SpriteLine %#...##....##.....##...## ;13
+SpriteLine %#...##....##.....##...## ;14
+SpriteLine %#...##....##.....##...## ;15
+SpriteLine %#####.....##......##.##. ;16
+SpriteLine %####......##.......###.. ;17
+SpriteLine %........................ ;18
+SpriteLine %........................ ;19
+SpriteLine %#.#.#.#.#.#.#.#.#.#.#.#. ;20
+SpriteLine %.#.#.#.#.#.#.#.#.#.#.#.# ;21
        

; - Misc

screenha !by 0
screenhb !by 0
screenh !by 0
scrtocol !by 0
tmp !by 0
!align 255,0
font8bpp !by 0	; 8bpp font calculated from 1bpp font
font8bpp_end = *+(256*64)