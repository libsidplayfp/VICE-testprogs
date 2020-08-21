; PS/2 Mouse routine - 2006 by David Murray and Hannu Nuotio
; Version 0.9

userport = $dd01	; address of userport I/O
userpddr = $dd03	; userport data direction register (1 = out)

ps2data  = $80		; ps2data bitmask (or)
ps2clk   = $40		; ps2clk bitmask (or)
ps2ndata = $7f		; !ps2data bitmask (and)
ps2nclk  = $bf		; !ps2clk bitmask (and)
ps2input = $3f		; ps2 input mask (and)
screen	= $0400

ps2delay = 30		; "clock = 0" delay value (>=20)
postinitdelay = 4	; delay between init and first mouse read
postreaddelay = 2	; delay after mouse packet reads

*=$0801               ;This is An Example Of Setting The Start Address Value

BASIC	.BYTE $0B,$08,$01,$00,$9E,$32,$30,$36,$31,$00,$00,$00
	;Adds BASIC line:  1 SYS 2061


PINIT	LDY	#$00
SPRLD1	LDA	ARROW,Y
	STA	$3000,Y
	INY
	CPY	#$80
	BNE	SPRLD1

	LDA	#$01		;set first sprite-
	STA	$D027		;color to white
	LDA	#$00		;set second sprite-
	STA	$D028		;color to black
	LDA	#$C0		;
	STA	$07F8		;Sprite 0's pointer
	LDA	#$C1		;
	STA	$07F9		;Sprite 1's pointer
	LDA	$D015		;Get current sprite enable settings
	ORA	#$03		;Enable sprites 0 and 1
	STA	$D015		;store sprite enable settings back
	
	SEI			;Sets up the IRQ-driven routine
	LDA	#<MOVEP
	STA	$0314
	LDA	#>MOVEP
	STA	$0315

	lda	#$01		;enable extended features
	sta	$d03f
	lda     #%00100000	; disable badlines
	sta     $d03c
	.byte	$32,$99		;sac     $99  ; burst enable, skip internal cycle       
	lda     #%00000011        
	.byte	$32,$00		;sac     $00
	ldx #$f0		; x = $f0 (Set remote mode)
	jsr ps2tx		; send the byte
	cpx #$fa		; check if x = $fa
	beq L01			; jump if it is
	lda #$34		; $f0 response != $fa, error code "4"
	jmp ps2error		; jump to ps2error	
L01	ldy #postinitdelay
	jsr delay
	CLI
	
	LDA	#$05		;Color white
	JSR	$FFD2
	LDA	#$93		;Clear-Home
	JSR	$FFD2		;Send to char-out
	
PRGLOOP	LDA	BUT		;MAIN PROGRAM LOOP STARTS HERE
	AND	#$01		;Check for left button
	BNE	LCLICK
	LDA	BUT
	AND	#$02
	BNE	RCLICK
	JMP	PRGLOOP
LCLICK	JSR	CLICK1
	LDA	#$A0		;Make the plotted character a solid block
	LDY	#$00
	STA	($FB),Y		;Put the character on the screen.
	JMP	PRGLOOP
RCLICK	JSR	CLICK1
	LDA	#$20		;Make the plotted character a BLANK space
	LDY	#$00
	STA	($FB),Y		;Put the character on the screen.
	JMP	PRGLOOP
CLICK1	LDA	PXL		;Routine for mouse click.
	STA	XL		;Copy all mouse-driver values over to the
	LDA	PXH		;values for this plug-in program.
	STA	XH
	LDA	PY
	STA	YL		
	DIV01	ROR	XH	;Takes high bit of X and rols it to carry flag
	ROR	XL		;Rotates low bits to the right, pulling high bit in from carry.
	CLC			;clears carry between each operation -
	ROR	XL		;from this point, to get rid of any remainder.
	CLC			;Essentially divides XH + XL by 8, with no remainder.
	ROR	XL		;
	CLC
	LSR	YL		;Essentially divides YL by 8, with no remainder.
	LSR	YL		;
	LSR	YL		;

	;The following routine uses the X and Y from the last routine to build
	;the screen memory location of the character cell under the mouse pointer.

MUL01	LDA	YL
	STA	ACC
	LDA	#$00
	STA	ACC2
	LDA	#$28
	STA	AUX
	JSR	MULT		;Multiplies Y * 40, leaves result in ACC(LOW) AND ACC2(HIGH).
	LDA	ACC
	CLC
	ADC	XL		;Add XL to value with carry
	STA	$FB	
	LDA	ACC2
	ADC	#$00		;Add the carry to high byte.
	CLC
	ADC	#$04		;add 1024. Now we have the screen location in $FB and $FC - 
	STA	$FC		;Zero page locations.
	
	RTS

	;Multiply routine - ACC*AUX -> [ACC,EXT] (low,hi) 32 bit result 

MULT	LDA #0
	STA EXT2
	LDY #$11
	CLC
MLOOP	ROR EXT2
	ROR
	ROR ACC2
	ROR ACC
	BCC MUL2
	CLC
	ADC AUX
	PHA
	LDA AUX2
	ADC EXT2
	STA EXT2
	PLA
MUL2	DEY
	BNE MLOOP
	STA EXT
	RTS


MOVEP	lda     #%00100000	; disable badlines
	sta     $d03c
	.byte	$32,$99		;sac     $99  ; burst enable, skip internal cycle 
	lda     #%00000011        
	.byte	$32,$00		;sac     $00
	ldx #$eb		; x = $eb (read data)
	jsr ps2tx		; send the byte
	cpx #$fa		; check if x = $fa
	beq L02			; jump if it is
	lda #$35		; $eb response != $fa, error code "5"
	jmp ps2error		; jump to ps2error

	; get movement data packet
L02	jsr ps2rx		; get byte 1 (buttons etc.)
	stx BUT			; store byte 1
	jsr ps2rx		; get byte 2 (x movement)
	stx MOVX		; store byte 2
	jsr ps2rx		; get byte 3 (y movement)
	stx MOVY		; store byte 3


	LDA	MOVX		;Check for movement on x.
	CMP	#$00
	BEQ	MOVEP1
	LDA	BUT
	AND	#%00010000	;Check X-Sign bit
	CMP	#%00010000
	BEQ	MOVEP1A	
	JSR	MVRT
	JMP	MOVEP1	
MOVEP1A	LDA	#$00
	SEC	
	SBC	MOVX
	STA	MOVX
	JSR	MVLF		;Go to move-left routine

MOVEP1	LDA	MOVY		;Check for movement on y.
	CMP	#$00
	BEQ	MOVEP2
	LDA	BUT
	AND	#%00100000	;Check Y-Sign bit
	CMP	#%00100000
	BEQ	MOVEP2A
	JSR	MVUP
	JMP	MOVEP2
MOVEP2A	LDA	#$00
	SEC
	SBC	MOVY
	STA	MOVY
	JSR	MVDN

MOVEP2	LDA	#$00		;Clear movement 
	STA	MOVY
	STA	MOVX

	LDA	PY		;start of mouse positioning routine.
	CLC	
	ADC	#$32
	STA	$D001		;Sprite 0 - Y
	STA	$D003		;Sprite 1 - Y
	LDA	PXL
	CLC
	ADC	#$18
	STA	$D000		;Sprite 0 - X
	STA	$D002		;Sprite 1 - X
	LDA	PXH
	ADC	#$00
	CMP	#$00
	BEQ	MOVEP3
	LDA	$D010
	ORA	#$03
	STA	$D010
	JMP	$EA31
MOVEP3	LDA	$D010
	AND	#$FC
	STA	$D010
	JMP	$EA31
	


MVDN	LDA	PY		;Subroutine for moving mouse down by value in MOVY
	CLC
	ADC	MOVY
	BCC	MVDN0		;Check if carry flag was set
	CLC
	LDA	#$C7
	STA	PY
	RTS
MVDN0	CMP	#$C7		;Check to ensure it is still less than 199
	BCS 	MVDN1	
	STA	PY
	RTS
MVDN1	LDA	#$C7
	STA	PY
	RTS

MVUP	LDA	PY		;Subroutine for moving mouse up by value in MOVY
	CLV
	SEC
	SBC	MOVY
	BCS	MVUP0		;Check if carry flag was set
	LDA	#$00
	STA	PY
	RTS
MVUP0	STA	PY
	RTS

MVRT	LDA	PXL		;Subroutine for moving mouse RIGHT by value in MOVX
	CLC
	ADC	MOVX
	STA	PXL
	LDA	PXH
	ADC	#$00
	STA	PXH
	LDA	#$00
	CMP	PXH
	BNE	MVRT1
	RTS
MVRT1	LDA	#$01
	CMP	PXH
	BCc	MVRT4
	LDA	PXL
	CMP	#$3F
	BCS	MVRT4
	RTS	
MVRT4	LDA	#$01		;This routine sets X-pos to 319 and returns.
	STA	PXH
	LDA	#$3F
	STA	PXL
	RTS

MVLF	LDA	PXL		;Subroutine for moving mouse left by value in MOVX
	SEC	
	SBC	MOVX
	STA	PXL
	BCc	MVLF1
	RTS
MVLF1	LDA	PXH
	CMP	#$00
	BEQ	MVLF2
	LDA	#$00
	STA	PXH
	RTS
MVLF2	LDA	#$00
	STA	PXL
	RTS
	
DELAY	ldx #0
L04	dex
	bne L04
	dey
	bne DELAY
	rts

ps2tx	stx ps2txbyte		; store byte to send
	lda userpddr		; set clock = output, clock = 0
	and #ps2input
	ora #ps2clk
	sta userpddr


	lda userport		; set clock = 0
	and #ps2nclk
	sta userport

	; wait for about 100us
	ldx #ps2delay		; delay value (x * 5 = delay [us])
L05	dex			; 2 cycles (1 cycle = 1 us?)
	bne L05			; 2+1 cycles (+1 if to different page)

	; preset loop and parity counter
	ldy #1			; y = 1 (for parity)
	ldx #8			; write 8 data bits


	lda userpddr		; set data = output
	ora #ps2data
	sta userpddr


	lda userport		; set data = 0
	and #ps2ndata
	sta userport


	lda userpddr		; set clock = input
	and #ps2nclk
	sta userpddr

; set the actual data bits, count parity 
; (should be with a timeout)

L06	lda userport		; a = userport
	and #ps2ndata		; ps2data = 0
	ror ps2txbyte		; ps2txbyte>>1, lsb->C
L07	bit userport 		; N = bit7 (data), V = bit6 (clock)
	bvs L07 		; wait until clock = 0 (bit6)
	bcc L09			; jump if data bit = 0
	ora #ps2data		; ps2data = 1
	iny			; parity counter ++
L09	sta userport		; set userport
L08	bit userport
	bvc L08 		; wait until clock = 1 (bit6)
	dex 			; x--
	bne L06			; loop next bit

; set parity bit
	tya			; a bit 0 = parity bit
	ror			; c = parity bit
L10	bit userport 		; N = bit7 (data), V = bit6 (clock)
	bvs L10			; wait until clock = 0 (bit6)
	lda userport		; a = userport
	and #ps2ndata		; ps2data = 0 = parity
	bcc L11			; jump if parity bit = 0
	ora #ps2data		; ps2data = 1 = parity
L11	sta userport		; set userport
L12	bit userport
	bvc L12			; wait until clock = 1 (bit 6)

	; set stop bit = set data to input
	lda userpddr
	and #ps2input
L13	bit userport
	bvs L13		; wait until clock = 0 (bit 6)
	sta userpddr	; set data and clock = input
L14	bit userport
	bvc L14		; wait until clock = 1 (bit 6)

	; get ack bit
L15	bit userport
	bvs L15 	; wait until clock = 0 (bit 6)
	bpl L16		; if data = 0 -> ok, jump
	lda #$30	; ack-bit was 1, error code "0"
	jmp ps2error	; jump to ps2error
L16	bit userport
	bvc L16		; wait until clock = 1 (bit 6)

	; set clock = output, clock = 0
	lda userpddr
	and #ps2input
	ora #ps2clk
	sta userpddr
	sta userport

; continue to ps2rx to receive response

ps2rx	lda userpddr	; set clock = input = 1
	and #ps2nclk
	sta userpddr

	; get start bit
L17	bit userport 	; N = bit7 (data), V = bit6 (clock)
	bvs L17		; wait until clock = 0 (bit6)
	bpl L18		; if data = 0 -> ok, jump
	lda #$31	; start bit was 1 -> error code "1"
	jmp ps2error	; jump to ps2error
L18	bit userport
	bvc L18		; wait until clock = 1 (bit6)

	; get the actual data bits
	ldy #1		; y = 1 (for parity)
	lda #0		; a = 0 (so ror will 0 to c)
	ldx #8		; read 8 data bits
	clc 		; c = 0 = assumed first data bit
L19	bit userport ; N = bit7 (data), V = bit6 (clock)
	bvs L19		; wait until clock = 0 (bit6)
	bpl L20		; skip if data = 0
	iny		; calculate parity
	sec 		; Data was 1, c = 1
L20	ror 		; a>>1, msb<-C
L21	bit userport
	bvc L21		; wait until clock = 1 (bit6)
	dex 		; x--
	bne L19		; loop next bit
	tax		; x = byte from PS/2

; get parity bit
L22	bit userport 	; N = bit7 (data), V = bit6 (clock)
	bvs L22 	; wait until clock = 0 (bit6)
	bpl L23		; skip if parity bit = 0
	iny		; calculate parity
L23	tya		; a = parity counter
	ror		; C = parity bit (should be 0)
	bcc L24		; jump if parity is correct
	lda #$32	; parity was incorrect -> error code "2"
	jmp ps2error	; jump to ps2error
L24	bit userport
	bvc L24 		; wait until clock = 1 (bit 6)

; get stop bit
L25	bit userport
	bvs L25 		; wait until clock = 0 (bit 6)
	bmi L26		; if data = 1 -> ok, jump
	lda #$33	; stop bit was 0 -> error code "3"
	jmp ps2error	; jump to ps2error
L26	bit userport
	bvc L26 		; wait until clock = 1 (bit 6)

; set clock = output, clock = 0
	lda userpddr
	and #ps2input
	ora #ps2clk
	sta userpddr
	sta userport

	rts		; return

; - ps2error
; parameters:
;  a = error code
; note:
;  the errors could be handled, this just halts
;
ps2error
	
	sta screen+10	; display error code
	stx screen+11	; display x (for ps2tx debug)
	lda #$fa
	sta screen+12	; display expected x (for ps2tx debug)
L27	INC	$D020	; flash border.
	jmp L27		; halt




PXL	.BYTE	$80	;Pointer X-coord (low)
PXH	.BYTE	$00	;Pointer X-coord (high, just first bit)
PY	.BYTE	$80	;Pointer Y-coord

BUT	.BYTE	$00
MOVX	.BYTE	$00
MOVY	.BYTE	$00

XL	.BYTE	$00	
XH	.BYTE	$00	
YL	.BYTE	$00	
ACC	.BYTE	$00	
ACC2	.BYTE	$00	
AUX	.BYTE	$00	
AUX2	.BYTE	$00	
EXT	.BYTE	$00	
EXT2	.BYTE	$00	

ps2txbyte	.BYTE	$00

ARROW	.BYTE $00,$00,$00,$40,$00,$00,$60,$00	;Data for sprite0
	.BYTE $00,$70,$00,$00,$78,$00,$00,$7C
	.BYTE $00,$00,$7E,$00,$00,$7F,$00,$00
	.BYTE $78,$00,$00,$6C,$00,$00,$4C,$00
	.BYTE $00,$06,$00,$00,$06,$00,$00,$03
	.BYTE $00,$00,$03,$00,$00,$00,$00,$00
	.BYTE $00,$00,$00,$00,$00,$00,$00,$00
	.BYTE $00,$00,$00,$00,$00,$00,$00,$00

	.BYTE $C0,$00,$00,$A0,$00,$00,$90,$00	;Data for sprite1
	.BYTE $00,$88,$00,$00,$84,$00,$00,$82
	.BYTE $00,$00,$81,$00,$00,$80,$80,$00
	.BYTE $87,$00,$00,$92,$00,$00,$AA,$00
	.BYTE $00,$C9,$00,$00,$09,$00,$00,$04
	.BYTE $80,$00,$04,$80,$00,$03,$00,$00
	.BYTE $00,$00,$00,$00,$00,$00,$00,$00
	.BYTE $00,$00,$00,$00,$00,$00,$00,$00
