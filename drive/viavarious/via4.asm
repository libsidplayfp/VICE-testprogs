        !to "via4.prg", cbm

TESTID =          4

tmp=$fc
addr=$fd
add2=$f9

TMP=$8000          ; measured data on C64 side

TESTLEN =         $20

NUMTESTS =        24

DTMP   = $0700          ; measured data on drive side

        !src "common.asm"

TESTSLOC

;------------------------------------------
; before:
;       [Timer A lo | Timer A hi] = 1
;       Timer A CTRL = [Timed Interrupt when Timer 1 is loaded, no PB7 |
;                       Continuous Interrupts, no PB7 |
;                       Timed Interrupt when Timer 1 is loaded, one-shot on PB7 |
;                       Continuous Interrupts, square-wave on PB7]
; in the loop:
;       read [Timer A lo | Timer A hi | IRQ Flags]
;       toggle Timer A CTRL = [Timed Interrupt | Continuous Interrupts]

	!zone {		; A
.test 	lda #1
	sta $1804       ; Timer A lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
        lda #%00000000
        sta $180b       ; Timed Interrupt when Timer 1 is loaded, no PB7
	ldx #0
.t1b	lda $1804       ; Timer A lo
	sta DTMP,x
	;lda $dc0e
	;eor #$1
	;sta $dc0e       ; toggle timer A start/stop
	lda $180b
	eor #%01000000
        sta $180b
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
        lda #%00000000
        sta $180b       ; Timed Interrupt when Timer 1 is loaded, no PB7
	ldx #0
.t1b	lda $1805       ; Timer A hi
	sta DTMP,x
	;lda $dc0e
	;eor #$1
	;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
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
        lda #%00000000
        sta $180b       ; Timed Interrupt when Timer 1 is loaded, no PB7
	ldx #0
.t1b	lda $1804       ; Timer A lo
	sta DTMP,x
	;lda $dc0e
	;eor #$1
	;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
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
        lda #%00000000
        sta $180b       ; Timed Interrupt when Timer 1 is loaded, no PB7
	ldx #0
.t1b	lda $1805       ; Timer A hi
	sta DTMP,x
	;lda $dc0e
	;eor #$1
	;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
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
        lda #%00000000
        sta $180b       ; Timed Interrupt when Timer 1 is loaded, no PB7
	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	;lda $dc0e
	;eor #$1
	;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
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
        lda #%00000000
        sta $180b       ; Timed Interrupt when Timer 1 is loaded, no PB7
	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	;lda $dc0e
	;eor #$1
	;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

;------------------------------------------
        !zone {         ; G
.test   lda #1
        sta $1804       ; Timer A lo
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%01000000
        sta $180b       ; Continuous Interrupts, no PB7
        ldx #0
.t1b    lda $1804       ; Timer A lo
        sta DTMP,x
        ;lda $dc0e
        ;eor #$1
        ;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; H
.test   lda #1
        sta $1804       ; Timer A lo
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%01000000
        sta $180b       ; Continuous Interrupts, no PB7
        ldx #0
.t1b    lda $1805       ; Timer A hi
        sta DTMP,x
        ;lda $dc0e
        ;eor #$1
        ;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; I
.test   lda #1
        sta $1805       ; Timer A hi
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%01000000
        sta $180b       ; Continuous Interrupts, no PB7
        ldx #0
.t1b    lda $1804       ; Timer A lo
        sta DTMP,x
        ;lda $dc0e
        ;eor #$1
        ;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; J
.test   lda #1
        sta $1805       ; Timer A hi
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%01000000
        sta $180b       ; Continuous Interrupts, no PB7
        ldx #0
.t1b    lda $1805       ; Timer A hi
        sta DTMP,x
        ;lda $dc0e
        ;eor #$1
        ;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; K
.test   lda #1
        sta $1804       ; Timer A lo
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%01000000
        sta $180b       ; Continuous Interrupts, no PB7
        ldx #0
.t1b    lda $180d       ; IRQ Flags / ACK
        sta DTMP,x
        ;lda $dc0e
        ;eor #$1
        ;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; L
.test   lda #1
        sta $1805       ; Timer A hi
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%01000000
        sta $180b       ; Continuous Interrupts, no PB7
        ldx #0
.t1b    lda $180d       ; IRQ Flags / ACK
        sta DTMP,x
        ;lda $dc0e
        ;eor #$1
        ;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

;------------------------------------------
        !zone {         ; M
.test   lda #1
        sta $1804       ; Timer A lo
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%10000000
        sta $180b       ; Timed Interrupt when Timer 1 is loaded, one-shot on PB7
        ldx #0
.t1b    lda $1804       ; Timer A lo
        sta DTMP,x
        ;lda $dc0e
        ;eor #$1
        ;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; N
.test   lda #1
        sta $1804       ; Timer A lo
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%10000000
        sta $180b       ; Timed Interrupt when Timer 1 is loaded, one-shot on PB7
        ldx #0
.t1b    lda $1805       ; Timer A hi
        sta DTMP,x
        ;lda $dc0e
        ;eor #$1
        ;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; O
.test   lda #1
        sta $1805       ; Timer A hi
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%10000000
        sta $180b       ; Timed Interrupt when Timer 1 is loaded, one-shot on PB7
        ldx #0
.t1b    lda $1804       ; Timer A lo
        sta DTMP,x
        ;lda $dc0e
        ;eor #$1
        ;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; P
.test   lda #1
        sta $1805       ; Timer A hi
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%10000000
        sta $180b       ; Timed Interrupt when Timer 1 is loaded, one-shot on PB7
        ldx #0
.t1b    lda $1805       ; Timer A hi
        sta DTMP,x
        ;lda $dc0e
        ;eor #$1
        ;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; Q
.test   lda #1
        sta $1804       ; Timer A lo
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%10000000
        sta $180b       ; Timed Interrupt when Timer 1 is loaded, one-shot on PB7
        ldx #0
.t1b    lda $180d       ; IRQ Flags / ACK
        sta DTMP,x
        ;lda $dc0e
        ;eor #$1
        ;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; R
.test   lda #1
        sta $1805       ; Timer A hi
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%10000000
        sta $180b       ; Timed Interrupt when Timer 1 is loaded, one-shot on PB7
        ldx #0
.t1b    lda $180d       ; IRQ Flags / ACK
        sta DTMP,x
        ;lda $dc0e
        ;eor #$1
        ;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

;------------------------------------------
        !zone {         ; S
.test   lda #1
        sta $1804       ; Timer A lo
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%11000000
        sta $180b       ; Continuous Interrupts, square-wave on PB7
        ldx #0
.t1b    lda $1804       ; Timer A lo
        sta DTMP,x
        ;lda $dc0e
        ;eor #$1
        ;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; T
.test   lda #1
        sta $1804       ; Timer A lo
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%11000000
        sta $180b       ; Continuous Interrupts, square-wave on PB7
        ldx #0
.t1b    lda $1805       ; Timer A hi
        sta DTMP,x
        ;lda $dc0e
        ;eor #$1
        ;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; U
.test   lda #1
        sta $1805       ; Timer A hi
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%11000000
        sta $180b       ; Continuous Interrupts, square-wave on PB7
        ldx #0
.t1b    lda $1804       ; Timer A lo
        sta DTMP,x
        ;lda $dc0e
        ;eor #$1
        ;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; V
.test   lda #1
        sta $1805       ; Timer A hi
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%11000000
        sta $180b       ; Continuous Interrupts, square-wave on PB7
        ldx #0
.t1b    lda $1805       ; Timer A hi
        sta DTMP,x
        ;lda $dc0e
        ;eor #$1
        ;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; W
.test   lda #1
        sta $1804       ; Timer A lo
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%11000000
        sta $180b       ; Continuous Interrupts, square-wave on PB7
        ldx #0
.t1b    lda $180d       ; IRQ Flags / ACK
        sta DTMP,x
        ;lda $dc0e
        ;eor #$1
        ;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; X
.test   lda #1
        sta $1805       ; Timer A hi
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%11000000
        sta $180b       ; Continuous Interrupts, square-wave on PB7
        ldx #0
.t1b    lda $180d       ; IRQ Flags / ACK
        sta DTMP,x
        ;lda $dc0e
        ;eor #$1
        ;sta $dc0e       ; toggle timer A start/stop
        lda $180b
        eor #%01000000
        sta $180b
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

;------------------------------------------

NEXTNAME !pet "via5"
NEXTNAME_END

DATA
        !bin "via4ref.bin", NUMTESTS * $0100, 2
ERRBUF
