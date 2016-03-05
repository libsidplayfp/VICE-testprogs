        !to "via5.prg", cbm

TESTID =          5

tmp=$fc
addr=$fd
add2=$f9

TMP=$8000          ; measured data on C64 side

TESTLEN =         $20

NUMTESTS =        24 - 6

DTMP   = $0700          ; measured data on drive side

        !src "common.asm"

        !align 255,0
TESTSLOC

;------------------------------------------
; before: --
; in the loop:
;       [Timer A lo | Timer A hi | Timer A latch lo | Timer A latch hi] = loop counter
;       read [Timer A lo | Timer A hi | IRQ Flags]

	!zone {		; A
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

	!zone {		; B
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

	!zone {		; C
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

	!zone {		; D
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

	!zone {		; E
.test 	ldx #0
.l1	stx $1804       ; Timer A lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .l1
	rts
        * = .test+TESTLEN
        }

	!zone {		; F
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

;----------------------------------------
        !zone {         ; G
.test   ldx #0
.l1     stx $1806       ; Timer A lo
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda $1806       ; Timer A lo
        sta DTMP,x
        inx
        bne .l1
        rts
        * = .test+TESTLEN
        }

        !zone {         ; H
.test   ldx #0
.l1     stx $1806       ; Timer A lo
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda $1807       ; Timer A hi
        sta DTMP,x
        inx
        bne .l1
        rts
        * = .test+TESTLEN
        }

        !zone {         ; I
.test   ldx #0
.l1     stx $1807       ; Timer A hi
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda $1806       ; Timer A lo
        sta DTMP,x
        inx
        bne .l1
        rts
        * = .test+TESTLEN
        }

        !zone {         ; J
.test   ldx #0
.l1     stx $1807       ; Timer A hi
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda $1807       ; Timer A hi
        sta DTMP,x
        inx
        bne .l1
        rts
        * = .test+TESTLEN
        }

        !zone {         ; K
.test   ldx #0
.l1     stx $1806       ; Timer A lo
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda $180d       ; IRQ Flags / ACK
        sta DTMP,x
        inx
        bne .l1
        rts
        * = .test+TESTLEN
        }

        !zone {         ; L
.test   ldx #0
.l1     stx $1807       ; Timer A hi
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
; before: --
; in the loop:
;       [Timer B lo | Timer B hi] = loop counter
;       start Timer B (set to count CLK)
;       read [Timer B lo | Timer B hi | IRQ Flags]

	!zone {		; M
.test 	ldx #0
.l1	stx $1808       ; Timer B lo
	;lda #$11
	;sta $dc0f       ; start timer B continuous, force reload
        lda #%00000000
        sta $180b
	lda $1808       ; Timer B lo
	sta DTMP,x
	inx
	bne .l1
	rts
        * = .test+TESTLEN
        }

	!zone {		; N
.test 	ldx #0
.l1	stx $1808       ; Timer B lo
	;lda #$11
	;sta $dc0f       ; start timer B continuous, force reload
        lda #%00000000
        sta $180b
	lda $1809       ; Timer B hi
	sta DTMP,x
	inx
	bne .l1
	rts
        * = .test+TESTLEN
        }

	!zone {		; O
.test 	ldx #0
.l1	stx $1809       ; Timer B hi
	;lda #$11
	;sta $dc0f       ; start timer B continuous, force reload
        lda #%00000000
        sta $180b
	lda $1808       ; Timer B lo
	sta DTMP,x
	inx
	bne .l1
	rts
        * = .test+TESTLEN
        }

	!zone {		; P
.test 	ldx #0
.l1	stx $1809       ; Timer B hi
	;lda #$11
	;sta $dc0f       ; start timer B continuous, force reload
        lda #%00000000
        sta $180b
	lda $1809       ; Timer B hi
	sta DTMP,x
	inx
	bne .l1
	rts
        * = .test+TESTLEN
        }

	!zone {		; Q
.test 	ldx #0
.l1	stx $1808       ; Timer B lo
	;lda #$11
	;sta $dc0f       ; start timer B continuous, force reload
        lda #%00000000
        sta $180b
	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .l1
	rts
        * = .test+TESTLEN
        }

	!zone {		; R
.test 	ldx #0
.l1	stx $1809       ; Timer B hi
	;lda #$11
	;sta $dc0f       ; start timer B continuous, force reload
        lda #%00000000
        sta $180b
	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	inx
	bne .l1
	rts
        * = .test+TESTLEN
        }

DATA
        !bin "via5ref.bin", NUMTESTS * $0100, 2
ERRBUF
