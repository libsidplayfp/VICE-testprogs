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

#define	TEST(DDRB,PRB,CR,TIMER,THIFL)				\
	!zone {							:\
.test 								:\
	lda #0							:\
	sta $dc02						:\
	lda #DDRB						:\
	sta $dc03	; ddr input				:\
	lda #PRB						:\
	sta $dc01	; port register 0			:\
	lda #1							:\
	sta $dc04+TIMER+TIMER+THIFL				:\
	lda #CR		; control reg				:\
	sta $dc0e+TIMER						:\
	ldx #0							:\
.t1b	lda $dc01						:\
	sta DTMP,x						:\
	inx							:\
	bne .t1b							:\
	rts							:\
        * = .test+TESTLEN
        }

TEST($c0,$00,$11,0,0)
TEST($c0,$00,$11,0,1)
TEST($c0,$00,$11,1,0)
TEST($c0,$00,$11,1,1)

TEST($c0,$00,$13,0,0)
TEST($c0,$00,$13,0,1)
TEST($c0,$00,$13,1,0)
TEST($c0,$00,$13,1,1)

TEST($c0,$00,$15,0,0)
TEST($c0,$00,$15,0,1)
TEST($c0,$00,$15,1,0)
TEST($c0,$00,$15,1,1)

TEST($c0,$00,$17,0,0)
TEST($c0,$00,$17,0,1)
TEST($c0,$00,$17,1,0)
TEST($c0,$00,$17,1,1)

