        fillvalue=$00

        !initmem 	fillvalue
        !cpu 6502
        !to "mdbasicapos.prg", cbm

        *= $0801

        ; MDBASIC: an apostrophe (') outside quotes is an alternate REM.
        ; Like REM, the rest of the line is stored verbatim and is NOT
        ; tokenized; a colon does NOT terminate it. Only -wmdbasic treats
        ; ' this way, so the words after ' below stay literal text and the
        ; program round-trips byte for byte.

        ; 100 '+,-,print,input,
        !word n1            ; ptr to next line
        !word 100           ; line nr
        !byte $27           ; ' (alternate REM)
        !pet "+,-,print,input,"
        !byte 0             ; end of line
n1:
        ; 101 ' print:input  (colon does NOT terminate the comment)
        !word n2            ; ptr to next line
        !word 101           ; line nr
        !byte $27           ; '
        !pet " print:input"
        !byte 0             ; end of line
n2:
        ; 102 print:' goto run  (' after a real statement and a colon)
        !word n3            ; ptr to next line
        !word 102           ; line nr
        !byte $99           ; PRINT
        !byte $3a           ; :
        !byte $27           ; '
        !pet " goto run"
        !byte 0             ; end of line
n3:
        ; 103 print"it's":' the ' inside quotes is just text, not a comment
        !word n4            ; ptr to next line
        !word 103           ; line nr
        !byte $99           ; PRINT
        !byte $22           ; "
        !pet "it's"
        !byte $22           ; "
        !byte $3a           ; :
        !byte $27           ; '
        !pet " done"
        !byte 0             ; end of line
n4:
        !word 0             ; basic end
