        !to "via4.prg", cbm

TESTID =          4

tmp=$fc
addr=$fd
add2=$f9

ERRBUF=$5f00
TMP=$6000          ; measured data on C64 side
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
	;eor #$1
	;sta $dc0e       ; toggle timer A start/stop
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
	;eor #$1
	;sta $dc0e       ; toggle timer A start/stop
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
	;eor #$1
	;sta $dc0e       ; toggle timer A start/stop
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
	;eor #$1
	;sta $dc0e       ; toggle timer A start/stop
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
	;eor #$1
	;sta $dc0e       ; toggle timer A start/stop
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
	;eor #$1
	;sta $dc0e       ; toggle timer A start/stop
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

;------------------------------------------
	!zone {		; G
.test 	lda #1
	sta $1808       ; Timer B lo
	;lda #$11
	;sta $dc0f       ; start timer B continuous, force reload
	ldx #0
.t1b	lda $1808       ; Timer B lo
	sta DTMP,x
	;lda $dc0f
	;eor #$1
	;sta $dc0f       ; toggle timer B start/stop
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; H
.test 	lda #1
	sta $1808       ; Timer B lo
	;lda #$11
	;sta $dc0f       ; start timer B continuous, force reload
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	;lda $dc0f
	;eor #$1
	;sta $dc0f       ; toggle timer B start/stop
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; I
.test 	lda #1
	sta $1809       ; Timer B hi
	;lda #$11
	;sta $dc0f       ; start timer B continuous, force reload
	ldx #0
.t1b	lda $1808       ; Timer B lo
	sta DTMP,x
	;lda $dc0f
	;eor #$1
	;sta $dc0f       ; toggle timer B start/stop
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; J
.test 	lda #1
	sta $1809       ; Timer B hi
	;lda #$11
	;sta $dc0f       ; start timer B continuous, force reload
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	;lda $dc0f
	;eor #$1
	;sta $dc0f       ; toggle timer B start/stop
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; K
.test 	lda #1
	sta $1808       ; Timer B lo
	;lda #$11
	;sta $dc0f       ; start timer B continuous, force reload
	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	;lda $dc0f
	;eor #$1
	;sta $dc0f       ; toggle timer B start/stop
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; L
.test 	lda #1
	sta $1809       ; Timer B hi
	;lda #$11
	;sta $dc0f       ; start timer B continuous, force reload
	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	;lda $dc0f
	;eor #$1
	;sta $dc0f       ; toggle timer B start/stop
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

;------------------------------------------

;------------------------------------------
	!zone {		; M
.test 	lda #1
	sta $1804       ; Timer A lo
	;lda #$19
	;sta $dc0e       ; start timer A oneshot, force reload
	ldx #0
.t1b	lda $1804       ; Timer A lo
	sta DTMP,x
	;lda $dc0e
	;eor #$9
	;sta $dc0e       ; toggle timer A oneshot, start/stop
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; N
.test 	lda #1
	sta $1804       ; Timer A lo
	;lda #$19
	;sta $dc0e       ; start timer A oneshot, force reload
	ldx #0
.t1b	lda $1805       ; Timer A hi
	sta DTMP,x
	;lda $dc0e
	;eor #$9
	;sta $dc0e       ; toggle timer A oneshot, start/stop
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; O
.test 	lda #1
	sta $1805       ; Timer A hi
	;lda #$19
	;sta $dc0e       ; start timer A oneshot, force reload
	ldx #0
.t1b	lda $1804       ; Timer A lo
	sta DTMP,x
	;lda $dc0e
	;eor #$9
	;sta $dc0e       ; toggle timer A oneshot, start/stop
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; P
.test 	lda #1
	sta $1805       ; Timer A hi
	;lda #$19
	;sta $dc0e       ; start timer A oneshot, force reload
	ldx #0
.t1b	lda $1805       ; Timer A hi
	sta DTMP,x
	;lda $dc0e
	;eor #$9
	;sta $dc0e       ; toggle timer A oneshot, start/stop
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; Q
.test 	lda #1
	sta $1804       ; Timer A lo
	;lda #$19
	;sta $dc0e       ; start timer A oneshot, force reload
	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	;lda $dc0e
	;eor #$9
	;sta $dc0e       ; toggle timer A oneshot, start/stop
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; R
.test 	lda #1
	sta $1805       ; Timer A hi
	;lda #$19
	;sta $dc0e       ; start timer A oneshot, force reload
	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	;lda $dc0e
	;eor #$9
	;sta $dc0e       ; toggle timer A oneshot, start/stop
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

;------------------------------------------
	!zone {		; S
.test 	lda #1
	sta $1808       ; Timer B lo
	;lda #$19
	;sta $dc0f       ; start timer B oneshot, force reload
	ldx #0
.t1b	lda $1808       ; Timer B lo
	sta DTMP,x
	;lda $dc0f
	;eor #$9
	;sta $dc0f       ; toggle timer B oneshot, start/stop
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; T
.test 	lda #1
	sta $1808       ; Timer B lo
	;lda #$19
	;sta $dc0f       ; start timer B oneshot, force reload
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	;lda $dc0f
	;eor #$9
	;sta $dc0f       ; toggle timer B oneshot, start/stop
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; U
.test 	lda #1
	sta $1809       ; Timer B hi
	;lda #$19
	;sta $dc0f       ; start timer B oneshot, force reload
	ldx #0
.t1b	lda $1808       ; Timer B lo
	sta DTMP,x
	;lda $dc0f
	;eor #$9
	;sta $dc0f       ; toggle timer B oneshot, start/stop
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; V
.test 	lda #1
	sta $1809       ; Timer B hi
	;lda #$19
	;sta $dc0f       ; start timer B oneshot, force reload
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	;lda $dc0f
	;eor #$9
	;sta $dc0f       ; toggle timer B oneshot, start/stop
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; W
.test 	lda #1
	sta $1808       ; Timer B lo
	;lda #$19
	;sta $dc0f       ; start timer B oneshot, force reload
	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	;lda $dc0f
	;eor #$9
	;sta $dc0f       ; toggle timer B oneshot, start/stop
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; X
.test 	lda #1
	sta $1809       ; Timer B hi
	;lda #$19
	;sta $dc0f       ; start timer B oneshot, force reload
	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	;lda $dc0f
	;eor #$9
	;sta $dc0f       ; toggle timer B oneshot, start/stop
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

;        * = DATA
;        !bin "via4ref.bin", NUMTESTS * $0100, 2
