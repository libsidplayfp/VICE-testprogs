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

        lda #$ff
        sta $dc05
        sta $dd05
        
        .if MODE = 0

        ; initial one time delay to timer latch
        lda #$ff
        sta $dc04

        ; clear interrupt flag
        bit $dc0d

        ; allow timer irq
        lda #$81                ; 2
        sta $dc0d               ; 4

        ; copy latch to timer, start timer
        lda #%00010001
        sta $dc0e               ; 4
        
        .endif
        
        .if MODE = 1

        ; initial one time delay to timer latch
        lda #$ff
        sta $dd04
        ; copy latch to timer, dont start yet
        lda #%00010000
        sta $dd0e

        ; clear interrupt flag
        bit $dd0d

        ; allow timer irq
        lda #$81                ; 2
        sta $dd0d               ; 4

        ; dont copy latch, start timer
        lda #%00000001
        sta $dd0e               ; 4
        
        .endif

        ; irq can not trigger in the instruction following the CLI, so do it now
        cli                     ; 2
        inc $03e4               ; 5

mlp:
        inc $03e5               ; 5

        .byte $02   ; JAM
        
        ; if we ever come here, something is seriously wrong
        lda #2
        sta $d020
        lda #$ff
        sta $d7ff
        jmp mlp

irq:
        pha
        lda #2
        sta $d020
        inc $03e6
        lda #$ff
        sta $d7ff
        bit $dc0d
        pla
        rti

nmi:
        pha
        lda #2
        sta $d020
        inc $03e7
        lda #$ff
        sta $d7ff
        bit $dd0d
        pla
        rti
