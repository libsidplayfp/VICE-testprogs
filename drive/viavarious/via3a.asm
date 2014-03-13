        !to "via3a.prg", cbm

TESTID =          $3a

tmp=$fc
addr=$fd
add2=$f9

ERRBUF=$5f00
TMP=$6000
DATA=$8000

TESTLEN =         $20

NUMTESTS =        16

DTMP   = $0700          ; measured data on drive side
TESTSLOC = $1000


        !src "common.asm"


        * = TESTSLOC


	!zone {		; A
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

	!zone {		; B
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

	!zone {		; C
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

	!zone {		; D
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

	!zone {		; E
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

	!zone {		; F
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

	!zone {		; G
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

	!zone {		; H
.test	lda #1
	sta $dc07
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

	!zone {		; I
.test 	lda #1
	sta $dc04
	lda #$9
	sta $dc0e
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; J
.test 	lda #1
	sta $dc05
	lda #$9
	sta $dc0e
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; K
.test 	lda #1
	sta $dc06
	lda #$9
	sta $dc0f
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; L
.test	lda #1
	sta $dc07
	lda #$9
	sta $dc0f
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; M
.test	lda #1
	sta $dc04
	lda #$19
	sta $dc0e
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; N
.test	lda #1
	sta $dc05
	lda #$19
	sta $dc0e
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; O
.test	lda #1
	sta $dc06
	lda #$19
	sta $dc0f
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; P
.test	lda #1
	sta $dc06
	lda #$19
	sta $dc0f
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }
