; related to https://sourceforge.net/p/vice-emu/bugs/2024/
rasterline = $fe

        * = $1000

start:  sei

        lda #$35
        sta $01

        bit $D012 ; wait for rasterline $100, before proceeding
        bpl *-3

        ; Setup a raster-interrupt
        sei
        lda #<irq
        sta $fffe
        lda #>irq
        sta $ffff
        ; select IRQ events (VIC: raster, CIA1: none)
        lda #%00000001 ; VIC:  raster-event
        sta $d01a
        lda #%00011111 ; CIA1: none
        sta $dc0d
        ; select rasterline in for the raster-event ($D012[w] and bit 7 of $D011[w])
        lda #<rasterline
        sta $d012
        lda $d011
        !if (rasterline >= $100) {ora #%10000000} else {and #%01111111}
        sta $d011

        ; ack any pending VIC and CIA1 events just in case
        bit $dc0d
        lda #%00001111
        sta $d019
        cli

break:  jmp *

irq:    eor #0      ; just to do something to make the interrupt-code easy to spot in the CPU-history
        inc $d020
        inc $d021
        inc $d019
endIrq: rti

otherCode:          ; This is where we "g XXXX" to
        inc bugDetect
        jmp break

bugDetect: !byte 0 ; Should stay 0 until AFTER the first interrupt. If it is 1 inside the first interrupt, we're doomed. (It actually becomes 2)
