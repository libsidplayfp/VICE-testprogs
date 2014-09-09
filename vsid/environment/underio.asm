
realstart       = $0f00
realinit        = $1000
realplay        = $1003

;headerversion   = $0002

cleanimage      = 1     ; does not use memory outside loading range

imagestart      = $0800
imageend        = $f000

    !src "header.asm"

;-------------------------------------------------------------------------------

    * = imagestart
    !text "test1234"

    ; include calypso sid binary ($0f00 - ~$4000)
    * = realstart
    !binary "Calypso.sid" ,, $7c + 2 ; skip psid header and load address

    * = $cf00
_init
        pha
        lda #$35
        sta $01
        pla
        jmp realinit
_play
        lda #$35
        sta $01
        jmp realplay

    * = $df00
init
        jmp _init
play
        jmp _play

    * = imageend
    !byte 0
