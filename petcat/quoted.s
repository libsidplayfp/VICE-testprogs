        fillvalue=$00

        !initmem 	fillvalue
        !cpu 6502
        !to "quoted.prg", cbm

; all codes, outside quotes, one per line

        *= $0801

        !for i, 255 {
            !if (i != $20) {
            !word * + 8     ; ptr to next line
            !word i         ; line nr
            !byte $22,i,$22 ; value
            !byte 0         ; end of line
            }
        }

; all codes after DATA, outside quotes, one per line
        !for i, 255 {
            !if (i != $20) {
            !word * + 9         ; ptr to next line
            !word 1000 + i      ; line nr
            !byte $83           ; DATA
            !byte $22, i, $22   ; space, value
            !byte 0             ; end of line
            }
        }

; all codes after REM, outside quotes, one per line
        !for i, 255 {
            !if (i != $20) {
            !word * + 9         ; ptr to next line
            !word 2000 + i      ; line nr
            !byte $8f           ; REM
            !byte $22, i, $22   ; space, value
            !byte 0             ; end of line
            }
        }

        !word 0         ; basic end

; FIXME: a line containing a single space is not handled
; FIXME: space(s) at the end of a line are not handled
