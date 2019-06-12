    .macpack longbranch
    .export Start

Start:
        sei
        ldx #0
clp:
        lda #1
        sta $d800,x
        sta $d900,x
        sta $da00,x
        sta $db00,x

        lda #0
        sta $0000,x
        sta $0100,x
        sta $0200,x
        sta $0300,x
        inx
        bne clp

        lda #$2f
        sta $00
        lda #$35
        sta $01

        lda #5
        sta $d020
        lda #$05
        sta $d018

        lda #>irq
        sta $ffff
        lda #<irq
        sta $fffe

        lda #>nmi
        sta $fffb
        lda #<nmi
        sta $fffa

        ; disallow timer irqs
        lda #$7f
        sta $dc0d
        sta $dd0d
        ; stop timers
        lda #0
        sta $dc0e
        sta $dd0e
        ; clear interrupt flag
        bit $dc0d
        bit $dd0d

        lda #0
        sta $dc05
        sta $dd05
        ; initial one time delay to timer latch
        lda #9-3
        sta $dc04
        lda #5-3
        sta $dd04
        ; copy latch to timer, dont start yet
        lda #%00010000
        sta $dc0e
        lda #%00010000
        sta $dd0e

        ; continues delay to timer latch
        lda #0
        sta $dc04
        sta $dd04

        ; clear interrupt flag
        bit $dc0d
        bit $dd0d

        ; allow timer irq
        lda #$81                ; 2
        sta $dc0d               ; 4
        sta $dd0d               ; 4

        ; irq can not trigger in the instruction following the CLI, so do it now
        cli                     ; 2

        ; dont copy latch, start timer
        lda #%00000001
        sta $dc0e               ; 4
        sta $dd0e               ; 4

        ; both irq and nmi trigger during the next instruction...
        inc $03e4               ; 5
        ; ... so we do never come here
mlp:
        inc $03e5               ; 5

        ; if we ever come here, something is seriously wrong
        lda #2
        sta $d020
        lda #$ff
        sta $d7ff
        jmp mlp

        ; we do not ack the irq, it will keep triggering
irq:
;        lda $dc0d
        inc $03e6
        rti

        ; we do not ack the nmi
nmi:
;        lda $dd0d
        inc $03e7
        jmp *
