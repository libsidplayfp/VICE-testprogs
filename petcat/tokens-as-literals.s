	fillvalue=$00

	!initmem 	fillvalue
	!cpu 6502
	!to "tokens-as-literals.prg", cbm

        *= $0801
line0:
        !word line1a ; ptr to next line
        !word 1     ; line nr
; when entering in BASIC, this tokenizes to:
; 4d 49 44   ab   4c 49 4e 45
        !pet "mid-line" ; 4d 49 44 2d 4c 49 4e 45
        !byte 0 ; end of line
line1a:
        !word line1b ; ptr to next line
        !word 1     ; line nr
; when entering in BASIC, this tokenizes to:
; 4d 49 44   ab   4c 49 4e 45
        !byte $4d,$49,$44,$ab,$4c,$49,$4e,$45
        !byte 0 ; end of line
line1b:

        !word line2a ; ptr to next line
        !word 2     ; line nr
; when entering in BASIC, this tokenizes to:
; $99
        !pet "print"
        !byte 0 ; end of line
line2a:
        !word line2b ; ptr to next line
        !word 2     ; line nr
; when entering in BASIC, this tokenizes to:
; $99
        !byte $99
        !byte 0 ; end of line
line2b:

        !word line2c ; ptr to next line
        !word 2     ; line nr
        !byte $22
        !pet "print"
        !byte $22
        !byte 0 ; end of line
line2c:
        !word line2d ; ptr to next line
        !word 2     ; line nr
        !byte $22
        !byte $99
        !byte $22
        !byte 0 ; end of line
line2d:

        !word line3a ; ptr to next line
        !word 3     ; line nr
; when entering in BASIC, this tokenizes to:
; 49 4d   99    45 52
        !pet "imprinter"
        !byte 0 ; end of line
line3a:

        !word line3b ; ptr to next line
        !word 3     ; line nr
; when entering in BASIC, this tokenizes to:
; 49 4d   99    45 52
        !byte $49, $4d, $99, $45, $52
        !byte 0 ; end of line
line3b:


        !word line4a ; ptr to next line
        !word 4     ; line nr
; when entering in BASIC, this tokenizes to:
; ac aa ab ad  b3 b2 b1 ae
        !pet "*+-/<=>^"
        !byte 0 ; end of line
line4a:

        !word line4b ; ptr to next line
        !word 4     ; line nr
; when entering in BASIC, this tokenizes to:
; ac aa ab ad  b3 b2 b1 ae
        !byte $ac, $aa, $ab, $ad, $b3, $b2, $b1, $ae
        !byte 0 ; end of line
line4b:

        !word line4c ; ptr to next line
        !word 4     ; line nr
        !byte $22 ; "
        !pet "*+-/<=>^"
        !byte $22 ; "
        !byte 0 ; end of line
line4c:

        !word line4d ; ptr to next line
        !word 4     ; line nr
        !byte $22 ; "
        !byte $ac, $aa, $ab, $ad, $b3, $b2, $b1, $ae
        !byte $22 ; "
        !byte 0 ; end of line
line4d:


    !word 0 ; basic end
