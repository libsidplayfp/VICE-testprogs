
.if (FORMAT = 0)                ; runable .prg
                jmp main
                .include "main.s"
                .include "cgplayer.s"
.endif

.if (FORMAT = 1)                ; regular .sid file including player
headerversion = $0002
imagestart    = $1000
init          = $1000
play          = $1003
                .include "header.s"
                .include "cgplayer.s"
.endif

.if (FORMAT = 2)                ; .sid file with compute sidplayer flag set
headerversion = $0002
imagestart    = $1000
init          = $0000
play          = $0000
                .include "header.s"
.endif

;-------------------------------------------------------------------------------
musdata:        .incbin "Scroll_Machine_tune01.mus", 2
strdata:        .word 0
;-------------------------------------------------------------------------------
;wdsdata:        .word 0
