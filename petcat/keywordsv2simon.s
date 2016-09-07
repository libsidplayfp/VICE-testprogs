
	fillvalue=$00
	
	!initmem 	fillvalue
	!cpu 6502
	!to "keywordsv2simon.prg", cbm

        *= $0801
line0:
        !word line1 ; ptr to next line
        !word 1 ; line nr
        !byte $80
        !for i, $7 {
            !byte ":"
            !byte $80 + i
        }
        !byte 0 ; end of line
line1:
        !word line2 ; ptr to next line
        !word 2 ; line nr
        !byte $88
        !for i, $7 {
            !byte ":"
            !byte $88 + i
        }
        !byte 0 ; end of line
line2:
        !word line3 ; ptr to next line
        !word 3 ; line nr
        !byte $90
        !for i, $7 {
            !byte ":"
            !byte $90 + i
        }
        !byte 0 ; end of line
line3:
        !word line4 ; ptr to next line
        !word 4 ; line nr
        !byte $98
        !for i, $7 {
            !byte ":"
            !byte $98 + i
        }
        !byte 0 ; end of line
line4:
        !word line5 ; ptr to next line
        !word 5 ; line nr
        !byte $a0
        !for i, $7 {
            !byte ":"
            !byte $a0 + i
        }
        !byte 0 ; end of line
line5:
        !word line6 ; ptr to next line
        !word 6 ; line nr
        !byte $a8
        !for i, $7 {
            !byte ":"
            !byte $a8 + i
        }
        !byte 0 ; end of line
line6:
        !word line7 ; ptr to next line
        !word 7 ; line nr
        !byte $b0
        !for i, $7 {
            !byte ":"
            !byte $b0 + i
        }
        !byte 0 ; end of line
line7:
        !word line8 ; ptr to next line
        !word 8 ; line nr
        !byte $b8
        !for i, $7 {
            !byte ":"
            !byte $b8 + i
        }
        !byte 0 ; end of line
line8:
        !word line9 ; ptr to next line
        !word 9 ; line nr
        !byte $c0
        !for i, $7 {
            !byte ":"
            !byte $c0 + i
        }
        !byte 0 ; end of line
line9:
        !word line10 ; ptr to next line
        !word 10 ; line nr
        !byte $c8
        !for i, $3 {
            !byte ":"
            !byte $c8 + i
        }
        !byte 0 ; end of line
line10:
        !word line11 ; ptr to next line
        !word 11 ; line nr
        !byte $64
        !byte $01
        !for i, $6 {
            !byte ":"
            !byte $64
            !byte $01 + i
        }
        !byte 0 ; end of line
line11:
        !word line12 ; ptr to next line
        !word 12 ; line nr
        !byte $64
        !byte $08
        !for i, $7 {
            !byte ":"
            !byte $64
            !byte $08 + i
        }
        !byte 0 ; end of line
line12:
        !word line13 ; ptr to next line
        !word 13 ; line nr
        !byte $64
        !byte $10
        !for i, $7 {
            !byte ":"
            !byte $64
            !byte $10 + i
        }
        !byte 0 ; end of line
line13:
        !word line14 ; ptr to next line
        !word 14 ; line nr
        !byte $64
        !byte $18
        !for i, $7 {
            !byte ":"
            !byte $64
            !byte $18 + i
        }
        !byte 0 ; end of line
line14:
        !word line15 ; ptr to next line
        !word 15 ; line nr
        !byte $64
        !byte $20
        !byte ":"
        !byte $64
        !byte $21
        !for i, $5 {
            !byte ":"
            !byte $64
            !byte $22 + i
        }
        !byte 0 ; end of line
line15:
        !word line16 ; ptr to next line
        !word 16 ; line nr
        !byte $64
        !byte $28
        !byte ":"
        !byte $64
        !byte $29
        !byte ":"
        !byte $64
        !byte $2c
        !byte ":"
        !byte $64
        !byte $2e
        !byte 0 ; end of line
line16:
        !word line17 ; ptr to next line
        !word 17 ; line nr
        !byte $64
        !byte $30
        !for i, $7 {
            !byte ":"
            !byte $64
            !byte $30 + i
        }
        !byte 0 ; end of line
line17:
        !word line18 ; ptr to next line
        !word 18 ; line nr
        !byte $64
        !byte $38
        !for i, $3 {
            !byte ":"
            !byte $64
            !byte $38 + i
        }
        !byte 0 ; end of line
line18:
        !word line19 ; ptr to next line
        !word 19 ; line nr
        !byte $64
        !byte $40
        !for i, $7 {
            !byte ":"
            !byte $64
            !byte $40 + i
        }
        !byte 0 ; end of line
line19:
        !word line20 ; ptr to next line
        !word 20 ; line nr
        !byte $64
        !byte $48
        !for i, $7 {
            !byte ":"
            !byte $64
            !byte $48 + i
        }
        !byte 0 ; end of line
line20:
        !word line21 ; ptr to next line
        !word 21 ; line nr
        !byte $64
        !byte $50
        !for i, $3 {
            !byte ":"
            !byte $64
            !byte $50 + i
        }
        !for i, $3 {
            !byte ":"
            !byte $64
            !byte $54 + i
        }
        !byte 0 ; end of line
line21:
        !word line22 ; ptr to next line
        !word 22 ; line nr
        !byte $64
        !byte $58
        !for i, $5 {
            !byte ":"
            !byte $64
            !byte $58 + i
        }
        !byte ":"
        !byte $64
        !byte $5f
        !byte 0 ; end of line
line22:
        !word line23 ; ptr to next line
        !word 23 ; line nr
        !byte $64
        !byte $60
        !for i, $7 {
            !byte ":"
            !byte $64
            !byte $60 + i
        }
        !byte 0 ; end of line
line23:
        !word line24 ; ptr to next line
        !word 24 ; line nr
        !byte $64
        !byte $68
        !for i, $7 {
            !byte ":"
            !byte $64
            !byte $68 + i
        }
        !byte 0 ; end of line
line24:
        !word line25 ; ptr to next line
        !word 25 ; line nr
        !byte $64
        !byte $70
        !for i, $7 {
            !byte ":"
            !byte $64
            !byte $70 + i
        }
        !byte 0 ; end of line
line25:
        !word line26 ; ptr to next line
        !word 26 ; line nr
        !byte $64
        !byte $78
        !for i, $7 {
            !byte ":"
            !byte $64
            !byte $78 + i
        }
        !byte 0 ; end of line
line26:
        !word line27 ; ptr to next line
        !word 27 ; line nr
        !byte $ff
        !byte 0 ; end of line
line27:
        !word 0 ; basic end
