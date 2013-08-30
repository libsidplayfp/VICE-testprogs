
        .macpack cbm

        .export _main

_main:

        sei
        lda #$35
        sta $01

        lda #0
        sta $d020
        lda #10
        sta $d021

        ldx #0
@lp4:
        lda screen,x
        sta $0400,x
        lda #1
        sta $d800,x
        sta $d900,x
        lda screen+$0100,x
        sta $0500,x
        lda #$20
        sta $0600,x
        sta $0700,x
        inx
        bne @lp4

        ldx #0
@lp4a:
        lda #$a0
        sta $0400 + (0*40),x
        sta $0400 + (4*40),x 
        lda #$7
        sta $d800 + (0*40),x
        lda #$5
        sta $d800 + (4*40),x
        inx
        cpx #40
        bne @lp4a

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
        lda #$08
        sta $d012
        lda #$9b
        sta $d011

        lda #$7f
        sta $dc0d


        lda #$10
        sta $dd0e
        lda #< (((63*312) / 2) - 1)
        sta $dd04
        lda #> (((63*312) / 2) - 1)
        sta $dd05

@lp2c:   lda $d011
        and #$80
        beq @lp2c

@lp2d:   lda $d011
        and #$80
        bne @lp2d

        lda #$32
@lp:
        cmp $d012
        bne @lp

        lda #$11
        sta $dd0e




        lda #$10
        sta $dc0e
        lda #< (((63*312) / 4) - 1)
        sta $dc04
        lda #> (((63*312) / 4) - 1)
        sta $dc05

@lp2a:  lda $d011
        and #$80
        beq @lp2a

@lp2b:  lda $d011
        and #$80
        bne @lp2b

        lda #$52
@lp1:
        cmp $d012
        bne @lp1

        lda #$11
        sta $dc0e

        lda #$81
        sta $dd0d
        sta $dc0d

        lda $dd0d
        lda $dc0d
        cli
        jmp @ml

        .align 256
@ml:
        inc $0400 + (40*1) + 5

        lda $dc0e
        sta $0400 + (40*2) + 30
        lda $dc0f
        sta $0400 + (40*2) + 31
        lda $dc04
        sta $0400 + (40*2) + 32
        lda $dc05
        sta $0400 + (40*2) + 33
        lda $dc06
        sta $0400 + (40*2) + 34
        lda $dc07
        sta $0400 + (40*2) + 35

        lda $dd0e
        sta $0400 + (40*3) + 30
        lda $dd0f
        sta $0400 + (40*3) + 31
        lda $dd04
        sta $0400 + (40*3) + 32
        lda $dd05
        sta $0400 + (40*3) + 33
        lda $dd06
        sta $0400 + (40*3) + 34
        lda $dd07
        sta $0400 + (40*3) + 35

        inc $d021

        ldx #$44
@lp2q:
        dex
        bne @lp2q

        inc $d021

        ldx #100-40
@lp2w:
        dex
        bne @lp2w

        dec $d021
        bit $ea

        ldx #100
@lp2e:
        dex
        bne @lp2e

        dec $d021

        ldx #100 + 3
@lp2x:
        dex
        bne @lp2x

@cont:   lda #0
        and #$07
        tax
        lda delaytab1,x
        sta @delay
        lda delaytab1+1,x
        sta @delay+1

        inc @cont+1
        inc @cont+1

        nop
        nop
;        nop

@delay:  nop
        nop

        jmp @ml

delaytab1:
        nop
        nop

        bit $ea
        bit $ea
        bit $ea
        bit $ea
        nop
        nop

        bit $ea
        nop
        nop

;        bit $ea
        nop
        nop

screen:          ;1234567890123456789012345678901234567890
        scrcode "                                        "
        scrcode "main 0                                  "
        scrcode "irq  0 unhandled: 0                     "
        scrcode "nmi  0 unhandled: 0                     "
        scrcode "                                        "
        scrcode "                                        "
        scrcode "red:raster irq grn:cia1 irq yel:cia2 irq"
        scrcode "                                        "
        scrcode "background pattern is 'metastable' and  "
        scrcode "will move when the timing is disturbed  "
        scrcode "by unhandled irq/nmi or non cycle exact "
        scrcode "restart after freezing.                 "
        scrcode "                                        "
        scrcode "                                        "
        scrcode "                                        "
        scrcode "                                        "
        scrcode "                                        "

        .align 256
;-------------------------------------------------------------------------------

irq:
        inc $0400 + (40*2) + 5
        pha
        txa
        pha

        lda $d019
        bpl @notvic
        sta $d019

        lda #2
        sta $d020

        ldx #100
@lp2a:
        dex
        bne @lp2a

        lda #0
        sta $d020

        pla
        tax
        pla
        rti

@notvic:
        lda $dc0d
        bpl @notcia1

        lda #5
        sta $d020

        ldx #100
@lp2b:
        dex
        bne @lp2b

        lda #0
        sta $d020

        pla
        tax
        pla
        rti

@notcia1:
        inc $0400 + (40*2) + 18

        pla
        tax
        pla
        rti

        .align 256
;-------------------------------------------------------------------------------

nmi:
        inc $0400 + (40*3) + 5

        pha
        txa
        pha

        lda $dd0d
        bpl @notcia2

        lda #7
        sta $d020

        ldx #100
@lp2:
        dex
        bne @lp2

        lda #0
        sta $d020

        pla
        tax
        pla
        rti

@notcia2:
        inc $0400 + (40*3) + 18

        pla
        tax
        pla
        rti
