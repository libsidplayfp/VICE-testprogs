; borderdma
; ---------
; 2009 Hannu Nuotio

; This program tests simultaneous DTV DMA & CPU writes to $d020/1.

; --- Constants

screen = $0400
spriteptr = $07f8
colorram = $d800  ; colorram address
border = $d020    ; border color register
backcol = $d021   ; background color register

testline = $32
textxoff = 0

spritey = testline
sprite1x = 24 + (textxoff*8)
sprite2x = sprite1x + 24
sprite3x = sprite2x + 24
sprite4x = sprite3x + 24
spriteenable = %00001111
spritecolor = $f

; - colors

testcolor_dma = 2
testcolor_cpu = 5
textcolor = $f

; - codes

CODE_REP = $ff
CODE_COL = $fe
CODE_END = $fd
CODE_MIN = CODE_END


; --- Macros

; SpriteLine - for easy definition of sprites
; from "ddrv.a" by Marco Baye
!macro SpriteLine .v {
!by .v>>16, (.v>>8)&255, .v&255
}


; --- Variables

; - zero page

tmp = $ff
scrptr = $fb            ; zp pointer to screen
colptr = $39            ; zp pointer to colorram
txtptr = $fd            ; zp pointer to text
color = $ff

; --- Main 

; start of program
*=$0801
entry:
; BASIC stub: "1 SYS 2061"
!by $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00


mlcodeentry:
; enable extended registers
lda #1
sta $d03f

; change mode to 8BPP text, lowercase charset, disable badline
lda #%00100100
sta $d03c
lda #%00011011
ldx #%00001000
ldy #%00010110
sta $d011
stx $d016
sty $d018

; set bg color
lda #0
sta backcol

; enable skip+burst
sei
!by $32, $99    ; sac #$99
lda #3
!by $32, $00    ; sac #$00
cli

; setup common dma
ldx #(common_dma_values_len - 1)
-
lda common_dma_values,x
sta $d300,x
dex
bpl -

; set common sprite stuff
lda #<sprite1x
sta $d000
lda #<sprite2x
sta $d002
lda #<sprite3x
sta $d004
lda #<sprite4x
sta $d006
lda #spritey
sta $d001
sta $d003
sta $d005
sta $d007
lda #(((>sprite4x)<<3) + ((>sprite3x)<<2) + ((>sprite2x)<<1) + (>sprite1x))
sta $d010
lda #sprite1_addr
sta spriteptr + 0
lda #sprite2_addr
sta spriteptr + 1
lda #sprite3_addr
sta spriteptr + 2
lda #sprite4_addr
sta spriteptr + 3
lda #testcolor_dma
sta $d025   ; multicolor 0
lda #testcolor_cpu
sta $d026   ; multicolor 1
lda #spritecolor
sta $d027
sta $d028
sta $d029
sta $d02a
lda #0
sta $d01b   ; priority
sta $d017   ; y expand
sta $d01d   ; x expand
lda #spriteenable
sta $d01c   ; MCM
sta $d015   ; enable

; set pointers etc
lda #<screen
sta scrptr
sta colptr
lda #>screen
sta scrptr+1
lda #>colorram
sta colptr+1
lda #<message
sta txtptr
lda #>message
sta txtptr+1
lda #textcolor
sta color
ldy #0

; text loop
text:
ldx #1
text_skip_ldx:
lda (txtptr),y
cmp #CODE_MIN
beq text_end
bcc text_plain
tax
jsr inctxtptr
lda (txtptr),y
jsr inctxtptr
cpx #CODE_REP
beq text_rep
sta color
bne text
text_rep:
tax
bne text_skip_ldx
text_plain:
sta (scrptr),y
pha
lda color
sta (colptr),y
pla
jsr incscrptr
dex
bne text_plain
jsr inctxtptr
bne text
text_end:
lda #'1'
sta spriteptr-1

sei

testloop:

!align 3,0
; wait for vb
- nop:lda $d011
nop:nop:bpl -
- nop:lda $d011
nop:nop:bmi -

; set bg black
nop:nop:lda #$00
nop:sta border

; wait for testline
nop:nop:lda #testline
- nop:cmp $d012
nop:nop:bne -
; stabilize
nop:lda $d044
cmp #$84:beq stable
cmp #$83:beq stable
nop:nop:nop:nop
stable:

; position line
nop:nop:ldy #(4 + textxoff)
- nop:dey:bne -

; display colors in border
ldy #testcolor_cpu:ldx #$00
nop:nop:lda #$0d
nop:sta $d31f
nop             ; r
sty border      ; w
nop             ; r
sty border      ; w
nop:nop:nop:nop ; r
nop             ; w
sty border      ; r
nop             ; w / done
stx border

; setup background DMA
nop:lda #<backcol
nop:sta $d303

; wait for next testline
nop:nop:lda #testline+5
- nop:cmp $d012
nop:nop:bne -

; position line
nop:nop:ldy #4
- nop:dey:bne -

; display colors in background
ldy #testcolor_cpu:ldx #$00
nop:nop:lda #$0d
nop:sta $d31f
nop             ; r
sty backcol     ; w
nop             ; r
sty backcol     ; w
nop:nop:nop:nop ; r
nop             ; w
sty backcol     ; r
nop             ; w / done
stx backcol

; setup border DMA
nop:lda #<border
nop:sta $d303

; check for joy2 fire
lda $dc00
and #%00010000
beq +
lda #spriteenable
+ 
sta $d015   ; enable

nop:jmp testloop


; --- Subroutines

; - inctxtptr
;
inctxtptr:
inc txtptr
bne inctxtptr_exit
inc txtptr+1
inctxtptr_exit:
rts


; - incscrptr
;
incscrptr:
inc scrptr
inc colptr
bne incscrptr_exit
inc scrptr+1
inc colptr+1
incscrptr_exit:
rts


; --- Data

!ct scr

message:
;    |---------0---------0---------0--------|
;!tx "0123456789012345678901234567890123456789"
!tx CODE_REP,40," "
!tx "<"
!tx CODE_REP,83," "
!tx "borderdma - C64DTV test program"
!tx CODE_REP,85," "
!tx CODE_COL, testcolor_dma, "DMA"
!tx CODE_COL, textcolor, " & "
!tx CODE_COL, testcolor_cpu, "CPU"
!tx CODE_COL, textcolor
!tx " are both writing to $d020/1 at"
!tx "the same time. The first line is the    "
!tx "result, the second line directly below  "
!tx "is a sprite replica of how it should    "
!tx "look like (press joy2 fire to disable)."
!tx CODE_REP,41," "
!tx "Zoomed in version: (VICII sprite coords)"
!tx CODE_REP,40," "
!tx CODE_COL, textcolor, "$d020 "
!tx CODE_COL, testcolor_dma, "2"
!tx CODE_COL, testcolor_cpu, "333"
!tx CODE_COL, testcolor_dma, "4"
!tx CODE_COL, testcolor_cpu, "455"
!tx CODE_COL, testcolor_dma, "566"
!tx CODE_COL, testcolor_cpu, "7"
!tx CODE_COL, testcolor_dma, "778"
!tx CODE_REP,25," "
!tx CODE_COL, testcolor_dma, "6"
!tx CODE_COL, testcolor_cpu, "048"
!tx CODE_COL, testcolor_dma, "2"
!tx CODE_COL, testcolor_cpu, "604"
!tx CODE_COL, testcolor_dma, "826"
!tx CODE_COL, testcolor_cpu, "0"
!tx CODE_COL, testcolor_dma, "482"
!tx CODE_REP,24," "
!tx CODE_COL, textcolor, "x"
!tx CODE_REP,15," "
!tx "x"
!tx CODE_REP,18," "
!tx CODE_COL, testcolor_dma
!tx "DMA R W R W R W R W"
!tx CODE_REP,21," "
!tx CODE_COL, testcolor_cpu
!tx "CPU  R W R W R R W R W  (11111)"
!tx CODE_REP,9," "
!tx CODE_COL, textcolor, "$d021 "
!tx CODE_COL, testcolor_dma, "233"
!tx CODE_COL, testcolor_cpu, "3"
!tx CODE_COL, testcolor_dma, "44555"
!tx CODE_COL, testcolor_cpu, "667"
!tx CODE_COL, testcolor_dma, "77889"
!tx CODE_COL, testcolor_cpu, "9900111"
!tx CODE_REP,16," "
!tx CODE_COL, testcolor_dma, "604"
!tx CODE_COL, testcolor_cpu, "8"
!tx CODE_COL, testcolor_dma, "26048"
!tx CODE_COL, testcolor_cpu, "260"
!tx CODE_COL, testcolor_dma, "48260"
!tx CODE_COL, testcolor_cpu, "4826048"
!tx CODE_REP,15," "
!tx CODE_COL, textcolor, "x"
!tx CODE_REP,24," "
!tx "x"
!tx CODE_REP,129," "
!tx CODE_END


dma_test_data:
!fi 4, testcolor_dma

common_dma_values:
!by <dma_test_data  ; 00 source low
!by >dma_test_data  ; 01 source mid
!by $40     ; 02 source high (RAM)
!by <border ; 03 dest low
!by >border ; 04 dest middle
!by $80     ; 05 dest high (IO)
!by 1       ; 06 source step low
!by 0       ; 07 source step high
!by 0       ; 08 dest step low
!by 0       ; 09 dest step high
!by 4       ; 0a dma len low
!by 0       ; 0b dma len high
!by 0       ; 0c source mod low
!by 0       ; 0d source mod high
!by 0       ; 0e dest mod low
!by 0       ; 0f dest mod high
!by 4       ; 10 source (line) len low
!by 0       ; 11 source (line) len high
!by 4       ; 12 dest (line) len low
!by 0       ; 13 dest (line) len high
!by 0       ; 14 ?
!by 0       ; 15 ?
!by 0       ; 16 ?
!by 0       ; 17 ?
!by 0       ; 18 ?
!by 0       ; 19 ?
!by 0       ; 1a ?
!by 0       ; 1b ?
!by 0       ; 1c ?
!by 0       ; 1d no continue
!by 0       ; 1e no modulos
common_dma_values_len = * - common_dma_values

!align 63, 0
sprite1:
;            765432107654321076543210
+SpriteLine %...#.#############.#.###
+SpriteLine %#.......................
+SpriteLine %........................
+SpriteLine %........................
+SpriteLine %........................
+SpriteLine %...#.#.#.#.#.#####.#.#.#
+SpriteLine %#.......................
!align 63, 0, 0
sprite2:
+SpriteLine %##########.#.#.#.#.#.###
+SpriteLine %........................
+SpriteLine %........................
+SpriteLine %........................
+SpriteLine %........................
+SpriteLine %.#.#.#.#.#.#.###########
!align 63, 0, 0
sprite3:
+SpriteLine %##.#.#.#.#.#.#..........
+SpriteLine %..............#.........
+SpriteLine %........................
+SpriteLine %........................
+SpriteLine %........................
+SpriteLine %##.#.#.#.#.#.#.#.#.#.###
!align 63, 0, 0
sprite4:
+SpriteLine %........................
+SpriteLine %........................
+SpriteLine %........................
+SpriteLine %........................
+SpriteLine %........................
+SpriteLine %######################..
+SpriteLine %......................#.
!align 63, 0, 0

sprite1_addr = <(sprite1/64)
sprite2_addr = <(sprite2/64)
sprite3_addr = <(sprite3/64)
sprite4_addr = <(sprite4/64)
