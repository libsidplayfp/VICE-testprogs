
v15CF = $0400
v175E = $0401

pattern2B0C = $050C
pattern2B1C = $051C

v2B0C = $050C
v2B1C = $051C
v2B24 = $0524
v2B2C = $052C
v2B2D = $052D

;-------------------------------------------------------------------------------

    * = $0801
    !byte $0c, $08, $00, $00, $9e, $20, $34, $30, $39, $36
    !byte 0,0,0

;-------------------------------------------------------------------------------

    * = $1000

    lda #$20
-
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    inx
    bne -

    lda #$01
    sta $DF00
    lda $DF00
    sta $0400 + 2

    lda #$02
    sta $DF02
    lda $DF02
    sta $0400 + 3

    jmp wheelsdetect

iC25Fa:
    lda #10
    sta $d020
    lda #$ff    ; failure
    sta $d7ff
    jmp *
iC25Fb:
    lda #5
    sta $d020
    lda #0      ; success
    sta $d7ff
    jmp *

;-------------------------------------------------------------------------------

wheelsdetect:
    LDA #$00            ;:1d27  A9 00       LDA #$00
    STA v2B2D           ;:1d29  8D 2D 2B    STA v2B2D
    LDA #$02            ;:1d2c  A9 02       LDA #$02
    STA v2B2C           ;:1d2e  8D 2C 2B    STA v2B2C

    LDA $DF00           ;:1d31  AD 00 DF    LDA $DF00
    AND #$10            ;:1d34  29 10       AND #$10
    BEQ i1D3D           ;:1d36  F0 05       BEQ $1D3D
    LDA #$20            ;:1d38  A9 20       LDA #$20
    STA v2B2C           ;:1d3a  8D 2C 2B    STA v2B2C
i1D3D:
    LDA $DF00           ;:1d3d  AD 00 DF    LDA $DF00
    AND #$E0            ;:1d40  29 E0       AND #$E0
    BNE i1D5E           ;:1d42  D0 1A       BNE $1D5E

    LDX $DF02           ;:1d44  AE 02 DF    LDX $DF02
    LDA #$55            ;:1d47  A9 55       LDA #$55
    STA $DF02           ;:1d49  8D 02 DF    STA $DF02
    CMP $DF02           ;:1d4c  CD 02 DF    CMP $DF02
    BNE i1D5B           ;:1d4f  D0 0A       BNE $1D5B
    LDA #$AA            ;:1d51  A9 AA       LDA #$AA
    STA $DF02           ;:1d53  8D 02 DF    STA $DF02
    CMP $DF02           ;:1d56  CD 02 DF    CMP $DF02
    BEQ i1D66      ; register at $DF02     ;:1d59  F0 0B       BEQ $1D66

    ; restore $DF02
i1D5B:
    STX $DF02           ;:1d5b  8E 02 DF    STX $DF02
i1D5E:
    LDA #$00            ;:1d5e  A9 00       LDA #$00
    STA v15CF           ;:1d60  8D CF 15    STA v15CF
    JMP iC25Fa           ;:1d63  4C 5F C2    JMP $C25F

i1D66:
    LDA #$01            ;:1d66  A9 01       LDA #$01
    STA v2B2D           ;:1d68  8D 2D 2B    STA v2B2D
    LDA #$00            ;:1d6b  A9 00       LDA #$00
    STA $08             ;:1d6d  85 08       STA $08
i1D6F:
    JSR i1D97           ;:1d6f  20 97 1D    JSR $1D97
    BCC i1D84           ; ok :1d72  90 10       BCC $1D84
    ; error
    LDA v2B2D           ;:1d74  AD 2D 2B    LDA v2B2D
    CMP v2B2C           ;:1d77  CD 2C 2B    CMP v2B2C
    BEQ i1D87           ;:1d7a  F0 0B       BEQ $1D87
    INC v2B2D           ;:1d7c  EE 2D 2B    INC v2B2D
    INC $08             ;:1d7f  E6 08       INC $08
    CLV                 ;:1d81  B8          CLV
    BVC i1D6F           ;:1d82  50 EB       BVC $1D6F

i1D84:
    DEC v2B2D           ;:1d84  CE 2D 2B    DEC v2B2D
i1D87:
    LDA v2B2D           ;:1d87  AD 2D 2B    LDA v2B2D
    STA v15CF           ;:1d8a  8D CF 15    STA v15CF
    BEQ i1D94           ;:1d8d  F0 05       BEQ $1D94
    LDA #$18            ;:1d8f  A9 18       LDA #$18
    STA v175E           ;:1d91  8D 5E 17    STA v175E
i1D94:
    JMP iC25Fb           ;:1d94  4C 5F C2    JMP $C25F

;-------------------------------------------------------------------------------

i1D97:
    LDA #>v2B24            ;:1d97  A9 2B       LDA #$2B
    STA $03             ;:1d99  85 03       STA $03
    LDA #<v2B24            ;:1d9b  A9 24       LDA #$24
    STA $02             ;:1d9d  85 02       STA $02
    LDA #$00            ;:1d9f  A9 00       LDA #$00
    STA $04             ;:1da1  85 04       STA $04
    STA $05             ;:1da3  85 05       STA $05
    LDA #$00            ;:1da5  A9 00       LDA #$00
    STA $07             ;:1da7  85 07       STA $07
    LDA #$08            ;:1da9  A9 08       LDA #$08
    STA $06             ;:1dab  85 06       STA $06
    JSR i1E08           ;:1dad  20 08 1E    JSR $1E08

    LDA #>pattern1E00            ;:1db0  A9 1E       LDA #$1E
    STA $03             ;:1db2  85 03       STA $03
    LDA #<pattern1E00            ;:1db4  A9 00       LDA #$00
    STA $02             ;:1db6  85 02       STA $02
    JSR i1E0B           ;:1db8  20 0B 1E    JSR $1E0B

    LDA #>v2B0C            ;:1dbb  A9 2B       LDA #$2B
    STA $03             ;:1dbd  85 03       STA $03
    LDA #<v2B0C            ;:1dbf  A9 0C       LDA #$0C
    STA $02             ;:1dc1  85 02       STA $02
    JSR i1E08           ;:1dc3  20 08 1E    JSR $1E08

    LDA $08             ;:1dc6  A5 08       LDA $08
    PHA                 ;:1dc8  48          PHA
    LDA #$00            ;:1dc9  A9 00       LDA #$00
    STA $08             ;:1dcb  85 08       STA $08
    LDA #>v2B1C            ;:1dcd  A9 2B       LDA #$2B
    STA $03             ;:1dcf  85 03       STA $03
    LDA #<v2B1C            ;:1dd1  A9 1C       LDA #$1C
    STA $02             ;:1dd3  85 02       STA $02
    JSR i1E08           ;:1dd5  20 08 1E    JSR $1E08

    PLA                 ;:1dd8  68          PLA
    STA $08             ;:1dd9  85 08       STA $08
    LDA #>v2B24            ;:1ddb  A9 2B       LDA #$2B
    STA $03             ;:1ddd  85 03       STA $03
    LDA #<v2B24            ;:1ddf  A9 24       LDA #$24
    STA $02             ;:1de1  85 02       STA $02
    JSR i1E0B           ;:1de3  20 0B 1E    JSR $1E0B

    LDY #$07            ;:1de6  A0 07       LDY #$07
i1DE8:
    LDA pattern1E00,Y         ;:1de8  B9 00 1E    LDA $1E00,Y
    CMP pattern2B0C,Y         ;:1deb  D9 0C 2B    CMP pattern2B0C,Y
    BNE i1DFE           ;:1dee  D0 0E       BNE $1DFE
    LDX $08             ;:1df0  A6 08       LDX $08
    BEQ i1DF9           ;:1df2  F0 05       BEQ $1DF9
    CMP pattern2B1C,Y         ;:1df4  D9 1C 2B    CMP pattern2B1C,Y
    BEQ i1DFE           ;:1df7  F0 05       BEQ $1DFE
i1DF9:
    DEY                 ;:1df9  88          DEY
    BPL i1DE8           ;:1dfa  10 EC       BPL $1DE8
    SEC                 ;:1dfc  38          SEC
    RTS                 ;:1dfd  60          RTS
i1DFE:
    CLC                 ;:1dfe  18          CLC
    RTS                 ;:1dff  60          RTS

;-------------------------------------------------------------------------------

pattern1E00:
    !byte $52, $41, $4d, $43, $68, $65, $63, $6b, $a0, $91, $2c, $a0   ;RAMCheck

;-------------------------------------------------------------------------------

i1E08:
    LDY #$91            ;:1e08  A0 91       LDY #$91
i1E0B = * + 1
    BIT $90A0           ;:1e0a  2C A0 90    BIT $90A0
    LDA $03             ;:1e0d  A5 03       LDA $03
    STA $DF03           ;:1e0f  8D 03 DF    STA $DF03
    LDA $02             ;:1e12  A5 02       LDA $02
    STA $DF02           ;:1e14  8D 02 DF    STA $DF02
    LDA $05             ;:1e17  A5 05       LDA $05
    STA $DF05           ;:1e19  8D 05 DF    STA $DF05
    LDA $04             ;:1e1c  A5 04       LDA $04
    STA $DF04           ;:1e1e  8D 04 DF    STA $DF04
    LDA $08             ;:1e21  A5 08       LDA $08
    STA $DF06           ;:1e23  8D 06 DF    STA $DF06
    LDA $07             ;:1e26  A5 07       LDA $07
    STA $DF08           ;:1e28  8D 08 DF    STA $DF08
    LDA $06             ;:1e2b  A5 06       LDA $06
    STA $DF07           ;:1e2d  8D 07 DF    STA $DF07
    LDA #$00            ;:1e30  A9 00       LDA #$00
    STA $DF09           ;:1e32  8D 09 DF    STA $DF09
    STA $DF0A           ;:1e35  8D 0A DF    STA $DF0A
    STY $DF01           ;:1e38  8C 01 DF    STY $DF01
    RTS                 ;:1e3b  60          RTS

