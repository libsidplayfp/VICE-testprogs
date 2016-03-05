        !to "via1.prg", cbm

TESTID = 1

tmp=$fc
addr=$fd
add2=$f9

TMP    = $8000          ; measured data on C64 side

TESTLEN = $20

NUMTESTS = 14 - 6

DTMP   = $0700          ; measured data on drive side

        !src "common.asm"

        !align 255,0
TESTSLOC

;-------------------------------------------------------------------------------
; before:
;       ---
; in the loop:
;       read [Timer A lo | Timer A hi | Timer A lo latch | Timer A hi latch | Timer B lo | Timer B hi]

        !zone {         ; A
.test    ldx #0
.t1b     lda $1804       ; Timer A lo
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; B
.test    ldx #0
.t1b     lda $1805       ; Timer A hi
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; C
.test    ldx #0
.t1b     lda $1806       ; Timer A latch lo
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; D
.test    ldx #0
.t1b     lda $1807       ; Timer A latch hi
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; E
.test    ldx #0
.t1b     lda $1808       ; Timer B lo
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; F
.test    ldx #0
.t1b     lda $1809       ; Timer B hi
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

;-------------------------------------------------------------------------------
; before:
;       start Timer B (switch to count clock cycles)
; in the loop:
;       read [Timer B lo | Timer B hi]

        !zone {         ; G
.test   ;lda #$1
        ;sta $dc0f       ; start timer B continuous
        lda #%00000000
        sta $180b

        ldx #0
.t1b     lda $1808       ; Timer B lo
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; H
.test   ;lda #$1
        ;sta $dc0f       ; start timer B continuous
        lda #%00000000
        sta $180b

        ldx #0
.t1b     lda $1809       ; Timer B hi
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

;-------------------------------------------------------------------------------

DATA
        !bin "via1ref.bin", NUMTESTS * $0100, 2
ERRBUF
