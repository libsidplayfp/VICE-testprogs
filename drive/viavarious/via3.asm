        !to "via3.prg", cbm

TESTID =          3

tmp=$fc
addr=$fd
add2=$f9

ERRBUF=$5f00
TMP=$8000          ; measured data on C64 side
DATA=$9000

TESTLEN =         $20

NUMTESTS =        16

DTMP   = $0700          ; measured data on drive side
TESTSLOC = $1000


        !src "common.asm"


        * = TESTSLOC


	!zone {
.test 	lda #1
	sta $1804       ; Timer A lo
	;lda #$1
	;sta $dc0e       ; start timer A continuous
        lda #%01000000
        sta $180b       ; continuous IRQs

	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test 	lda #1
	sta $1804       ; Timer A lo
	;lda #$1
	;sta $dc0e       ; start timer A continuous
        lda #%01000000
        sta $180b       ; continuous IRQs

	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test 	lda #1
	sta $1808       ; Timer B lo
	;lda #$1
	;sta $dc0f       ; start timer B continuous
        lda #%00000000
        sta $180b

	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test	lda #1
	sta $1808       ; Timer B lo
	;lda #$1
	;sta $dc0f       ; start timer B continuous
        lda #%00000000
        sta $180b

	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test	lda #1
	sta $1804       ; Timer A lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
        lda #%01000000
        sta $180b       ; continuous IRQs

	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test	lda #1
	sta $1804       ; Timer A lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
        lda #%01000000
        sta $180b       ; continuous IRQs

	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test	lda #1
	sta $1808       ; Timer B lo
	;lda #$11
	;sta $dc0f       ; start timer B continuous, force reload
        lda #%00000000
        sta $180b
	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test	lda #1
	sta $1808       ; Timer B lo
	;lda #$11
	;sta $dc0f       ; start timer B continuous, force reload
        lda #%00000000
        sta $180b
	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test 	lda #1
	sta $1805       ; Timer A hi
	;lda #$1
	;sta $dc0e       ; start timer A continuous
        lda #%01000000
        sta $180b       ; continuous IRQs

	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test 	lda #1
	sta $1805       ; Timer A hi
	;lda #$1
	;sta $dc0e       ; start timer A continuous
        lda #%01000000
        sta $180b       ; continuous IRQs

	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test 	lda #1
	sta $1809       ; Timer B hi
	;lda #$1
	;sta $dc0f       ; start timer B continuous
        lda #%00000000
        sta $180b

	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test	lda #1
	sta $1809       ; Timer B hi
	;lda #$1
	;sta $dc0f       ; start timer B continuous
        lda #%00000000
        sta $180b

	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test	lda #1
	sta $1805       ; Timer A hi
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
        lda #%01000000
        sta $180b       ; continuous IRQs

	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test	lda #1
	sta $1805       ; Timer A hi
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
        lda #%01000000
        sta $180b       ; continuous IRQs

	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test	lda #1
	sta $1808       ; Timer B lo
	;lda #$11
	;sta $dc0f       ; start timer B continuous, force reload
        lda #%00000000
        sta $180b

	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {
.test	lda #1
	sta $1808       ; Timer B lo
	;lda #$11
	;sta $dc0f       ; start timer B continuous, force reload
        lda #%00000000
        sta $180b

	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

        * = DATA
        !bin "via3ref.bin", NUMTESTS * $0100, 2
        