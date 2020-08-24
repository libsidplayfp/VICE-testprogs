;ACME 0.94.4

!ifdef lib_cbm_c64_petscii_a !eof
lib_cbm_c64_petscii_a = 1

; cursor movements
petscii_UP		= 145
petscii_DOWN		=  17
petscii_LEFT		= 157
petscii_RIGHT		=  29

; other control codes
petscii_STOP		=   3
petscii_CR		=  13	; carriage return
petscii_CS		= 141	; carriage return, shifted
petscii_REVSON		=  18
petscii_REVSOFF		= 146
petscii_HOME		=  19
petscii_CLEAR		= 147
petscii_DEL		=  20:	petscii_BACKSPACE	=  20
petscii_INST		= 148:	petscii_INSERT		= 148
petscii_SHIFTSPACE	= 160

; color codes
petscii_BLACK		= 144
petscii_WHITE		=   5
petscii_RED		=  28
petscii_CYAN		= 159
petscii_PURPLE		= 156
petscii_GREEN		=  30
petscii_BLUE		=  31
petscii_YELLOW		= 158
petscii_ORANGE		= 129
petscii_BROWN		= 149
petscii_LRED		= 150
petscii_GRAY1		= 151
petscii_GRAY2		= 152
petscii_LGREEN		= 153
petscii_LBLUE		= 154
petscii_GRAY3		= 155

; switching character set
petscii_LOCK		=   8	; forbid CBM-shift (C128 uses 11)
petscii_UNLOCK		=   9	; allow CBM-shift (C128 uses 12)
petscii_LOWERCASE	=  14	; switch to lowercase/uppercase character set
petscii_UPPERCASE	= 142	; switch to uppercase/graphics character set

; function keys
petscii_F1		= 133:	petscii_F2		= 137
petscii_F3		= 134:	petscii_F4		= 138
petscii_F5		= 135:	petscii_F6		= 139
petscii_F7		= 136:	petscii_F8		= 140
