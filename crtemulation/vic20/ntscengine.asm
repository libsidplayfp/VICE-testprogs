    *=$1800

    SEI
    LDX #<irq
    LDY #>irq
    STX $0314
    STY $0315
    LDX #$43
    LDY #$42
    STX $9124
    LDA #$11
-
    CMP $9004
    BNE -
    LDA #$13
-
    CMP $9004
    BNE -
    LDX #$18
-
    DEX
    BNE -
    LDA $9004
    CMP #$14
    BEQ +
    NOP
    NOP
+
    LDX #$17
-
    DEX
    BNE -
    BIT $EA
    LDA $9004
    CMP #$15
    BEQ +
    BIT $2C
+
    LDX #$17
-
    DEX
    BNE -
    NOP
    NOP
    LDA $9004
    CMP #$16
    BNE +
+
    LDX #$07
-
    DEX
    BNE -
    NOP
    BIT $24
    STY $9125
    CLI
    RTS

irq:
    CLD
    SEC
    LDA #$15
    SBC $9124
    CMP #$0A
    BCC +
    JMP $EABF
+
    LSR
    STA i186F
    CLV
    BCC +
+
i186F=*+1
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
i1884=*+1
i1885=*+2
    JMP +
+
i1886:
-
    LDA $1A00,Y
    STX $900F
    TAX
    AND #$F0
    ORA $FB
    STA $900E
    NOP
    STX $900F
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
    LDX #$B7
    LDY #$18
    JMP i18E5
-
    LDA $1C00,Y
    STX $900F
    TAX
    AND #$F0
    ORA $FB
    STA $900E
    NOP
    STX $900F
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
    LDX #<i1886
    LDY #>i1886
i18E5:
    STX i1884
    STY i1885
    PLA
    STA $FB
    JMP $EABF
 
