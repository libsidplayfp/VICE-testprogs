;SNES Adapter Sample Code (C64 version)
;by David Murray 2021
;dfwgreencars@gmail.com

!to "snestest-c64.prg",cbm

;The following addresses are used to store the current 
;state of the SNES buttons.  While it is possible to 
;condense this into two bytes by using 8 bits and 4 bits,
;it ends up being much easier and faster to use a single byte
;for the status of each button. 0=off 1=on
SNES_B		=$C000
SNES_Y		=$C001
SNES_SELECT	=$C002
SNES_START	=$C003
SNES_UP		=$C004
SNES_DOWN	=$C005
SNES_LEFT	=$C006
SNES_RIGHT	=$C007
SNES_A		=$C008
SNES_X		=$C009
SNES_BACK_L	=$C00A
SNES_BACK_R	=$C00B

*=$0801		;START ADDRESS IS $0801

BASIC:	!BYTE $0B,$08,$01,$00,$9E,$32,$30,$36,$31,$00,$00,$00
	;Adds BASIC line:  1 SYS 2061
	
	;First, initialize the data-direction registers of the
	;user port.
	LDA	#%00101000	;Pins 3 & 5 are output
	STA	$DD03	;Data-direction-register for userport

	JSR	DISPLAY_BUTTON_TEXT
	JMP	MAIN_LOOP
	
;This routine just displays the text on the screen.
DISPLAY_BUTTON_TEXT:
	LDX	#0
DBT0:	LDA	MESSAGE,X
	CMP	#0
	BEQ	DBT1
	JSR	$FFD2
	INX
	JMP	DBT0
DBT1:	RTS

MESSAGE	!BYTE 5,147	;white color, clear screen.
	!PET " b"
	!BYTE 13
	!PET " y"
	!BYTE 13
	!PET " select"
	!BYTE 13
	!PET " start"	
	!BYTE 13
	!PET " up"
	!BYTE 13
	!PET " down"
	!BYTE 13
	!PET " left"
	!BYTE 13
	!PET " right"
	!BYTE 13
	!PET " a"
	!BYTE 13
	!PET " x"
	!BYTE 13
	!PET " back-left"
	!BYTE 13
	!PET " back-right"
	!BYTE 0

MAIN_LOOP:
	JSR	SNES_CONTROLLER_READ
	JSR	DISPLAY_BUTTON_STATUS
	JMP	MAIN_LOOP

DISPLAY_BUTTON_STATUS:
	LDA	#$00
	STA	$FB
	LDA	#$04
	STA	$FC
	LDX	#0
	LDY	#0
DBLOOP:	LDA	SNES_B,X
	CMP	#0
	BNE	DB1
	LDA	#32	;SPACE
	JMP	DB5
DB1:	LDA	#81	;ROUND BALL CHARACTER
DB5:	STA	($FB),Y
	;now add 40 to screen destination
	LDA	$FB
	CLC
	ADC	#40
	STA	$FB
	LDA	$FC
	ADC	#00
	STA	$FC
	INX
	CPX	#12
	BNE	DBLOOP	
	RTS

;This is a generic routine for reading the 12 states of the
;buttons on the SNES pad.  It isn't optimized for this specific
;program (otherwise it would write to screen RAM directly)
SNES_CONTROLLER_READ:
	;now latch data
	LDA	#%00100000	;latch on pin 5
	STA	$DD01	
	LDA	#%00000000
	STA	$DD01	
	LDX	#0
	;Now read in bits
SRLOOP:	LDA	$DD01
	AND	#%01000000	;READ pin 6
	CMP	#%01000000
	BEQ	SRL1
	LDA	#1
	JMP	SRL5
SRL1:	LDA	#0
SRL5:	STA	SNES_B,X
	;pulse the clock line
	LDA	#%00001000	;CLOCK on pin 3
	STA	$DD01
	LDA	#%00000000
	STA	$DD01
	INX
	CPX	#12
	BNE	SRLOOP
	RTS
