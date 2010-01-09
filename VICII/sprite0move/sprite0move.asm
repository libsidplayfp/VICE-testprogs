; sprite0move
; -----------
; based on testprogs/VICII/gfxfetch/gfxfetch.asm

; Opens side border, displays test sprite (#0), lets the user move it.

; NOTE! Only PAL tested.


; --- Macros

; SpriteLine - for easy definition of sprites
; from "ddrv.a" by Marco Baye
!macro SpriteLine .v {
!by .v>>16, (.v>>8)&255, .v&255
}


; --- Consts

; Select the video timing (processor clock cycles per raster line)
;CYCLES = 65     ; 6567R8 and above, NTSC-M
;CYCLES = 64    ; 6567R5 6A, NTSC-M
CYCLES = 63    ; 6569 (all revisions), PAL-B

raster = 46          ; start of raster interrupt
spritey = 51         ; sprite 0 Y

cinv = $0314
cnmi = $0318
screen = $0400
sprite0ptr = $7f8    ; pointer location

start_sprite_x = 320

GETIN = $ffe4           ; ret: a = 0: no keys pressed, otherwise a = ASCII code

key_sprite_l = $41
key_sprite_r = $44
key_sprite_ll = $57
key_sprite_rr = $53
key_sprite_next = $52
key_sprite_prev = $46

; --- Variables

; - zero page

temp = $ff              ; temp zero page variable
strptr = $39            ; zp pointer to string
tmpptr = $56            ; temporary zp pointer 2
scrptr = $fb            ; zp pointer to screen
zpzero = $fe            ; zero

; --- Code

*=$0801
basic:
; BASIC stub: "1 SYS 2061"
!by $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00

start:
    jsr setup
    jsr install
    jmp mainloop

install:        ; install the raster routine
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
    lda #$1b
    sta $d011     ; set the raster interrupt location
    lda #raster
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
    ; delay badline by messing with yscroll
    lda $d012
    sec
    sbc #1
    and #$07
    sta testloop_newyscroll_1
    lda $d011
    and #$f8
testloop_newyscroll_1 = * + 1
    ora #$12
    sta $d011

    ; prepare $d015 for opening the border
    lda #$0f
    sta $d016

    ; open the border two lines before the sprite fetches
    lda zpzero
    sta $d016

    ; prepare $d015 for opening the border
    lda #$0f
    sta $d016

    ldx #9
-   dex
    bne -
    nop
    nop

    ; open the border on the line before the sprite fetches
    lda zpzero
    sta $d016

    ; prepare $d015 for opening the border
    lda #$0f
    sta $d016

    ; loops
    ldy #21

    ldx #9
-   dex
    bne -
    beq *+2

testloop:
    ; open side border
    inc $d016
    dec $d016

    ; delay badline by messing with yscroll
    lda $d012
    sec
    sbc #1
    and #$07
    sta testloop_newyscroll
    lda $d011
    and #$f8
testloop_newyscroll = * + 1
    ora #$12
    sta $d011
    nop
    dey
    bne testloop

    ; restore d016
    lda #$08
    sta $d016

    lda #$80
postloop:
    cmp $d012
    bne postloop
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


; --  Main loop

mainloop:
    jsr print_sprite_loc

mainloop_wait:
    lda #$ff
-   cmp $d012
    bne -
    jsr GETIN
    beq mainloop_wait

!if 0 {
    ; print pressed key
    tax
    lda #<text_location_sprite_0 + 5
    sta tmpptr
    lda #>text_location_sprite_0
    sta tmpptr+1
    txa
    jsr printhex
    txa
}

++  cmp #key_sprite_next
    bne ++
    ; next sprite
    lda #sprite_last_ptr
    cmp spriteptr
    beq mainloop_wait
    inc spriteptr
    jsr set_sprite_ptr
    jmp mainloop_wait

++  cmp #key_sprite_prev
    bne ++
    ; prev sprite
    lda #sprite_first_ptr
    cmp spriteptr
    beq mainloop_wait
    dec spriteptr
    jsr set_sprite_ptr
    jmp mainloop_wait

++  cmp #key_sprite_l
    bne ++
    ; spritex--
    dec sprite0x
    lda #$ff
    cmp sprite0x
    bne +
    dec sprite0xh
+   jsr set_sprite_x
    jmp mainloop

++  cmp #key_sprite_ll
    bne ++
    ; spritex -= 16
    lda sprite0x
    sec
    sbc #$10
    sta sprite0x
    bcs +
    dec sprite0xh
+   jsr set_sprite_x
    jmp mainloop

++  cmp #key_sprite_r
    bne ++
    ; spritex++
    inc sprite0x
    bne +
    inc sprite0xh
+   jsr set_sprite_x
    jmp mainloop

++  cmp #key_sprite_rr
    bne ++
    ; spritex += 16
    lda sprite0x
    clc
    adc #$10
    sta sprite0x
    bcc +
    inc sprite0xh
+   jsr set_sprite_x
    jmp mainloop

++  jmp mainloop_wait

    jmp mainloop


; -- Subroutines

; - setup
;
setup:
    lda #0
    sta $3fff

    lda #0
    sta zpzero

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

    ; set sprite stuff
    jsr set_sprite_x
    jsr set_sprite_ptr
    ; all 8 sprites at the same line
    lda #spritey
    sta $d001
    sta $d003
    sta $d005
    sta $d007
    sta $d009
    sta $d00b
    sta $d00d
    sta $d00f
    ; zero other sprite X coords
    lda #0
    sta $d002
    sta $d004
    sta $d006
    sta $d008
    sta $d00a
    sta $d00c
    sta $d00e

    ; misc stuff
    lda #$0f
    sta $d027   ; sprite 0 color
    lda #0
    sta $d01b   ; priority
    sta $d01c   ; MCM
    sta $d01d   ; x expand
    sta $d017   ; y expand
    lda #$ff
    sta $d015   ; enable
    rts


; - set_sprite_x
;
set_sprite_x:
    lda sprite0x
    sta $d000
    lda sprite0xh
    and #1
    sta sprite0xh
    sta $d010
    rts


; - set_sprite_ptr
;
set_sprite_ptr:
    lda spriteptr
    sta sprite0ptr
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


; - print_sprite_loc
;
print_sprite_loc:
    lda #<text_location_sprite_0
    sta tmpptr
    lda #>text_location_sprite_0
    sta tmpptr+1
    lda sprite0xh
    jsr printhex
    lda sprite0x
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

; sprite 0 X coordinate
sprite0x:  !by <start_sprite_x
sprite0xh: !by >start_sprite_x

; selected sprite 0 pointer
spriteptr: !by sprite_first_ptr

!ct scr

; hex lookup table
hex_lut !tx "0123456789abcdef"

; help text
message:
;    |---------0---------0---------0--------|
!tx "sprite 0 on border testprog             "
!tx "                                        "
!tx "controls:                               "
!tx " a/d  - move 1 pixel left/right         "
!tx " w/s  - move 16 pixels left/right       "
!tx " r/f  - next/previous sprite            "
!tx "                                        "
!tx "current sprite location: "
text_location_sprite_0 = * - message + screen
!tx                           "              "
!tx "                                        "
!tx "                                        "

!by 0

; sprites
* = $2000
spritedata:
sprite_first_ptr = * / 64
;            765432107654321076543210
+SpriteLine %#....................... ;1
+SpriteLine %.#...................... ;2
+SpriteLine %..#..................... ;3
+SpriteLine %...#.................... ;4
+SpriteLine %....#................... ;5
+SpriteLine %.....#.................. ;6
+SpriteLine %......#................. ;7
+SpriteLine %.......#................ ;8
+SpriteLine %........#............... ;9
+SpriteLine %.........#.............. ;10
+SpriteLine %..........#............. ;11
+SpriteLine %...........#............ ;12
+SpriteLine %............#........... ;13
+SpriteLine %.............#.......... ;14
+SpriteLine %..............#......... ;15
+SpriteLine %...............#........ ;16
+SpriteLine %................#....... ;17
+SpriteLine %.................#...... ;18
+SpriteLine %..................#..... ;19
+SpriteLine %...................#.... ;20
+SpriteLine %....................#... ;21
!by 0

;            765432107654321076543210
+SpriteLine %#.......#.......#....... ;1
+SpriteLine %#.......#.......#....... ;2
+SpriteLine %#.......#.......#....... ;3
+SpriteLine %#.......#.......#....... ;4
+SpriteLine %#.......#.......#....... ;5
+SpriteLine %#.......#.......#....... ;6
+SpriteLine %#.......#.......#....... ;7
+SpriteLine %#.......#.......#....... ;8
+SpriteLine %#.......#.......#....... ;9
+SpriteLine %#.......#.......#....... ;10
+SpriteLine %#.......#.......#....... ;11
+SpriteLine %#.......#.......#....... ;12
+SpriteLine %#.......#.......#....... ;13
+SpriteLine %#.......#.......#....... ;14
+SpriteLine %#.......#.......#....... ;15
+SpriteLine %#.......#.......#....... ;16
+SpriteLine %#.......#.......#....... ;17
+SpriteLine %#.......#.......#....... ;18
+SpriteLine %#.......#.......#....... ;19
+SpriteLine %#.......#.......#....... ;20
+SpriteLine %#.......#.......#....... ;21
!by 0

sprite_last_ptr = * / 64
;            765432107654321076543210
+SpriteLine %#....................... ;1
+SpriteLine %#....................... ;2
+SpriteLine %#....................... ;3
+SpriteLine %#....................... ;4
+SpriteLine %#....................... ;5
+SpriteLine %#....................... ;6
+SpriteLine %#....................... ;7
+SpriteLine %#....................... ;8
+SpriteLine %#....................... ;9
+SpriteLine %#....................... ;10
+SpriteLine %#....................... ;11
+SpriteLine %#....................... ;12
+SpriteLine %#....................... ;13
+SpriteLine %#....................... ;14
+SpriteLine %#....................... ;15
+SpriteLine %#....................... ;16
+SpriteLine %#....................... ;17
+SpriteLine %#....................... ;18
+SpriteLine %#....................... ;19
+SpriteLine %#....................... ;20
+SpriteLine %#....................... ;21
!by 0

