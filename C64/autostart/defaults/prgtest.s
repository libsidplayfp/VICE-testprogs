USEULTIMAX = 0

    !to "test.prg",cbm

MEMBUFFER = $c000
REGBUFFER = $c000 + $0400

;-------------------------------------------------------------------------------

    *=$0801

    !byte $0c, $08, $00, $00, $9e, $20, $32, $35, $36, $30, $00, $00, $00


CODESTART = $0a00
    !src "test.s"

    !src "refio.s"
    !src "refmem.s"

    ; make sure the binary always ends at the same "odd" address
    * = $1cde
    !byte $42
