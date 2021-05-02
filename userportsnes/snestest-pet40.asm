;SNES Adapter Sample Code (PET 40 version)
;by David Murray 2021
;dfwgreencars@gmail.com

!to "snestest-pet40.prg",cbm

;The following addresses are used to store the current 
;state of the SNES buttons.  While it is possible to 
;condense this into two bytes by using 8 bits and 4 bits,
;it ends up being much easier and faster to use a single byte
;for the status of each button. 0=off 1=on
SNES_B      = $0F00
SNES_Y      = $0F01
SNES_SELECT = $0F02
SNES_START  = $0F03
SNES_UP     = $0F04
SNES_DOWN   = $0F05
SNES_LEFT   = $0F06
SNES_RIGHT  = $0F07
SNES_A      = $0F08
SNES_X      = $0F09
SNES_BACK_L = $0F0A
SNES_BACK_R = $0F0B

DATA        = $E841
DIRECTION   = $E843

*=$0400		;START ADDRESS IS $0400

BASIC:	!BYTE $00,$0B,$04,$01,$00,$9E,$31,$30,$33,$37,$00,$00,$00
	;Adds BASIC line:  1 SYS 1037
	
	;First, initialize the data-direction registers of the
	;user port.
	LDA	#%00101000	;Pins 3 & 5 are output
	STA	DIRECTION	;Data-direction-register for userport

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

MESSAGE	!BYTE 147	;white color, clear screen.
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
	LDA	#$80
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
	STA	DATA	
	LDA	#%00000000
	STA	DATA	
	LDX	#0
	;Now read in bits
SRLOOP:	LDA	DATA
	AND	#%01000000	;READ pin 6
	CMP	#%01000000
	BEQ	SRL1
	LDA	#1
	JMP	SRL5
SRL1:	LDA	#0
SRL5:	STA	SNES_B,X
	;pulse the clock line
	LDA	#%00001000	;CLOCK on pin 3
	STA	DATA
	LDA	#%00000000
	STA	DATA
	INX
	CPX	#12
	BNE	SRLOOP
	RTS
