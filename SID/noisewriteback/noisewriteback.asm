            *=$0801
            ; BASIC stub: "1 SYS 2061"
            !byte $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00
            jmp start

start:
    sei
    lda #$0b
    sta $d011
    lda #>irq
    sta $0315
    lda #<irq
    sta $0314
    lda $d011
    bpl *-3
    lda $d011
    bmi *-3
    jsr $0ff6
    lda $dc0d
    cli
    jmp *

irq:
    inc $d020
    jsr $1003
    dec $d020
    ;lda $dc0d
    jmp $ea31


            * = $0ff6

    LDX #$97
    STX $DC04
    LDX #$19
    STX $DC05

    JMP i1009
    JMP i100D
    JMP i10F0
i1009:                                  ; init
    STA i1010
    RTS
i100D:                                  ; play
    LDX #$00
i1010 = * + 1
    LDY #$00                            ; song nr
    BMI i103C
    TXA
    LDX #$0D
i1016:
    STA i116D,X
    DEX
    BPL i1016

    STA $D40B
    STA $D412
    STA $D415
    STA i103D
    STX i1010
    TAX
    LDA #$11
    STA i117D,X
    LDA #$01
    STA i117E,X
    STA i1180,X
    JMP i115D
i103C:
i103D = * +1
    LDA #$00
    STA $D417
    LDA #$00
    ORA #$0F
    STA $D418
    DEC i117E,X
    BEQ i1058
    BPL i1055
    LDA i117D,X
    STA i117E,X
i1055:
    JMP i10BA
i1058:
    LDA i1170,X
    BNE i1081

    LDY i117B,X
    LDA i11DC,Y
    STA $FC
    LDA i11DF,Y
    STA $FD
    LDY i116D,X
    LDA ($FC),Y
    CMP #$FF
    BCC i1079
    INY
    LDA ($FC),Y
    TAY
    LDA ($FC),Y
i1079:
    STA i117C,X
    INY
    TYA
    STA i116D,X
i1081:
    LDY i1180,X
    LDA i11E8,Y
    STA i118E,X
    LDA i1176,X
    BEQ i10BA
    SEC
    SBC #$60
    STA i117F,X
    LDA #$00
    STA i1176,X
    LDA i11E9,Y
    STA i1178,X
    LDA #$FF
    STA i1181,X
    LDA i11E7,Y
    STA i1177,X
    LDA i11E6,Y
    STA $D406,X
    LDA i11E5,Y
    STA $D405,X
    JMP i115D
i10BA:
    LDY i1177,X
    BEQ i10F0
    LDA i11EA,Y
    BEQ i10C7
    STA i1178,X
i10C7:
    LDA i11EB,Y
    CMP #$FF
    INY
    TYA
    BCC i10D4
    CLC
    LDA i11EF,Y
i10D4:
    STA i1177,X
    LDA i11EE,Y
    BEQ i10F0
    BPL i10E3
    ADC i117F,X
    AND #$7F
i10E3:
    TAY
    LDA i118C,Y
    STA i1185,X
    LDA i11B2,Y
    STA i1186,X
i10F0:
    LDA i117E,X
    CMP i118E,X
    BEQ i10FB
    JMP i1151
i10FB:
    LDY i117C,X
    LDA i11E2,Y
    STA $FC
    LDA i11E4,Y
    STA $FD
    LDY i1170,X
    LDA ($FC),Y
    CMP #$40
    BCC i1125
    CMP #$C0
    BCC i112B
    LDA i1171,X
    BNE i111C
    LDA ($FC),Y
i111C:
    ADC #$00
    STA i1171,X
    BEQ i1148
    BNE i1151
i1125:
    STA i1180,X
    INY
    LDA ($FC),Y
i112B:
    CMP #$BD
    BEQ i1148
    STA i1176,X
    LDA i1180,X
    CMP #$02
    BCS i1167
    LDA #$00
    STA $D406,X
    LDA #$0F
    STA $D405,X
    LDA #$FE
    STA i1181,X
i1148:
    INY
    LDA ($FC),Y
    BEQ i114E
    TYA
i114E:
    STA i1170,X
i1151:
    LDA i1185,X
    STA $D400,X
    LDA i1186,X
    STA $D401,X
i115D:
    LDA i1178,X
    AND i1181,X
    STA $D404,X
    RTS

i1167:
    !byte $c9, $03, $90, $d8, $b0, $db
i116D:
    !byte $00, $00, $00
i1170:
    !byte $00
i1171:
    !byte $00, $00, $00, $00, $00
i1176:
    !byte $00
i1177:
    !byte $00
i1178:
    !byte $00, $00, $00
i117B:
    !byte $00
i117C:
    !byte $00
i117D:
    !byte $00
i117E:
    !byte $00
i117F:
    !byte $00
i1180:
    !byte $01
i1181:
    !byte $fe, $00, $00, $00
i1185:
    !byte $00
i1186:
    !byte $00, $00, $00, $00, $00, $00
i118C:
    !byte $00, $00
i118E:
    !byte $00, $00, $5f, $74, $8a, $a1, $ba, $d4, $f0
    !byte $0e, $2d, $4e, $71, $96, $be, $e8, $14, $43, $74, $a9, $e1
    !byte $1c, $5a, $9c, $e2, $2d, $7c, $cf, $28, $85, $e8, $52, $c1
    !byte $37, $b4, $39
i11B2:
    !byte $c5, $5a, $f7, $9e, $01, $01, $01, $01, $01
    !byte $01, $01, $02, $02, $02, $02, $02, $02, $02, $03, $03, $03
    !byte $03, $03, $04, $04, $04, $04, $05, $05, $05, $06, $06, $06
    !byte $07, $07, $08, $08, $09, $09, $0a, $0a, $0b
i11DC:
    !byte $f5, $f8, $fb
i11DF:
    !byte $11, $11, $11
i11E2:
    !byte $fe, $0c
i11E4:
    !byte $11
i11E5:
    !byte $12
i11E6:
    !byte $00
i11E7:
    !byte $fd
i11E8:
    !byte $01
i11E9:
    !byte $06
i11EA:
    !byte $d9
i11EB:
    !byte $09, $d9, $81
i11EE:
    !byte $00
i11EF:
    !byte $ff, $80, $80, $8c, $80, $02, $00, $ff
    !byte $00, $01, $ff, $00, $01, $ff, $00, $01, $78, $f9, $7b, $f9
    !byte $7d, $f9, $7c, $f9, $73, $f9, $64, $f9, $00, $bd, $fd, $00
