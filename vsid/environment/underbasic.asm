
realstart       = $0f00
realinit        = $1000
realplay        = $1003

;headerversion   = $0002

cleanimage      = 1     ; does not use memory outside loading range

imagestart      = $0800
imageend        = $bfff

    !src "header.asm"

;-------------------------------------------------------------------------------

    * = imagestart
    !text "test1234"

    ; include calypso sid binary ($0f00 - ~$4000)
    * = realstart
    !binary "Calypso.sid" ,, $7c + 2 ; skip psid header and load address

    * = $b000
init
        jmp realinit
play
        jmp realplay

    * = imageend
    !byte 0
