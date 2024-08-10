BORDERCOLOR = $ff19
SCREENCOLOR = $ff15
DEBUGREG = $fdcf        ; http://plus4world.powweb.com/forum.php?postid=31417#31429

        !to "outrun.prg", cbm

        * = $1001

        !byte $0C, $10, $E4, $07, $9E, $20, $34, $31, $31, $32, $00	; 10 SYS 4112
        !byte $00, $00

;------------------------------------------------------------------------------

        *= $1010

        SEI

        LDA #$00        ; black
        STA BORDERCOLOR

        ; very simple test, which can be found eg in "turbo outrun". reads $fdd0
        ; in a loop, ORs the values and errors out if the result remains zero
        ; after 256 rounds
        ;
        ; found in turbo outrun at $2190
        lda $fdd0
        ldx #0
-
        ora $fdd0
        bne passed
        dex
        bne -

failed:
        LDA #(3 << 4) | 2 ; red
        STA BORDERCOLOR
        lda #$ff
        sta DEBUGREG
        jmp *

passed:
        LDA #(3 << 4) | 5 ; green
        STA BORDERCOLOR
        lda #$00
        sta DEBUGREG
        jmp *

