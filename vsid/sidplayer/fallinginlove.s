
STEREO = 1

.if (FORMAT = 0)
                jmp main
.endif
.if (FORMAT = 1)
headerversion = $0003
imagestart    = $1000
init          = $1000
play          = $1003
                .include "header.s"
.endif

;-------------------------------------------------------------------------------

.if (FORMAT = 0)
                .include "main.s"
.endif
                .include "cgplayer.s"

;-------------------------------------------------------------------------------
musdata:        .incbin "I_cant_Help_Falling_in_Love.mus", 2
strdata:        .incbin "I_cant_Help_Falling_in_Love.str", 2
;-------------------------------------------------------------------------------
;wdsdata:        .incbin "I_cant_Help_Falling_in_Love.wds", 2

