        fillvalue=$00

        !initmem 	fillvalue
        !cpu 6502
        !to "remdata.prg", cbm

        *= $0801

        ; 1000 data +,-,print,input,
        !word n1            ; ptr to next line
        !word 1000          ; line nr
        !byte $83           ; DATA
        !pet " +,-,print,input,"
        !byte 0             ; end of line
n1:
        ; 1001 data print,":",input
        !word n2            ; ptr to next line
        !word 1001          ; line nr
        !byte $83           ; DATA
        !pet " print,"
        !byte $22,':',$22
        !pet ",input"
        !byte 0             ; end of line
n2:
        ; 1002 data print:{$99 = print}
        !word n3            ; ptr to next line
        !word 1002          ; line nr
        !byte $83           ; DATA
        !pet " print:"
        !byte $99           ; PRINT
        !byte 0             ; end of line
n3:
        ; 2003 {$99 = print}:rem print
        !word n4            ; ptr to next line
        !word 1003          ; line nr
        !byte $99           ; PRINT
        !byte $3a           ; :
        !byte $83           ; DATA
        !pet " print"
        !byte 0             ; end of line
n4:

        ; after REM, the entire line will not get tokenized
        ; - a colon does NOT terminate the REM mode

        ; 2000 rem +,-,print,input,
        !word n21           ; ptr to next line
        !word 2000          ; line nr
        !byte $8f           ; REM
        !pet " +,-,print,input,"
        !byte 0             ; end of line
n21:
        ; 2001 rem print,":",input
        !word n22            ; ptr to next line
        !word 2001          ; line nr
        !byte $8f           ; REM
        !pet " print,"
        !byte $22,':',$22
        !pet ",input"
        !byte 0             ; end of line
n22:
        ; 2002 rem print:{$99 = print}
        !word n23            ; ptr to next line
        !word 2002          ; line nr
        !byte $8f           ; REM
        !pet " print:"
        !byte $99           ; PRINT
        !byte 0             ; end of line
n23:
        ; 2003 {$99 = print}:rem print
        !word n24            ; ptr to next line
        !word 2003          ; line nr
        !byte $99           ; PRINT
        !byte $3a           ; :
        !byte $8f           ; REM
        !pet " print"
        !byte 0             ; end of line
n24:

        ; regular tokens used above

        ; 3000 print
        !word n31           ; ptr to next line
        !word 3000          ; line nr
        !byte $99           ; PRINT
        !byte 0             ; end of line
n31:

        ; TODO: literal keywords

        !word 0         ; basic end
