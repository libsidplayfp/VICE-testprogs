            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0

;-------------------------------------------------------------------------------

    * = $080d

    sei
    
    ldx #0
    stx $d020
    stx $d021
-
    lda #1
    sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $db00,x
    lda #$20
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    inx
    bne -

    lda #%00000100   ; disable freeze button
    sta $de01
    
lp:    
    lda $de01
    sta $0400
    
    jmp lp
    
