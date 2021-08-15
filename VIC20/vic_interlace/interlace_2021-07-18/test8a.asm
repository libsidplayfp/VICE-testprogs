
* = $1201

!word nextline
!byte $E5, $07, $9E, $20, $38, $39, $36, $30
!byte 0
nextline:
!word 0

* = $1300

!binary "bitmap8a.prg",,2

* = $2300

Init:
 JSR $E518
 LDA #135
 STA $9000
 LDA #23
 STA $9001
 LDA #20
 STA $9002
 LDA #48
 STA $9003
 LDA #107
 STA $900F
 LDA #1
 LDY #0
Init_00:
 STA $9400,Y
 STA $9500,Y
 INY
 BNE Init_00
 JSR Move
 JMP Main

Move:
 LDA #$00
 TAY
 STA $FB
 STA $FD
 LDA #$13
 STA $FC
 LDA #$10
 STA $FE
 LDX #$10
Move_00:
 LDA ($FB),Y
 STA ($FD),Y
 INY
 BNE Move_00
 INC $FC
 INC $FE
 DEX
 BNE Move_00
 RTS

Count262:
 LDX #$00
 LDY #$81
Count262_00:
 CPY $9004
 BNE Count262_00
 INY
 INY
Count262_01:
 CPY $9004
 BNE Count262_01
Count262_02:
 INX
 CPY $9004
 BEQ Count262_02
 CPX #$06
 RTS

Main:
 SEI
Main_00:
 JSR Count262
 BCC Main_01
 BCS Main_02
Main_01:
 LDA #$CC
 STA $9005
 BNE Main_00
Main_02:
 LDA #$EE
 STA $9005
 BNE Main_00
