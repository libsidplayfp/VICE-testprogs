;-------------------------------------------------------------------------------
; acme -DWAVES=0 -DNEWSID=0 -f cbm -o noise_writeback_check.prg noise_writeback_check.asm
;-------------------------------------------------------------------------------
            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-------------------------------------------------------------------------------

; disallow interrupts and disable screen to get stable timing
    sei
    lda #0
    sta $d011

; set frequency
    lda #$00
    sta $d40E
    sta $d40F

; set testbit to reset noise and oscillator
    lda #$08
    sta $d412

; noise reg need some time to reset
    ldy #$10
---
    ldx #$00
--
    lda #$f0
-
    cmp $d012
    bne -
    dex
    bne --
    dey
    bne ---

; at this point all bit should be high

; release testbit and set noise only
    lda #$80
    sta $d412

; sanity check
; after the first shift we should read all
; ones except for bit zero due to the XOR feedback
    lda $d41b
    sta $0400
    cmp #$fe
    bne nok

; set testbit
    lda reference
    sta $d412

; release testbit
    lda reference+1
    sta $d412

; force another shift with noise only
    lda #$88
    sta $d412
    lda #$80
    sta $d412

; check
    lda $d41b
    sta $0401
    cmp reference+2
    bne nok

; force another shift with noise only
    lda #$88
    sta $d412
    lda #$80
    sta $d412

; check again
    lda $d41b
    sta $0402
    cmp reference+3
    bne nok

; force another shift with noise only
    lda #$88
    sta $d412
    lda #$80
    sta $d412

; check again
    lda $d41b
    sta $0403
    cmp reference+4
    bne nok

; force another shift with noise only
    lda #$88
    sta $d412
    lda #$80
    sta $d412

; check again
    lda $d41b
    sta $0404
    cmp reference+5
    bne nok

; force another shift with noise only
    lda #$88
    sta $d412
    lda #$80
    sta $d412

; check again
    lda $d41b
    sta $0405
    cmp reference+6
    bne nok

ok:
    lda #5
    jmp prnt

nok:
    lda #2

prnt:
    sta $D020

    ldy #0      ; success
    lda $d020
    and #$0f
    cmp #5
    beq +
    ldy #$ff    ; failure
+
    sty $d7ff

; enable screen again to make result visible
    cli
    lda #$1b
    sta $d011

    jmp *

reference:
    !if WAVES = 0 {
        ; 8 -> 8
        !byte $88
        !byte $80
        !byte $fc
        !byte $fc
        !byte $fc
        !byte $f8
        !byte $f8
    }

    !if WAVES = 1 {
        ; 8 -> 9
        !byte $88
        !byte $90
        !byte $fc
        !byte $6c
        !byte $d8
        !byte $b1
        !byte $d8
    }

    !if WAVES = 2 {
        ; 8 -> c
        !byte $88
        !byte $c0
        !byte $fc
        !byte $fc
        !byte $fc
        !byte $f8
        !byte $f8
    }

    !if WAVES = 3 {
        ; 9 -> 8
        !byte $98
        !byte $80
        !if NEWSID = 0 {
            !byte $fc
            !byte $fc
            !byte $fc
            !byte $f8
            !byte $f8
        } else {
            !byte $7c
            !byte $f8
            !byte $fc
            !byte $f8
            !byte $f8
        }
    }

    !if WAVES = 4 {
        ; a -> 8
        !byte $a8
        !byte $80
        !byte $fc
        !byte $fc
        !byte $fc
        !byte $f8
        !byte $f8
    }

    !if WAVES = 5 {
        ; 9 -> 9
        !byte $98
        !byte $90
        !byte $6c
        !byte $48
        !byte $91
        !byte $91
        !byte $4a
    }

    !if WAVES = 6 {
        ; 9 -> a
        !byte $98
        !byte $a0
        !if NEWSID = 0 {
            !byte $fc
            !byte $6c
            !byte $d8
            !byte $b1
            !byte $d8
        } else {
            !byte $6c
            !byte $48
            !byte $91
            !byte $91
            !byte $4a
        }
    }

    !if WAVES = 7 {
        ; a -> 9
        !byte $a8
        !byte $90
        !if NEWSID = 0 {
            !byte $fc
            !byte $6c
            !byte $d8
            !byte $b1
            !byte $d8
        } else {
            !byte $6c
            !byte $48
            !byte $91
            !byte $91
            !byte $4a
        }
    }

    !if WAVES = 8 {
        ; a -> a
        !byte $a8
        !byte $a0
        !byte $6c
        !byte $48
        !byte $91
        !byte $91
        !byte $4a
    }

    !if WAVES = 9 {
        ; c -> c
        !byte $c8
        !byte $c0
        !if NEWSID = 0 {
            !byte $fc
            !byte $fc
            !byte $fc
            !byte $f8
            !byte $f8
        } else {
            !byte $fc
            !byte $68
            !byte $d8
            !byte $b1
            !byte $d8
        }
    }

    !if WAVES = 10 {
        ; d -> e
        !byte $d8
        !byte $e0
        !if NEWSID = 0 {
            !byte $fc
            !byte $68
            !byte $d0
            !byte $b1
            !byte $c8
        } else {
            !byte $6c
            !byte $48
            !byte $91
            !byte $91
            !byte $4a
        }
    }

    !if WAVES = 11 {
        ; e -> b
        !byte $e8
        !byte $b0
        !byte $6c
        !byte $48
        !byte $91
        !byte $91
        !byte $4a
    }

    !if WAVES = 12 {
        ; e -> d
        !byte $e8
        !byte $d0
        !if NEWSID = 0 {
            !byte $ec
            !byte $48
            !byte $d0
            !byte $91
            !byte $c8
        } else {
            !byte $6c
            !byte $48
            !byte $91
            !byte $91
            !byte $4a
        }
    }
