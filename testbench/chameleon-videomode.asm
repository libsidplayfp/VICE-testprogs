; $0400 if != $20 then videomode is NTSC

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

        lda #%11000000  ; PAL
        ldx $0400
        cpx #$20
        beq +
        lda #%11000010  ; NTSC
+
        sta $d0f2       ; set vic-ii emulation

        lda #$27        ; MMU Slot for I/O RAM
        sta $d0af
        lda #0
        ldx #1
        ; there is free memory at 0x00010000
        sta $d0a0
        sta $d0a1
        stx $d0a2
        sta $d0a3

        lda #0          ; return code = 0
        sta $d7ff

        sta $d0ff       ; leave config mode
        
        dec $d020
        cli
        rts
