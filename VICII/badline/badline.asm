; screenpos
; --------
; Test interrupt delay with badline.

; PAL only. The test sets up NMI interrupts simultaneously with VIC
; badlines and programs them to trigger at variable times with respect
; to the badline start position. The end result shows how interrupts
; are delayed with respect to badline.

; Program structure:
;
; - establish a stable on raster interrupt on the line preceding display.
; - program CIA timer to trigger right before a badline
; - in the CIA interrupt, change display color to a value and back
; - program next interrupt 7 rasterlines later & with 1 larger CIA delay,
;   repeat until end of screen.

; --- Consts

cinv = $fffe
cnmi = $fffa
raster = 48     ; start of raster interrupt
m = $fb         ; zero page variable
screen = $400

; --- Code, based on:
; http://codebase64.org/doku.php?id=base:double_irq&s[]=stable&s[]=raster 

*=$0801
; "1 SYS 2061".
basic: !by $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00
; 2061 ->
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
    lda #raster    ;IRQ on line 52
    sta $d012
    lda #$1b    ;High bit (lines 256-311)
    sta $d011
                 ;NOTE double IRQ
                 ;cannot be on or
                 ;around a BAD LINE!
                 ;(Fast Line)
 
    asl $d019   ;Ack any previous
    bit $dc0d   ;IRQ's
    bit $dd0d

    lda #<nmi
    ldx #>nmi
    sta $fffa
    stx $fffb

    cli         ;Allow IRQ's
    jmp *       ;Endless Loop

nmi:
    inc $d020
    dec $d020
    rti

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
irq2
     txs         ;Restore STACK
                 ;Pointer
     ldx #$08    ;Wait exactly 1
     dex         ;lines worth of
     bne *-1     ;cycles for compare
     bit $ea     ;Minus compare
;     nop         ;cycles

     ldx $d012
     cpx $d012
     beq start   ;If no waste 1 more
                 ;cycle
start
     dex
     stx $d012
     jsr dostuff
     lda #<irq1  ;Set IRQ to point
     ldx #>irq1  ;to subsequent IRQ
     sta $fffe
     stx $ffff
     asl $d019   ;Ack RASTER IRQ
 
     lda #$00    ;Reload A,X,and Y
reseta1  = *-1       ;registers
     ldx #$00
resetx1  = *-1
     ldy #$00
resety1  = *-1
     rti         ;Return from IRQ

irqpos: !by raster
 
; start action here
dostuff:
  inc $d021
  inc $d020
  dec $d021
  dec $d020

; 1. establish stable rasters throughout screen region,
;    by programming new interrupts 8 lines from now.
  lda irqpos
  cmp #$f7
  bcc skiprestart

; next addition would overflow, let's just start over.
  lda #raster
  sta $d012
  sta irqpos
  rts

skiprestart:
  cld
  clc
  adc #$8
  sta $d012
  sta irqpos

  rts
