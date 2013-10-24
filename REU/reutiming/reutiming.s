        .export Start

Start:
        sei

        LDX #$00
        stx $d020
        stx $d021
l240A:
        LDA #$20
        STA $0400,X
        STA $0500,X
        STA $0600,X
        STA $0700,X
        LDA #$01
        STA $D800,X
        STA $D900,X
        STA $DA00,X
        STA $DB00,X
        INX
        BNE l240A

        lda #$ff
        sta $dc04
        sta $dc05

        ; setup reu regs, start transfer ($10 bytes to $0400)
        lda #$00 ; addr ctrl
        sta $df0a
        lda #$00 ; irq mask
        sta $df09
        lda #$00 
        sta $df08
        lda #$10 ; transfer len lo 
        sta $df07
        lda #$00 ; reu addr
        sta $df06
        sta $df05
        sta $df04
        lda #>$0400 ; c64 addr hi
        sta $df03
        lda #<$0400 ; c64 addr lo
        sta $df02

        lda #%00010001  ; start timer
        sta $dc0e

        lda #$91        ; 2     cmd (exec immediatly reu->c64)
        sta $df01       ; 4

        lda $dc04       ; 4
        pha
        tax
        and #$0f
        tay
        lda hextab,y
        sta $0400 + 40 + 5
        txa
        lsr
        lsr
        lsr
        lsr
        tay
        lda hextab,y
        sta $0400 + 40 + 4

        pla
        sta $0400 + 40
        cmp #$ff - ($10 + 7)    ; $e8
        beq allok

        lda #2
        sta $d020
        jmp *

allok:
        lda #5
        sta $d020
        jmp *

hextab:
        .byte "0123456789"
        .byte 1,2,3,4,5,6
