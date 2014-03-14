        !to "via1.prg", cbm

TESTID = 1

tmp=$fc
addr=$fd
add2=$f9

ERRBUF = $5f00
TMP    = $8000          ; measured data on C64 side
DATA   = $9000

TESTLEN = $20

NUMTESTS = 12

DTMP   = $0700          ; measured data on drive side
TESTSLOC = $1000

        !src "common.asm"

        * = TESTSLOC

        !zone {
.test    ldx #0
.t1b     lda $1804       ; Timer A lo
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test    ldx #0
.t1b     lda $1805       ; Timer A hi
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test    ldx #0
.t1b     lda $1808       ; Timer B lo
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test    ldx #0
.t1b     lda $1809       ; Timer B hi
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test   ;lda #$1
        ;sta $dc0e       ; start timer A continuous
        ldx #0
.t1b     lda $1804       ; Timer A lo
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test   ;lda #$1
        ;sta $dc0e       ; start timer A continuous
        ldx #0
.t1b     lda $1805       ; Timer A hi
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test   ;lda #$1
        ;sta $dc0f       ; start timer B continuous
        ldx #0
.t1b     lda $1808       ; Timer B lo
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test   ;lda #$1
        ;sta $dc0f       ; start timer B continuous
        ldx #0
.t1b     lda $1809       ; Timer B hi
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test   ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        ldx #0
.t1b     lda $1804       ; Timer A lo
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test   ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        ldx #0
.t1b     lda $1805       ; Timer A hi
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test   ;lda #$11
        ;sta $dc0f       ; start timer B continuous, force reload
        ldx #0
.t1b     lda $1808       ; Timer B lo
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test   ;lda #$11
        ;sta $dc0f       ; start timer B continuous, force reload
        ldx #0
.t1b     lda $1809       ; Timer B hi
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }


 
