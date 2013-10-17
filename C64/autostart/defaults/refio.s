cpuref:
            !byte $00, $00, $00, $f5, $30, $00, $2f, $37
vicref :
            !byte $00, $00, $00, $00, $00, $00, $00, $00
            !byte $00, $00, $00, $00, $00, $00, $00, $00
            !byte $00, $1b, $00, $00, $00, $00, $c8, $00
            !byte $15, $71, $f0, $00, $00, $00, $00, $00
            !byte $fe, $f6, $f1, $f2, $f3, $f4, $f0, $f1
            !byte $f2, $f3, $f4, $f5, $f6, $f7, $fc, $ff
cia1ref:
            !byte $7f, $ff, $ff, $00, $00, $00, $ff, $04
            !byte $00, $00, $00, $01, $00, $81, $01, $08
            !byte $ff, $ff, $7f, $00, $00, $00, $00, $00
cia2ref:
            !byte $c7, $ff, $3f, $00, $ff, $ff, $ff, $ff
            !byte $00, $00, $00, $01, $00, $00, $08, $08
            !byte $3f, $ff, $c7, $00, $00, $00, $00, $00

rameref:
            !byte $00, $00, $00, $00, $54, $45, $53, $54
;-----------------------------------------------------------

cpumask:
            !byte $ff, $ff, $ff, $ff, $ff, $00, $ff, $ff
vicmask:
            !byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
            !byte $ff, $7f, $00, $00, $00, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
cia1mask:
            !byte $ff, $ff, $ff, $ff, $00, $00, $ff, $ff
            !byte $ff, $ff, $fe, $6f, $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff, $00, $00, $00, $00
cia2mask:
            !byte $3f, $ff, $ff, $ff, $ff, $ff, $ff, $ff
            !byte $ff, $ff, $fe, $6f, $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff, $00, $00, $00, $00

ramemask:
            !byte $00, $00, $00, $00, $ff, $ff, $ff, $ff

