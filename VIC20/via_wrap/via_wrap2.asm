;**************************************************************************
;*
;* FILE  via_wrap2.asm 
;* Copyright (c) 2009 Daniel Kahlin <daniel@kahlin.net>
;* Written by Daniel Kahlin <daniel@kahlin.net>
;*
;* DESCRIPTION
;*   Test case for via timer wrap around.
;*
;******
    processor 6502
    include	"macros.i"

    if EXPANDED=1
BASIC_START equ	$1201   ; expanded
SCR_BASE    equ	$1000
COL_BASE    equ	$9400
    else
BASIC_START equ	$1001   ; unexpanded
SCR_BASE    equ	$1e00
COL_BASE    equ	$9600
    endif

    if TIMER=1
TLO     equ $9124
THI     equ $9125
    else
TLO     equ $9128
THI     equ $9129
    endif

tmp_zp  equ	$fb
ptr_zp  equ	$fc

        seg	code
        org	BASIC_START
;**************************************************************************
;*
;* Basic line!
;*
;******
start_of_line:
        dc.w	end_line
        dc.w	0
    if EXPANDED=1
        dc.b	$9e,"4629 /T.L.R/",0
    else
        dc.b	$9e,"4117 /T.L.R/",0
    endif
end_line:
        dc.w	0

;**************************************************************************
;*
;* NAME  startofcode
;*
;******
startofcode:
        lda	#<greet_msg
        ldy	#>greet_msg
        jsr	$cb1e

        ldx	#0
        lda	646
soc_lp1:
        sta	COL_BASE,x
        sta	COL_BASE+$0100,x
        inx
        bne	soc_lp1

        ldx	#22*2
soc_lp2:
        lda	reference-1,x
        sta	SCR_BASE+22*3-1,x
        dex
        bne	soc_lp2

    if TIMER=1

        lda	#<TLO          ; timer lo
        ldx	#%00000000     ; single
        jsr	perform_test
        lda	#<THI          ; timer hi
        ldx	#%00000000     ; single
        jsr	perform_test

        lda	#<continuous_msg
        ldy	#>continuous_msg
        jsr	$cb1e

        lda	#<TLO          ; timer lo
        ldx	#%01000000     ; continuous
        jsr	perform_test
        lda	#<THI          ; timer hi
        ldx	#%01000000     ; continuous
        jsr	perform_test

    else

        lda	#<TLO          ; timer lo
        ldx	#%00010000     ; single
        jsr	perform_test
        lda	#<THI          ; timer hi
        ldx	#%00010000     ; single
        jsr	perform_test

    endif

        jmp	dochecks

perform_test:
        sei
        sta	pt_sm2+1
        ldy	#0
pt_lp1:
        lda	#$7f
        sta	$912e      ; irq enable
        sta	$912d      ; IRQ flags
        stx	$912b      ; AUX control
        lda	#18
        sta	TLO
        sty	tmp_zp
        lda	#BR_LEN-1
        sec
        sbc	tmp_zp
        sta	pt_sm1+1
        clc

    if TIMERHI=1
        lda	#$01
        sta	THI	;load T1
        jsr delay
    else
        lda	#$00
        sta	THI	;load T1
    endif

pt_sm1:
        bcc	pt_sm1
pt_branch:
        ds.b    20,$a9
        dc.b    $24,$ea
BR_LEN  equ . - pt_branch

pt_sm2:
        lda TLO        ; lobyte will be patched, so first measure timer-lo, then timer-hi
        sta ($d1),y
        iny
        cpy #BR_LEN
        bne pt_lp1

        cli
        lda #13
        jmp $ffd2

greet_msg:
        dc.b	147,"VIA WRAP2 / TLR",13,13
        dc.b	"REFERENCE:",13,13,13,13
    if TIMER=1
        dc.b	"MEASURED (SINGLE):",13
    else
        dc.b	"MEASURED:",13
    endif
        dc.b	0
continuous_msg:
        dc.b	13
        dc.b	"MEASURED (CONT):",13
        dc.b	0

reference:
    if TIMER=1
        dc.b	10,9,8,7,6,5,4,3,2,1,0,255,18,17,16,15,14,13,12,11,10,9
    if TIMERHI=1
        dc.b	0,0,0,0,0,0,0,0,0,0,0,255,1,1,1,1,1,1,1,1,1,1
    else
        dc.b	0,0,0,0,0,0,0,0,0,0,0,255,0,0,0,0,0,0,0,0,0,0
    endif

    else
    if TIMERHI=1
        dc.b	14,13,12,11,10,9,8,7,6,5,4,3,2,1,0,255,18,17,16,15,14,13
        dc.b	244,244,244,244,244,244,244,244,244,244,244,244,244,244,244,243,243,243,243,243,243,243
    else
        dc.b	10,9,8,7,6,5,4,3,2,1,0,255,18,17,16,15,14,13,12,11,10,9
        dc.b	0,0,0,0,0,0,0,0,0,0,0,255,255,255,255,255,255,255,255,255,255,255
    endif
    endif

delay:
        txa         ;2
        pha
        ldx #46     ;2
dl1:
        dex         ;2
        bne dl1     ;3
        pla
        tax         ;2
        clc         ;2
        rts

dochecks:

        ldx	#22*2
chk_lp1:
        ldy #5                     ; green
        lda	reference-1,x
        cmp	SCR_BASE+22*7-1,x
        beq	chk_sk1
        ldy #2                     ; red
        sty result+1
chk_sk1:
        tya
        sta	COL_BASE+22*7-1,x
        dex
        bne	chk_lp1

    if TIMER=1

        ldx	#22*2
chk_lp2:
        ldy #5                     ; green
        lda	reference-1,x
        cmp	SCR_BASE+22*11-1,x
        beq	chk_sk2
        ldy #2                     ; red
        sty result+1
chk_sk2:
        tya
        sta	COL_BASE+22*11-1,x
        dex
        bne	chk_lp2

    endif

result:
        lda #5
        ora #$10
        sta $900f

        ; store value to "debug cart"
        lda #0 ; success
        cpy #5 ; green
        beq res_sk1
        lda #$ff ; failure
res_sk1:
        sta $910f

        jmp *

