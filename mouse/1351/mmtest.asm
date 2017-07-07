
        * =  $801
        !byte  $B
        !byte	8
        !byte	0
        !byte	0
        !byte $9E ; û
        !byte $32 ; 2
        !byte $30 ; 0
        !byte $36 ; 6
        !byte $34 ; 4
        !byte	0
        !byte	0
        !byte	0

        * = $0810
        LDA	#$93 ; 'ì'
        JSR	$FFD2
        JSR	print_header
        LDA	#4
        STA	byte_A70
        LDA	#$18
        STA	byte_A71
        LDA	#0
        STA	$33C
        STA	$33D
        JSR	sub_D91
        SEI
!if PORT = 1 {
        LDA	#$40 ; '@'
} else {
        LDA	#$80 ; '@'
}
        STA	$DC00
        LDA	#$C0 ; '¿'
        STA	$DC02

loc_838:
        LDX	#0
        STX	$C004
        LDA	$D419
        STA	$C001
        SEC
        SBC	$C000
        AND	#$7F ; ''
        CMP	#$40 ; '@'
        BCS	loc_853
        LSR
        BEQ	loc_866
        JMP	loc_85C

loc_853:
        EOR	#$7F ; ''
        ADC	#0
        LSR
        BEQ	loc_866
        ORA	#$80 ; 'Ä'

loc_85C:
        TAX
        LDA	$C001
        STA	$C000
        INC	$C004

loc_866:
        LDY	#0
        LDA	$D41A
        STA	$C003
        SEC
        SBC	$C002
        AND	#$7F ; ''
        CMP	#$40 ; '@'
        BCS	loc_880
        LSR
        BEQ	loc_892
        ORA	#$80 ; 'Ä'
        JMP	loc_888

loc_880:
        EOR	#$7F ; ''
        CLC
        ADC	#1
        LSR
        BEQ	loc_892

loc_888:
        TAY
        LDA	$C003
        STA	$C002
        INC	$C004

loc_892:
!if PORT = 1 {
        LDA	$DC01
} else {
        LDA $DC00
}
        AND	#$1F
        CMP	$C005
        BEQ	loc_8A2
        STA	$C005
        JMP	loc_8A9

loc_8A2:
        LDA	#0
        CMP	$C004
        BEQ	loc_838

loc_8A9:
        TYA
        PHA
        TXA
        PHA
        JSR	sub_AF4
        JSR	sub_A74
        LDA	#$20 ; ' '
        JSR	sub_A39
        LDX	#1
        LDA	#1
        BIT	$D010
        BNE	loc_8CE
        DEX
        LDA	$D000
        CMP	#$64 ; 'd'
        BCS	loc_8CE
        LDA	#$20 ; ' '
        JSR	sub_A39

loc_8CE:
        TXA
        LDX	$D000
        JSR	sub_C8A
        LDA	#$20 ; ' '
        JSR	sub_A39
        LDX	#0
        LDA	$D001
        JSR	sub_937
        PLA
        INX
        JSR	sub_937
        PLA
        JSR	sub_937
        DEX
        LDA	$C001
        JSR	sub_937
        LDA	$C003
        JSR	sub_937
        LDA	#$20 ; ' '
        JSR	sub_A39
        JSR	sub_A39
        JSR	sub_A39
        JSR	sub_A39
        JSR	sub_A39
        JSR	sub_91A
        LDA	#$D
        JSR	sub_A39
        JMP	loc_838

        !byte $60 ; `
unk_915:
        !byte	8
        !byte	4
        !byte	1
        !byte	2
        !byte $10

sub_91A:
        LDA	$C005
        STA	$FB
        LDX	#4

loc_921:
        LDA	unk_915,X
        BIT	$FB
        BNE	loc_92D
        LDA	#$2A ; '*'
        JMP	loc_92F

loc_92D:
        LDA	#$2D ; '-'

loc_92F:
        JSR	sub_A39
        DEX
        BPL	loc_921
        RTS

byte_936:
        !byte 0

sub_937:
        CPX	#1
        BEQ	loc_945
        PHA
        LDA	#$20 ; ' '
        JSR	sub_A39
        PLA
        JMP	loc_954

loc_945:
        PHA
        ASL
        BCS	loc_94E
        LDA	#$20 ; ' '
        JSR	sub_A39

loc_94E:
        ROL	byte_936
        PLA
        AND	#$7F ; ''

loc_954:
        PHA
        CMP	#$64 ; 'd'
        BCS	loc_969
        LDA	#$20 ; ' '
        JSR	sub_A39
        PLA
        PHA
        CMP	#$A
        BCS	loc_969
        LDA	#$20 ; ' '
        JSR	sub_A39

loc_969:
        JSR	sub_976
        PLA
        JSR	sub_C17
        LDA	#$20 ; ' '
        JSR	sub_A39
        RTS

sub_976:
        CPX	#1
        BNE	locret_986
        LDA	byte_936
        AND	#1
        BEQ	locret_986
        LDA	#$2D ; '-'
        JSR	sub_A39

locret_986:
        RTS

unk_987:!byte $93 ; ì
!byte $4D ; M
!byte $4F ; O
!byte $55 ; U
!byte $53 ; S
!byte $45 ; E
!byte $20
!byte $54 ; T
!byte $45 ; E
!byte $53 ; S
!byte $54 ; T
!byte $20
!byte $56 ; V
!byte $30 ; 0
!byte $2E ; .
!byte $31 ; 1
!byte $20
!byte $20
!byte $20
!byte $20
!byte $20
!byte $20
!byte $20
!byte $20
!byte $20
!byte $20
!byte $20
!byte $20
!byte $20
!byte $20
!byte $20
!byte $20
!byte $4A ; J
!byte $41 ; A
!byte $43 ; C
!byte $4B ; K
!byte $20
!byte $32 ; 2
!byte $30 ; 0
!byte $30 ; 0
!byte $34 ; 4
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $B2 ; ≤
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $B2 ; ≤
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $B2 ; ≤
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $B2 ; ≤
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $B2 ; ≤
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $B2 ; ≤
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $B2 ; ≤
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $58 ; X
!byte $50 ; P
!byte $4F ; O
!byte $53 ; S
!byte $C2 ; ¬
!byte $59 ; Y
!byte $50 ; P
!byte $4F ; O
!byte $53 ; S
!byte $C2 ; ¬
!byte $58 ; X
!byte $44 ; D
!byte $49 ; I
!byte $46 ; F
!byte $C2 ; ¬
!byte $59 ; Y
!byte $44 ; D
!byte $49 ; I
!byte $46 ; F
!byte $C2 ; ¬
!byte $44 ; D
!byte $34 ; 4
!byte $31 ; 1
!byte $39 ; 9
!byte $C2 ; ¬
!byte $44 ; D
!byte $34 ; 4
!byte $31 ; 1
!byte $41 ; A
!byte $C2 ; ¬
!byte $20
!byte $20
!byte $20
!byte $20
!byte $C2 ; ¬
!byte $4C ; L
!byte $4D ; M
!byte $52 ; R
!byte $55 ; U
!byte $44 ; D
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $B1 ; ±
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $B1 ; ±
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $B1 ; ±
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $B1 ; ±
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $B1 ; ±
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $B1 ; ±
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $B1 ; ±
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `
!byte $60 ; `



print_header:
LDX	#0

loc_A2A:
LDA	unk_987,X
JSR	$FFD2
INX
CPX	#$A1 ; '°'
BNE	loc_A2A
RTS
; End of function print_header

byte_A36:!byte $C0
byte_A37:!byte 7
byte_A38:!byte 0



sub_A39:
PHA
TXA
PHA
TYA
PHA
TSX
LDA	$103,X
CMP	#$D
BNE	loc_A4E
LDA	#0
STA	byte_A38
JMP	loc_A68

loc_A4E:
LDA	byte_A36
STA	$FE
LDA	byte_A37
STA	$FF
LDY	byte_A38
LDA	$103,X
STA	($FE),Y
CPY	#$27 ; '''
BEQ	loc_A68
INY
STY	byte_A38

loc_A68:
PLA
TAY
PLA
TAX
PLA
RTS
; End of function sub_A39

byte_A6E:!byte 0
byte_A6F:!byte 4
byte_A70:!byte 0
byte_A71:!byte 0
byte_A72:!byte 0
byte_A73:!byte 0



sub_A74:
LDY	#$28 ; '('
LDA	byte_A70
JSR	sub_E58
PHA
TXA
CLC
ADC	byte_A6E
STA	$FC
PLA
ADC	byte_A6F
STA	$FD
LDA	$FC
CLC
ADC	#$28 ; '('
STA	$FE
LDA	$FD
ADC	#0
STA	$FF
LDA	byte_A71
JSR	sub_E58
PHA
TXA
CLC
ADC	byte_A6E
STA	byte_A72
PLA
ADC	byte_A6F
STA	byte_A73

loc_AAD:
LDY	#$27 ; '''

loc_AAF:
LDA	($FE),Y
STA	($FC),Y
DEY
BPL	loc_AAF
LDA	$FF
CMP	byte_A73
BNE	loc_AC4
LDA	$FE
CMP	byte_A72
BEQ	loc_AE1

loc_AC4:
LDA	$FC
CLC
ADC	#$28 ; '('
STA	$FC
LDA	$FD
ADC	#0
STA	$FD
LDA	$FE
CLC
ADC	#$28 ; '('
STA	$FE
LDA	$FF
ADC	#0
STA	$FF
JMP	loc_AAD

loc_AE1:
LDY	#$27 ; '''
LDA	#$20 ; ' '

loc_AE5:
STA	($FE),Y
DEY
BPL	loc_AE5
RTS
; End of function sub_A74

!byte	0
!byte	0
!byte	0
!byte $60 ; `
byte_AEF:!byte 0
byte_AF0:!byte 0
byte_AF1:!byte 0
byte_AF2:!byte 0
byte_AF3:!byte 0



sub_AF4:
CLD
LDA	$33C
CMP	#$18
BCC	loc_AFE
LDA	#$17

loc_AFE:
STA	byte_AF0
LDA	#$57 ; 'W'
SEC
SBC	byte_AF0
STA	byte_AF1
LDA	#$18
SEC
SBC	byte_AF0
STA	byte_AF0
LDA	$33D
CMP	#$15
BCC	loc_B1C
LDA	#$14

loc_B1C:
STA	byte_AF2
LDA	#$F9 ; '˘'
SEC
SBC	byte_AF2
STA	byte_AF3
LDA	#$32 ; '2'
SEC
SBC	byte_AF2
STA	byte_AF2
TXA
AND	#$80 ; 'Ä'
BEQ	loc_B4B
TXA
AND	#$7F ; ''
STA	byte_AEF
LDA	$D000
SEC
SBC	byte_AEF
STA	byte_AEF
BCC	loc_B70
JMP	loc_B97

loc_B4B:
TXA
CLC
ADC	$D000
STA	byte_AEF
BCC	loc_B82
LDA	$D010
AND	#1
BEQ	loc_B65
LDA	byte_AF1
STA	byte_AEF
JMP	loc_BAC

loc_B65:
LDA	$D010
ORA	#3
STA	$D010
JMP	loc_B89

loc_B70:
LDA	$D010
AND	#1
BEQ	loc_BA6
LDA	$D010
AND	#$FC ; '¸'
STA	$D010
JMP	loc_BAC

loc_B82:
LDA	$D010
AND	#1
BEQ	loc_BAC

loc_B89:
LDA	byte_AF1
CMP	byte_AEF
BCS	loc_BAC
STA	byte_AEF
JMP	loc_BAC

loc_B97:
LDA	$D010
AND	#1
BNE	loc_BAC
LDA	byte_AEF
CMP	byte_AF0
BCS	loc_BAC

loc_BA6:
LDA	byte_AF0
STA	byte_AEF

loc_BAC:
LDA	byte_AEF
STA	$D000
STA	$D002
TYA
AND	#$80 ; 'Ä'
BEQ	loc_BD4
TYA
AND	#$7F ; ''
STA	byte_AEF
LDA	$D001
SEC
SBC	byte_AEF
BCC	loc_BCE
CMP	byte_AF2
BCS	loc_BE5

loc_BCE:
LDA	byte_AF2
JMP	loc_BE5

loc_BD4:
TYA
CLC
ADC	$D001
BCS	loc_BE2
CMP	byte_AF3
BCC	loc_BE5
BEQ	loc_BE5

loc_BE2:
LDA	byte_AF3

loc_BE5:
STA	$D001
STA	$D003
RTS
; End of function sub_AF4

PHA
PHA
TSX
LSR	$101,X
LSR	$101,X
LSR	$101,X
LSR	$101,X
PLA
CLC
ADC	#$30 ; '0'
CMP	#$3A ; ':'
BCC	loc_C05
ADC	#6

loc_C05:
JSR	$FFD2
PLA
AND	#$F
ADC	#$30 ; '0'
CMP	#$3A ; ':'
BCC	loc_C13
ADC	#6

loc_C13:
JSR	$FFD2
RTS



sub_C17:
PHA
TXA
PHA
TYA
PHA
PHA
LDA	#0
PHA
TSX
LDA	$105,X
STA	$102,X
LDY	#$64 ; 'd'
JSR	sub_E9F
CMP	#0
BEQ	loc_C48
TAY
CLC
ADC	#$30 ; '0'
JSR	sub_A39
LDA	$102,X
SEC

loc_C3B:
SBC	#$64 ; 'd'
DEY
BNE	loc_C3B
STA	$102,X
LDA	#1
STA	$101,X

loc_C48:
LDA	$102,X
LDY	#$A
JSR	sub_E9F
CMP	#0
BNE	loc_C63
LDA	#1
AND	$101,X
BEQ	loc_C76
LDA	#$30 ; '0'
JSR	sub_A39
JMP	loc_C76

loc_C63:
TAY
CLC
ADC	#$30 ; '0'
JSR	sub_A39
LDA	$102,X
SEC

loc_C6E:
SBC	#$A
DEY
BNE	loc_C6E
STA	$102,X

loc_C76:
LDA	$102,X
CLC
ADC	#$30 ; '0'
JSR	sub_A39
PLA
PLA
PLA
TAY
PLA
TAX
PLA
RTS
; End of function sub_C17

byte_C87:!byte 0
byte_C88:!byte 0
byte_C89:!byte 0



sub_C8A:
STX	byte_C88
STA	byte_C89
PHA
TXA
PHA
TYA
PHA
LDA	#0
STA	byte_C87
LDA	#$27 ; '''
PHA
LDA	#$10
PHA
LDX	byte_C88
LDA	byte_C89
JSR	sub_EEB
PLA
PLA
CPX	#0
BEQ	loc_CCF
TXA
CLC
ADC	#$30 ; '0'
JSR	sub_A39

loc_CB6:
SEC
LDA	byte_C88
SBC	#$10
STA	byte_C88
LDA	byte_C89
SBC	#$27 ; '''
STA	byte_C89
DEX
BNE	loc_CB6
LDA	#1
STA	byte_C87

loc_CCF:
LDA	#3
PHA
LDA	#$E8 ; 'Ë'
PHA
LDX	byte_C88
LDA	byte_C89
JSR	sub_EEB
PLA
PLA
CPX	#0
BNE	loc_CF5
LDA	#1
AND	byte_C87
BEQ	loc_D15
TXA
CLC
ADC	#$30 ; '0'
JSR	sub_A39
JMP	loc_D15

loc_CF5:
TXA
CLC
ADC	#$30 ; '0'
JSR	sub_A39

loc_CFC:
SEC
LDA	byte_C88
SBC	#$E8 ; 'Ë'
STA	byte_C88
LDA	byte_C89
SBC	#3
STA	byte_C89
DEX
BNE	loc_CFC
LDA	#1
STA	byte_C87

loc_D15:
LDA	#0
PHA
LDA	#$64 ; 'd'
PHA
LDX	byte_C88
LDA	byte_C89
JSR	sub_EEB
PLA
PLA
CPX	#0
BNE	loc_D31
LDA	#1
AND	byte_C87
BEQ	loc_D51

loc_D31:
TXA
CLC
ADC	#$30 ; '0'
JSR	sub_A39

loc_D38:
SEC
LDA	byte_C88
SBC	#$64 ; 'd'
STA	byte_C88
LDA	byte_C89
SBC	#0
STA	byte_C89
DEX
BNE	loc_D38
LDA	#1
STA	byte_C87

loc_D51:
LDA	byte_C88
LDY	#$A
JSR	sub_E9F
TAX
CMP	#0
BNE	loc_D6F
LDA	#1
AND	byte_C87
BEQ	loc_D82
TXA
CLC
ADC	#$30 ; '0'
JSR	sub_A39
JMP	loc_D82

loc_D6F:
TXA
CLC
ADC	#$30 ; '0'
JSR	sub_A39
LDA	byte_C88
SEC

loc_D7A:
SBC	#$A
DEX
BNE	loc_D7A
STA	byte_C88

loc_D82:
LDA	byte_C88
CLC
ADC	#$30 ; '0'
JSR	sub_A39
PLA
TAY
PLA
TAX
PLA
RTS
; End of function sub_C8A




sub_D91:
LDX	#$3F ; '?'

loc_D93:
LDA	unk_DDA,X
STA	$380,X
LDA	unk_E19,X
STA	$3C0,X
DEX
BPL	loc_D93
LDA	#$E
STA	$7F8
LDA	#$F
STA	$7F9
LDA	#$B8 ; '∏'
STA	$D000
STA	$D002
LDA	#$97 ; 'ó'
STA	$D001
STA	$D003
LDA	#0
STA	$D010
STA	$D017
STA	$D01D
LDA	#1
STA	$D027
LDA	#2
STA	$D028
LDA	$D015
ORA	#3
STA	$D015
RTS
; End of function sub_D91

unk_DDA:!byte $80 ; Ä
!byte	0
!byte	0
!byte $C0 ; ¿
!byte	0
!byte	0
!byte $A0 ; †
!byte	0
!byte	0
!byte $90 ; ê
!byte	0
!byte	0
!byte $88 ; à
!byte	0
!byte	0
!byte $84 ; Ñ
!byte	0
!byte	0
!byte $82 ; Ç
!byte	0
!byte	0
!byte $81 ; Å
!byte	0
!byte	0
!byte $80 ; Ä
!byte $80 ; Ä
!byte	0
!byte $80 ; Ä
!byte $40 ; @
!byte	0
!byte $80 ; Ä
!byte $20
!byte	0
!byte $81 ; Å
!byte $F0 ; 
!byte	0
!byte $89 ; â
!byte	0
!byte	0
!byte $99 ; ô
!byte	0
!byte	0
!byte $A4 ; §
!byte $80 ; Ä
!byte	0
!byte $C4 ; ƒ
!byte $80 ; Ä
!byte	0
!byte $82 ; Ç
!byte $40 ; @
!byte	0
!byte	2
!byte $40 ; @
!byte	0
!byte	1
!byte $20
!byte	0
!byte	1
!byte $20
!byte	0
!byte	0
!byte $C0 ; ¿
!byte	0
unk_E19:!byte	0
!byte	0
!byte	0
!byte	0
!byte	0
!byte	0
!byte $40 ; @
!byte	0
!byte	0
!byte $60 ; `
!byte	0
!byte	0
!byte $70 ; p
!byte	0
!byte	0
!byte $78 ; x
!byte	0
!byte	0
!byte $7C ; |
!byte	0
!byte	0
!byte $7E ; ~
!byte	0
!byte	0
!byte $7F ; 
!byte	0
!byte	0
!byte $7F ; 
!byte $80 ; Ä
!byte	0
!byte $7F ; 
!byte $C0 ; ¿
!byte	0
!byte $7E ; ~
!byte	0
!byte	0
!byte $76 ; v
!byte	0
!byte	0
!byte $66 ; f
!byte	0
!byte	0
!byte $43 ; C
!byte	0
!byte	0
!byte	3
!byte	0
!byte	0
!byte	1
!byte $80 ; Ä
!byte	0
!byte	1
!byte $80 ; Ä
!byte	0
!byte	0
!byte $C0 ; ¿
!byte	0
!byte	0
!byte $C0 ; ¿
!byte	0
!byte	0
!byte	0
!byte	0



sub_E58:
CLD
PHA
PHA
PHA
PHA
PHA
TSX
LDA	#0
STA	$103,X
STA	$104,X
STA	$105,X
CPY	#0
BEQ	loc_E98
TYA
STA	$102,X

loc_E72:
LDA	$101,X
BEQ	loc_E98
LSR	$101,X
BCC	loc_E8F
CLC
LDA	$104,X
ADC	$102,X
STA	$104,X
LDA	$105,X
ADC	$103,X
STA	$105,X

loc_E8F:
ASL	$102,X
ROL	$103,X
JMP	loc_E72

loc_E98:
PLA
PLA
PLA
PLA
TAX
PLA
RTS

sub_E9F:
        CLD
        CPY	#0
        BEQ	locret_EEA
        PHA
        TYA
        PHA
        TXA
        PHA
        LDA	#1
        PHA
        LDA	#0
        PHA
        TSX

loc_EB0:
        LDA	$104,X
        BMI	loc_EBE
        ASL	$104,X
        ASL	$102,X
        JMP	loc_EB0

loc_EBE:
        LDA	$105,X
        SEC
        SBC	$104,X
        BCC	loc_ED6
        STA	$105,X
        LDA	$102,X
        ORA	$101,X
        STA	$101,X
        JMP	loc_EBE

loc_ED6:
        LSR	$104,X
        LSR	$102,X
        BCC	loc_EBE
        LDA	$101,X
        STA	$105,X
        PLA
        PLA
        PLA
        TAX
        PLA
        PLA

locret_EEA:
        RTS

sub_EEB:
        CLD
        PHA
        TXA
        PHA
        TSX
        LDA	$105,X
        BNE	loc_EFD
        LDA	$106,X
        BNE	loc_EFD
        JMP	loc_F79

loc_EFD:
        DEX
        DEX
        TXS
        LDA	#0
        PHA
        LDA	#1
        PHA
        LDA	#0
        PHA
        PHA
        TSX
        LDA	$10B,X
        STA	$105,X
        LDA	$10C,X
        STA	$106,X

loc_F17:
        LDA	$106,X
        BMI	loc_F2B
        ASL	$105,X
        ROL	$106,X
        ASL	$103,X
        ROL	$104,X
        JMP	loc_F17

loc_F2B:
        SEC
        LDA	$107,X
        SBC	$105,X
        PHA
        LDA	$108,X
        SBC	$106,X
        BCC	loc_F57
        STA	$108,X
        PLA
        STA	$107,X
        LDA	$103,X
        ORA	$101,X
        STA	$101,X
        LDA	$104,X
        ORA	$102,X
        STA	$102,X
        JMP	loc_F2B

loc_F57:
        PLA
        LSR	$106,X
        ROR	$105,X
        LSR	$104,X
        ROR	$103,X
        BCC	loc_F2B
        LDA	$101,X
        STA	$107,X
        LDA	$102,X
        STA	$108,X
        INX
        INX
        INX
        INX
        INX
        INX
        TXS

loc_F79:
        PLA
        TAX
        PLA
        RTS
