
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

        lda #0
        ldx #0
@l1:
        sta $0400,x
        inx
        bne @l1

        lda #0
        tax
        tay
@ml:
        sta $0428
        stx $0429
        sty $042a

        inc $d020
        jmp @ml

irq:
        inc $0400
        rti

nmi:
        inc $0401
        rti
