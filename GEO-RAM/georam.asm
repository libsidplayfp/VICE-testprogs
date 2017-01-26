!if TARGET = 0  {
        basicstart = $0801   ; C64
        georamdata = $de00
        georampage = $dffe
        georamblock = $dfff
        debugreg = $d7ff
}
!if TARGET = 1  {
        basicstart = $1c01   ; C128
        georamdata = $de00
        georampage = $dffe
        georamblock = $dfff
        debugreg = $d7ff
}
!if TARGET = 2  {
        basicstart = $1201   ; VIC20 (+8k)
        georamdata = $9800
        georampage = $9ffe
        georamblock = $9fff
        debugreg = $910f
}

        * = basicstart
        !binary "georam.prg",,2

        * = basicstart + $00ff
    LDX georamdata
    CPX georamdata
    BNE l094D
    INC georamdata
    CPX georamdata
    BEQ l094D
    LDX #$00
    STX georampage
    STX georamblock
    STX georamdata
    INX
    STX georampage
    STX georamdata
    INX
    STX georamblock
    STX georamdata
    LDX #$00
    STX georampage
    STX georamblock
    CPX georamdata
    BNE l094D
    INX
    STX georampage
    CPX georamdata
    BNE l094D
    INX
    STX georamblock
    CPX georamdata
    BNE l094D
    LDX #$01
    STX $90
    RTS
l094D:
    LDX #$00
    STX $90
    
!if TESTBENCH = 1 {
    lda #$ff
    sta debugreg
}
    RTS

        * = basicstart + $01ff

!if TARGET != 2  {
        
    LDA #$04
    JSR l0A59
    CPY georamdata
    BEQ l0A40
    LDA #$08
    JSR l0A59
    CPY georamdata
    BEQ l0A44
    LDA #$10
    JSR l0A59
    CPY georamdata
    BEQ l0A48
    LDA #$20
    JSR l0A59
    CPY georamdata
    BEQ l0A4C
    LDA #$40
    JSR l0A59
    CPY georamdata
    BEQ l0A50
    LDA #$80
    JSR l0A59
    CPY georamdata
    BEQ l0A54
    LDX #$40
    BNE l0A56
l0A40:
    LDX #$01
    BNE l0A56
l0A44:
    LDX #$02
    BNE l0A56
l0A48:
    LDX #$04
    BNE l0A56
l0A4C:
    LDX #$08
    BNE l0A56
l0A50:
    LDX #$10
    BNE l0A56
l0A54:
    LDX #$20
l0A56:
    STX $90
    
!if TESTBENCH = 1 {
    lda #$00
    sta debugreg
}
    
    RTS
l0A59:
    LDX #$00
    STX georampage
    STX georamblock
    LDY georamdata
    INY
    STA georamblock
    STY georamdata
    LDX #$00
    STX georamblock
    RTS

}

!if TARGET = 2  {
    jmp l122D
l1200:
    LDX #$00
    STX georampage
    STX georamblock
    LDY georamdata
    INY
    STA georamblock
    STY georamdata
    LDX #$00
    STX georamblock
    CMP #$04
    BEQ l1231
    CMP #$08
    BEQ l123A
    CMP #$10
    BEQ l1243
    CMP #$20
    BEQ l124C
    CMP #$40
    BEQ l1255
    BNE l125E
l122D:
    LDA #$04
    BNE l1200
l1231:
    CPY georamdata
    BEQ l1267
    LDA #$08
    BNE l1200
l123A:
    CPY georamdata
    BEQ l126B
    LDA #$10
    BNE l1200
l1243:
    CPY georamdata
    BEQ l126F
    LDA #$20
    BNE l1200
l124C:
    CPY georamdata
    BEQ l1273
    LDA #$40
    BNE l1200
l1255:
    CPY georamdata
    BEQ l1277
    LDA #$80
    BNE l1200
l125E:
    CPY georamdata
    BEQ l127B
    LDX #$40
    BNE l127D
l1267:
    LDX #$01
    BNE l127D
l126B:
    LDX #$02
    BNE l127D
l126F:
    LDX #$04
    BNE l127D
l1273:
    LDX #$08
    BNE l127D
l1277:
    LDX #$10
    BNE l127D
l127B:
    LDX #$20
l127D:

!if TESTBENCH = 1 {
    lda #$00
    sta debugreg
}

    STX $90
    RTS

}
