; bmsac
; -----
; 2007 Hannu Nuotio

; This program tests DTV burst mode opcode behaviour.

; Memory map:
; $0400-$07ff : screen
; $0a00-$xxxx : code

!ct scr


; --- Constants

rastercmp = 3	; raster line to wait for
screen = $0400	; screen address


; --- Variables

; - zero page

tmpptr = $39            ; temporary zp pointer
scrptr = $fb            ; zp pointer to screen
tmpvar = $ff            ; temporary zp variable
clkstart = $f0		; clk before opcode
clkstop = $f1		; clk after opcode
tmp1 = $f2
tmp2 = $f3


; --- Main 

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

; enable extended registers
lda #1
sta $d03f

; disable badlines
lda #%00100000
sta $d03c

mainloop:
jsr clearscreen
jsr disableburst
jsr do_tests1
jsr getinput

jsr clearscreen
jsr enableburst
jsr do_tests1
jsr getinput

jmp mainloop


; --- Subroutines

; -- Opcode tests

; - testopcode_sac
;
testopcode_sac:
; wait for beginning of line
lda #rastercmp
- cmp $d012
bne -

; prepare opcode (if needed)
ldx #0
- lda testopcode_sac_pos,x
cmp #$ea 	; nop
bne +
lda #$e8 	; inx
+ sta testopcode_sac_pos+$4000,x
inx
cpx #(testopcode_sac_end-testopcode_sac_pos)
bne -

; disable interrupts
sei

!align 3,0
; perform operation
ldx #0
!by $32, $cc	; sac #$CC
testopcode_sac_pos:
lda #$01
nop
nop
lda #$00
lda #$00

testopcode_sac_end:
; post opcode fixes (if needed)
!by $32, $00	; sac #$00

; enable interrupts
cli

; save clocks
lda #0
sta clkstart
stx clkstop
rts


; -- Opcode test wrappers

; - do_test_sac
;
do_test_sac:
lda #>screen+40*1
sta scrptr+1
lda #<screen+40*1
sta scrptr
lda #>opcode_sac_msg
sta tmpptr+1
lda #<opcode_sac_msg
sta tmpptr
jsr printstring
jsr testopcode_sac
jsr printresult
rts


; -- Opcode test wrapper wrappers

; - do_tests1
;
do_tests1:
jsr do_test_sac
rts


; -- Helper routines

; - clearscreen
;
clearscreen:
ldy #0
-
lda #' '                ; code for space
sta screen+$0000,y
sta screen+$0100,y
sta screen+$0200,y
sta screen+$02e8,y
iny
bne -
rts


; - disableburst
;
disableburst:
sei
!by $32, $99	; sac #$99
lda #0
!by $32, $00	; sac #$00
cli
lda #>screen+40*0
sta scrptr+1
lda #<screen+40*0
sta scrptr
lda #>test_noburst_msg
sta tmpptr+1
lda #<test_noburst_msg
sta tmpptr
jsr printstring
rts


; - enableburst
;
enableburst:
sei
!by $32, $99	; sac #$99
lda #3
!by $32, $00	; sac #$00
cli
lda #>screen+40*0
sta scrptr+1
lda #<screen+40*0
sta scrptr
lda #>test_burst_msg
sta tmpptr+1
lda #<test_burst_msg
sta tmpptr
jsr printstring
rts


; - printhex
; parameters:
;  scrptr -> screen location to print to
;  a = value to print
;
printhex:
pha

; mask lower
and #$0f

; lookup
tax
lda hex_lut,x

; print
ldy #1
sta (scrptr),y

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
ldy #0
sta (scrptr),y

; scrptr+=2
inc scrptr
bne +
inc scrptr+1
+ inc scrptr
bne +
inc scrptr+1
+
rts

; - hex lookup table
hex_lut
!tx "0123456789abcdef"


; - printresult
; parameters:
;  scrptr -> screen location to print to
;  clkstop = stop cycle
;  clkstart = start cycle
;
printresult:
lda clkstop
sec
sbc clkstart
jsr printhex
rts


; - printstring
; parameters:
;  scrptr -> screen location to print to
;  tmpptr -> string to print
;
printstring:
; string loop
ldy #0
- lda (tmpptr),y
beq +++         ; end if zero
sta (scrptr),y  ; print char
iny
bne -           ; loop if not zero
inc tmpptr+1
inc scrptr+1
bne -
+++
clc
tya		; update scrptr to next char
adc scrptr
sta scrptr
bcc +
inc scrptr+1
+
rts             ; return


; - getinput
; returns:
;  a = action (xxxfrldu, 1 = active)
;
getinput:
lda #0
sta joycount    ; reset joyrepeat counter
-- lda #200
!align 3,1
ldy joycount
!align 3,1
- ;inc $d020	; flash border 
cmp $d012
bne -           ; wait until raster = rastercmp
iny             ; y++
cpy #15		; check if y >= 15
bcc getinput_j  ; if not, skip
ldy #0          ; reset joyrepeat counter
lda #$ff        ; reset lastjoy for repeat
!align 3,1
sta lastjoy
getinput_j:
!align 3,1
sty joycount    ; store joycount
!align 3,1
lda $dc01       ; a = joystick 1
tax             ; save to x
!align 3,1
eor lastjoy     ; a = joy xor lastjoy
!align 3,1
and lastjoy     ; a = a and lastjoy
!align 3,1
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
;   |----------------------------------------|
test_burst_msg
!tx "bm on! x=0                              ",0
test_noburst_msg
!tx "bm off x=0                              ",0
opcode_sac_msg
!tx "2sac #$cc.lda #$01.nop.nop/inx.inx = ",0
