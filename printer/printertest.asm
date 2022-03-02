
; simple printer test.

; due to the missing CR after the last "5", on first run the program will only
; print "13", followed by CR. the "5" is stuck in the buffer and wont get
; printed until another "CR" was sent, or the buffer is flushed by other means.

; see https://sourceforge.net/p/vice-emu/bugs/597/

; x64 -default +virtualdev4 -pr4drv mps803 -device4 1 -pr4txtdev 0 -iecdevice4 -pr4output graphics  printertest.prg

; with device traps enabled:
; x64 -default -virtualdev4 -pr4drv mps803 -device4 1 -pr4txtdev 0 -iecdevice4 -pr4output graphics  printertest.prg


            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-------------------------------------------------------------------------------
            jmp start

        *=$0900
start:

open:
        lda #$04
        ldx #$04
        ldy #$00
        jsr $ffba
        jsr $ffc0

        ldx #$04
        jsr $ffc9

print:
        lda #$31        ; "1"
        jsr $ffd2
        lda #$33        ; "3"
        jsr $ffd2
        lda #$0D        ; CR
        jsr $ffd2
        lda #$35        ; "5"
        jsr $ffd2

close:
        lda #$04
        jsr $ffc3
        rts
