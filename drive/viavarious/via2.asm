        !to "via2.prg", cbm

TESTID = 2

tmp =$fc
addr=$fd
add2=$f9

ERRBUF=$5f00
TMP=$8000
DATA=$9000

TESTLEN =        $20

NUMTESTS =       16

DTMP   = $0700          ; measured data on drive side
TESTSLOC = $1000


        !src "common.asm"


        * = TESTSLOC


        !zone {
.test    lda #1
        sta $1804       ; Timer A lo
        ;lda #$1
        ;sta $dc0e       ; start timer A continuous
        ldx #0
.t1b     lda $1804      ; Timer A lo
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test    lda #1
        sta $1804
        ;lda #$1
        ;sta $dc0e       ; start timer A continuous
        ldx #0
.t1b     lda $1805
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test    lda #1
        sta $1808
        ;lda #$1
        ;sta $dc0f       ; start timer B continuous
        ldx #0
.t1b     lda $1808
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test    lda #1
        sta $1808
        ;lda #$1
        ;sta $dc0f       ; start timer B continuous
        ldx #0
.t1b     lda $1809
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test    lda #1
        sta $1804
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        ldx #0
.t1b     lda $1804
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test    lda #1
        sta $1804
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        ldx #0
.t1b     lda $1805
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test    lda #1
        sta $1808
        ;lda #$11
        ;sta $dc0f       ; start timer B continuous, force reload
        ldx #0
.t1b     lda $1808
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test    lda #1
        sta $1808
        ;lda #$11
        ;sta $dc0f       ; start timer B continuous, force reload
        ldx #0
.t1b     lda $1809
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test    lda #1
        sta $1805
        ;lda #$1
        ;sta $dc0e       ; start timer A continuous
        ldx #0
.t1b     lda $1804
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test    lda #1
        sta $1805
        ;lda #$1
        ;sta $dc0e       ; start timer A continuous
        ldx #0
.t1b     lda $1805
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test    lda #1
        sta $1809
        ;lda #$1
        ;sta $dc0f       ; start timer B continuous
        ldx #0
.t1b     lda $1808
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test    lda #1
        sta $1809
        ;lda #$1
        ;sta $dc0f       ; start timer B continuous
        ldx #0
.t1b     lda $1809
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test    lda #1
        sta $1805
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        ldx #0
.t1b     lda $1804
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test    lda #1
        sta $1805
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        ldx #0
.t1b     lda $1805
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test    lda #1
        sta $1808
        ;lda #$11
        ;sta $dc0f       ; start timer B continuous, force reload
        ldx #0
.t1b     lda $1808
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {
.test    lda #1
        sta $1808
        ;lda #$11
        ;sta $dc0f       ; start timer B continuous, force reload
        ldx #0
.t1b     lda $1809
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

 
