        fillvalue=$00

        !initmem        fillvalue
        !cpu 6502
        !to "mmcr.prg", plain

        *= $0801-2
        !word $0801
        !byte $0c,$08,$0b,$00,$9e
        !byte $32,$30,$36,$34
        !byte $00,$00,$00,$00

        !src "main-mmcr.s"
