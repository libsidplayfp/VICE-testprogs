l249A = $0400

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

        ldx #0
@lp1:
        lda l24AA,x
        sta $0428,x
        inx
        cpx #$10
        bne @lp1

        LDY #$03
l2425:
        STY l249A

        ; setup reu regs, start transfer ($10 bytes to test buffer)
        LDX #$0A
l242A:
        LDA l2490-1,X
        STA $DF00,X
        DEX
        BNE l242A

        CPY l249A
        BNE l2442 ; reu found !
        DEY
        BNE l2425

        ; ram expansion unit (reu) not found!
        lda #2
        sta $d020

        lda #$ff        ; failure
        sta $d7ff
        RTS

        ; check data
l2442:
        LDX #$0F
l2444:
        LDA l249A,X
        CMP l24AA,X
        BNE l2450 ; data check failed
        DEX
        BPL l2444
        ; reu found, data check ok
        lda #5
        sta $d020
        lda #$00 ; success
        sta $d7ff
        RTS
l2450:
        lda #7
        sta $d020
        lda #$00 ; success
        sta $d7ff
        RTS

    ; reu register values
l2490:
    .byte $91 ; cmd (exec immediatly reu->c64)
    .byte <l249A ; c64 addr lo
    .byte >l249A ; c64 addr hi
    .byte $3f ; reu addr
    .byte $4c ; reu addr
    .byte $01 ; reu addr
;    .byte $00 ; reu addr
;    .byte $00 ; reu addr
;    .byte $00 ; reu addr
    .byte $10 ; transfer len lo 
    .byte $00 
    .byte $00 ; irq mask
    .byte $00 ; addr ctrl

    ; test destination buffer
;l249A:
;    .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00 
    ; reference data (blureu)
l24AA:
    .byte $a0, $38, $8c, $18, $d0, $8d, $11, $d0, $a0, $01, $8c, $28, $d0, $a0, $0f, $8c 

