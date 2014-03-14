        !to "via5.prg", cbm

TESTID =          5

tmp=$fc
addr=$fd
add2=$f9

ERRBUF=$5f00
TMP=$6000
DATA=$8000

TESTLEN =         $20

NUMTESTS =        24

DTMP   = $0700          ; measured data on drive side
TESTSLOC = $1000


        !src "common.asm"


        * = TESTSLOC

;------------------------------------------
	!zone {		; A
.test 	lda #1
	sta $1804       ; Timer A lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1804       ; Timer A lo
	sta DTMP,x
	;lda $dc0e
	;eor #$10
	;sta $dc0e       ; toggle timer A force reload
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; B
.test 	lda #1
	sta $1804       ; Timer A lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1805       ; Timer A hi
	sta DTMP,x
	;lda $dc0e
	;eor #$10
	;sta $dc0e       ; toggle timer A force reload
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; C
.test 	lda #1
	sta $1805       ; Timer A hi
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1804       ; Timer A lo
	sta DTMP,x
	;lda $dc0e
	;eor #$10
	;sta $dc0e       ; toggle timer A force reload
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; D
.test 	lda #1
	sta $1805       ; Timer A hi
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1805       ; Timer A hi
	sta DTMP,x
	;lda $dc0e
	;eor #$10
	;sta $dc0e       ; toggle timer A force reload
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; E
.test 	lda #1
	sta $1804       ; Timer A lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	;lda $dc0e
	;eor #$10
	;sta $dc0e       ; toggle timer A force reload
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; F
.test 	lda #1
	sta $1805       ; Timer A hi
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	;lda $dc0e
	;eor #$10
	;sta $dc0e       ; toggle timer A force reload
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

;------------------------------------------
	!zone {		; G
.test 	lda #1
	sta $1808       ; Timer B lo
	lda #$11
	sta $dc0f
	ldx #0
.t1b	lda $1808       ; Timer B lo
	sta DTMP,x
	;lda $dc0f
	;eor #$10
	;sta $dc0f       ; toggle timer B force reload
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; H
.test 	lda #1
	sta $1808       ; Timer B lo
	lda #$11
	sta $dc0f
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	;lda $dc0f
	;eor #$10
	;sta $dc0f       ; toggle timer B force reload
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; I
.test 	lda #1
	sta $1809       ; Timer B hi
	lda #$11
	sta $dc0f
	ldx #0
.t1b	lda $1808       ; Timer B lo
	sta DTMP,x
	;lda $dc0f
	;eor #$10
	;sta $dc0f       ; toggle timer B force reload
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; J
.test 	lda #1
	sta $1809       ; Timer B hi
	lda #$11
	sta $dc0f
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	;lda $dc0f
	;eor #$10
	;sta $dc0f       ; toggle timer B force reload
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; K
.test 	lda #1
	sta $1808       ; Timer B lo
	lda #$11
	sta $dc0f
	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	;lda $dc0f
	;eor #$10
	;sta $dc0f       ; toggle timer B force reload
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; L
.test 	lda #1
	sta $1809       ; Timer B hi
	lda #$11
	sta $dc0f
	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	;lda $dc0f
	;eor #$10
	;sta $dc0f       ; toggle timer B force reload
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

;------------------------------------------

;------------------------------------------
	!zone {		; M
.test 	ldx #0
.l1	stx $1804       ; Timer A lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	lda $1804       ; Timer A lo
	sta DTMP,x
	inx
	bne .l1
	rts
        * = .test+TESTLEN
        }

	!zone {		; N
.test 	ldx #0
.l1	stx $1804       ; Timer A lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	lda $1805       ; Timer A hi
	sta DTMP,x
	inx
	bne .l1
	rts
        * = .test+TESTLEN
        }

	!zone {		; O
.test 	ldx #0
.l1	stx $1805       ; Timer A hi
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	lda $1804       ; Timer A lo
	sta DTMP,x
	inx
	bne .l1
	rts
        * = .test+TESTLEN
        }

	!zone {		; P
.test 	ldx #0
.l1	stx $1805       ; Timer A hi
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	lda $1805       ; Timer A hi
	sta DTMP,x
	inx
	bne .l1
	rts
        * = .test+TESTLEN
        }

	!zone {		; Q
.test 	ldx #0
.l1	stx $1805       ; Timer A hi
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .l1
	rts
        * = .test+TESTLEN
        }

	!zone {		; R
.test 	ldx #0
.l1	stx $1805       ; Timer A hi
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .l1
	rts
        * = .test+TESTLEN
        }

;------------------------------------------

	!zone {		; S
.test 	ldx #0
.l1	stx $1808       ; Timer B lo
	;lda #$11
	;sta $dc0f       ; start timer B continuous, force reload
	lda $1808       ; Timer B lo
	sta DTMP,x
	inx
	bne .l1
	rts
        * = .test+TESTLEN
        }

	!zone {		; T
.test 	ldx #0
.l1	stx $1808       ; Timer B lo
	;lda #$11
	;sta $dc0f       ; start timer B continuous, force reload
	lda $1809       ; Timer B hi
	sta DTMP,x
	inx
	bne .l1
	rts
        * = .test+TESTLEN
        }

	!zone {		; U
.test 	ldx #0
.l1	stx $1809       ; Timer B hi
	;lda #$11
	;sta $dc0f       ; start timer B continuous, force reload
	lda $1808       ; Timer B lo
	sta DTMP,x
	inx
	bne .l1
	rts
        * = .test+TESTLEN
        }

	!zone {		; V
.test 	ldx #0
.l1	stx $1809       ; Timer B hi
	;lda #$11
	;sta $dc0f       ; start timer B continuous, force reload
	lda $1809       ; Timer B hi
	sta DTMP,x
	inx
	bne .l1
	rts
        * = .test+TESTLEN
        }

	!zone {		; W
.test 	ldx #0
.l1	stx $1809       ; Timer B hi
	;lda #$11
	;sta $dc0f       ; start timer B continuous, force reload
	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .l1
	rts
        * = .test+TESTLEN
        }

	!zone {		; X
.test 	ldx #0
.l1	stx $1809       ; Timer B hi
	;lda #$11
	;sta $dc0f       ; start timer B continuous, force reload
	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .l1
	rts
        * = .test+TESTLEN
        }
