            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
            jmp start
;-------------------------------------------------------------------------------

     * = $0900
start:
            ldx #0
-
            lda #1
            sta $d800,x
            lda #15
            sta $d900,x
            inx
            bne -

loop:

            ldx #0
-
            lda $de00,x
            sta $0400,x
            lda $df00,x
            sta $0500,x
            inx
            bne -

            jmp loop
