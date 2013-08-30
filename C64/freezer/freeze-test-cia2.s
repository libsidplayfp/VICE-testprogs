
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
        lda #$1f
        sta $dc0d

        lda #$10
        sta $dd0e
        lda #< ((63*312) - 1)
        sta $dd04
        lda #> ((63*312) - 1)
        sta $dd05

@lp2:   lda $d011
        and #$80
        bne @lp2

        lda #$32
@lp:
        cmp $d012
        bne @lp
        
        lda #$11
        sta $dd0e
        lda #$81
        sta $dd0d
        lda $dd0d
        cli

@ml:
        inc $0400
        jmp @ml

nmi:
        inc $d020

        ldx #$00
@lp2:
        dex
        bne @lp2
        
        lda #0
        sta $d020
        lda $dd0d
        rti

irq:
        inc $0401
        rti
