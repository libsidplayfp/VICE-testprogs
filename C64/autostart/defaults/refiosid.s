; proper RSID environment:
; VIC - IRQ set to raster 0, but not enabled.
; CIA 1 timer A - set to 60Hz with the counter running and IRQs active.
; Other timers - disabled and loaded with $FFFF.
; Bank register - $37


cpuref:
            ;      A    X    Y  stack stat n/a  $00  $01
            !byte $01, $01, $01, $00, $00, $00, $2f, $37

vicref:
            !byte $00, $00, $00, $00, $00, $00, $00, $00
            !byte $00, $00, $00, $00, $00, $00, $00, $00
            !byte $00, $00, $00, $00, $00, $00, $c0, $00
            !byte $01, $71, $f0, $00, $00, $00, $00, $00
            !byte $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0
            !byte $f0, $f0, $f0, $f0, $f0, $f0, $f0, $ff
cia1ref:
            !byte $ff, $ff, $00, $00, $04, $25, $ff, $ff
            !byte $00, $00, $00, $01, $00, $81, $01, $00
            !byte $ff, $ff, $00, $00, $00, $00, $00, $00
cia2ref:
            !byte $ff, $ff, $00, $00, $ff, $ff, $ff, $ff
            !byte $00, $00, $00, $01, $00, $00, $00, $00
            !byte $ff, $ff, $c0, $00, $00, $00, $00, $00

rameref:
            !byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
;-----------------------------------------------------------

cpumask:
            ;      A    X    Y  stack stat n/a  $00  $01
            !byte $ff, $ff, $ff, $00, $00, $00, $ff, $ff

vicmask:
            !byte $00, $00, $00, $00, $00, $00, $00, $00
            !byte $00, $00, $00, $00, $00, $00, $00, $00 
            !byte $00, $00, $00, $00, $00, $ff, $00, $ff
            !byte $00, $f7, $ff, $ff, $00, $ff, $00, $00
            !byte $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0
            !byte $f0, $f0, $f0, $f0, $f0, $f0, $f0, $ff
cia1mask:
            !byte $00, $00, $00, $00, $00, $00, $ff, $ff
            !byte $ff, $ff, $fe, $6f, $ff, $ff, $ff, $ff
            !byte $00, $00, $00, $00, $00, $00, $00, $00
cia2mask:
            !byte $00, $00, $00, $00, $ff, $ff, $ff, $ff
            !byte $ff, $ff, $fe, $6f, $ff, $ff, $ff, $ff
            !byte $00, $00, $00, $00, $00, $00, $00, $00

ramemask:
            !byte $00, $00, $00, $00, $00, $00, $00, $00

