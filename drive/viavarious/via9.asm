        !to "via9.prg", cbm

TESTID =          9

tmp=$fc
addr=$fd
add2=$f9

ERRBUF=$5f00
TMP=$6000
DATA=$8000

TESTLEN =         $20

NUMTESTS =        6

DTMP   = $0700          ; measured data on drive side
TESTSLOC = $1000


        !src "common.asm"


        * = TESTSLOC

;------------------------------------------
	!zone {		; A
.test 	lda #1
	sta $dc04
	lda #$11
	sta $dc0e
	ldx #0
.t1b	lda $dc04
	sta DTMP,x
	lda $dc0e
	eor #$20
	sta $dc0e
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; B
.test 	lda #1
	sta $dc04
	lda #$11
	sta $dc0e
	ldx #0
.t1b	lda $dc05
	sta DTMP,x
	lda $dc0e
	eor #$20
	sta $dc0e
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; C
.test 	lda #1
	sta $dc04
	lda #$11
	sta $dc0e
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	lda $dc0e
	eor #$20
	sta $dc0e
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; D
.test 	lda #1
	sta $dc05
	lda #$11
	sta $dc0e
	ldx #0
.t1b	lda $dc04
	sta DTMP,x
	lda $dc0e
	eor #$20
	sta $dc0e
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; E
.test 	lda #1
	sta $dc05
	lda #$11
	sta $dc0e
	ldx #0
.t1b	lda $dc05
	sta DTMP,x
	lda $dc0e
	eor #$20
	sta $dc0e
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; F
.test 	lda #1
	sta $dc05
	lda #$11
	sta $dc0e
	ldx #0
.t1b	lda $dc0d
	sta DTMP,x
	lda $dc0e
	eor #$20
	sta $dc0e
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

