
	fillvalue=$00
	
	!initmem 	fillvalue
	!cpu 6502
	!to "keywordsv4vic20.prg", cbm

        *= $1201
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
        !for i, $7 {
            !byte ":"
            !byte $c8 + i
        }
        !byte 0 ; end of line
line10:
        !word line11 ; ptr to next line
        !word 11 ; line nr
        !byte $d0
        !for i, $7 {
            !byte ":"
            !byte $d0 + i
        }
        !byte 0 ; end of line
line11:
        !word line12 ; ptr to next line
        !word 12 ; line nr
        !byte $d8
        !for i, $7 {
            !byte ":"
            !byte $d8 + i
        }
        !byte 0 ; end of line
line12:
        !word line13 ; ptr to next line
        !word 13 ; line nr
        !byte $ff
        !byte 0 ; end of line
line13:
        !word 0 ; basic end
