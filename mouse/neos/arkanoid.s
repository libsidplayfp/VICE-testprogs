
; this code was extracted from arkanoid and serves as a literal reference - 
; DONT CHANGE!

i0940: !byte 0      ; player 1 or 2


iFE33:  !byte $80, $40, $20, $10, $08, $04, $02 ,$01

        !byte $28 ,$0a ,$3c ,$0a, $14, $02, $20, $40
        !byte $ae ,$38 ,$09 ,$f0, $08

readmouse:  ; fe48

    LDA i0940
    BEQ iFE50

    LDX #$00
iFE50 = * + 1
    BIT $01A2      ; LDX #$01

    LDA #$10
    STA $DC02,X    ; fire (strobe) = output

    LDA $DC00,X
    AND #%00101111 ; $2F (?)
    ORA iFE33,X    ; $80 or $40 (WTH?)
    STA $DC00,X    ; strobe = 0

    LDY #$08
    JSR iFEC9      ; delay

    LDA $DC00,X    ; XH
    ASL  
    ASL  
    ASL  
    ASL  
    STA iFEDF

    LDA $DC00,X    ; strobe = 1
    ORA #$10
    STA $DC00,X

    LDY #$01
    JSR iFEC9      ; delay

    LDA $DC00,X    ; XL
    AND #$0F
    ORA iFEDF
    TAX            ; WTF? (x-delta in X)
    
    ; from here on X contains bogus values ($00-$ff)

    LDA $DC00,X    ; strobe = 0
    AND #$EF
    STA $DC00,X

    LDY #$01
    JSR iFEC9      ; delay

    LDA $DC00,X    ; YH
    ASL  
    ASL  
    ASL  
    ASL  
    STA iFEDF

    LDA $DC00,X    ; strobe = 1
    ORA #$10
    STA $DC00,X

    LDY #$01
    JSR iFEC9      ; delay

    LDA $DC00,X    ; YL
    AND #$0F
    ORA iFEDF
    TAY            ; Y-delta in Y

    LDA #$00
    STA $DC00,X
    STA $DC02,X

    LDA $D419      ; check mouse button
    CMP #$FF
    BEQ iFEC6
    LDA #$00
iFEC6 = * + 1
    BIT $01A9  ; LDA #1
    RTS

iFEC9:
    NOP            ; delay routine
    DEY
    BNE iFEC9
    RTS

iFEDF:  !byte 0 ; temp
