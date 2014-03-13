        !to "via3.prg", cbm

TESTID =          3

tmp=$fc
addr=$fd
add2=$f9

ERRBUF=$5f00
TMP=$8000
DATA=$9000

TESTLEN =         $20

NUMTESTS =        16

DTMP   = $0700          ; measured data on drive side
TESTSLOC = $1000


        !src "common.asm"


        * = TESTSLOC


	!zone {
.test 	lda #1
	sta $dc04
	lda #$1
	sta $dc0e
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test 	lda #1
	sta $dc04
	lda #$1
	sta $dc0e
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test 	lda #1
	sta $dc06
	lda #$1
	sta $dc0f
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test	lda #1
	sta $dc06
	lda #$1
	sta $dc0f
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test	lda #1
	sta $dc04
	lda #$11
	sta $dc0e
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test	lda #1
	sta $dc04
	lda #$11
	sta $dc0e
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test	lda #1
	sta $dc06
	lda #$11
	sta $dc0f
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test	lda #1
	sta $dc06
	lda #$11
	sta $dc0f
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test 	lda #1
	sta $dc05
	lda #$1
	sta $dc0e
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test 	lda #1
	sta $dc05
	lda #$1
	sta $dc0e
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test 	lda #1
	sta $dc07
	lda #$1
	sta $dc0f
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test	lda #1
	sta $dc07
	lda #$1
	sta $dc0f
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test	lda #1
	sta $dc05
	lda #$11
	sta $dc0e
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test	lda #1
	sta $dc05
	lda #$11
	sta $dc0e
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test	lda #1
	sta $dc06
	lda #$11
	sta $dc0f
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test	lda #1
	sta $dc06
	lda #$11
	sta $dc0f
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }
