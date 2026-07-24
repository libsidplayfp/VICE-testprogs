
    * = 0 ; we start counting at 0
    !binary "testmem.tmp"

    !fill (4*254) - *, 0

    ; one or two extra buffer(s)
    !fill 254 * EXTRABUFFERS, 42

    ; fill one more buffer, so byte = offset in buffer
    !for i, 0, 253 {
        !byte i + 2
    }
