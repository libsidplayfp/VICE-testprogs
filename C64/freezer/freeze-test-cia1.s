
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

        lda #$00
        sta $d01a
        lda #$10
        sta $dc0e
        lda #< ((63*312) - 1)
        sta $dc04
        lda #> ((63*312) - 1)
        sta $dc05

@lp2a:  lda $d011
        and #$80
        beq @lp2a

@lp2b:  lda $d011
        and #$80
        bne @lp2b

        lda #$32
@lp:
        cmp $d012
        bne @lp

        lda #$11
        sta $dc0e

        lda #$81
        sta $dc0d
        lda $dc0d
        cli

@ml:
        inc $0400
        jmp @ml

irq:
        inc $d020

        ldx #$00
@lp2:
        dex
        bne @lp2
        
        lda #0
        sta $d020
        lda $dc0d
        rti

nmi:
        inc $0401
        rti
