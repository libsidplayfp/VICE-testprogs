DEBUGREG = $910f        ; http://sleepingelephant.com/ipw-web/bulletin/bb/viewtopic.php?f=2&t=7763&p=84058#p84058

start = $1800
end   = $1800 + 69*256 ; end < $6000
count = $FB
temp  = $FD

register = $9000 + reg

!if option = 1 {
delay_X=27
delay_Y=124
value=$05
}

!if option = 2 {
delay_X=42
delay_Y=161
value=$85
}

!if option = 3 {
delay_X=42
delay_Y=161
value=$85
}

 * = $1201

Stub:
 !word Stub_01
 !word 2021
 !byte $9E
 !byte $20
 !byte $34,$38,$30,$35
 !byte $3A
 !byte $8F
 !byte $20
Stub_00:

namestart:
!if reg = 4 {
 !pet "9004"
} else {
 !pet "9003"
}
!if option = 1 {
 !pet "-nolace"
}
!if option = 2 {
 !pet "lacetop"
}
!if option = 3 {
 !pet "lacebot"
}
nameend:
 !byte 0
Stub_01:
 !word 0

Sync:
 LDY #$7B
Sync_00:
 CPY $9004
 BNE Sync_00
 INY
 INY
Sync_01:
 CPY $9004
 BNE Sync_01
 JSR Sync_05
 INY
 CPY $9004
 BEQ Sync_02
 NOP
 NOP
Sync_02:
 JSR Sync_05
 NOP
 INY
 CPY $9004
 BEQ Sync_03
 BIT $24
Sync_03:
 JSR Sync_05
 NOP
 INY
 CPY $9004
 BNE Sync_04
Sync_04:
 RTS
Sync_05:
 LDX #21
Sync_06:
 DEX
 BNE Sync_06
 RTS

Scan:
 LDA #<start
 STA Scan_01+1
 LDA #>start
 STA Scan_01+2
 LDA #<(end-start-1)
 STA count
 LDA #>(end-start-1)
 STA count+1
Scan_00:
 LDX #$08
 LDY #$1B
 STX $900F
 LDA register
 STY $900F
Scan_01:
 STA $FFFF
 CLC
 LDA Scan_01+1
 ADC #$01
 STA Scan_01+1
 LDA Scan_01+2
 ADC #$00
 STA Scan_01+2
 LDX #delay_X
Scan_02:
 LDY #delay_Y
Scan_03:
 DEY
 BNE Scan_03
 DEX
 BNE Scan_02
 SEC
 LDA count
 SBC #$01
 STA count
 LDA count+1
 SBC #$00
 STA count+1
 BCS Scan_00
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

Wait:
 LDA #$40
Wait_00:
 CMP $9004
 BNE Wait_00
Wait_01:
 CMP $9004
 BEQ Wait_01
 RTS

Main:
 JSR $E518
 LDA #value
 STA $9000
 SEI
 LDA #$7F
 STA $911E
 LDA #10
 STA temp
Main_00:

!if option=1 {
 JSR Wait
}
!if option=2 {
; C=1 on exit, bottom frame "runs", sync. Scan: end of bottom, _full_ top, start of bottom
Main_00a:
 JSR Count262
 BCC Main_00a
}
!if option=3 {
; C=0 on exit, top frame "runs", sync. Scan: end of top, _full_ bottom, start of top
Main_00a:
 JSR Count262
 BCS Main_00a
}

 DEC temp
 BNE Main_00
 JSR Sync
 JSR Scan
 LDA #$82
 STA $911E
 CLI
 JSR $E518
 LDX $BA
 LDY #0
 JSR $FFBA
 LDA #nameend - namestart
 LDX #<Stub_00
 LDY #>Stub_00
 JSR $FFBD
 LDA #<start
 STA $C1
 LDA #>start
 STA $C2
 LDA #$C1
 LDX #<end
 LDY #>end
 JSR $FFD8

 lda #0
 sta DEBUGREG
 rts
