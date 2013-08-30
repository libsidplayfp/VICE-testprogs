
        .export _main

_main:

        sei
        lda #$35
        sta $01

        lda #<irq
        sta $fffe
        lda #>irq
        sta $ffff

        lda #<nmi
        sta $fffa
        lda #>nmi
        sta $fffb

        lda #$01
        sta $d01a
        lda #$32
        sta $d012
        lda #$1b
        sta $d011
        lda #$7f
        sta $dc0d
        cli

@ml:
        inc $0400
        jmp @ml

irq:
        lda $d012
        ldx #1
@lp2:
        inc $d020

        clc
        adc #$08
@lp1:
        cmp $d012
        bne @lp1

        dex
        bne @lp2
        
        inc $d019
        lda #0
        sta $d020
        rti

nmi:
        inc $0401
        rti
