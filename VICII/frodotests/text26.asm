
        *=$0801
        ; BASIC stub: "1 SYS 2061"
        !byte $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00
        jmp entrypoint

        *=$0900
entrypoint:

        SEI
        LDA $DC0D
        AND #$7F
        ORA #$01
        STA $DC0D
        LDA #$F8
        STA $D012
        LDA $D011
        AND #$7F
        STA $D011
        LDA #$81
        STA $D01A
        LDA #<irq
        STA $0314
        LDA #>irq
        STA $0315
        CLI
        RTS
irq:
        LDA $D019
        STA $D019
        LDA $D012
        CMP #$F8
        BEQ lastline
        CMP #$F3
        BEQ firstline
        LDA #$18
        STA $D011
        LDA #$14
        STA $D018
        LDA #$F3
        BNE skp
firstline:
        LDA #$1F
        STA $D011
        LDA #$04
        STA $D018
        LDA #$F8
skp:
        STA $D012
        JMP $FEBC
lastline:
        LDA #$10
        STA $D011
        LDA #$28
        STA $D012
        JMP $EA31
 
