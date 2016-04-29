; freezer detection/cartridge check from original Platoon tape
; checks if the memory at $1000-$10ff is filled with the same value
;
; thanks to Ian Coog for finding this routine

            *=$0801
            ; BASIC stub: "1 SYS 2061"
            !byte $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00
            jmp start

start:
            jsr platoontest
            jmp *

            * = $0a80
platoontest:

            LDA #<$1000
            STA $FD
            LDA #>$1000
            STA $FE

i0A88:
            LDY #$00
            LDA ($FD),Y
            STA i0B16
            INY
            CMP ($FD),Y
            BNE i0AC3
            INY
            CMP ($FD),Y
            BNE i0AC3
            INY
            CMP ($FD),Y
            BNE i0AC3
            INY
            CMP ($FD),Y
            BNE i0AC3

            LDA #<$1000
            STA $FD
            LDA #>$1000
            STA $FE

            LDY #$00
i0AAD:
            LDA ($FD),Y
            CMP i0B16
            BEQ i0ABA
            INY
            BNE i0AAD
            JMP i0ADB
i0ABA:
            INC i0B17
            INY
            BNE i0AAD
            JMP i0ADB
i0AC3:
            LDA $FD
            CMP #<$1100
            BNE i0AD2
            LDA $FE
            CMP #>$1100
            BNE i0AD2
            JMP i0AE2
i0AD2:
            INC $FD
            BNE i0AD8
            INC $FE
i0AD8:
            JMP i0A88
i0ADB:
            LDA i0B17
            CMP #$8C
            BCS i0AE3
i0AE2:
            ; test passed
            lda #5
            sta $d020
            lda #$00
            sta $d7ff
            RTS

i0AE3:
            ; test failed
            lda #10
            sta $d020
            lda #$ff
            sta $d7ff
            rts
;.C:0ae3  A2 00       LDX #$00
;.C:0ae5  8A          TXA
;.C:0ae6  9D 00 08    STA $0800,X
;.C:0ae9  9D 00 02    STA $0200,X
;.C:0aec  9D 00 03    STA $0300,X
;.C:0aef  8D 30 0A    STA $0A30
;.C:0af2  8D 31 0A    STA $0A31
;.C:0af5  8D 20 D0    STA $D020
;.C:0af8  8D 21 D0    STA $D021
;.C:0afb  E8          INX
;.C:0afc  D0 E8       BNE $0AE6
;.C:0afe  A2 62       LDX #$62
;.C:0b00  9D 80 0A    STA $0A80,X
;.C:0b03  CA          DEX
;.C:0b04  10 FA       BPL $0B00
;.C:0b06  78          SEI
;.C:0b07  A9 23       LDA #$23
;.C:0b09  85 01       STA $01
;.C:0b0b  A9 00       LDA #$00
;.C:0b0d  8D 20 D0    STA $D020
;.C:0b10  8D 21 D0    STA $D021
;.C:0b13  4C 13 0B    JMP $0B13

i0B16:  !byte $00
i0B17:  !byte $ff
