


	fillvalue=$00

	!initmem 	fillvalue
	!cpu 6502
	!to "spaces.prg", cbm

        *= $0801
line0:
        !word line1 ; ptr to next line
        !word 0     ; line nr

        !byte $20, $20, $20
        !pet "3 spaces at start of line"
        !byte 0 ; end of line
line1:
        !word line2 ; ptr to next line
        !word 1     ; line nr

        !pet "3 spaces:"
        !byte $20, $20, $20
;        !pet "mid-line"
        !pet ":here"
        !byte 0 ; end of line
line2:
        !word line3 ; ptr to next line
        !word 2     ; line nr

        !pet "3 spaces:"
        !byte $20, $20, $20
        !byte 0 ; end of line
line3:


    !word 0 ; basic end
