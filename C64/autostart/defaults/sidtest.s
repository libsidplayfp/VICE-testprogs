
USEULTIMAX = 0

SIGBUFFER = $07E8
MEMBUFFER = $c000
REGBUFFER = $c000 + $0400

;-------------------------------------------------------------------------------

    * = $0801 - ($7c + 2)

    !byte $50, $53, $49, $44 ; PSID

    !byte $00, $02              ; +04    WORD version
    !byte $00, $7c              ; +06    WORD dataOffset
    !byte $00, $00              ; +08    WORD loadAddress
    !byte >start, <start        ; +0A    WORD initAddress
    !byte $00, $00              ; +0C    WORD playAddress
    !byte $00, $03              ; +0E    WORD songs
    !byte $00, $02              ; +10    WORD startSong
    !byte $00, $00, $00, $00    ; +12    LONGWORD speed

    ; +$16 name
    !byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    !byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    ; +$36 author
    !byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    !byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    ; +$56 released
    !byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    !byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

    !byte $00, $24 ; +$76    WORD flags
    !byte $00      ; +$78    BYTE startPage (relocStartPage)
    !byte $00      ; +$79    BYTE pageLength (relocPages)
    !byte $00, $00 ; +$7A    WORD reserved

    !byte < $0801, > $0801

    * = $0801

    !byte $0c, $08, $00, $00, $9e, $20, $32, $35, $36, $30, $00, $00, $00

CODESTART = $0a00
    !src "test.s"

    !src "refiosid.s"
    !src "refmem.s"

testname:
          ;1234567890123456
    !text "SID DEFAULTS    "

    ; make sure the binary always ends at the same "odd" address
    * = $1cde
    !byte $42
