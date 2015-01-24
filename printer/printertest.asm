
; simple printer test. expected output should look like this:

;13
;5

; note how no CR is sent after the last line


; x64 -default +virtualdev -pr4drv mps803 -device4 1 -pr4txtdev 0 -iecdevice4 -pr4output graphics  printertest.prg

; with device traps enabled:
; x64 -default -virtualdev -pr4drv mps803 -device4 1 -pr4txtdev 0 -iecdevice4 -pr4output graphics  printertest.prg


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
        lda #$31
        jsr $ffd2
        lda #$33
        jsr $ffd2
        lda #$0D
        jsr $ffd2
        lda #$35
        jsr $ffd2

close:
        lda #$04
        jsr $ffc3
        rts
