cpuref:
            !byte $00, $00, $00, $00, $00, $00, $00, $1f

vicref:
            !byte $00, $00, $00, $00, $00, $00, $00, $00
            !byte $00, $00, $00, $00, $00, $00, $00, $00
            !byte $00, $00, $00, $00, $00, $00, $c0, $00
            !byte $01, $71, $f0, $00, $00, $00, $00, $00
            !byte $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0
            !byte $f0, $f0, $f0, $f0, $f0, $f0, $f0, $ff
cia1ref:
            !byte $ff, $ff, $00, $00, $ff, $ff, $ff, $ff
            !byte $00, $00, $00, $01, $00, $00, $00, $00
            !byte $ff, $ff, $00, $00, $00, $00, $00, $00
cia2ref:
            !byte $ff, $ff, $00, $00, $ff, $ff, $ff, $ff
            !byte $00, $00, $00, $01, $00, $00, $00, $00
            !byte $ff, $ff, $c0, $00, $00, $00, $00, $00

rameref:
            !byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
;-----------------------------------------------------------

cpumask:
            !byte $00, $00, $00, $00, $00, $00, $00, $17

vicmask:
            !byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
            !byte $ff, $00, $00, $00, $00, $ff, $00, $ff
            !byte $00, $f7, $ff, $ff, $ff, $ff, $ff, $ff
            !byte $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0
            !byte $f0, $f0, $f0, $f0, $f0, $f0, $f0, $ff
cia1mask:
            !byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff, $00, $00, $00, $00
cia2mask:
            !byte $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
            !byte $3f, $ff, $3f, $ff, $00, $00, $00, $00

ramemask:
            !byte $00, $00, $00, $00, $00, $00, $00, $00

