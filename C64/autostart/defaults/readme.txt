
CPU (a,x,y,sp,status,n/a,$00,$01)

VIC

CIA1

CIA2

MEMTOP (9ff0-9fff, the filename of the loaded program shows up here)

- green means match, red means fail
- yellow marks areas which are undefined / may change

- in cpu status, bit 5 (-) and bit 3 (I) must be set after reset

- in the .crt version, press reset two times to check repeatedly

- press + / - to select memory page shown at the bottom
        , selects page $00
        . selects page $de

NOTE: test.prg must be loaded from disk using LOAD"TEST",8 - else it will fail
