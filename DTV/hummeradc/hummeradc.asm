; adcrdxx.asm
; (c) 2006 by doug garmon
; released under gpl licence

; delay loops removed for this version

portb = $dd01
ddr = $dd03
zstore = $fb

; cia2 portb data direction register settings
startddr = %00000110
writeddr = %00000111
readddr =  %00000110

start = %00000100
clock = %00000010
writemask = %00000001

; the commands and data in the following section
; are stored in reverse-bit order (backwards)
adccmd = %00000001	; adc read cmd (100)
ctrlrg = %00000110	; control reg setting cmd (011)
chnatt = %00000100	; channel attribute setting cmd (001)
wakeup = %00000010	; channel wakeup cmd (010)

*=$0801
        !byte $0b,$08,$0a,$00,$9e,$32,$30,$36,$31,0,0,0

; jump table
;		jmp read		; read the adc
;		jmp init		; perform all the init subroutines
		jmp dmdisp		; demo/display pot values

; data section
; bits are stored backwards
; %00000000	channel #0 (000) 3 bits
; %00001000	4-bit control reg setting (0001) 4 bits
; the next two setting could just as easily be reset to effect only chan #0
; %11111111	set all channels for wakeup - 8 bits
; %11111111	set all channels to analog, not just channel 0 - 8 bits
channel		!byte $00		; channel #
chancrset	!byte %00001000		; channel control reg setting data
chanwake	!byte %11111111		; channel wakeup function -- all
chananalog	!byte %11111111		; set channels to analog -- all

; read the adc
read		sei			; disable interrupts

		jsr startsig		; the start signal

		lda #adccmd		; send adc command
		sta zstore		; bits to write in zstore
		ldx #$03

sendcmd		jsr sendbits		; send it

		lda channel		; send channel #
		sta zstore		; bits to write in zstore
		ldx #$03

sendchan	jsr sendbits		; send it

		lda #readddr		; setup port for read
		sta ddr

		ldx #$04		; two empty clock cycles = 4 clock toggles
cycle		jsr toggleclock
		dex
		bne cycle

		lda #$00
		sta zstore		; blank the data store

		ldx #$08		; get the 8 bits adc

; fetch and store the adc bits
; read each data bit in the middle of the clock cycle

readadc		jsr toggleclock
		lda portb		; get adc bit

		ror
		rol zstore

		jsr toggleclock
		dex
		bne readadc		; go back & get next bit

		jsr toggleclock		; get the last bit (skip the roll)

		jsr toggleclock		; complete last clock tic...
		jsr toggleclock

		cli			; enable interrupts
		rts

; init
; call all the init routines

init

; init the control register settings
;	set the voltage reference to use 'ref' pin

initcrs
		sei
		jsr startsig

		lda #ctrlrg		; control reg setting command
		sta zstore		; bits to write in zstore
		ldx #$03		; 3 bits

		jsr sendbits		; send the cmd

		lda chancrset		; cntl reg setting
		sta zstore
		ldx #$04		; 4 bits in a cr setting

		jsr sendbits		; send the setting

; init channels for analog input
initchn
		jsr startsig

		lda #chnatt		; channel attribute command
		sta zstore		; bits to write in zstore
		ldx #$03		; 3 bits

		jsr sendbits		; send the cmd

		lda chananalog		; set channels to analog
		sta zstore
		ldx #$08		; 8 bits

		jsr sendbits		; send the setting

; init channels for wakeup function
initwake
		jsr startsig

		lda #wakeup		; wakeup command
		sta zstore		; bits to write in zstore
		ldx #$03		; 3 bits

		jsr sendbits		; send the cmd

		lda chanwake		; set channels to wake
		sta zstore
		ldx #$08		; 8 bits

		jsr sendbits		; send the setting
		cli

		rts

; send bits to adc
; zstore holds bits (one byte, up to 8 bits)
; x reg holds number of bits

sendbits
		jsr writebit
		jsr toggleclock

		lsr zstore		; shift the cmd/data bits
		dex
		bne sendbits		; loop back until all bits sent

		rts


; start signal, initiate any transfer
;	startsig also initializes the ddr for whatever cmd follows

startsig
		lda #startddr		; initialize for start
		sta ddr
		lda #start
		sta portb		; begin start signal

		lda #$00
		sta portb		; drop start

		lda #writeddr		; initialize for write
		sta ddr
		rts

; toggles clock

toggleclock
		lda portb
		eor #clock		; eor the current state of clock
		sta portb

		rts

; sets clock, writes to dio
; 	writing only involves two bits (clock and data), so don't set clock and data
; 	separately--just set the two bits as required and write to the port once.

writebit
		lda zstore
		and #writemask		; and the data bit
		ora #clock		; set the clock bit
		sta portb

		rts

; david murray's demo/display routine:
; display adc values in loop, exit on keypress

dmdisp		jsr init

		lda #$93		; petscii for clearscreen
		jsr $ffd2		; kernal char-out
disp
		lda #$13		; print home
		jsr $ffd2

		jsr read		; read the ADC
		lda zstore
		and #$f0		; get only high 4-bits
		ror
		ror
		ror
		ror
		jsr convert
		jsr $ffd2
		lda zstore
		and #$0f		; get only low 4 bits
		jsr convert
		jsr $ffd2
		jsr $ffe4		; get char from keyboard
;		cmp #$00
;		bne convert2		; if not equal to zero, end.
        sta $0400+80

		jmp disp
convert
		adc #$30		; routine converts a digit 0-15 to
		cmp #$3a		; a petscii character for hex display
		bcc convert2
		adc #$06
convert2
		rts
