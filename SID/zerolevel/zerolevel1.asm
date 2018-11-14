
            *=$0801
            !word bend
            !word 10
            !byte $9e
            !byte "2","0","6","1", 0
bend:       !word 0    

        jmp start

        * = $0900
start:
        lda #0
        ldx #$1f
-
        sta $d400,x
        dex
        bpl -

        lda #$0b
        sta $d417
        lda #$0f
        sta $d418
-
        inc $d020
        jmp -
 
