        !to "via2.prg", cbm

TESTID = 2

tmp =$fc
addr=$fd
add2=$f9

ERRBUF=$5f00
TMP=$8000          ; measured data on C64 side
DATA=$9000

TESTLEN =        $20

NUMTESTS =       16 - 4

DTMP   = $0700          ; measured data on drive side
TESTSLOC = $1000


        !src "common.asm"


        * = TESTSLOC

;------------------------------------------
; before:
;       [Timer A lo | Timer A hi] = 1
; in the loop:
;       read [Timer A lo | Timer A hi | Timer A latch lo | Timer A latch hi]

        !zone {         ; A
.test   lda #1
        sta $1804        ; Timer A lo
        ;lda #$1
        ;sta $dc0e       ; start timer A continuous
        ldx #0
.t1b    lda $1804        ; Timer A lo
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; B
.test   lda #1
        sta $1804        ; Timer A lo
        ;lda #$1
        ;sta $dc0e       ; start timer A continuous
        ldx #0
.t1b    lda $1805        ; Timer A hi
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; C
.test   lda #1
        sta $1804
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        ldx #0
.t1b    lda $1806        ; Timer A latch lo
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; D
.test   lda #1
        sta $1804
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        ldx #0
.t1b    lda $1807        ; Timer A latch hi
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        ;-----------------------------------

        !zone {         ; E
.test   lda #1
        sta $1805        ; Timer A hi
        ;lda #$1
        ;sta $dc0e       ; start timer A continuous
        ldx #0
.t1b    lda $1804
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; F
.test    lda #1
        sta $1805
        ;lda #$1
        ;sta $dc0e       ; start timer A continuous
        ldx #0
.t1b    lda $1805
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; G
.test   lda #1
        sta $1805
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        ldx #0
.t1b    lda $1806
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; H
.test    lda #1
        sta $1805
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        ldx #0
.t1b    lda $1807
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

;------------------------------------------
; before:
;       [Timer B lo | Timer B hi] = 1
;       start Timer B (switch to count clock cycles)
; in the loop:
;       read [Timer B lo | Timer B hi]


        !zone {         ; I
.test   lda #1
        sta $1808        ; Timer B lo
        ;lda #$1
        ;sta $dc0f       ; start timer B continuous
        lda #%00000000
        sta $180b
        ldx #0
.t1b    lda $1808        ; Timer B lo
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; J
.test    lda #1
        sta $1808        ; Timer B lo
        ;lda #$1
        ;sta $dc0f       ; start timer B continuous
        lda #%00000000
        sta $180b
        ldx #0
.t1b     lda $1809
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; K
.test    lda #1
        sta $1809
        ;lda #$1
        ;sta $dc0f       ; start timer B continuous
        lda #%00000000
        sta $180b
        ldx #0
.t1b     lda $1808
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; L
.test    lda #1
        sta $1809
        ;lda #$1
        ;sta $dc0f       ; start timer B continuous
        lda #%00000000
        sta $180b
        ldx #0
.t1b     lda $1809
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        * = DATA
        !bin "via2ref.bin", NUMTESTS * $0100, 2
