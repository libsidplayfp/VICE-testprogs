
DEBUG = 0

    .export Start

Start:

    sei

    lda #$01
    sta $d01a
    lda #$7f
    sta $dc0d
    lda #$1b
    sta $d011
    lda #$20
    sta $d012
    lda #>irq
    sta $ffff
    lda #<irq
    sta $fffe

    lda #0
    sta $d020
    sta $d021

    ldx #0
@lp1:
    lda #$00
    sta $0002,x
    lda #$00
    sta $0200,x
    lda #$00
    sta $0400,x
    lda #$20
    sta $0500,x
    sta $0600,x
    sta $06e8,x
    lda #$01
    sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $dae8,x
    inx
    bne @lp1

    lda #$2f
    sta $00
    lda #$35
    sta $01

    
    lda $dc0d
    sta $dc0d
    inc $d019
    cli

mlp:
    jsr jitter

    jmp mlp

jitter:
jbx:    ldx #0
jby:    ldy #1
        nop         ; 2
        bit $ea     ; 3
        bit $eaea   ; 4

        lda ($ff),y ; 5+1
        lda ($ff,x) ; 6

        inc $c000,x ; 7
        bne jsk

        inx
        iny
        iny
jsk:
        iny
        stx jbx+1
        sty jby+1
        rts

    .import rastersync_lp

tmp = $f0
val00 = $f3
val01 = $f4

irq:
    pha
    txa
    pha
    tya
    pha

    lda $d013
    sta tmp
    lda $d014
    sta tmp+1

    jsr rastersync_lp

    ldx #6
@lp1:
    dex
    bne @lp1
    nop
    nop

    lda #1
    ldx #2
@lp:
    inc $d020
    inc $d020
    inc $d020
    inc $d020
    inc $d020
    inc $d020
    inc $d020
    inc $d020
    inc $d020
    sta $d020
    dex
    bne @lp

    ; screen at $0000, ROM char
    lda #$05
    sta $d018

border = * + 1
    lda #5
    sta $d020
    ;sta $d021

    inc val00
    dec val01

    ; in the border area the VIC fetches from last byte in the video bank
    ; ($3fff). so we write the value we want to write to 0/1 to $3fff, then
    ; actually write 0/1

    ldx #$2f
    ldy #$35

    lda val00
    sta $3fff

    stx $00

    lda val01
    sta $3fff

    sty $01

checkoffs = * + 1
    lda #0
    jsr setsprites
    lda $d01f
.if DEBUG
    lda #2
    sta $d020
    sta $d021
.endif
    lda #$41
    cmp $d012
    bne *-3
.if DEBUG
    lda #3
    sta $d020
    sta $d021
.endif
    ; screen at $0400, charset from $0000
    lda #$10
    sta $d018
    
    lda #$51
    cmp $d012
    bne *-3
.if DEBUG
    lda #4
    sta $d020
    sta $d021
.endif
    ; screen at $0400, ROM char
    lda #$15
    sta $d018
    
    ldx checkoffs
    lda $d01f
    sta $0400 + (5 * 40),x
    lda val00,x
    sta $0400 + (6 * 40),x

    lda $0400 + (5 * 40),x
    eor $0400 + (6 * 40),x
    sta $0400 + (7 * 40),x
    beq @noerr
    lda #10
    sta border
@noerr:
    
.if DEBUG
    lda #0
    sta $d020
    sta $d021
.endif
    lda checkoffs
    eor #1
    sta checkoffs
    
    jsr jitter

    ldx #$2f
    ldy #$35
;    stx $00
;    sty $01
    
    inc $d019

    pla
    tay
    pla
    tax
    pla
    rti

setsprites:

;        lda #50 + (2*8)
        clc
        adc #50 + (2*8)
        ldx #0
@lp2:
        sta $d001,x
        inx
        inx
        cpx #8*2
        bne @lp2

        lda #$80
        sta $0200

        ldy #24 + (1*8) + 7
        ldx #0
@lp1:
        tya
        sta $d000,x
        dey
        inx
        inx
        cpx #8*2
        bne @lp1

        
        ldx #0
@lp3:
        lda #5
        sta $d027,x
        lda #$0200 / 64
        sta $0400+$03f8,x
        inx
        cpx #8
        bne @lp3

        lda #$ff
        sta $d015
        lda #0
        sta $d017
        sta $d01c
        sta $d01d
        rts

