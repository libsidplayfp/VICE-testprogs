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

; set pulse width
    sta $d410
    sta $d411

; set testbit to reset noise and oscillator
    lda #$08
    sta $d412

; noise reg need some time to reset
!if NEWSID = 0 {
    ldy #1    ; wait ~1 sec for 6581
} else {
    ldy #10   ; wait ~10 sec for 8580
}
---
    ldx #60   ; sixty frames = 1 sec for NTSC, 1.2 sec for PAL
--
w1: bit $d011
    bpl w1
w2: bit $d011
    bmi w2
    dex
    bne --
    dey
    bne ---

; at this point all bit should be high

; set noise and testbit
    lda #$88
    sta $d412

; sanity check
; now we should read all ones
    lda $d41b
    sta $0400
    cmp #$ff
    bne nok

; set testbit and selected wave
    lda reference
    sta $d412

; release testbit
    lda reference+1
    sta $d412

; shift and check noise output several times
    ldy reference+2
    ldx #0
loop
; force another shift with noise only
    lda #$88
    sta $d412
    lda #$80
    sta $d412

; check
    lda $d41b
    sta $0401,x
    cmp reference+3,x
    bne nok

    inx
    dey
    bne loop

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
        !byte 10
        !byte $FE
        !byte $FC
        !byte $FC
        !byte $FC
        !byte $F8
        !byte $F8
        !byte $F8
        !byte $F8
        !byte $F0
        !byte $F0
    }

    !if WAVES = 1 {
        ; 8 -> 9
        !byte $88
        !byte $90
        !if NEWSID = 0 {
            !byte 10
        } else {
            !byte 8
        }
        !byte $FE
        !byte $6C
        !byte $D8
        !byte $B5
        !byte $D8
        !byte $6A
        !byte $B1
        !byte $F8
        !byte $07 ; *** unstable on 8580
        !byte $F0
    }

    !if WAVES = 2 {
        ; 8 -> a
        !byte $88
        !byte $A0
        !if NEWSID = 0 {
            !byte 10
        } else {
            !byte 8
        }
        !byte $FE
        !byte $6C
        !byte $D8
        !byte $B5
        !byte $D8
        !byte $6A
        !byte $B1
        !byte $F8
        !byte $07 ; *** unstable on 8580
        !byte $F0
    }

    !if WAVES = 3 {
        ; 8 -> b
        !byte $88
        !byte $B0
        !if NEWSID = 0 {
            !byte 10
        } else {
            !byte 8
        }
        !byte $FE
        !byte $6C
        !byte $D8
        !byte $B5
        !byte $D8
        !byte $6A
        !byte $B1
        !byte $F8
        !byte $07 ; *** unstable on 8580
        !byte $F0
    }

    !if WAVES = 4 {
        ; 8 -> c
        !byte $88
        !byte $C0
        !if NEWSID = 0 {
            !byte 10
            !byte $FE
            !byte $FC
            !byte $FC
            !byte $FC
            !byte $F8
            !byte $F8
            !byte $F8
            !byte $F8
            !byte $F0
            !byte $F0
        }
    }

    !if WAVES = 5 {
        ; 8 -> d
        !byte $88
        !byte $D0
        !if NEWSID = 0 {
            !byte 10
        } else {
            !byte 8
        }
        !byte $FE
        !byte $6C
        !byte $D8
        !byte $B5
        !byte $D8
        !byte $6A
        !byte $B1
        !byte $F8
        !byte $07 ; *** unstable on 8580
        !byte $F0
    }

    !if WAVES = 6 {
        ; 8 -> e
        !byte $88
        !byte $E0
        !if NEWSID = 0 {
            !byte 10
        } else {
            !byte 9
        }
        !byte $FE
        !byte $6C
        !byte $D8
        !byte $B5
        !byte $D8
        !byte $6A
        !byte $B1
        !byte $F8
        !byte $07 ; *** unstable on 8580
        !byte $F0
    }

    !if WAVES = 7 {
        ; 8 -> f
        !byte $88
        !byte $F0
        !byte 10
        !byte $FE
        !byte $6C
        !byte $D8
        !byte $B5
        !byte $D8
        !byte $6A
        !byte $B1
        !byte $F8
        !byte $07
        !byte $F0
    }

    !if WAVES = 8 {
        ; 9 -> 8
        !byte $98
        !byte $80
        !byte 10
        !byte $FE
        !byte $FC
        !byte $FC
        !byte $FC
        !byte $F8
        !byte $F8
        !byte $F8
        !byte $F8
        !byte $F0
        !byte $F0
    }

    !if WAVES = 9 {
        ; 9 -> 9
        !byte $98
        !byte $90
        !if NEWSID = 0 {
            !byte 10
        } else {
            !byte 7
        }
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07 ; *** unstable on 8580
        !byte $07
        !byte $62
    }

    !if WAVES = 10 {
        ; 9 -> a
        !byte $98
        !byte $A0
        !if NEWSID = 0 {
            !byte 10
            !byte $FE
            !byte $6C
            !byte $D8
            !byte $B5
            !byte $D8
            !byte $6A
            !byte $B1
            !byte $F8
            !byte $07
            !byte $F0
        }
    }

    !if WAVES = 11 {
        ; 9 -> b
        !byte $98
        !byte $B0
        !byte 10
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07
        !byte $07
        !byte $62
    }

    !if WAVES = 12 {
        ; 9 -> c
        !byte $98
        !byte $C0
        !if NEWSID = 0 {
            !byte 10
            !byte $FE
            !byte $FC
            !byte $FC
            !byte $FC
            !byte $F8
            !byte $F8
            !byte $F8
            !byte $F8
            !byte $F0
            !byte $F0
        }
    }

    !if WAVES = 13 {
        ; 9 -> d
        !byte $98
        !byte $D0
        !if NEWSID = 0 {
            !byte 10
        } else {
            !byte 7
        }
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07 ; *** unstable on 8580
        !byte $07
        !byte $62
    }

    !if WAVES = 14 {
        ; 9 -> e
        !byte $98
        !byte $E0
        !if NEWSID = 0 {
            !byte 10
            !byte $FE
            !byte $6C
            !byte $D8
            !byte $B5
            !byte $D8
            !byte $6A
            !byte $B1
            !byte $F8
            !byte $07
            !byte $F0
        }
    }

    !if WAVES = 15 {
        ; 9 -> f
        !byte $98
        !byte $F0
        !if NEWSID = 0 {
            !byte 10
        } else {
            !byte 8
        }
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07
        !byte $07 ; *** unstable on 8580
        !byte $62
    }

    !if WAVES = 16 {
        ; a -> 8
        !byte $A8
        !byte $80
        !byte 10
        !byte $FE
        !byte $FC
        !byte $FC
        !byte $FC
        !byte $F8
        !byte $F8
        !byte $F8
        !byte $F8
        !byte $F0
        !byte $F0
    }

    !if WAVES = 17 {
        ; a -> 9
        !byte $A8
        !byte $90
        !if NEWSID = 0 {
            !byte 10
            !byte $FE
            !byte $6C
            !byte $D8
            !byte $B5
            !byte $D8
            !byte $6A
            !byte $B1
            !byte $F8
            !byte $07
            !byte $F0
        } else {
            !byte 7
            !byte $6C
            !byte $48
            !byte $91
            !byte $91
            !byte $4A
            !byte $23
            !byte $B1
        }
    }

    !if WAVES = 18 {
        ; a -> a
        !byte $A8
        !byte $A0
        !byte 10
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07
        !byte $07
        !byte $62
    }

    !if WAVES = 19 {
        ; a -> b
        !byte $A8
        !byte $B0
        !if NEWSID = 0 {
            !byte 10
        } else {
            !byte 7
        }
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07 ; *** unstable on 8580
        !byte $07
        !byte $62
    }

    !if WAVES = 20 {
        ; a -> c
        !byte $A8
        !byte $C0
        !if NEWSID = 0 {
            !byte 10
            !byte $FE
            !byte $FC
            !byte $FC
            !byte $FC
            !byte $F8
            !byte $F8
            !byte $F8
            !byte $F8
            !byte $F0
            !byte $F0
        }
    }

    !if WAVES = 21 {
        ; a -> d
        !byte $A8
        !byte $D0
        !if NEWSID = 0 {
            !byte 10
            !byte $FE
            !byte $6C
            !byte $D8
            !byte $B5
            !byte $D8
            !byte $6A
            !byte $B1
            !byte $F8
            !byte $07
            !byte $F0
        } else {
            !byte 8
            !byte $6C
            !byte $48
            !byte $91
            !byte $91
            !byte $4A
            !byte $23
            !byte $B1
            !byte $07
        }
    }

    !if WAVES = 22 {
        ; a -> e
        !byte $A8
        !byte $E0
        !byte 10
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07
        !byte $07
        !byte $62
    }

    !if WAVES = 23 {
        ; a -> f
        !byte $A8
        !byte $F0
        !if NEWSID = 0 {
            !byte 10
        } else {
            !byte 7
        }
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07 ; *** unstable on 8580
        !byte $07
        !byte $62
    }

    !if WAVES = 24 {
        ; b -> 8
        !byte $B8
        !byte $80
        !if NEWSID = 0 {
            !byte 10
            !byte $FE
            !byte $FC
            !byte $FC
            !byte $FC
            !byte $F8
            !byte $F8
            !byte $F8
            !byte $F8
            !byte $F0
            !byte $F0
        }
    }

    !if WAVES = 25 {
        ; b -> 9
        !byte $B8
        !byte $90
        !if NEWSID = 0 {
            !byte 10
        } else {
            !byte 7
        }
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07 ; *** unstable on 8580
        !byte $07
        !byte $62
    }

    !if WAVES = 26 {
        ; b -> a
        !byte $B8
        !byte $A0
        !if NEWSID = 0 {
            !byte 10
        } else {
            !byte 7
        }
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07 ; *** unstable on 8580
        !byte $07
        !byte $62
    }

    !if WAVES = 27 {
        ; b -> b
        !byte $B8
        !byte $B0
        !byte 10
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07
        !byte $07
        !byte $62
    }

    !if WAVES = 28 {
        ; b -> c
        !byte $B8
        !byte $C0
        !if NEWSID = 0 {
            !byte 10
            !byte $FE
            !byte $FC
            !byte $FC
            !byte $FC
            !byte $F8
            !byte $F8
            !byte $F8
            !byte $F8
            !byte $F0
            !byte $F0
        }
    }

    !if WAVES = 29 {
        ; b -> d
        !byte $B8
        !byte $D0
        !if NEWSID = 0 {
            !byte 10
        } else {
            !byte 8
        }
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07
        !byte $07 ; *** unstable on 8580
        !byte $62
    }

    !if WAVES = 30 {
        ; b -> e
        !byte $B8
        !byte $E0
        !if NEWSID = 0 {
            !byte 10
        } else {
            !byte 8
        }
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07
        !byte $07 ; *** unstable on 8580
        !byte $62
    }

    !if WAVES = 31 {
        ; b -> f
        !byte $B8
        !byte $F0
        !if NEWSID = 0 {
            !byte 10
        } else {
            !byte 8
        }
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07
        !byte $07 ; *** unstable on 8580
        !byte $62
    }

    !if WAVES = 32 {
        ; c -> 8
        !byte $C8
        !byte $80
        !byte 10
        !byte $FE
        !byte $FC
        !byte $FC
        !byte $FC
        !byte $F8
        !byte $F8
        !byte $F8
        !byte $F8
        !byte $F0
        !byte $F0
    }

    !if WAVES = 33 {
        ; c -> 9
        !byte $C8
        !byte $90
        !if NEWSID = 0 {
            !byte 10
            !byte $FE
            !byte $6C
            !byte $D8
            !byte $B5
            !byte $D8
            !byte $6A
            !byte $B1
            !byte $F8
            !byte $07
            !byte $F0
        } else {
            !byte 7
            !byte $FC
            !byte $68
            !byte $D8
            !byte $B1
            !byte $D8
            !byte $62
            !byte $B1
            !byte $E4 ; *** unstable on 8580
        }
    }

    !if WAVES = 34 {
        ; c -> a
        !byte $C8
        !byte $A0
        !if NEWSID = 0 {
            !byte 10
        } else {
            !byte 8
        }
        !byte $FE
        !byte $6C
        !byte $D8
        !byte $B5
        !byte $D8
        !byte $6A
        !byte $B1
        !byte $F8
        !byte $07 ; *** unstable on 8580
        !byte $F0
    }

    !if WAVES = 35 {
        ; c -> b
        !byte $C8
        !byte $B0
        !if NEWSID = 0 {
            !byte 10
            !byte $FE
            !byte $6C
            !byte $D8
            !byte $B5
            !byte $D8
            !byte $6A
            !byte $B1
            !byte $F8
            !byte $07
            !byte $F0
        }
    }

    !if WAVES = 36 {
        ; c -> c
        !byte $C8
        !byte $C0
        !if NEWSID = 0 {
            !byte 10
            !byte $FE
            !byte $FC
            !byte $FC
            !byte $FC
            !byte $F8
            !byte $F8
            !byte $F8
            !byte $F8
            !byte $F0
            !byte $F0
        }
    }

    !if WAVES = 37 {
        ; c -> d
        !byte $C8
        !byte $D0
        !if NEWSID = 0 {
            !byte 10
            !byte $FE
            !byte $6C
            !byte $D8
            !byte $B5
            !byte $D8
            !byte $6A
            !byte $B1
            !byte $F8
            !byte $07
            !byte $F0
        }
    }

    !if WAVES = 38 {
        ; c -> e
        !byte $C8
        !byte $E0
        !byte 10
        !if NEWSID = 0 {
            !byte $FE
            !byte $6C
            !byte $D8
            !byte $B5
            !byte $D8
            !byte $6A
            !byte $B1
            !byte $F8
            !byte $07
            !byte $F0
        } else {
            !byte $FC
            !byte $68
            !byte $D8
            !byte $B1
            !byte $D8
            !byte $62
            !byte $B1
            !byte $E0
            !byte $07
            !byte $E0
        }
    }

    !if WAVES = 39 {
        ; c -> f
        !byte $C8
        !byte $F0
        !if NEWSID = 0 {
            !byte 10
            !byte $FE
            !byte $6C
            !byte $D8
            !byte $B5
            !byte $D8
            !byte $6A
            !byte $B1
            !byte $F8
            !byte $07
            !byte $F0
        } else {
            !byte 7
            !byte $6C
            !byte $48
            !byte $91
            !byte $91
            !byte $4A
            !byte $23
            !byte $B1
        }
    }

    !if WAVES = 40 {
        ; d -> 8
        !byte $D8
        !byte $80
        !byte 10
        !byte $FE
        !byte $FC
        !byte $FC
        !byte $FC
        !byte $F8
        !byte $F8
        !byte $F8
        !byte $F8
        !byte $F0
        !byte $F0
    }

    !if WAVES = 41 {
        ; d -> 9
        !byte $D8
        !byte $90
        !if NEWSID = 0 {
            !byte 10
        } else {
            !byte 8
        }
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07
        !byte $07 ; *** unstable on 8580
        !byte $62
    }

    !if WAVES = 42 {
        ; d -> a
        !byte $D8
        !byte $A0
        !if NEWSID = 0 {
            !byte 10
            !byte $FE
            !byte $6C
            !byte $D8
            !byte $B5
            !byte $D8
            !byte $6A
            !byte $B1
            !byte $F8
            !byte $07
            !byte $F0
        }
    }

    !if WAVES = 43 {
        ; d -> b
        !byte $D8
        !byte $B0
        !byte 10
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07
        !byte $07
        !byte $62
    }

    !if WAVES = 44 { ; seems unstable
        ; d -> c
        !byte $D8
        !byte $C0
        !if NEWSID = 0 {
            !byte 10
            !byte $FC
            !byte $F8
            !byte $F4
            !byte $F8
            !byte $E8
            !byte $F0
            !byte $F8
            !byte $C0
            !byte $F0
            !byte $E0
        }
    }

    !if WAVES = 45 {
        ; d -> d
        !byte $D8
        !byte $D0
        !byte 10
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07
        !byte $07
        !byte $62
    }

    !if WAVES = 46 { ; seems unstable
        ; d -> e
        !byte $D8
        !byte $E0
        !if NEWSID = 0 {
            !byte 10
            !byte $FC
            !byte $68
            !byte $D0
            !byte $B1
            !byte $C8
            !byte $62
            !byte $B1
            !byte $C0
            !byte $07
            !byte $E0
        }
    }

    !if WAVES = 47 {
        ; d -> f
        !byte $D8
        !byte $F0
        !byte 10
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07
        !byte $07
        !byte $62
    }

    !if WAVES = 48 {
        ; e -> 8
        !byte $E8
        !byte $80
        !byte 10
        !byte $FE
        !byte $FC
        !byte $FC
        !byte $FC
        !byte $F8
        !byte $F8
        !byte $F8
        !byte $F8
        !byte $F0
        !byte $F0
    }

    !if WAVES = 49 {
        ; e -> 9
        !byte $E8
        !byte $90
        !byte 10
        !if NEWSID = 0 {
            !byte $FE
            !byte $6C
            !byte $D8
            !byte $B5
            !byte $D8
            !byte $6A
            !byte $B1
            !byte $F8
            !byte $07
            !byte $F0
        } else {
            !byte $6C
            !byte $48
            !byte $91
            !byte $91
            !byte $4A
            !byte $23
            !byte $B1
            !byte $07
            !byte $07
            !byte $62
        }
    }

    !if WAVES = 50 {
        ; e -> a
        !byte $E8
        !byte $A0
        !byte 10
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07
        !byte $07
        !byte $62
    }

    !if WAVES = 51 {
        ; e -> b
        !byte $E8
        !byte $B0
        !if NEWSID = 0 {
            !byte 10
        } else {
            !byte 7
        }
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07 ; *** unstable on 8580
        !byte $07
        !byte $62
    }

    !if WAVES = 52 { ; seems unstable
        ; e -> c
        !byte $E8
        !byte $C0
        !if NEWSID = 0 {
            !byte 10
            !byte $FC
            !byte $F8
            !byte $F4
            !byte $F8
            !byte $E8
            !byte $F0
            !byte $F8
            !byte $C0
            !byte $F0
            !byte $E0
        }
    }

    !if WAVES = 53 {
        ; e -> d
        !byte $E8
        !byte $D0
        !if NEWSID = 1 {
            !byte 10
            !byte $6C
            !byte $48
            !byte $91
            !byte $91
            !byte $4A
            !byte $23
            !byte $B1
            !byte $07
            !byte $07
            !byte $62
        }
    }

    !if WAVES = 54 {
        ; e -> e
        !byte $E8
        !byte $E0
        !byte 10
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07
        !byte $07
        !byte $62
    }

    !if WAVES = 55 {
        ; e -> f
        !byte $E8
        !byte $F0
        !byte 10
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07
        !byte $07
        !byte $62
    }

    !if WAVES = 56 {
        ; f -> 8
        !byte $F8
        !byte $80
        !if NEWSID = 0 {
            !byte 10
            !byte $FE
            !byte $FC
            !byte $FC
            !byte $FC
            !byte $F8
            !byte $F8
            !byte $F8
            !byte $F8
            !byte $F0
            !byte $F0
        }
    }

    !if WAVES = 57 {
        ; f -> 9
        !byte $F8
        !byte $90
        !byte 10
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07
        !byte $07
        !byte $62
    }

    !if WAVES = 58 {
        ; f -> a
        !byte $F8
        !byte $A0
        !byte 10
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07
        !byte $07
        !byte $62
    }

    !if WAVES = 59 {
        ; f -> b
        !byte $F8
        !byte $B0
        !byte 10
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07
        !byte $07
        !byte $62
    }

    !if WAVES = 60 {
        ; f -> c
        !byte $F8
        !byte $C0
        !if NEWSID = 0 {
            !byte 10
            !byte $FC
            !byte $F8
            !byte $F4
            !byte $F8
            !byte $E8
            !byte $F0
            !byte $F8
            !byte $C0
            !byte $F0
            !byte $E0
        }
    }

    !if WAVES = 61 {
        ; f -> d
        !byte $F8
        !byte $D0
        !byte 10
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07
        !byte $07
        !byte $62
    }

    !if WAVES = 62 {
        ; f -> e
        !byte $F8
        !byte $E0
        !byte 10
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07
        !byte $07
        !byte $62
    }

    !if WAVES = 63 {
        ; f -> f
        !byte $F8
        !byte $F0
        !byte 10
        !byte $6C
        !byte $48
        !byte $91
        !byte $91
        !byte $4A
        !byte $23
        !byte $B1
        !byte $07
        !byte $07
        !byte $62
    }
