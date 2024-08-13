
        * = $0801
        !word eol,0
        !byte $9e, $32,$30,$36,$31, 0 ; sys 2061
eol:    !word 0

;------------------------------------------------------------------------------

        sei
        lda #$35
        sta $01
        lda #>irq
        ldx #<irq
        sta $ffff
        stx $fffe

        ldx #0
-       lda #$20
        sta $0400,x
        sta $0500,x
        sta $0600,x
        sta $0700,x
        lda #$01
        sta $d800,x
        sta $d900,x
        sta $da00,x
        sta $db00,x
        inx
        bne -

        lda #0      ; all timers off
        sta $dc0e
        sta $dc0f

        lda #$00
        sta $dc05
        lda #$ff
        sta $dc04

        lda #%00010001
        sta $dc0e

        lda #$81
        sta $dc0d

        lda #$1b
        sta $d011  ; clear bit 8 of irq raster line
        lda #$01
        sta $d01a  ; enable raster irq...
        lda #$5b
        sta $d012  ; ... at raster line 91

        ; wait for raster irq to trigger at least once
-       cmp $d012
        bne -

        cli        ; enable interrupts

        ; these opcodes will be incorrectly executed
        sta $0400
        sta $0401

        sei
        ; signal failure
        lda #$ff
        sta $d7ff
        lda #2
        sta $d020

        jmp *

irq:
        pha
        lda $d019           ; Raster flag in bit0
        lsr
        bcs israster

        lda $dc0d           ; ACK CIA1 Irq, TimerA flag in bit0
        lsr
        bcs istimer

        inc $0428
        pla
        ;rti
        plp ; pull status, irq should trigger after this
        sta $0400+(2*40)
        sei
        ; signal failure
        lda #$ff
        sta $d7ff
        lda #2
        sta $d020
        jmp *


istimer:
        inc $0429
        pla
        ;rti
        plp ; pull status, irq should trigger after this
        sta $0400+(3*40)
        sei
        ; signal failure
        lda #$ff
        sta $d7ff
        lda #2
        sta $d020
        jmp *

israster:
        inc $042a

        lda $dc0d           ; ACK CIA1 Irq, TimerA flag in bit0
        lsr
        bcs istimer2

        pla
        ;rti
        plp ; pull status, irq should trigger after this
        sta $0400+(4*40)
        sei
        ; signal failure
        lda #$ff
        sta $d7ff
        lda #2
        sta $d020
        jmp *

istimer2:
        inc $042c

        bne +
        ; signal pass
        lda #$00
        sta $d7ff
        lda #5
        sta $d020

        jmp *
+
        pla
        ;rti
        plp ; pull status, irq should trigger after this
        sta $0400+(5*40)
        sei
        ; signal failure
        lda #$ff
        sta $d7ff
        lda #2
        sta $d020
        jmp *
