
	fillvalue=$00
	
	!initmem 	fillvalue
	!cpu 6502
	!to "tokensv2.prg", cbm

        *= $0801
line0:
        !word line1 ; ptr to next line
        !word 1 ; line nr
        !byte '"'
        !for i, $c {
            !byte i
        }
        !byte '"'
        !byte 0 ; end of line
line1:
        !word line2 ; ptr to next line
        !word 2 ; line nr
        !byte '"'
        !for i, $14 {
            !byte $d + i
        }
        !for i, $2b {
            !byte $22 + i
        }
        !byte '"'
        !byte 0 ; end of line
line2:
        !word line3 ; ptr to next line
        !word 3 ; line nr
        !byte '"'
        !for i, $40 {
            !byte $4d + i
        }
        !byte '"'
        !byte 0 ; end of line
line3:
        !word line4 ; ptr to next line
        !word 4 ; line nr
        !byte '"'
        !for i, $40 {
            !byte $8d + i
        }
        !byte '"'
        !byte 0 ; end of line
line4:
        !word line5 ; ptr to next line
        !word 5 ; line nr
        !byte '"'
        !for i, $40-$e {
            !byte $cd + i
        }
        !byte '"'
        !byte 0 ; end of line
line5:

        !word 0 ; basic end
			