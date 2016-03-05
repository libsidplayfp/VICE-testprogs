        !to "via9.prg", cbm

TESTID =          9

tmp=$fc
addr=$fd
add2=$f9

TMP=$8000          ; measured data on C64 side

TESTLEN =         $20

NUMTESTS =        12

DTMP   = $0700          ; measured data on drive side

        !src "common.asm"

        !align 255,0
TESTSLOC

;------------------------------------------
; before:
;       [Timer B lo | Timer B hi] = 1
;       Timer B CTRL = [timer B counts clock | PB6]
; in the loop:
;       read [Timer B lo | Timer B hi | IRQ Flags]
;       toggle toggle timer B counts PB6/Clock

	!zone {		; A
.test 	lda #1
	sta $1808       ; Timer B lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
        lda #%00000000
        sta $180b       ; Continuous
	ldx #0
.t1b	lda $1808       ; Timer B lo
	sta DTMP,x
        ;lda $dc0e
        ;eor #$20
        ;sta $dc0e       ; toggle timer A counts CNT/Clock
        lda $180b
        eor #$20
        sta $180b       ; toggle timer B counts PB6/Clock
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; B
.test 	lda #1
	sta $1808       ; Timer B lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
        lda #%00000000
        sta $180b       ; Continuous
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	;lda $dc0e
	;eor #$20
	;sta $dc0e       ; toggle timer A counts CNT/Clock
        lda $180b
        eor #$20
        sta $180b       ; toggle timer B counts PB6/Clock
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; C
.test 	lda #1
	sta $1808       ; Timer B lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
        lda #%00000000
        sta $180b       ; Continuous
	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	;lda $dc0e
	;eor #$20
	;sta $dc0e       ; toggle timer A counts CNT/Clock
        lda $180b
        eor #$20
        sta $180b       ; toggle timer B counts PB6/Clock
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }
        
        ;---------------------------------------

	!zone {		; D
.test 	lda #1
	sta $1809       ; Timer B hi
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
        lda #%00000000
        sta $180b       ; Continuous
	ldx #0
.t1b	lda $1808       ; Timer B lo
	sta DTMP,x
	;lda $dc0e
	;eor #$20
	;sta $dc0e       ; toggle timer A counts CNT/Clock
        lda $180b
        eor #$20
        sta $180b       ; toggle timer B counts PB6/Clock
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; E
.test 	lda #1
	sta $1809       ; Timer B hi
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
        lda #%00000000
        sta $180b       ; Continuous
	ldx #0
.t1b	lda $1809       ; Timer B hi
	sta DTMP,x
	;lda $dc0e
	;eor #$20
	;sta $dc0e       ; toggle timer A counts CNT/Clock
        lda $180b
        eor #$20
        sta $180b       ; toggle timer B counts PB6/Clock
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; F
.test 	lda #1
	sta $1809       ; Timer B hi
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
        lda #%00000000
        sta $180b       ; Continuous
	ldx #0
.t1b	lda $180d       ; IRQ Flags / ACK
	sta DTMP,x
	;lda $dc0e
	;eor #$20
	;sta $dc0e       ; toggle timer A counts CNT/Clock
        lda $180b
        eor #$20
        sta $180b       ; toggle timer B counts PB6/Clock
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }


        !zone {         ; G
.test   lda #1
        sta $1808       ; Timer B lo
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%00100000
        sta $180b       ; Count Pulses on PB6
        ldx #0
.t1b    lda $1808       ; Timer B lo
        sta DTMP,x
        ;lda $dc0e
        ;eor #$20
        ;sta $dc0e       ; toggle timer A counts CNT/Clock
        lda $180b
        eor #$20
        sta $180b       ; toggle timer B counts PB6/Clock
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; H
.test   lda #1
        sta $1808       ; Timer B lo
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%00100000
        sta $180b       ; Count Pulses on PB6
        ldx #0
.t1b    lda $1809       ; Timer B hi
        sta DTMP,x
        ;lda $dc0e
        ;eor #$20
        ;sta $dc0e       ; toggle timer A counts CNT/Clock
        lda $180b
        eor #$20
        sta $180b       ; toggle timer B counts PB6/Clock
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; I
.test   lda #1
        sta $1808       ; Timer B lo
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%00100000
        sta $180b       ; Count Pulses on PB6
        ldx #0
.t1b    lda $180d       ; IRQ Flags / ACK
        sta DTMP,x
        ;lda $dc0e
        ;eor #$20
        ;sta $dc0e       ; toggle timer A counts CNT/Clock
        lda $180b
        eor #$20
        sta $180b       ; toggle timer B counts PB6/Clock
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }
        
        ;---------------------------------------

        !zone {         ; J
.test   lda #1
        sta $1809       ; Timer B hi
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%00100000
        sta $180b       ; Count Pulses on PB6
        ldx #0
.t1b    lda $1808       ; Timer B lo
        sta DTMP,x
        ;lda $dc0e
        ;eor #$20
        ;sta $dc0e       ; toggle timer A counts CNT/Clock
        lda $180b
        eor #$20
        sta $180b       ; toggle timer B counts PB6/Clock
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; K
.test   lda #1
        sta $1809       ; Timer B hi
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%00100000
        sta $180b       ; Count Pulses on PB6
        ldx #0
.t1b    lda $1809       ; Timer B hi
        sta DTMP,x
        ;lda $dc0e
        ;eor #$20
        ;sta $dc0e       ; toggle timer A counts CNT/Clock
        lda $180b
        eor #$20
        sta $180b       ; toggle timer B counts PB6/Clock
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

        !zone {         ; L
.test   lda #1
        sta $1809       ; Timer B hi
        ;lda #$11
        ;sta $dc0e       ; start timer A continuous, force reload
        lda #%00100000
        sta $180b       ; Count Pulses on PB6
        ldx #0
.t1b    lda $180d       ; IRQ Flags / ACK
        sta DTMP,x
        ;lda $dc0e
        ;eor #$20
        ;sta $dc0e       ; toggle timer A counts CNT/Clock
        lda $180b
        eor #$20
        sta $180b       ; toggle timer B counts PB6/Clock
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
        }

DATA
        !bin "via9ref.bin", NUMTESTS * $0100, 2
ERRBUF
