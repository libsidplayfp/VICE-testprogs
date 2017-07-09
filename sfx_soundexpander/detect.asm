        * =  $801
        !byte  $B
        !byte	8
        !byte	0
        !byte	0
        !byte $9E ; SYS
        !byte $32 ; 2
        !byte $30 ; 0
        !byte $36 ; 6
        !byte $34 ; 4
        !byte	0
        !byte	0
        !byte	0

        * = $0810
        LDA	#$93
        JSR	$FFD2

        lda #0
        sta $d020
        
        jsr jch_detect_chip
        bcs fail
        
        lda #5
        sta $d020
        jmp *
        
fail:
        lda #2
        sta $d020
        jmp *
        
; ------------------------------------------------------------------------------

loc_10600:
        stx $df40       ; select ym3526 register
        nop
        nop
        nop
        nop             ; wait 12 cycles for register select
        sta $df50       ; write to it
        ldx #5
lop:    dex
        nop
        bne lop         ; wait 36 cycles to do the next write
		rts				; return from subroutine	

; ------------------------------------------------------------------------------
; JCH_DETECT_CHIP
; returns carry set if fail
; ------------------------------------------------------------------------------
jch_detect_chip:
loc_1062B:			
		sei				; sure? disable interrupts
		ldx #$04		; set timer control byte to #$60 = clear timers T1 T2 and ignore them
		lda #$60
		jsr loc_10600
		ldx #$04		; set timer control byte to #$80 = clear timers T1 T2 and ignore them
		lda #$80		; reset flags for timer 1 & 2, IRQset : all other flags are ignored
		jsr loc_10600
		ldy $df60		; get soundcard/chip status byte
		sty tread		; store it
		ldx #$02		; Set timer1 to max value
		lda #$ff
		jsr loc_10600
		ldx #$04		; set timer control byte to #$21 = mask timer2 (ignore bit1) and enable bit0 (load timer1 value and begin increment)
		lda #$21		; this should lead to overflow (255) and setting of bits 7 and 6 in status byte (either timer expired, timer1 expired). 
		jsr loc_10600	
		ldy #$02
		ldx #$ff		; wait about 0x200 cycles of loading the status byte
loc_1064C:		
		lda $df60		; status byte is df60 according to discussions
		dex
		bne loc_1064C
		dey
		bne loc_1064C
		and #$e0		; and the value there with e0 (11100000, bits 7, 6 and 5) to make sure all others are 0. 
		eor #$c0		; check if bits 7 and 6 are set (should result in 0)
		sta $0400
		inc $0400+40
		bne loc_10663	; not zero ? jmp to set carry and leave subroutine

		tay				; is was zero, no moce a out of the way for a moment
		lda tread		; read the previous status byte
		and #$e0		; "and" that with e0, ends in zero if no bits are set
		sta $0401
		inc $0401+40
		bne loc_10663	; was it not zero ? ok, jmp to set carry and leave

		ldx #$04		; ok previous status was no timers set. set timer control byte to #$60 = clear timers T1 T2 and ignore them
		lda #$60		
		jsr loc_10600	
		clc				; clear the carry flag
		jmp loc_10664	; leave the subroutine

loc_10663:				
		sec				; set the carry flag
loc_10664:				
		cli				; enalble interrupts
		rts
		
tread:  !byte 0
