        !to "via20.prg", cbm

TESTID = 20

tmp =$fc
addr=$fd
add2=$f9

TMP    = $8000          ; measured data on C64 side

TESTLEN =        $40

NUMTESTS =       16 - 4

DTMP   = $0700          ; measured data on drive side
viabase = $1800

        !src "common.asm"

        !align 255,0
TESTSLOC

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
        sta viabase+$6        	; Timer 1 latch lo
	lda #<.TIMER2
	sta viabase+$8		; Timer 2 latch lo
	lda #>.TIMER1
	sta viabase+$7		; Timer 1 latch hi
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

;-------------------------------------------------------------------------------
NEXTNAME !pet "via21"
NEXTNAME_END

DATA
        !bin "via20ref.bin", NUMTESTS * $0100, 2
ERRBUF
