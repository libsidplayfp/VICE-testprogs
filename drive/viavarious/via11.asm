        !to "via11.prg", cbm

TESTID =          11

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

!macro  TEST .DDRB,.PRB,.CR,.TIMER,.THIFL {
.test
        lda #0
        sta $1803                       ; port A ddr
        lda #.DDRB
        sta $1802                       ; port B ddr input
        lda #.PRB
        sta $1800                       ; port B data
        lda #1
        sta $1804+(.TIMER*4)+.THIFL
        lda #.CR                        ; control reg
        sta $1c0b+.TIMER
        ldx #0
.t1b    lda $1800                       ; port B data
        sta DTMP,x
        inx
        bne .t1b
        rts
        * = .test+TESTLEN
}

+TEST $c0,$00,$11,0,0
+TEST $c0,$00,$11,0,1
+TEST $c0,$00,$11,1,0
+TEST $c0,$00,$11,1,1

+TEST $c0,$00,$13,0,0
+TEST $c0,$00,$13,0,1
+TEST $c0,$00,$13,1,0
+TEST $c0,$00,$13,1,1

+TEST $c0,$00,$15,0,0
+TEST $c0,$00,$15,0,1
+TEST $c0,$00,$15,1,0
+TEST $c0,$00,$15,1,1

+TEST $c0,$00,$17,0,0
+TEST $c0,$00,$17,0,1
+TEST $c0,$00,$17,1,0
+TEST $c0,$00,$17,1,1

