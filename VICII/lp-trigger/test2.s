
    .export Start

Start:


    jsr initirq
    jmp *

    sei
    lda #$35
    sta $01

    lda #$01
    sta $d01a
    lda #$7f
    sta $dc0d
    lda #$1b
    sta $d011
    lda #$20
    sta $d012

    lda $dc0d
    sta $dc0d
    inc $d019
    cli

    lda #0
    sta $d020
    sta $d021

    ldx #0
@lp1:
    lda #$20
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $06e8,x
    lda #$1
    sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $dae8,x
    inx
    bne @lp1

    ldx #0
@lp:
    lda #$a0
    sta $0400,x
    sta $0428,x
    lda cols,x
    sta $d800,x
    sta $d828,x
    inx
    cpx #40
    bne @lp

jitter:
    nop         ; 2
    bit $ea     ; 3
    bit $eaea   ; 4

    lda ($ff),y ; 5+1
    lda ($ff,x) ; 6

    inc $06e8,x ; 7

    inx
    iny

    jmp jitter

cols:
    .byte 1,1,1,1,1,1
    .byte 2,2,2,2,2,2
    .byte 3,3,3,3,3,3
    .byte 4,4,4,4,4,4
    .byte 5,5,5,5,5,5
    .byte 6,6,6,6,6,6
    .byte 7,7,7,7,7,7

    .import rastersync_lp

tmp = $f0

testlp:
         ldx #$ff
         ldy #$00
         ; prepare cia ports
         stx $dc00     ; port A = $ff (inactive)
         sty $dc02     ; ddr A = $00  (all input)
         stx $dc03     ; ddr B = $ff  (all output)
         stx $dc01     ; port B = $ff (inactive)
         ; now trigger the lp latch
         sty $dc01     ; port B = $00 (active)
         stx $dc01     ; port B = $ff (inactive)
;         lda $d013     ; get x-position (pixels, divided by two)
    lda $d013
    sta tmp
    lda $d014
    sta tmp+1
         ; restore cia setup
         stx $dc02     ; ddr A = $ff  (all output)
         sty $dc03     ; ddr B = $00  (all input)
         stx $dc01     ; port B = $ff (inactive)
         ldx #$7f
         stx $dc00     ; port A = $7f


    lda tmp
    and #$0f
    tax
    lda hextab,x
    sta $0401
    
    lda tmp
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tax
    lda hextab,x
    sta $0400

    lda tmp
    tax
    sta $0400+(4*40),x
    
    lda tmp+1
    and #$0f
    tax
    lda hextab,x
    sta $0404
    
    lda tmp+1
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tax
    lda hextab,x
    sta $0403
    
    rts

hextab:
    .byte "0123456789",1,2,3,4,5,6,7,8

        ;*= $2000    ;Assemble to $2000
initirq:
 
         sei         ;Disable IRQ's
         lda #$7f    ;Disable CIA IRQ's
         sta $dc0d
         sta $dd0d

         lda #$35    ;Bank out kernal and basic
         sta $01     ;$e000-$ffff
 
         lda #<irq1  ;Install RASTER IRQ
         ldx #>irq1  ;into Hardware
         sta $fffe   ;Interrupt Vector
         stx $ffff
 
 
         lda #$01    ;Enable RASTER IRQs
         sta $d01a
         lda #$34    ;IRQ on line 52
         sta $d012
         lda #$1b    ;High bit (lines 256-311)
         sta $d011
                     ;NOTE double IRQ
                     ;cannot be on or
                     ;around a BAD LINE!
                     ;(Fast Line)
 
         lda #$0e    ;Set Background
         sta $d020   ;and Border colors
         lda #$06
         sta $d021
         lda #$00
         sta $d015   ;turn off sprites
 
         jsr clrscreen
         jsr clrcolor
         jsr printtext
 
         asl $d019   ;Ack any previous
         bit $dc0d   ;IRQ's
         bit $dd0d
 
         cli         ;Allow IRQ's
 
         jmp *       ;Endless Loop
 
        .repeat 128+7
        .byte 0
        .endrepeat

 
irq1:
         sta reseta1 ;Preserve A,X and Y
         stx resetx1 ;Registers
         sty resety1 ;VIA self modifying
                     ;code
                     ;(Faster than the
                     ;STACK is!)
 
         lda #<irq2  ;Set IRQ Vector
         ldx #>irq2  ;to point to the
                     ;next part of the
         sta $fffe   ;Stable IRQ
         stx $ffff   ;ON NEXT LINE!
         inc $d012
         asl $d019   ;Ack RASTER IRQ
         tsx         ;We want the IRQ
         cli         ;To return to our
         nop         ;endless loop
         nop         ;NOT THE END OF
         nop         ;THIS IRQ!
         nop
         nop         ;Execute nop's
         nop         ;until next RASTER
         nop         ;IRQ Triggers
         nop
         nop         ;2 cycles per
         nop         ;instruction so
         nop         ;we will be within
         nop         ;1 cycle of RASTER
         nop         ;Register change
         nop
irq2:
         txs         ;Restore STACK
                     ;Pointer
         ldx #$08    ;Wait exactly 1
         dex         ;lines worth of
         bne *-1     ;cycles for compare
         bit $ea     ;Minus compare
         nop         ;cycles
 
         nop  ;<--- remove 1 NOP for PAL
 
         lda #$35    ;RASTER change yet?
         cmp $d012
         beq start   ;If no waste 1 more
                     ;cycle
start:
         nop         ;Some delay
         nop         ;So stable can be
         nop         ;seen
 
         lda #$0e    ;Colors
         ldx #$06
 
         sta $d021   ;Here is the proof
         stx $d021
 
         lda #<irq1  ;Set IRQ to point
         ldx #>irq1  ;to subsequent IRQ
         ldy #$34    ;at line $68
         sta $fffe
         stx $ffff
         sty $d012
         asl $d019   ;Ack RASTER IRQ

        jsr testlp
 
reseta1  = *+1       ;registers
         lda #$00    ;Reload A,X,and Y
resetx1  = *+1
         ldx #$00
resety1  = *+1
         ldy #$00
 
         rti         ;Return from IRQ
 
nmi:
         asl $d019   ;Ack all IRQ's
         lda $dc0d
         lda $dd0d
         lda #$81    ;reset CIA 1 IRQ
         ldx #$00    ;remove raster IRQ
         ldy #$37    ;reset MMU to roms
         sta $dc0d
         stx $d01a
         sty $01
         ldx #$ff    ;clear the stack
         txs
         cli         ;reenable IRQ's
         jmp $9000   ;back to Turbo
 
clrscreen:
         lda #$20    ;Clear the screen
         ldx #$00
clrscr:   sta $0400,x
         sta $0500,x
         sta $0600,x
         sta $0700,x
         dex
         bne clrscr
         rts
clrcolor:
         lda #$03    ;Clear color memory
         ldx #$00
clrcol:   sta $d800,x
         sta $d900,x
         sta $da00,x
         sta $db00,x
         dex
         bne clrcol
         rts
 
printtext:
         lda #$16    ;C-set = lower case
         sta $d018
 
exit:     rts
