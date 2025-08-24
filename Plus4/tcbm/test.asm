
; related to https://sourceforge.net/p/vice-emu/bugs/2160/

BORDERCOLOR = $ff19
SCREENCOLOR = $ff15
DEBUGREG = $fdcf        ; http://plus4world.powweb.com/forum.php?postid=31417#31429

TIA_DRIVE9 = $fec0
TIA_DRIVE8 = $fee0

    * = $1001

    !byte $0C, $10, $E4, $07, $9E, $20, $34, $31, $31, $32, $00     ; 10 SYS 4112
    !byte $00, $00

    *= $1010

    SEI
    LDA #$FC
    STA $FEF4       ; DDRB
    LDA #$FC
    STA $FEF1       ; PB
    AND #$FC
    CMP #$FC
    BNE failure
    LDA #$00
    STA $FEF4       ; DDRB
    LDA $FEF1       ; PB
    AND #$FC
    BNE failure
    LDA #$3F
    STA $FEF5       ; DDRC
    LDA #$3F
    STA $FEF2       ; PC
    LDA $FEF2       ; PC
    AND #$3F
    CMP #$3F
    BNE failure
    LDA #$00
    STA $FEF5       ; DDRC
    LDA $FEF2       ; PC
    AND #$3F
    BNE failure

    ; OK
    LDA #(3 << 4) | 5 ; green
    STA BORDERCOLOR
    lda #$00
    sta DEBUGREG

    JMP $F445 ; exit to monitor

failure:
    ; ERROR
    LDA #(3 << 4) | 2 ; red
    STA BORDERCOLOR
    lda #$ff
    sta DEBUGREG

    JMP $F445 ; exit to monitor
