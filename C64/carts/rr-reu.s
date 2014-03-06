
CRTID = 36 ; retro replay

ROMSTART = $8000

    !to "rr-reu.bin",plain

        * = ROMSTART

        !word start
        !word start
        !byte $c3, $c2, $cd, $38, $30

;-------------------------------------------------------------------------------

start:
        sei
        lda #$1b
        sta $d011
        lda #$17
        sta $d018
        lda #$c8
        sta $d016

        lda #$2f
        sta $00
        lda #$37
        sta $01

        ; switch to REU mapping
        lda #%01000000
        sta $de01

        ; show i/o areas on screen
        ldx #0
lp:
        lda #1
        sta $d800,x
        lda #2
        sta $d900,x
        lda #3
        sta $da00,x
        lda #4
        sta $db00,x
        lda #$20
        sta $0400,x
        sta $0500,x
        lda $de00,x
        sta $0600,x
        lda $df00,x
        sta $0700,x
        inx
        bne lp

        ; now test if a reu transfer actually works
        ldx #19
lp1:
        lda txt1,x
        sta $0400,x
        dex
        bpl lp1

        ; setup reu regs, start transfer
        lda #$00 ; addr ctrl
        sta $df0a
        lda #$00 ; irq mask
        sta $df09
        lda #$00 
        sta $df08
        lda #20 ; transfer len lo 
        sta $df07
        lda #$00 ; reu addr
        sta $df06
        sta $df05
        sta $df04
        lda #>$0400 ; c64 addr hi
        sta $df03
        lda #<$0400 ; c64 addr lo
        sta $df02

        lda #$90        ; 2     cmd (exec immediatly c64->REU)
        sta $df01       ; 4

        ; setup reu regs, start transfer
        lda #$00 ; addr ctrl
        sta $df0a
        lda #$00 ; irq mask
        sta $df09
        lda #$00 
        sta $df08
        lda #20 ; transfer len lo 
        sta $df07
        lda #$00 ; reu addr
        sta $df06
        sta $df05
        sta $df04
        lda #>$0414 ; c64 addr hi
        sta $df03
        lda #<$0414 ; c64 addr lo
        sta $df02

        lda #$91        ; 2     cmd (exec immediatly reu->c64)
        sta $df01       ; 4

        ; check
        ldy #2

        ldx #19
chk:
        lda $0400,x
        cmp $0414,x
        bne doneerror
        dex
        bpl chk

        ldy #5
doneerror:
        sty $d020

        jmp *

;-------------------------------------------------------------------------------
txt1:
    !scr "1RR4PLUS9REU3TEST890"