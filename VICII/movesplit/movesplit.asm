; movesplit
; ---------
; Does a $d011 split at user-movable position.

; NOTE! Only PAL tested.

!ct scr

; --- Consts

; Select the video timing (processor clock cycles per raster line)
;CYCLES = 65     ; 6567R8 and above, NTSC-M
;CYCLES = 64    ; 6567R5 6A, NTSC-M
CYCLES = 63    ; 6569 (all revisions), PAL-B

start_raster = 47       ; start of raster interrupt

vmode_stdtext = $1b     ; d011 flags for normal vmode
vmode_test = $5b        ; d011 flags for tested split

cinv = $0314
cnmi = $0318
screen = $0400

GETIN = $ffe4           ; ret: a = 0: no keys pressed, otherwise a = ASCII code

key_split_l = $41
key_split_r = $44
key_split_u = $57
key_split_d = $53

key_tchar_n = $52
key_tchar_p = $46
key_tchar_nn = $54
key_tchar_pp = $47

key_tcharmod_n = $59
key_tcharmod_p = $48
key_tcharmod_nn = $55
key_tcharmod_pp = $4a

key_tmodmode = $4b

key_tmode_e = $45
key_tmode_b = $42

key_tmode_e_to = $c5
key_tmode_b_to = $c2

key_d022_n = $5a
key_d023_n = $58
key_d024_n = $43


; --- Variables

; - zero page

temp = $ff              ; temp zero page variable
strptr = $39            ; zp pointer to string
tmpptr = $56            ; temporary zp pointer 2
scrptr = $fb            ; zp pointer to screen


; --- Code

*=$0801
basic:
; BASIC stub: "1 SYS 2061"
!by $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00

start:
    jsr setup
    jsr install
    jmp mainloop

install:          ; install the raster routine
    jsr restore   ; Disable the Restore key (disable NMI interrupts)
checkirq:
    lda cinv      ; check the original IRQ vector
    ldx cinv+1    ; (to avoid multiple installation)
    cmp #<irq1
    bne irqinit
    cpx #>irq1
    beq skipinit
irqinit:
    sei
    sta oldirq    ; store the old IRQ vector
    stx oldirq+1
    lda #<irq1
    ldx #>irq1
    sta cinv      ; set the new interrupt vector
    stx cinv+1
skipinit:
    lda #vmode_stdtext
    sta $d011     ; set the raster interrupt location
    lda #start_raster
    sta $d012
    lda #$7f
    sta $dc0d     ; disable timer interrupts
    sta $dd0d
    ldx #1
    stx $d01a     ; enable raster interrupt
    lda $dc0d     ; acknowledge CIA interrupts
    lsr $d019     ; and video interrupts
    cli
    rts

deinstall:
    sei           ; disable interrupts
    lda #$1b
    sta $d011     ; restore text screen mode
    lda #$81
    sta $dc0d     ; enable Timer A interrupts on CIA 1
    lda #0
    sta $d01a     ; disable video interrupts
    lda oldirq
    sta cinv      ; restore old IRQ vector
    lda oldirq+1
    sta cinv+1
    bit $dd0d     ; re-enable NMI interrupts
    cli
    rts

; -- IRQ handlers

; Auxiliary raster interrupt (for syncronization)
irq1:
; irq (event)   ; > 7 + at least 2 cycles of last instruction (9 to 16 total)
; pha           ; 3
; txa           ; 2
; pha           ; 3
; tya           ; 2
; pha           ; 3
; tsx           ; 2
; lda $0104,x   ; 4
; and #xx       ; 2
; beq           ; 3
; jmp ($314)    ; 5
                ; ---
                ; 38 to 45 cycles delay at this stage
    lda #<irq2
    sta cinv
    lda #>irq2
    sta cinv+1
    nop           ; waste at least 12 cycles
    nop           ; (up to 64 cycles delay allowed here)
    nop
    nop
    nop
    nop
    inc $d012     ; At this stage, $d012 has already been incremented by one.
    lda #1
    sta $d019     ; acknowledge the first raster interrupt
    cli           ; enable interrupts (the second interrupt can now occur)
    ldy #9
    dey
    bne *-1       ; delay
    nop           ; The second interrupt will occur while executing these
    nop           ; two-cycle instructions.
    nop
    nop
    nop
oldirq = * + 1  ; Placeholder for self-modifying code
    jmp *         ; Return to the original interrupt

; Main raster interrupt
irq2:
; irq (event)   ; 7 + 2 or 3 cycles of last instruction (9 or 10 total)
; pha           ; 3
; txa           ; 2
; pha           ; 3
; tya           ; 2
; pha           ; 3
; tsx           ; 2
; lda $0104,x   ; 4
; and #xx       ; 2
; beq           ; 3
; jmp (cinv)    ; 5
                ; ---
                ; 38 or 39 cycles delay at this stage
    lda #<irq1
    sta cinv
    lda #>irq1
    sta cinv+1
    ldx $d012
    nop
!if CYCLES != 63 {
!if CYCLES != 64 {
    nop           ; 6567R8, 65 cycles/line
    bit $24
} else {
    nop           ; 6567R56A, 64 cycles/line
    nop
}
} else {
    bit $24       ; 6569, 63 cycles/line
}
    cpx $d012     ; The comparison cycle is executed CYCLES or CYCLES+1 cycles
                  ; after the interrupt has occurred.
    beq *+2       ; Delay by one cycle if $d012 hadn't changed.
                  ; Now exactly CYCLES+3 cycles have passed since the interrupt.
    dex
    dex
    stx $d012     ; restore original raster interrupt position
    ldx #1
    stx $d019     ; acknowledge the raster interrupt

; start action here
testloop_pre:
    ; delay for correct x placement
    ldx split_x
    lda split_x_lut,x
    jsr delay

    ; additional delay
    ldx #6
-   dex
    bne -
    nop

    ; loops
    ldy #7

testloop:
!if 0 {
    ; prepare split values
    lda #2 ;#vmode_test
    ldx #6 ;#vmode_stdtext

    ; do the split
    sta $d021
    stx $d021
} else {
    ; prepare split values
test_vmode_from = * + 1
    lda #vmode_test
test_vmode_to = * + 1
    ldx #vmode_stdtext

    ; do the split
    sta $d011
    stx $d011
}
    ldx #7
-   dex
    bne -
    nop
    nop
    nop
    nop
    nop

    dey
    bne testloop

    dec $d020
    inc $d020

    ldx #vmode_stdtext
    stx $d011
endirq:
    jmp $ea81     ; return to the auxiliary raster interrupt

restore:        ; disable the Restore key
    lda cnmi
    ldy cnmi+1
    pha
    lda #<nmi     ; Set the NMI vector
    sta cnmi
    lda #>nmi
    sta cnmi+1
    ldx #$81
    stx $dd0d     ; Enable CIA 2 Timer A interrupt
    ldx #0
    stx $dd05
    inx
    stx $dd04     ; Prepare Timer A to count from 1 to 0.
    ldx #$dd
    stx $dd0e     ; Cause an interrupt.
nmi = * + 1
    lda #$40      ; RTI placeholder
    pla
    sta cnmi
    sty cnmi+1    ; restore original NMI vector (although it won't be used)
    rts

; - delay
;
!align 63, 0
delay:              ;delay 80-accu cycles, 0<=accu<=64
    lsr             ;2 cycles akku=akku/2 carry=1 if accu was odd, 0 otherwise
    bcc waste1cycle ;2/3 cycles, depending on lowest bit, same operation for both
waste1cycle:
    sta smod+1      ;4 cycles selfmodifies the argument of branch
    clc             ;2 cycles
;now we have burned 10/11 cycles.. and jumping into a nopfield
smod:
    bcc *+10
!by $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
!by $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
!by $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
!by $ea,$ea,$ea,$ea,$ea,$ea,$ea,$ea
    rts             ;6 cycles


; --  Main loop

mainloop:
    ; print some text
    lda #>screen
    sta scrptr+1
    lda #<screen
    sta scrptr
    lda #>message
    sta strptr+1
    lda #<message
    sta strptr
    jsr print_text

    ; print current settings
    jsr print_split_loc
    jsr print_test_char
    jsr print_test_char_mod
    jsr print_test_vmode
    jsr print_colors

    ; update the active line
    jsr print_test_line

mainloop_wait:
    lda #$ff
-   cmp $d012
    bne -
    jsr GETIN
    beq mainloop_wait

!if 0 {
    ; print pressed key
    pha
    tax
    lda #<(screen + 23*40)
    sta tmpptr
    lda #>(screen + 23*40)
    sta tmpptr+1
    txa
    jsr printhex
    pla
}

++  cmp #key_split_l
    bne ++
    ; split_x--
    ldx split_x
    dex
    cpx #$ff
    bne +
    ldx #62
+   stx split_x
    jmp mainloop

++  cmp #key_split_r
    bne ++
    ; split_x++
    ldx split_x
    inx
    cpx #63
    bne +
    ldx #0
+   stx split_x
    jmp mainloop

++  cmp #key_split_u
    bne ++
    ; split_y--
    ldx split_y
    stx split_y_old
    dex
    cpx #$ff
    bne +
    ldx #24
+   stx split_y
    jsr update_y
    jmp mainloop

++  cmp #key_split_d
    bne ++
    ; split_y++
    ldx split_y
    stx split_y_old
    inx
    cpx #25
    bne +
    ldx #0
+   stx split_y
    jsr update_y
    jmp mainloop

++  cmp #key_tchar_p
    bne ++
    ; tchar--
    lda #-1
    jsr change_tchar
    jmp mainloop

++  cmp #key_tchar_pp
    bne ++
    ; tchar -= 16
    lda #-$10
    jsr change_tchar
    jmp mainloop

++  cmp #key_tchar_n
    bne ++
    ; tchar++
    lda #1
    jsr change_tchar
    jmp mainloop

++  cmp #key_tchar_nn
    bne ++
    ; tchar += 16
    lda #$10
    jsr change_tchar
    jmp mainloop

++  cmp #key_tcharmod_p
    bne ++
    ; tcharmod--
    lda #-1
    jsr change_tcharmod
    jmp mainloop

++  cmp #key_tcharmod_pp
    bne ++
    ; tcharmod -= 16
    lda #-$10
    jsr change_tcharmod
    jmp mainloop

++  cmp #key_tcharmod_n
    bne ++
    ; tcharmod++
    lda #1
    jsr change_tcharmod
    jmp mainloop

++  cmp #key_tcharmod_nn
    bne ++
    ; tcharmod += 16
    lda #$10
    jsr change_tcharmod
    jmp mainloop

++  cmp #key_tmodmode
    bne ++
    ; toggle adc/eor
    lda tmodmode
    eor #$20    ; adc #imm = $69, eor #imm = $49
    sta tmodmode
    jmp mainloop

++  cmp #key_tmode_e
    bne ++
    ; toggle ecm
    lda test_vmode_from
    eor #$40
    sta test_vmode_from
    jmp mainloop

++  cmp #key_tmode_b
    bne ++
    ; toggle bmm
    lda test_vmode_from
    eor #$20
    sta test_vmode_from
    jmp mainloop

++  cmp #key_tmode_e_to
    bne ++
    ; toggle ecm
    lda test_vmode_to
    eor #$40
    sta test_vmode_to
    jmp mainloop

++  cmp #key_tmode_b_to
    bne ++
    ; toggle bmm
    lda test_vmode_to
    eor #$20
    sta test_vmode_to
    jmp mainloop

++  cmp #key_d022_n
    bne ++
    ; d022++
    inc $d022
    jmp mainloop

++  cmp #key_d023_n
    bne ++
    ; d023++
    inc $d023
    jmp mainloop

++  cmp #key_d024_n
    bne ++
    ; d024++
    inc $d024
    jmp mainloop

++  jmp mainloop_wait


; -- Subroutines

; - setup
;
setup:
    lda #0
    sta $3fff

    ; set screen color
    lda 646
    ldx #0
-   sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $dae8,x
    inx
    bne -

    ; set key repeat on all keys.
    lda #255
    sta 650

    ; copy character rom to $2000-
    lda #>$d000
    sta strptr+1    ; points to font source
    lda #>$2000
    sta scrptr+1    ; points to font destination
    lda #>$3000
    sta tmpptr+1    ; points to xor'd font dest
    lda #0
    sta strptr
    sta scrptr
    sta tmpptr

    ldy #0          ; loop counter

    sei             ; interrups off
    lda $01
    and #$fb
    sta $01         ; character rom on

-   lda (strptr),y
    sta (scrptr),y
    eor #$f0        ; invert the first half of the char
    sta (tmpptr),y
    iny
    bne -
    inc strptr+1
    inc scrptr+1
    inc tmpptr+1
    lda tmpptr+1
    cmp #>$4000
    bne -

    lda $01
    ora #$04
    sta $01         ; character rom off

    lda $dc0d       ; acknowledge CIA interrupts
    lsr $d019       ; and video interrupts
    cli             ; interrupts on

    ; font = bitmap = $2000
    lda #$18
    sta $d018

    rts


; - update_y
;  x = new split y
;
update_y:
    ; update raster IRQ line
    sei
    lda split_y_lsb_lut,x
    sta $d012
    lda $dc0d     ; acknowledge CIA interrupts
    lsr $d019     ; and video interrupts
    cli

    ; erase old test line
    ldx split_y_old
    lda split_y_text_lsb_lut,x
    sta scrptr
    lda split_y_text_msb_lut,x
    sta scrptr+1
    lda #>empty_line
    sta strptr+1
    lda #<empty_line
    sta strptr
    jsr print_text
    rts

; - change_tchar
; parameter:
;  a = amount (msb = direction)
;
change_tchar:
    sta change_tchar_amount
    lda tchar
    clc
change_tchar_amount = * + 1
    adc #$12
    sta tchar
    rts

; - change_tcharmod
; parameter:
;  a = amount (msb = direction)
;
change_tcharmod:
    sta change_tcharmod_amount
    lda tcharmod
    clc
change_tcharmod_amount = * + 1
    adc #$12
    sta tcharmod
    rts

; - print_text
; parameters:
;  scrptr -> screen location to print to
;  strptr -> string to print
;
print_text:
    ldy #0
-   lda (strptr),y
    beq +++         ; end if zero
    sta (scrptr),y  ; print char
    iny
    bne -           ; loop if not zero
    inc strptr+1
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


; - print_test_line
;
print_test_line:
    ldx split_y
    lda split_y_text_lsb_lut,x
    sta tmpptr
    lda split_y_text_msb_lut,x
    sta tmpptr+1
    ldy #0
    lda tchar
-   sta (tmpptr),y
    clc
tmodmode = *
tcharmod = * + 1
    adc #$00
    iny
    cpy #40
    bne -
    rts

; - print_split_loc
;
print_split_loc:
    lda #<text_location_split_x
    sta tmpptr
    lda #>text_location_split_x
    sta tmpptr+1
    lda split_x
    jsr printhex
    lda #<text_location_split_y
    sta tmpptr
    lda #>text_location_split_y
    sta tmpptr+1
    lda split_y
    jsr printhex
    rts

; - print_test_char
;
print_test_char:
    lda tchar
    sta text_location_tchar
    lda #<text_location_tchar_hex
    sta tmpptr
    lda #>text_location_tchar_hex
    sta tmpptr+1
    lda tchar
    jsr printhex
    rts

; - print_test_char_mod
;
print_test_char_mod:
    lda #<text_location_tcharmod
    sta tmpptr
    lda #>text_location_tcharmod
    sta tmpptr+1
    lda tcharmod
    jsr printhex
    lda #<text_location_tmodmode
    sta tmpptr
    lda #>text_location_tmodmode
    sta tmpptr+1
    lda tmodmode
    jsr printhex
    rts

; - print_test_vmode
;
print_test_vmode:
    lda #<text_location_tmode_from
    sta tmpptr
    lda #>text_location_tmode_from
    sta tmpptr+1
    lda test_vmode_from
    jsr printhex
    lda #<text_location_tmode_to
    sta tmpptr
    lda #>text_location_tmode_to
    sta tmpptr+1
    lda test_vmode_to
    jsr printhex
    rts

; - print_colors
;
print_colors:
    lda #<text_location_d02x
    sta tmpptr
    lda #>text_location_d02x
    sta tmpptr+1
    lda $d022
    and #$0f
    jsr printhex
    lda $d023
    and #$0f
    jsr printhex
    lda $d024
    and #$0f
    jsr printhex
    rts

; - printhex
; parameters:
;  tmpptr:h -> screen location to print to
;  a = value to print
; returns:
;  tmpptr:h += 2
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
    sta (tmpptr),y
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
    dey
    sta (tmpptr),y
    ; tmpptr+=2
    inc tmpptr
    bne +
    inc tmpptr+1
+   inc tmpptr
    bne +
    inc tmpptr+1
+   rts



; --- Data

; current position
split_x: !by 0
split_y: !by 0
split_y_old: !by 0

; current test char
tchar: !by 0

; hex lookup table
hex_lut: !scr "0123456789abcdef"

; help text
message:
;     |---------0---------0---------0--------|
!scr "                                        "
!scr "movesplit v4 - controls:                "
!scr " a/d/w/s - move split position : "
text_location_split_x = * - message + screen
!scr                                  "xx/"
text_location_split_y = * - message + screen
!scr                                     "xx  "
!scr " r/f/t/g - change base char    : "
text_location_tchar_hex = * - message + screen
!scr                                  "xx = "
text_location_tchar = * - message + screen
!scr                                       "x "
!scr " y/h/u/j - change char modifier: "
text_location_tcharmod = * - message + screen
!scr                                  "xx     "
!scr " k - change modifier (adc/eor) : "
text_location_tmodmode = * - message + screen
!scr                                  "xx     "
!scr " (sh-)e/b - toggle ecm/bmm bit : "
text_location_tmode_from = * - message + screen
!scr                                  "xx->"
text_location_tmode_to = * - message + screen
!scr                                      "xx "
!scr " z/x/c - inc $d022/3/4: "
text_location_d02x = * - message + screen
!scr                         "xxxxxx          "
empty_line
!scr "                                        "
!by 0

; lookup for positions
split_y_text_lsb_lut:
!for i, 25 { !by <(screen + (i-1)*40) }
split_y_text_msb_lut:
!for i, 25 { !by >(screen + (i-1)*40) }
split_y_lsb_lut:
!for i, 25 { !by <(start_raster + (i-1) * 8) }
!align 63,0
split_x_lut:
!for i, 64 { !by 64-i }
