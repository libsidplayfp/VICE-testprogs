        !to "via7.prg", cbm

TESTID =          7

tmp=$fc
addr=$fd
add2=$f9

ERRBUF=$5f00
TMP=$6000
DATA=$8000

TESTLEN = $40

NUMTESTS =        16

DTMP   = $0700          ; measured data on drive side
TESTSLOC = $1000


        !src "common.asm"


        * = TESTSLOC

;------------------------------------------
	!zone {		; A
.test 	lda #1
	sta $1809       ; Timer B hi
	lda #$51	; cascade mode
	sta $dc0f
	lda #1
	sta $1804       ; Timer A lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; B
.test 	lda #1
	sta $1809       ; Timer B hi
	lda #$51	; cascade mode
	sta $dc0f
	lda #1
	sta $1805       ; Timer A hi
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; C
.test 	lda #1
	sta $1809       ; Timer B hi
	lda #$71	; cascade mode with CNT=1
	sta $dc0f
	lda #1
	sta $1804       ; Timer A lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; D
.test 	lda #1
	sta $1809       ; Timer B hi
	lda #$71	; cascade mode with CNT=1
	sta $dc0f
	lda #1
	sta $1805       ; Timer A hi
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; E
.test 	lda #1
	sta $1808       ; Timer B lo
	lda #$51	; cascade mode
	sta $dc0f
	lda #1
	sta $1804       ; Timer A lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; F
.test 	lda #1
	sta $1808       ; Timer B lo
	lda #$51	; cascade mode
	sta $dc0f
	lda #1
	sta $1805       ; Timer A hi
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; G
.test 	lda #1
	sta $1808       ; Timer B lo
	lda #$51	; cascade mode
	sta $dc0f
	lda #1
	sta $1804       ; Timer A lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	;lda $dc0e
	;eor #1
	;sta $dc0e       ; toggle timer A start/stop
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; H
.test 	lda #1
	sta $1808       ; Timer B lo
	lda #$51	; cascade mode
	sta $dc0f
	lda #1
	sta $1805       ; Timer A hi
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	lda $dc0e
	eor #1
	sta $dc0e
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; I
.test 	lda #1
	sta $1808       ; Timer B lo
	lda #$51	; cascade mode
	sta $dc0f
	lda #1
	sta $1804       ; Timer A lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	;lda $dc0f
	;eor #1
	;sta $dc0f       ; toggle timer B start/stop
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; J
.test 	lda #1
	sta $1808       ; Timer B lo
	lda #$51	; cascade mode
	sta $dc0f
	lda #1
	sta $1805       ; Timer A hi
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	;lda $dc0f
	;eor #1
	;sta $dc0f       ; toggle timer B start/stop
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; K
.test 	lda #1
	sta $1808       ; Timer B lo
	lda #$51	; cascade mode
	sta $dc0f
	lda #1
	sta $1804       ; Timer A lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	;lda $dc0f
	;eor #$20
	;sta $dc0f       ; toggle timer B counts CNT/Clock
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; L
.test 	lda #1
	sta $1808       ; Timer B lo
	lda #$51	; cascade mode
	sta $dc0f
	lda #1
	sta $1805       ; Timer A hi
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	;lda $dc0f
	;eor #$20
	;sta $dc0f       ; toggle timer B counts CNT/Clock
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; M
.test 	lda #1
	sta $1808       ; Timer B lo
	lda #$51	; cascade mode
	sta $dc0f
	lda #1
	sta $1804       ; Timer A lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	;lda $dc0f
	;eor #$40
	;sta $dc0f       ; toggle timer B counts Timer A/Clock
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; N
.test 	lda #1
	sta $1808       ; Timer B lo
	lda #$51	; cascade mode
	sta $dc0f
	lda #1
	sta $1805       ; Timer A hi
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	;lda $dc0f
	;eor #$40
	;sta $dc0f       ; toggle timer B counts Timer A/Clock
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; O
.test 	lda #1
	sta $1808       ; Timer B lo
	lda #$51	; cascade mode
	sta $dc0f
	lda #1
	sta $1804       ; Timer A lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	;lda $dc0f
	;eor #$40
	;sta $dc0f       ; toggle timer B counts timer A/Clock
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; P
.test 	lda #1
	sta $1808       ; Timer B lo
	lda #$51	; cascade mode
	sta $dc0f
	lda #1
	sta $1805       ; Timer A hi
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	;lda $dc0f
	;eor #$10
	;sta $dc0f       ; toggle timer B force load
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }


