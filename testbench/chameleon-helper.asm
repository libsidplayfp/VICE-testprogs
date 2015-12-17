
        *=$0801

        !word link
        !word 42        ; 42
        !byte $9e       ; SYS
        !text "2061"    ; 2061
        !byte 0
link:   !word 0

        sei
        inc $d020
        lda #42
        sta $d0fe       ; enable config mode
        lda #$22        ; MMU and I/O RAM
        sta $d0fa       ; enable config registers
        lda #$27        ; MMU Slot for I/O RAM
        sta $d0af
        lda #0
        ldx #1
        ; there is free memory at 0x00010000
        sta $d0a0
        sta $d0a1
        stx $d0a2
        sta $d0a3
        dec $d020
        lda #0
        sta $d7ff
        cli
        rts