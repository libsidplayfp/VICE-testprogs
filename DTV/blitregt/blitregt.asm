; blitregt
; --------
; 2007 Hannu Nuotio

; This program tests DTV behaviour on writes to blitter regs during a blit.

; Memory map:
; $0400-$07ff : screen
; $0a00-$xxxx : code

; TODO:

!ct scr


; --- Constants

delaycount = 5  ; how much to wait before reg writes
rastercmp = 3	; raster line to wait for
screen = $0400	; screen address


; --- Variables

; - zero page

tmpptr = $39            ; temporary zp pointer
scrptr = $fb            ; zp pointer to screen
tmpvar = $ff            ; temporary zp variable

; --- Main 

*=$0a00
mlcodeentry:

; enable extended registers
lda #1
sta $d03f

; disable badlines & colorfetch
lda #%00110000
sta $d03c

; enable burst+skip
sei
!by $32, $99    ; sac #$99
lda #3
!by $32, $00    ; sac #$00
cli

mainloop:
jsr clearscreen
jsr doblittest_sa
jsr getinput
jsr clearscreen
jsr doblittest_sa_mod
jsr getinput
jsr clearscreen
jsr doblittest_sa_ll
jsr getinput
jsr clearscreen
jsr doblittest_sa_step
jsr getinput
jsr clearscreen
jsr doblittest_sb_mod
jsr getinput
jsr clearscreen
jsr doblittest_sb_ll
jsr getinput
jsr clearscreen
jsr doblittest_sb_step
jsr getinput
jsr clearscreen
jsr doblittest_dest_mod
jsr getinput
jsr clearscreen
jsr doblittest_dest_ll
jsr getinput
jsr clearscreen
jsr doblittest_dest_step
jsr getinput
jsr clearscreen
jsr doblittest_len
jsr getinput
jsr clearscreen
jsr doblittest_d33b
jsr getinput
jsr clearscreen
jsr doblittest_shift
jsr getinput
jsr clearscreen
jsr doblittest_minterm
jsr getinput
jmp mainloop


; --- Subroutines

; -- Tests

; - doblittest_sa
;
doblittest_sa:
; setup blit
ldx #<blitdata_a
ldy #>blitdata_a
jsr setupblit
jsr waitblit
; start blit
stx $d33a
; delay
!if delaycount > 0 {
ldx #delaycount
- dex
bne -
}
; change source A
ldx #<blitdata_b
ldy #>blitdata_b
stx $d320	; source A low
sty $d321	; source A middle
jsr waitblit
lda #<+
ldx #>+
jsr printstring
rts
;     |----------------------------------------|
+ !tx "scr a changed (should be aaaa...)       ",0


; - doblittest_sa_mod
;
doblittest_sa_mod:
; setup blit
ldx #<blitdata_mod
ldy #>blitdata_mod
jsr setupblit
; extra setup
ldy #40
sty $d325	; source A len low
sta $d326	; source A len high
ldy #1
sty $d323	; source A mod low
jsr waitblit
; start blit
stx $d33a
; delay
!if delaycount > 0 {
ldx #delaycount
- dex
bne -
}
; change mod
ldy #5
sty $d323	; source A mod low
jsr waitblit
lda #<+
ldx #>+
jsr printstring
rts
;     |----------------------------------------|
+ !tx "scr a mod changed                       ",0


; - doblittest_sa_ll
;
doblittest_sa_ll:
; setup blit
ldx #<blitdata_mod
ldy #>blitdata_mod
jsr setupblit
; extra setup
ldy #40
sty $d325	; source A len low
sta $d326	; source A len high
ldy #1
sty $d323	; source A mod low
jsr waitblit
; start blit
stx $d33a
; delay
!if delaycount > 0 {
ldx #delaycount
- dex
bne -
}
; change ll
ldy #42
sty $d325	; source A len low
jsr waitblit
lda #<+
ldx #>+
jsr printstring
rts
;     |----------------------------------------|
+ !tx "scr a line len changed                  ",0


; - doblittest_sa_step
;
doblittest_sa_step:
; setup blit
ldx #<blitdata_mod
ldy #>blitdata_mod
jsr setupblit
jsr waitblit
; start blit
stx $d33a
; delay
!if delaycount > 0 {
ldx #delaycount
- dex
bne -
}
; change step
ldy #0
sty $d327	; source A step
jsr waitblit
lda #<+
ldx #>+
jsr printstring
rts
;     |----------------------------------------|
+ !tx "scr a step changed                      ",0


; - doblittest_sb_mod
;
doblittest_sb_mod:
; setup blit
ldx #<blitdata_mod
ldy #>blitdata_mod
jsr setupblit
jsr setupblit_b
; extra setup
ldy #40
sty $d32d	; source B len low
sta $d32e	; source B len high
ldy #1
sty $d32b	; source B mod low
jsr waitblit
; start blit
stx $d33a
; delay
!if delaycount > 0 {
ldx #delaycount
- dex
bne -
}
; change mod
ldy #5
sty $d32b	; source B mod low
jsr waitblit
lda #<+
ldx #>+
jsr printstring
rts
;     |----------------------------------------|
+ !tx "scr b mod changed                       ",0


; - doblittest_sb_ll
;
doblittest_sb_ll:
; setup blit
ldx #<blitdata_mod
ldy #>blitdata_mod
jsr setupblit
jsr setupblit_b
; extra setup
ldy #40
sty $d32d	; source B len low
sta $d32e	; source B len high
ldy #1
sty $d32b	; source B mod low
jsr waitblit
; start blit
stx $d33a
; delay
!if delaycount > 0 {
ldx #delaycount
- dex
bne -
}
; change ll
ldy #42
sty $d32d	; source B len low
jsr waitblit
lda #<+
ldx #>+
jsr printstring
rts
;     |----------------------------------------|
+ !tx "scr b line len changed                  ",0


; - doblittest_sb_step
;
doblittest_sb_step:
; setup blit
ldx #<blitdata_mod
ldy #>blitdata_mod
jsr setupblit
jsr setupblit_b
jsr waitblit
; start blit
stx $d33a
; delay
!if delaycount > 0 {
ldx #delaycount
- dex
bne -
}
; change step
ldy #0
sty $d32f	; source B step
jsr waitblit
lda #<+
ldx #>+
jsr printstring
rts
;     |----------------------------------------|
+ !tx "scr b step changed                      ",0


; - doblittest_dest_mod
;
doblittest_dest_mod:
; setup blit
ldx #<blitdata_mod
ldy #>blitdata_mod
jsr setupblit
; extra setup
ldy #40
stx $d335	; dest len low
sty $d336	; dest len high
ldy #1
sty $d333	; dest mod low
jsr waitblit
; start blit
stx $d33a
; delay
!if delaycount > 0 {
ldx #delaycount
- dex
bne -
}
; change mod
ldy #5
sty $d333	; dest mod low
jsr waitblit
lda #<+
ldx #>+
jsr printstring
rts
;     |----------------------------------------|
+ !tx "dest mod changed                        ",0


; - doblittest_dest_ll
;
doblittest_dest_ll:
; setup blit
ldx #<blitdata_mod
ldy #>blitdata_mod
jsr setupblit
; extra setup
ldy #40
sty $d335	; dest len low
sta $d336	; dest len high
ldy #1
sty $d333	; dest mod low
jsr waitblit
; start blit
stx $d33a
; delay
!if delaycount > 0 {
ldx #delaycount
- dex
bne -
}
; change ll
ldy #42
sty $d335	; dest len low
jsr waitblit
lda #<+
ldx #>+
jsr printstring
rts
;     |----------------------------------------|
+ !tx "dest line len changed                   ",0


; - doblittest_dest_step
;
doblittest_dest_step:
; setup blit
ldx #<blitdata_mod
ldy #>blitdata_mod
jsr setupblit
jsr waitblit
; start blit
stx $d33a
; delay
!if delaycount > 0 {
ldx #delaycount
- dex
bne -
}
; change step
ldy #1
sty $d337	; dest step
jsr waitblit
lda #<+
ldx #>+
jsr printstring
rts
;     |----------------------------------------|
+ !tx "dest step changed                       ",0


; - doblittest_len
;
doblittest_len:
; setup blit
ldx #<blitdata_b
ldy #>blitdata_b
jsr setupblit
jsr waitblit
; start blit
stx $d33a
; delay
!if delaycount > 0 {
ldx #delaycount
- dex
bne -
}
; change blit len
ldy #0
sty $d338	; blit len low
jsr waitblit
lda #<+
ldx #>+
jsr printstring
rts
;     |----------------------------------------|
+ !tx "len changed (should be bbbb...)         ",0


; - doblittest_d33b
;
doblittest_d33b:
; setup blit
ldx #<blitdata_a
ldy #>blitdata_a
jsr setupblit
jsr waitblit
; start blit
stx $d33a
; delay
!if delaycount > 0 {
ldx #delaycount
- dex
bne -
}
; enable source B
ldy #1
sty $d33b	; enable b, write always
jsr waitblit
lda #<+
ldx #>+
jsr printstring
rts
;     |----------------------------------------|
+ !tx "enable src b (should be aaaa...)        ",0


; - doblittest_shift
;
doblittest_shift:
; setup blit
ldx #<blitdata_mod
ldy #>blitdata_mod
jsr setupblit
jsr waitblit
; start blit
stx $d33a
; delay
!if delaycount > 0 {
ldx #delaycount
- dex
bne -
}
; enable shift
ldy #%00100001
sty $d33b	; shift, XOR
jsr waitblit
lda #<+
ldx #>+
jsr printstring
rts
;     |----------------------------------------|
+ !tx "shift = 1 (should see normal text)      ",0


; - doblittest_minterm
;
doblittest_minterm:
; setup blit
ldx #<blitdata_a
ldy #>blitdata_a
jsr setupblit
ldy #0
sty $d33b	; enable b, write always
jsr waitblit
; start blit
stx $d33a
; delay
!if delaycount > 0 {
ldx #delaycount
- dex
bne -
}
; minterm = and
ldy #0
sty $d33b	; no shift, AND
jsr waitblit
lda #<+
ldx #>+
jsr printstring
rts
;     |----------------------------------------|
+ !tx "minterm = and (should see char 0...)    ",0


; -- Helpers

; - waitblit
;
waitblit:
lda $d33f
bne waitblit	; wait for blit to finish
rts


; - clearscreen
;
clearscreen:
; setup blit
ldx #<blitdata_empty
ldy #>blitdata_empty
jsr setupblit
jsr waitblit
; start blit
stx $d33a
jsr waitblit
rts


; - setupblit
; parameters:
;  x/y = source A&B low/high
; retuns:
;  a = 0
;  x = $0f
;
setupblit:
lda #0
stx $d320	; source A low
sty $d321	; source A middle
sta $d322	; source A high
sta $d323	; source A mod low
sta $d324	; source A mod high
stx $d328	; source B low
sty $d329	; source B middle
sta $d32a	; source B high
sta $d32b	; source B mod low
sta $d32c	; source B mod high
ldx #<40*24
stx $d325	; source A len low
stx $d32d	; source B len low
stx $d335	; dest len low
stx $d338	; blit len low
ldy #>40*24
sty $d326	; source A len high
sty $d32e	; source B len high
sty $d336	; dest len high
sty $d339	; blit len high
ldx #%00010000
stx $d327	; source A step
stx $d32f	; source B step
stx $d337	; dest step
ldx #<screen
stx $d330	; dest low
ldy #>screen
sty $d331	; dest middle
sta $d332	; dest high
sta $d333	; dest mod low
sta $d334	; dest mod high
ldx #1
stx $d33b	; disable B, write always
ldx #%00100000
stx $d33e	; no shift, XOR
sta $d33f	; no continue
ldx #$0f	; pos. direction, start
rts


; - setupblit_b
; retuns:
;
setupblit_b:
ldy #<blitdata_0
sty $d320	; source A low
ldy #>blitdata_0
sty $d321	; source A middle
ldy #0
sty $d33b	; enable B, write always
ldy #%00100000
sty $d33e	; no shift, XOR
rts


; - printstring
; parameters:
;  a:x -> string to print
;
printstring:
sta tmpptr
stx tmpptr+1
lda #<screen+40*24
sta scrptr
lda #>screen+40*24
sta scrptr+1
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
tya             ; update scrptr to next char
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
- ;inc $d020    ; flash border
cmp $d012
bne -           ; wait until raster = rastercmp
iny             ; y++
cpy #30         ; check if y >= 30
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


; --- Data

blitdata_a
!for i, 40*24 {!by 'a'}

blitdata_b
!for i, 40*24 {!by 'b'}

blitdata_mod
;               |----------------------------------------|
!for i, 24 {!tx "these lines should be aligned correctly."}

blitdata_0
!for i, 40*24 {!by 0}

blitdata_empty
!for i, 40*24 {!by ' '}
