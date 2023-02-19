
	fillvalue=$00

	!initmem 	fillvalue
	!cpu 6502
	!to "keywordsv65.prg", cbm

        *= $2001
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
        !for i, $5 {
            !byte ":"
            !byte $c8 + i
        }
        !byte 0 ; end of line
line10:
        !word line11 ; ptr to next line
        !word 11 ; line nr
        !byte $ce
        !byte $02
        !for i, $5 {
            !byte ":"
            !byte $ce
            !byte $02 + i
        }
        !byte 0 ; end of line
line11:
        !word line12 ; ptr to next line
        !word 12 ; line nr
        !byte $ce
        !byte $08
        !for i, $7 {
            !byte ":"
            !byte $ce
            !byte $08 + i
        }
        !byte ":"
        !byte $cf
        !byte 0 ; end of line
line12:
        !word line13 ; ptr to next line
        !word 13 ; line nr
        !byte $d0
        !for i, $7 {
            !byte ":"
            !byte $d0 + i
        }
        !byte 0 ; end of line
line13:
        !word line14 ; ptr to next line
        !word 14 ; line nr
        !byte $d8
        !for i, $7 {
            !byte ":"
            !byte $d8 + i
        }
        !byte 0 ; end of line
line14:
        !word line15 ; ptr to next line
        !word 15 ; line nr
        !byte $e0
        !for i, $7 {
            !byte ":"
            !byte $e0 + i
        }
        !byte 0 ; end of line
line15:
        !word line16 ; ptr to next line
        !word 16 ; line nr
        !byte $e8
        !for i, $7 {
            !byte ":"
            !byte $e8 + i
        }
        !byte 0 ; end of line
line16:
        !word line17 ; ptr to next line
        !word 17 ; line nr
        !byte $f0
        !for i, $7 {
            !byte ":"
            !byte $f0 + i
        }
        !byte 0 ; end of line
line17:
        !word line18 ; ptr to next line
        !word 18 ; line nr
        !byte $f8
        !for i, $5 {
            !byte ":"
            !byte $f8 + i
        }
        !byte 0 ; end of line
line18:
        !word line19 ; ptr to next line
        !word 19 ; line nr
        !byte $fe
        !byte $02
        !for i, $5 {
            !byte ":"
            !byte $fe
            !byte $02 + i
        }
        !byte 0 ; end of line
line19:
        !word line20 ; ptr to next line
        !word 20 ; line nr
        !byte $fe
        !byte $08
        !for i, $7 {
            !byte ":"
            !byte $fe
            !byte $08 + i
        }
        !byte 0 ; end of line
line20:
        !word line21 ; ptr to next line
        !word 21 ; line nr
        !byte $fe
        !byte $10
        !for i, $7 {
            !byte ":"
            !byte $fe
            !byte $10 + i
        }
        !byte 0 ; end of line
line21:
        !word line22 ; ptr to next line
        !word 22 ; line nr
        !byte $fe
        !byte $18
        !for i, $7 {
            !byte ":"
            !byte $fe
            !byte $18 + i
        }
        !byte 0 ; end of line
line22:
        !word line23 ; ptr to next line
        !word 23 ; line nr
        !byte $fe
        !byte $21
        ; skip $fe $22
        !for i, $5 {
            !byte ":"
            !byte $fe
            !byte $22 + i
        }
        !byte 0 ; end of line
line23:
        !word line24 ; ptr to next line
        !word 24 ; line nr
        !byte $fe
        !byte $28
        !for i, $7 {
            !byte ":"
            !byte $fe
            !byte $28 + i
        }
        !byte 0 ; end of line
line24:
        !word line25 ; ptr to next line
        !word 25 ; line nr
        !byte $fe
        !byte $30
        !for i, $7 {
            !byte ":"
            !byte $fe
            !byte $30 + i
        }
        !byte 0 ; end of line
line25:
        !word line26 ; ptr to next line
        !word 26 ; line nr
        !byte $fe
        !byte $38
        !byte ":"
        !byte $fe
        !byte $39
        !for i, $5 {
            !byte ":"
            !byte $fe
            !byte $3a + i
        }
        !byte 0 ; end of line
line26:
        !word line27 ; ptr to next line
        !word 27 ; line nr
        !byte $fe
        !byte $40
        !for i, $7 {
            !byte ":"
            !byte $fe
            !byte $40 + i
        }
        !byte 0 ; end of line
line27:
        !word line28 ; ptr to next line
        !word 28 ; line nr
        !byte $fe
        !byte $48
        !byte ":"
        !byte $ff
        !byte 0 ; end of line
line28:
        !word line29 ; ptr to next line
        !word 29 ; line nr
        !byte $81 ; for
        !pet "i"
        !byte $b2 ; =
        !pet "$1def"
        !byte $a4 ; to
        !pet "$def1"
        !byte $a9 ; step
        !pet "$def"
        !byte 0 ; end of line

line29:
        !word line30 ; ptr to next line
        !word 30 ; line nr
        !byte $58, $b2 ; x=
        !byte $ce
        !byte $10 ; wpeek()
        !pet "($d020)"
        !byte 0 ; end of line

line30:
        !word line31 ; ptr to next line
        !word 31 ; line nr
        !byte $fe
        !byte $1d ; wpoke
        !pet " $d020,$1234"
        !byte 0 ; end of line

line31:
        !word line32 ; ptr to next line
        !word 32 ; line nr
        !byte $fe
        !byte $49 ; mount
        !pet " ",$22,"filename.d81",$22
        !byte 0 ; end of line

line32:
        !word line33 ; ptr to next line
        !word 33 ; line nr
        !byte $58, $b2 ; x=
        !pet "1"
        !byte $fe
        !byte $52 ; <<
        !pet "7"
        !byte 0 ; end of line

line33:
        !word 0 ; basic end
