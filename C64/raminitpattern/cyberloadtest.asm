; The Last Ninja - System 3 - 1987 - Cyberload
;
; provided by john64
:
; Cyberload checks ram for byte repetition most probably to "detect" the Expert
; cartridge. I have checked 4 Cyberload games: The Last Ninja, Bangkok Knights,
; Last Ninja 2 and Back to the Future 3. All 4 games check the same memory area.
; Last Ninja is from 1987 and Back to the Future 3 from 1991 so in those 4 years
; this routine doesn't seem to be altered.
;-------------------------------------------------------------------------------

            *=$0801
            ; BASIC stub: "1 SYS 2061"
            !byte $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00
            jmp start
start:
            sei
            lda #$35
            sta $01

            ldy #$ff
            lda $f379,y
lp:
            cmp $f379,y
            bne passed
            dey
            bne lp

            ; failed
            lda #10
            sta $d020
            lda #$ff
            sta $d7ff
            jmp *
passed:
            ; passed
            lda #5
            sta $d020
            lda #$00
            sta $d7ff
            jmp *

;-------------------------------------------------------------------------------
; The code below is from the original tape version of The Last Ninja with my
; comments added. It's a simple check, if all bytes in the $f379 - $f479 range
; are identical then the test fails. If within that range only one byte is found
; that differs from the others then the test is passed.
;
;.C:0056 A9 91           LDA #$91
;.C:0058 8D 0E DD        STA $DD0E
;.C:005b 8D 0F DD        STA $DD0F
;.C:005e A2 8B           LDX #$8B
;.C:0060 8A              TXA
;.C:0061 29 0F           AND #$0F
;.C:0063 A8              TAY
;.C:0064 5D 72 00        EOR $0072,X
;.C:0067 59 14 03        EOR $0314,Y
;.C:006a 88 DEY
;.C:006b 10 FA           BPL $0067
;.C:006d 9D 72 00        STA $0072,X
;.C:0070 CA              DEX
;.C:0071 D0 ED           BNE $0060
;.C:0073 2E 34 09        ROL $0934
;.C:0076 A9 3E           LDA #$3E
;.C:0078 8D FA FF        STA $FFFA
;.C:007b B9 79 F3        LDA $F379,Y ; Start value Y = #$ff. Check $f379-$f479 for byte repetition. If all bytes are identical then test fails.
;.C:007e D9 79 F3        CMP $F379,Y
;.C:0081 D0 0F           BNE $0092 ; Once a byte has been found that differs from the other bytes within the range then the test is passed.
;.C:0083 88              DEY
;.C:0084 D0 F8           BNE $007E
;.C:0086 99 02 00        STA $0002,Y ; Test failed, mess up memory.
;.C:0089 99 92 00        STA $0092,Y
;.C:008c 99 00 03        STA $0300,Y
;.C:008f C8              INY
;.C:0090 D0 F4           BNE $0086
;.C:0092 A9 1B           LDA #$1B ; Passed the test, continue loading.
;.C:0094 8D 11 D0        STA $D011
;.C:0097 A9 94           LDA #$94
;.C:0099 8D 04 DC        STA $DC04
;.C:009c A9 02           LDA #$02
;.C:009e 8D 05 DC        STA $DC05
;.C:00a1 A9 FF           LDA #$FF
;.C:00a3 48              PHA
;.C:00a4 20 BF 03        JSR $03BF
;.C:00a7 68              PLA
;.C:00a8 2A              ROL A
;.C:00a9 C9 0F           CMP #$0F
;.C:00ab D0 F6           BNE $00A3
;.C:00ad 20 AE 03        JSR $03AE
;.C:00b0 C9 0F           CMP #$0F
;.C:00b2 F0 F9           BEQ $00AD
;.C:00b4 C9 F0           CMP #$F0
;.C:00b6 D0 E9           BNE $00A1
;.C:00b8 A2 00           LDX #$00
;.C:00ba 20 AE 03        JSR $03AE
;.C:00bd 49 56           EOR #$56
;.C:00bf 95 02           STA $02,X
;.C:00c1 E8              INX
;.C:00c2 E0 04           CPX #$04
;.C:00c4 90 F4           BCC $00BA
;.C:00c6 20 AE 03        JSR $03AE
;.C:00c9 49 A4           EOR #$A4
;.C:00cb A0 00           LDY #$00
;.C:00cd 91 02           STA ($02),Y
;.C:00cf E6 02           INC $02
;.C:00d1 D0 02           BNE $00D5
;.C:00d3 E6 03           INC $03
;.C:00d5 A5 04           LDA $04
;.C:00d7 D0 02           BNE $00DB
;.C:00d9 C6 05           DEC $05
;.C:00db C6 04           DEC $04
;.C:00dd A5 04           LDA $04
;.C:00df 05 05           ORA $05
;.C:00e1 D0 E3           BNE $00C6
;.C:00e3 60              RTS
