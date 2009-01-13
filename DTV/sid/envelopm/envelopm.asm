; envelopm
; --------
; 2008 Hannu Nuotio

; Interactive DTVSID envelope testprog

; Start of project: 2.12.2008

; Compiles with ACME 0.91
; # acme --cpu 6502 -f cbm -o envelopm.prg envelopm.asm

; Type RUN to start.

; Known bugs:

; TODO:

; Memory map:
; $0000-$03ff : (mostly) unused
; $0400-$07ff : screen
; $0801-$xxxx : code
; $xxxx-$zzzz : data
; $zzzz-$ffff : unused

; Notes:


; --- Constants

DEBUG = 0

; - colors
color_back = $2
color_border = $0
color_text = $1
color_hilite = $2

; - keys
key_up    = $91
key_down  = $11

key_left  = $9d ; dma on
key_right = $1d ; dma off

key_enter = $0d ; save reg
key_s = $53     ; save all regs

key_space = $20 ; start test
key_g = $47     ; stop test

key_y = $59     ; increase vol
key_h = $48     ; decrease vol

key_u = $55     ; increase env
key_j = $4a     ; decrease env

key_i = $49     ; env += $10
key_k = $4b     ; env -= $10

key_o = $4f     ; save env reg
key_l = $4c     ; 


; - kernal functions
SCNKEY = $ff9f
GETIN = $ffe4           ; ret: a = 0: no keys pressed, otherwise a = ASCII code

; - hw addresses
screen = $0400          ; screen address
color = $d800           ; color ram address
vicborder = $d020       ; border color register
vicbackgnd = $d021      ; background color register
vicraster = $d012       ; raster compare register
keybuf = $0277          ; keyboard buffer
keybuflen = $c6         ; keyboard buffer byte count
sidbase = $d400         ; SID base address

; - other
rastercmp = $ff
cursor_min = $7
cursor_max = $e
dmalen = 63*312/2 ; - 1

; --- Zero page variables

; temp variables
tmp  = $23
tmp2 = $24
tmp3 = $25

; - colorram pointer
colptr = $fb
colptrh = $fc

; - temp pointer
tmpptr = $fd
tmpptrh = $fe


; --- Main 

!ct scr ; screencode

; start of program
*=$0801
entry:
; BASIC stub: "1 SYS 2061"
!by $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00

mlcodeentry:
; enable extended registers
lda #1
sta $d03f

; enable skip+burst
;sei
;!by $32, $99    ; sac #$99
;lda #3
;!by $32, $00    ; sac #$00
;cli

; disable badlines and colorram fetch
lda #%00110000
sta $d03c

; setup common dma
ldx #(common_dma_values_len - 1)
-
lda common_dma_values,x
sta $d300,x
dex
bpl -

; setup screen
lda #color_back
sta vicbackgnd
lda #color_border
sta vicborder
ldy #0
- 
lda prgtxt+$0000,y
sta screen+$0000,y
lda prgtxt+$0100,y
sta screen+$0100,y
lda prgtxt+$0200,y
sta screen+$0200,y
lda prgtxt+$02e8,y
sta screen+$02e8,y
lda #color_text
sta color+$0000,y
sta color+$0100,y
sta color+$0200,y
sta color+$02e8,y
iny
bne -

ldx #0
- lda shadowsid,x
sta sidbase,x
inx
cpx #$19
bne -

menu:
; update SID regs, redraw values
ldx #cursor_min
- lda shadowsid,x
sta sidbase,x
jsr printhexatcursor
inx
cpx #cursor_max
bne -
ldx #$18
lda shadowsid,x
sta sidbase,x
jsr printhexatcursor


menuchanged:
lda #<envtextloc
sta tmpptr
lda #>envtextloc
sta tmpptrh
lda envelope
jsr printhex

; check if cursor is within limits
lda cursor
cmp #cursor_max
bcc +
lda #cursor_min
sta cursor
+
lda cursor
cmp #cursor_min
bcs +
lda #cursor_max-1
sta cursor
+
; erase old cursor
lda #' '
ldx cursor_old
jsr putcursor
; draw cursor
lda #'>'
ldx cursor
jsr putcursor
; print addr
lda #<addrtxtloc
sta tmpptr
lda #>addrtxtloc
sta tmpptrh
txa
jsr printhex
; print binary
tax
lda shadowsid,x
jsr printbinary
; print bits
ldx cursor
jsr printbits

menuwait:
jsr getkey     ; wait for key

!if DEBUG = 1 {
; display keycode
pha
stx $c000
lda #<screen
sta tmpptr
lda #>screen
sta tmpptrh
txa
jsr printhex
ldx $c000
pla
}

; process input

; check for 0..9, a..f
jsr checkhex
cmp #16
beq ++
; hex char pressed, store MS4b
asl
asl
asl
asl
sta tmp
; get the other nibble
jsr getkey
jsr checkhex
cmp #16
beq menuwait    ; cancel if 2nd is not hex
; add LS4b & store to shadow SID regs
clc
adc tmp
ldx cursor
sta shadowsid,x
; display unwritten value in different color
lda #color_hilite
sta color_print
jsr printhexatcursor
lda #color_text
sta color_print
jmp menuchanged

++ cpx #key_enter
bne ++
; enter pressed, update reg
ldx cursor
lda shadowsid,x
sta sidbase,x
jsr printhexatcursor
jmp menuwait

++ cpx #key_s
bne ++
; s pressed, update all regs
ldx #cursor_min
- lda shadowsid,x
sta sidbase,x
inx
cpx #cursor_max
bne -
jmp menu

++ cpx #key_space
bne ++
; space pressed, start test
jsr starttest
jmp menu

++ cpx #key_g
bne ++
; g pressed, stop test
jsr stoptest
jmp menu

++ cpx #key_u
bne ++
ldy envelope
iny
cpy #$00
beq +
sty envelope
+
jmp menuchanged

++ cpx #key_j
bne ++
ldy envelope
dey
cpy #$ff
beq +
sty envelope
+
jmp menuchanged

++ cpx #key_i
bne ++
clc
lda envelope
adc #$10
cmp #$00
beq +
sta envelope
+
jmp menuchanged

++ cpx #key_k
bne ++
sec
lda envelope
sbc #$10
cmp #$ff
beq +
sta envelope
+
jmp menuchanged

++ cpx #key_y
bne ++
ldy shadowsid+$18
iny
tya
and #$0f
beq +
sty shadowsid+$18
+
jmp menu

++ cpx #key_h
bne ++
ldy shadowsid+$18
dey
tya
and #$0f
cmp #$0f
beq +
sty shadowsid+$18
+
jmp menu

++ cpx #key_right
bne ++
jsr dma_off
jmp menu

++ cpx #key_left
bne ++
jsr dma_on
jmp menu

++ cpx #key_o
bne ++
lda envelope
sta $d41f
jmp menu

; store cursor position
++ lda cursor
sta cursor_old

++ cpx #key_up
bne ++
; up pressed, move cursor
dec cursor
jmp menuchanged

++ cpx #key_down
bne ++
; down pressed, move cursor
inc cursor
jmp menuchanged

++
jmp menuwait


; --- Subroutines

; - starttest
; changes:
;  a
;
starttest:
lda shadowsid+$0b
ora #$01
sta shadowsid+$0b
sta sidbase+$0b
rts

; - stoptest
; changes:
;  a
;
stoptest:
lda shadowsid+$0b
and #$fe
sta shadowsid+$0b
sta sidbase+$0b
rts

; - dma_off
; changes:
;  a
;
dma_off:
lda #$0
sta $d31f
lda #' '
sta dmatextloc
rts

; - dma_on
; changes:
;  a
;
dma_on:
lda #$4c    ; vblank start
sta $d31f
lda #'x'
sta dmatextloc
rts

; - getkey
; returns:
;  a = x = pressed key
; changes:
;  y, tmpptr
;
getkey:
lda #rastercmp
- cmp vicraster
bne -           ; wait until raster = rastercmp
jsr SCNKEY
jsr GETIN       ; read keyboard
tax             ; x = pressed key (or 0)
beq getkey      ; if no keys pressed, no input -> wait
rts

; - putcursor
; parameters:
;  a = char
;  x = location
; changes:
;  y, tmpptr
;
putcursor:
pha
lda txtlocl_lut,x
sta tmpptr
lda txtloch_lut,x
sta tmpptrh
pla
ldy #0
sta (tmpptr),y
rts

; - printhexatcursor
; parameters:
;  x = cursor
; changes:
;  a, y, tmp, tmpptr
;
printhexatcursor:
stx tmp
lda txtlocl_lut,x
sta tmpptr
lda txtloch_lut,x
sta tmpptrh
lda shadowsid,x
jsr printhex
ldx tmp
rts

; - printbits
; parameters:
;  x = location
; changes:
;  a, x, y, tmpptr
;
printbits:
lda txtbitsl_lut,x
sta tmpptr
lda txtbitsh_lut,x
sta tmpptrh
ldy #0
ldx #0
- lda (tmpptr),y
sta bitstxtloc,x
iny
inx
cpx #40
bne -
rts

; - printbinary
; parameters:
;  a = value
; changes:
;  a, x, tmp
;
printbinary:
sta tmp
ldx #0
- lda #'0'
rol tmp
bcc +
lda #'1'
+ sta bintxtloc,x
inx
inx
inx
inx
inx
cpx #(8*5)
bne -
rts

; - printhex
; parameters:
;  tmpptr -> screen location to print to (-1)
;  a = value to print
; changes:
;  x, y
;
printhex:
pha
pha
tay
lda tmpptr
sta colptr
lda tmpptrh
clc
adc #>(color-screen)
sta colptrh
tya
; mask lower
and #$0f
; lookup
tax
lda hex_lut,x
; print
ldy #2
sta (tmpptr),y
lda color_print
sta (colptr),y
; lsr x4
pla
lsr
lsr
lsr
lsr
; lookup
tax
lda hex_lut,x
; print
ldy #1
sta (tmpptr),y
lda color_print
sta (colptr),y
pla
rts

; - checkhex
; parameters:
;  a = x = char to check
; returns:
;  a = hex value of char, or 16 if not
; changes:
;  tmp2
;
checkhex:
stx tmp2
ldx #0
- lda hexchar_lut,x
cmp tmp2
beq +
inx
cpx #16
bne -
+ txa
ldx tmp2
rts


; --- Strings

;    |---------01-3------0---------01234567-|
prgtxt
!tx "----------------------------------------" ; 0
!tx " envelopm - dtvsid envelope tester v0.4 " ; 1
!tx "----------------------------------------" ; 2
!tx "           ch1 ch2 ch3 -  filter        " ; 3
!tx " freq lo   xx  xx  xx  -  fc lo     xx  " ; 4
!tx " freq hi   xx  xx  xx  -  fc hi     xx  " ; 5
!tx " pw lo     xx  xx  xx  -  res/filt  xx  " ; 6
!tx " pw hi     xx  xx  xx  -  mode/vol  xx  " ; 7
!tx " control   xx  xx  xx  -                " ; 8
!tx " atk/dcy   xx  xx  xx  - dma    --------" ; 9
!tx " stn/rls   xx  xx  xx  - env xx - $d4xx " ; 10
!tx "--------------------------------- bits: " ; 11
!tx "d7=  d6=  d5=  d4=  d3=  d2=  d1=  d0=  " ; 12
!tx "                                        " ; 13
!tx "----------------------------------------" ; 14
!tx " cursor keys: move cursor               " ; 15
!tx " 0..9, a..f : set new value             " ; 16
!tx " enter: write value to sid              " ; 17
!tx " s: write all values to sid             " ; 18
!tx " space/g: start/stop note               " ; 19
!tx " u/j, i/k: envelope inc/dec, +-$10      " ; 20
!tx " y/h: volume up/down                    " ; 21
!tx " crsr lt/rt: start/stop dma             " ; 22
!tx " o: store env value                     " ; 23
!tx "                                        " ; 24


addrtxtloc = screen+10*40+37-1
bintxtloc = screen+12*40+3
bitstxtloc = screen+13*40
osctextloc = screen+9*40+29-1
envtextloc = screen+10*40+29-1
dmatextloc = screen+9*40+29

ch1txtoff = 4*40+11-1
ch2txtoff = ch1txtoff+4
ch3txtoff = ch2txtoff+4
chxtxtoff = 4*40+36-1

txt_reg0
!tx "f7   f6   f5   f4   f3   f2   f1   f0   "
txt_reg1
!tx "f15  f14  f13  f12  f11  f10  f9   f8   "
txt_reg2
!tx "pw7  pw6  pw5  pw4  pw3  pw2  pw1  pw0  "
txt_reg3
!tx "-    -    -    -    pw11 pw10 pw9  pw8  "
txt_reg4
!tx "nois puls saw  trig test ring sync gate "
txt_reg5
!tx "atk3 atk2 atk1 atk0 dcy3 dcy2 dcy1 dc0  "
txt_reg6
!tx "stn3 stn2 stn1 stn0 rls3 rls2 rls1 rls0 "
txt_reg15
!tx "-    -    -    -    -    fc2  fc1  fc0  "
txt_reg16
!tx "fc10 fc9  fc8  fc7  fc6  fc5  fc4  fc3  "
txt_reg17
!tx "res3 res2 res1 res0 filx fil3 fil2 fil1 "
txt_reg18
!tx "3off hp   bp   lp   vol3 vol2 vol1 vol0 "


; --- Data

txtlocl_lut:
!by <(screen+ch1txtoff+0*40)
!by <(screen+ch1txtoff+1*40)
!by <(screen+ch1txtoff+2*40)
!by <(screen+ch1txtoff+3*40)
!by <(screen+ch1txtoff+4*40)
!by <(screen+ch1txtoff+5*40)
!by <(screen+ch1txtoff+6*40)
!by <(screen+ch2txtoff+0*40)
!by <(screen+ch2txtoff+1*40)
!by <(screen+ch2txtoff+2*40)
!by <(screen+ch2txtoff+3*40)
!by <(screen+ch2txtoff+4*40)
!by <(screen+ch2txtoff+5*40)
!by <(screen+ch2txtoff+6*40)
!by <(screen+ch3txtoff+0*40)
!by <(screen+ch3txtoff+1*40)
!by <(screen+ch3txtoff+2*40)
!by <(screen+ch3txtoff+3*40)
!by <(screen+ch3txtoff+4*40)
!by <(screen+ch3txtoff+5*40)
!by <(screen+ch3txtoff+6*40)
!by <(screen+chxtxtoff+0*40)
!by <(screen+chxtxtoff+1*40)
!by <(screen+chxtxtoff+2*40)
!by <(screen+chxtxtoff+3*40)

txtloch_lut:
!by >(screen+ch1txtoff+0*40)
!by >(screen+ch1txtoff+1*40)
!by >(screen+ch1txtoff+2*40)
!by >(screen+ch1txtoff+3*40)
!by >(screen+ch1txtoff+4*40)
!by >(screen+ch1txtoff+5*40)
!by >(screen+ch1txtoff+6*40)
!by >(screen+ch2txtoff+0*40)
!by >(screen+ch2txtoff+1*40)
!by >(screen+ch2txtoff+2*40)
!by >(screen+ch2txtoff+3*40)
!by >(screen+ch2txtoff+4*40)
!by >(screen+ch2txtoff+5*40)
!by >(screen+ch2txtoff+6*40)
!by >(screen+ch3txtoff+0*40)
!by >(screen+ch3txtoff+1*40)
!by >(screen+ch3txtoff+2*40)
!by >(screen+ch3txtoff+3*40)
!by >(screen+ch3txtoff+4*40)
!by >(screen+ch3txtoff+5*40)
!by >(screen+ch3txtoff+6*40)
!by >(screen+chxtxtoff+0*40)
!by >(screen+chxtxtoff+1*40)
!by >(screen+chxtxtoff+2*40)
!by >(screen+chxtxtoff+3*40)

txtbitsl_lut:
!by <(txt_reg0)
!by <(txt_reg1)
!by <(txt_reg2)
!by <(txt_reg3)
!by <(txt_reg4)
!by <(txt_reg5)
!by <(txt_reg6)
!by <(txt_reg0)
!by <(txt_reg1)
!by <(txt_reg2)
!by <(txt_reg3)
!by <(txt_reg4)
!by <(txt_reg5)
!by <(txt_reg6)
!by <(txt_reg0)
!by <(txt_reg1)
!by <(txt_reg2)
!by <(txt_reg3)
!by <(txt_reg4)
!by <(txt_reg5)
!by <(txt_reg6)
!by <(txt_reg15)
!by <(txt_reg16)
!by <(txt_reg17)
!by <(txt_reg18)

txtbitsh_lut:
!by >(txt_reg0)
!by >(txt_reg1)
!by >(txt_reg2)
!by >(txt_reg3)
!by >(txt_reg4)
!by >(txt_reg5)
!by >(txt_reg6)
!by >(txt_reg0)
!by >(txt_reg1)
!by >(txt_reg2)
!by >(txt_reg3)
!by >(txt_reg4)
!by >(txt_reg5)
!by >(txt_reg6)
!by >(txt_reg0)
!by >(txt_reg1)
!by >(txt_reg2)
!by >(txt_reg3)
!by >(txt_reg4)
!by >(txt_reg5)
!by >(txt_reg6)
!by >(txt_reg15)
!by >(txt_reg16)
!by >(txt_reg17)
!by >(txt_reg18)

; - hex lookup table
hex_lut
!tx "0123456789abcdef"

; - hex char lookup table
hexchar_lut
!by $30,$31,$32,$33,$34,$35,$36,$37,$38,$39,$41,$42,$43,$44,$45,$46

; - DMA settings
common_dma_values
!by <envelope   ; 00 source low
!by >envelope   ; 01 source mid
!by $40         ; 02 source high (RAM envelope)
!by <$d41f      ; 03 dest low
!by >$d41f      ; 04 dest middle
!by $80         ; 05 dest high (IO $d41f, ch2 env)
!by 0           ; 06 source step low
!by 0           ; 07 source step high
!by 0           ; 08 dest step low
!by 0           ; 09 dest step high
!by <dmalen     ; 0a dma len low
!by >dmalen     ; 0b dma len high
!by 0           ; 0c source mod low
!by 0           ; 0d source mod high
!by 0           ; 0e dest mod low
!by 0           ; 0f dest mod high
!by <1          ; 10 source (line) len low
!by >1          ; 11 source (line) len high
!by <1          ; 12 dest (line) len low
!by >1          ; 13 dest (line) len high
!by 0           ; 14 ?
!by 0           ; 15 ?
!by 0           ; 16 ?
!by 0           ; 17 ?
!by 0           ; 18 ?
!by 0           ; 19 ?
!by 0           ; 1a ?
!by 0           ; 1b ?
!by 0           ; 1c ?
!by 0           ; 1d no continue
!by 0           ; 1e no modulos
common_dma_values_len = * - common_dma_values


; --- Variables

cursor      !by cursor_min   ; cursor (== SID addr LSB)
cursor_old  !by cursor_min   ; previous cursor location
color_print !by color_text

envelope !by $80    ; envelope value

!align 255,0    ; align to page border

shadowsid ; shadow SID registers
!by $00, $00, $00, $00, $00, $00, $00    ; ch1
!by $00, $20, $00, $01, $20, $00, $00    ; ch2
!by $00, $00, $00, $00, $00, $00, $00    ; ch3
!by $00, $00, $00, $08

progsize = * - entry
