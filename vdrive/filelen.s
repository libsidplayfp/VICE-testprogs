
        !initmem $00            ; fill unused memory with zeros
        !cpu 6502               ; use 6502
        !to "filelen.prg", cbm

        SETNAM = $FFBD
        SETLFS = $FFBA
        LOAD   = $FFD5

        ;-----------------------------------------------------
        ; basic header
        ;-----------------------------------------------------
        *= $0801
        !byte $0c,$08           ; link to next basic line
        !word 12345             ; line number
        !byte $9e               ; token for "sys"
        !byte $32,$35,$36,$30   ; "2560" ($0a00)
        !byte $00,$00   ; 2 zeros to mark end of basic line
        !byte $00,$00   ; 2 zeros to mark end of basic program

        * = $0a00

        lda #15            ; this is wrong! filename is only 8 chars
        ldx #<filename     ; and because of that the loading should
        ldy #>filename     ; fail
        jsr SETNAM
        lda #0
        ldx #8                ;DeviceNumber
        ldy #0
        jsr SETLFS
        lda #0
        ldx #0
        ldy #8
        jsr LOAD

        inc $d020
        jmp *-3

filename:
        !text "somefile",0