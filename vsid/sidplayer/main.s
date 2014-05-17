
            .export main

;-------------------------------------------------------------------------------
main:
            sei
            lda #0
            sta $d020
            sta $d021

            ldx #0
@lp:
            lda #$20
            sta $0400,x
            sta $0500,x
            sta $0600,x
            sta $0700,x
            lda #1
            sta $d800,x
            sta $d900,x
            sta $da00,x
            sta $db00,x
            inx
            bne @lp

            lda #0
            jsr cgplayer_inittune

            lda #>irq
            sta $0315
            lda #<irq
            sta $0314
            lda $dc0d
            cli

            jmp *
;-------------------------------------------------------------------------------
irq:
            lda $d012
            sta @start+1
            lda #1
            sta $d020
            jsr cgplayer_playtick
            lda #0
            sta $d020
            lda $d012
            sec
@start:     sbc #$00

            jmp $ea31

;-------------------------------------------------------------------------------
