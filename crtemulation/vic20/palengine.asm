    * = $1800

    SEI
    LDX #<irq
    LDY #>irq
    STX $0314
    STY $0315
    LDX #$86
    LDY #$56
    STX $9124
    LDA #$1E
-
    CMP $9004
    BNE -

    LDA #$20
-
    CMP $9004
    BNE -

    LDX #$18
-
    DEX
    BNE -

    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

    LDA $9004
    CMP #$21
    BEQ +

    NOP
    NOP
+
    LDX #$17
-
    DEX
    BNE -

    BIT $EA
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP

    LDA $9004
    CMP #$22
    BEQ +

    BIT $2C
+
    LDX #$17
-
    DEX
    BNE -
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    LDA $9004
    CMP #$23
    BNE +
+
    LDX #$02
-
    DEX
    BNE -
    NOP
    NOP
    NOP
    STY $9125
    CLI
    RTS
irq:
    CLD
    SEC
    LDA #$58
    SBC $9124
    CMP #$0A
    BCC +
    JMP $EABF
+
    LSR
    STA $1881
    CLV
    BCC +
+
    BVC +
    NOP
    NOP
    NOP
    NOP
+
    LDA $FB
    PHA
    LDA $900E
    AND #$0F
    STA $FB
    LDX $900F
    LDY #$00
i1896=*+1
i1897=*+2
    JMP +
+
i1898:
-
    LDA $1A00,Y
    STX $900F
    TAX
    AND #$F0
    ORA $FB
    STA $900E
    NOP
    STX $900F
    NOP
    NOP
    NOP
    LDA $1B00,Y
    STA $900F
    BIT $EA
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    INY
    CPY #$C1
    BCC -

    LDX #<i18cc
    LDY #>i18cc
    JMP i18FD
    
i18cc:
-
    LDA $1C00,Y
    STX $900F
    TAX
    AND #$F0
    ORA $FB
    STA $900E
    NOP
    STX $900F
    NOP
    NOP
    NOP
    LDA $1D00,Y
    STA $900F
    BIT $EA
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    NOP
    INY
    CPY #$C1
    BCC -

    LDX #<i1898
    LDY #>i1898
i18FD:
    STX i1896
    STY i1897
    PLA
    STA $FB

    JMP $EABF
 
