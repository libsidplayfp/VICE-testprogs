        fillvalue=$00

        !initmem        fillvalue
        !cpu 6502
        !to "mmcrplugin.prg", plain

        *= $0810-2
        !word $0810

        !src "main-mmcr.s"
