        * = $1000
start:
        sei

        lda #$35
        sta $01

        lda #$7f
        sta $dc0d

        bit $D011
        bpl *-3
        bit $D011
        bmi *-3

        lda #<irq
        sta $fffe
        lda #>irq
        sta $ffff

        lda #$01
        sta $d012
        lda #$1b
        sta $d011

        lda #$01
        sta $d01a

firstbp:
; produces a label al C:0064 .1
        !for n, 1, 100 {
             nop
         }
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
            nop
        jmp *

irq:    eor #0      ; just to do something to make the interrupt-code easy to spot in the CPU-history
        inc $d020
        inc $d021
        inc $d019
endIrq: rti

otherCode:          ; This is where we "g XXXX" to
        inc bugDetect
        jmp firstbp

bugDetect:
        !byte 0     ; Should stay 0 until AFTER the first interrupt.
                    ; If it is 1 inside the first interrupt, we're doomed. (It actually becomes 2)
