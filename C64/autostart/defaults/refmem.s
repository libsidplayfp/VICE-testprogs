            * = CODESTART + $0800
pagesref:
            !binary "dump-pages.bin"

            * = CODESTART + $0c00
pagesmask:
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff

            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            ; $A0-$A2/160-162         Real-time jiffy Clock
            !byte $00, $00, $00, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            ; $C5/197                 Matrix value of last Key pressed
            !byte $ff, $ff, $ff, $ff,  $ff, $00, $ff, $ff
            ; $C8/200                 Pointer: End of Line for Input
            ; $C9-$CA/201-202         Cursor X/Y position at start of Input
            ; $CB/203                 Matrix value of last Key pressed
            ; $CC/204                 Flag: Cursor blink
            ; $CD/205                 Timer: Count down for Cursor blink toggle
            ; $CE/206                 Character under Cursor while Cursor Inverted            
            !byte $00, $00, $00, $00,  $00, $00, $00, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            ; $F5-$F6/245-246         Vector: Current Keyboard decoding Table
            ; $F7-$F8/247-248         RS232 Input Buffer Pointer            
            !byte $ff, $ff, $ff, $ff,  $ff, $00, $00, $00
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff

            ; $0100-$0104 seems to be always "38911" after reset
            !byte $ff, $ff, $ff, $ff,  $ff, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00

            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff

            ; $0200-$0258    BASIC Input Buffer (Input Line from Screen)
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $00, $00, $00, $00,  $00, $00, $00, $00
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff

            ; $0287/647               Background Color under Cursor
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $00
            ;  $028B   Repeat Key: Speed Counter
            ;  $028C   Repeat Key: First repeat delay Counter
            !byte $ff, $ff, $ff, $00,  $00, $ff, $ff, $ff

            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff

            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff

            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
            !byte $ff, $ff, $ff, $ff,  $ff, $ff, $ff, $ff
