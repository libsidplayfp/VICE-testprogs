; dadb.prg - originally written andreas boose(?)

; runs code in the (high nibbles of) the color ram

; when the program is working, the border color can be changed from white to
; black by pressing space

;-------------------------------------------------------------------------------

            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0

;-------------------------------------------------------------------------------

    * = $080d

    SEI
    LDA #$50
    LDX #$04
i0812:
    STA $07F8,X
    DEX
    BPL i0812

    LDA #$60    ; RTS
    STA $07FD
    STA $39FF

    LDA #$40    ; RTI
i0822:
    DEX
    STA $3F00,X
    BNE i0822

    TXA
i0829:
    STA $D900,X
    STA $DA00,X
    STA $DB00,X
    INX
    BNE i0829

    LDA #>$DC41
    STA $41
    LDA #<$DC41
    STA $40

    STA $D011
    STX $D015   ; X=0

    STA $DA8D   ; A=$41 EOR(zp,X)

    ; fill stack with $DA
    LDA #$DA
i0848:
    PHA
    DEX
    BNE i0848

    STA $DB1D   ; A=$DA NOP
    LDY #$08    ; Y=$08 PHP
    STY $DADD

    LDA #$7F
    STA $DC0D,X      ; X=0
    STX $D01A
    STA $D019
                     ; Y=8, X=0
i085F:
    LDA i0889 - 8,Y
    STA $3F60,X
    AND #$0F
    BEQ i0873

    CLC
    STA $60
    TXA
    ADC $60
    TAX
    INY
    BNE i085F

i0873:
    LDA #$90        ; A=$90 BCC
    STA $3FFF

    LDA $D011
i087B:
    CMP $D011
    BEQ i087B

    LDY #<$D010
    STY $60
    LDA #>$D010
    STA $61

    RTI             ; continues at DADA (=RTS)

i0889:
    !byte $61 ; 00
    !byte $92 ; 01
    !byte $b1 ; 03
    !byte $75 ; 04
    !byte $75 ; 09
    !byte $75 ; 0e
    !byte $75 ; 13
    !byte $72 ; 18
    !byte $32 ; 1a
    !byte $b1 ; 1c
    !byte $93 ; 1d
    !byte $92 ; 20
    !byte $50 ; 22
 
 
 
 
