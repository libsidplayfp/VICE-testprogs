
line=60
delay=21

* = $1201
!word nextline
!byte $E5 ,$07 ,$9E ,$20 ,$38 ,$35 ,$38 ,$34
!byte 0
nextline:
!word 0

!binary "bitmap7a.prg"

* = $2188

Start:
    CLC
    LDA #$10
    TAY
-
    STA $0FF0,Y
    ADC #$0C
    BCC +
    SBC #$EF
+
    INY
    BNE -

    LDY #$05
-
    CLC
    LDA $EDE4,Y
    ADC i21FA,Y
    STA $9000,Y
    DEY
    BPL -

    LDA $900E
    AND #$0F
    ORA $120E
    STA $900E
    LDA $120F
    STA $900F

    LDA #<$1210
    STA $FB
    LDA #>$1210
    STA $FC
    LDA #<$1100
    STA $FD
    LDA #>$1100
    STA $FE

    LDX #$0F
    LDY #$00
-
    LDA ($FB),Y
    STA ($FD),Y
    INY
    BNE -

    INC $FC
    INC $FE
    DEX
    BNE -

    LDX #$00
    LDY #$00
-
    LDA $2110,X
    INX
    STA $9400,Y
    INY
    LSR
    LSR
    LSR
    LSR
    STA $9400,Y
    INY
    CPY #$F0
    BNE -
-
    JSR $FFE4
    BEQ -
    JMP Main

i21FA:
    !byte $02, $fe, $fe, $eb, $00, $0c


* = $2200

Main:
 SEI
 LDA $9000
 ORA #$80
 STA $9000
Main_00:
 LDY #line
Main_01:
 CPY $9004
 BNE Main_01
 INY
 INY
Main_02:
 CPY $9004
 BNE Main_02
 JSR Main_09
 INY
 CPY $9004
 BEQ Main_03
 NOP
 NOP
Main_03:
 JSR Main_09
 NOP
 INY
 CPY $9004
 BEQ Main_04
 BIT $24
Main_04:
 JSR Main_09
 NOP
 INY
 CPY $9004
 BNE Main_05
Main_05:
 LDX #23
Main_06:
 DEX
 BNE Main_06
 NOP
 LDX #$20
Main_07:
 LDA #$5B
 LDY #$1B
 STA $900F
 STY $900F
 LDY #9
Main_08:
 DEY
 BNE Main_08
 NOP
 DEX
 BNE Main_07
 JMP Main_00
Main_09:
 LDX #delay
Main_10:
 DEX
 BNE Main_10
 RTS
