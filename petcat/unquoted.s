        fillvalue=$00

        !initmem 	fillvalue
        !cpu 6502
        !to "unquoted.prg", cbm

; all codes, outside quotes, one per line

        *= $0801

        !for i, 255 {
            !word * + 6     ; ptr to next line
            !word i         ; line nr
            !byte i         ; value
            !byte 0         ; end of line
        }

; all codes after DATA, outside quotes, one per line
        !for i, 255 {
            !word * + 8         ; ptr to next line
            !word 1000 + i      ; line nr
            !byte $83           ; DATA
            !byte $20, i        ; space, value
            !byte 0             ; end of line
        }

; all codes after REM, outside quotes, one per line
        !for i, 255 {
            !word * + 8         ; ptr to next line
            !word 2000 + i      ; line nr
            !byte $8f           ; REM
            !byte $20, i        ; space, value
            !byte 0             ; end of line
        }

        !word 0         ; basic end
