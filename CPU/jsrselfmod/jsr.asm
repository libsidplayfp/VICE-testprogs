
; http://forum.6502.org/viewtopic.php?f=1&t=7640

;   10 DIM code 99:P%=code
;   20 [ SEI:TSX:STX&70:LDX#0:TXS:JMP&00FE:]
;   30 P%=&FE: REM here's the vital code to test
;   40 [ JSR &4321:]
;   50 P%=&121: REM real 6502 will land here
;   60 [ LDX&70: TXS: LDA #ASC("P"):CLI:RTS: ]
;   70 P%=&4321:REM incorrect emulator will land here
;   80 [ LDX&70: TXS: LDA #ASC("F"):CLI:RTS: ]
;   90 PRINT CHR$(USR code) 

    * = $0801

    !word n
    !word 4711
    !byte $9e
    !text "2304"
n
    !word 0
    !word 0

    * = $0900

    sei

    ldx #2
-
    lda code1,x
    sta $00fe,x
    dex
    bpl -

    ldx #12
-
    lda code2,x
    sta $0121,x
    dex
    bpl -

    ldx #12
-
    lda code3,x
    sta $4321,x
    dex
    bpl -

    ldx #0
    txs
    jmp $00fe

; here's the vital code to test
code1:
!pseudopc $00fe {
    jsr $4321
}

; real 6502 will land here
code2:
!pseudopc $0121 {
    lda #5  ; green
    sta $d020
    lda #0
    sta $d7ff
    jmp *
}

; incorrect emulator will land here
code3:
!pseudopc $4321 {
    lda #2  ; red
    sta $d020
    lda #$ff
    sta $d7ff
    jmp *
}
