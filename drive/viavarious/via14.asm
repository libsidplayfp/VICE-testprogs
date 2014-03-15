        !to "via14.prg", cbm

TESTID  =        14

tmp=$fc
addr=$fd
add2=$f9

ERRBUF=$5f00
TMP=$6000
DATA=$8000

TESTLEN = $40

NUMTESTS=        4

DTMP   = $0700          ; measured data on drive side
TESTSLOC = $1000


        !src "common.asm"


        * = TESTSLOC

;------------------------------------------
	!zone {		; A
.test 	;lda #$00
	;sta $dc0f       ; stop timer B
	lda #1
	sta $1809       ; Timer B hi
        ;lda #$51
        ;sta $dc0f       ; start timer B continuous, force reload, count Timer A (cascade mode)
	lda #1
	sta $1804       ; Timer A lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1808       ; Timer B lo
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; B
.test 	;lda #$20
	;sta $dc0f       ; stop timer B, count CNT transitions
	lda #1
	sta $1809       ; Timer B hi
        ;lda #$51
        ;sta $dc0f       ; start timer B continuous, force reload, count Timer A (cascade mode)
	lda #1
	sta $1804       ; Timer A lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1808       ; Timer B lo
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; C
.test 	;lda #$40
	;sta $dc0f       ; stop timer B, count timer A underflows
	lda #1
	sta $1809       ; Timer B hi
        ;lda #$51
        ;sta $dc0f       ; start timer B continuous, force reload, count Timer A (cascade mode)
	lda #1
	sta $1804       ; Timer A lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1808       ; Timer B lo
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }

	!zone {		; D
.test 	;lda #$60
	;sta $dc0f       ; stop timer B, count timer A underflows while CNT=1
	lda #1
	sta $1809       ; Timer B hi
        ;lda #$51
        ;sta $dc0f       ; start timer B continuous, force reload, count Timer A (cascade mode)
	lda #1
	sta $1804       ; Timer A lo
	;lda #$11
	;sta $dc0e       ; start timer A continuous, force reload
	ldx #0
.t1b	lda $1808       ; Timer B lo
	sta DTMP,x
	inx
	bne .t1b
	rts
        * = .test+TESTLEN
        }
