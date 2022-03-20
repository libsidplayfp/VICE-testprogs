        !to "via21.prg", cbm

TESTID = 21

tmp =$fc
addr=$fd
add2=$f9

ERRBUF = $1f00
TMP    = $2000          ; measured data on C64 side
DATA   = $3000          ; reference data

TESTLEN =        $40

NUMTESTS =       16 - 4

TESTSLOC = $1800

DTMP=screenmem

        !src "common.asm"


        * = TESTSLOC

;------------------------------------------
; before:
;       Timer 1 / 2 ] = [ 0013 / 0114 | 0014 / 0015 | ... ]
; in the loop:
;       read IFR
;       reset interrupt flags
;
; The loop takes a slightly different time than the timers.
; This slowly varies the offset between the loop and the time of the IRQs.
;
; Answers the questions:
; - does T2 in SR free running mode generate IRQs?
; - does a FFFF underflow generate an IRQ in 8-bit mode?

!macro TEST .TIMER1,.TIMER2,.ACR {
.test	lda #$EE		; CA2 and CB2 output 1 to prevent their IRQs
	sta viabase+$c		; set this in the PCR
	lda #.ACR		; set timer modes
	sta viabase+$b		; ACR
	lda #<.TIMER1
        sta viabase+$4        	; Timer 1 counter lo
	lda #<.TIMER2
	sta viabase+$8		; Timer 2 latch lo
	lda #>.TIMER1
	sta viabase+$5		; Timer 1 counter hi; reloads counter
	lda #>.TIMER2
	sta viabase+$9		; Timer 2 latch hi; reloads counter
        ldx #0
.t1b    lda viabase+$d		; Interrupt Flag Register	;  4
	sta viabase+$d		; ack/reset interrupt flags	;  4
        sta DTMP,x						;  5
        inx							;  2
        bne .t1b						;  3
        rts			; total                           18
        * = .test+TESTLEN
}

                        	; A
+TEST $0013,$0114,%01010000	; Timer 1 continuous; Timer 2 continuous/SR free running
				; B
+TEST $0014,$0115,%01010000	; Timer 1 continuous; Timer 2 continuous/SR free running
				; C
+TEST $0015,$0116,%01010000	; Timer 1 continuous; Timer 2 continuous/SR free running
				; D
+TEST $0017,$0118,%01010000	; Timer 1 continuous; Timer 2 continuous/SR free running
				; E
+TEST $0018,$0119,%01010000	; Timer 1 continuous; Timer 2 continuous/SR free running
				; F
+TEST $0028,$0101,%01010000	; Timer 1 continuous; Timer 2 continuous/SR free running
				; G
+TEST $0038,$0102,%01010000	; Timer 1 continuous; Timer 2 continuous/SR free running
				; H
+TEST $0048,$0103,%01010000	; Timer 1 continuous; Timer 2 continuous/SR free running
				; I
+TEST $0050,$0104,%01010000	; Timer 1 continuous; Timer 2 continuous/SR free running
				; J
+TEST $0051,$0104,%01010000	; Timer 1 continuous; Timer 2 continuous/SR free running
				; K
+TEST $0052,$0104,%01010000	; Timer 1 continuous; Timer 2 continuous/SR free running
				; L
+TEST $0053,$0117,%01010000	; Timer 1 continuous; Timer 2 continuous/SR free running


        * = DATA
        !bin "via21ref.bin", NUMTESTS * $0100, 2
