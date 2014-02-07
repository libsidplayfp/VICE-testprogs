;
; Easyflash test.
;
; Runs through banking and roms and displays information on the screen.
; Compare against a real easyflash.
; The code here requires recognisable patterns in the rest of the easyflash rom.
;

	.code

bank	=	$80
mode	=	$81
stringL	=	$FC
stringH	=	$FD
cursorL	=	$FE
cursorH	=	$FF
testloc = $0200 ; Location of print and test routines copied to RAM as ROM will be switched off

romid:
	.byte	$AA, $55, $AA, $23

characters:
	.byte	$00, $00, $00, $00, $00, $00, $00, $00
	.byte	$18, $18, $18, $18, $00, $00, $18, $00    ; 33  !
	.byte	$66, $66, $66, $00, $00, $00, $00, $00
	.byte	$66, $66, $FF, $66, $FF, $66, $66, $00
	.byte	$18, $3E, $60, $3C, $06, $7C, $18, $00
	.byte	$62, $66, $0C, $18, $30, $66, $46, $00
	.byte	$3C, $66, $3C, $38, $67, $66, $3F, $00
	.byte	$06, $0C, $18, $00, $00, $00, $00, $00
	.byte	$0C, $18, $30, $30, $30, $18, $0C, $00
	.byte	$30, $18, $0C, $0C, $0C, $18, $30, $00
	.byte	$00, $66, $3C, $FF, $3C, $66, $00, $00
	.byte	$00, $18, $18, $7E, $18, $18, $00, $00
	.byte	$00, $00, $00, $00, $00, $18, $18, $30
	.byte	$00, $00, $00, $7E, $00, $00, $00, $00
	.byte	$00, $00, $00, $00, $00, $18, $18, $00
	.byte	$00, $03, $06, $0C, $18, $30, $60, $00
	.byte	$3C, $66, $6E, $76, $66, $66, $3C, $00
	.byte	$18, $18, $38, $18, $18, $18, $7E, $00
	.byte	$3C, $66, $06, $0C, $30, $60, $7E, $00
	.byte	$3C, $66, $06, $1C, $06, $66, $3C, $00
	.byte	$06, $0E, $1E, $66, $7F, $06, $06, $00
	.byte	$7E, $60, $7C, $06, $06, $66, $3C, $00
	.byte	$3C, $66, $60, $7C, $66, $66, $3C, $00
	.byte	$7E, $66, $0C, $18, $18, $18, $18, $00
	.byte	$3C, $66, $66, $3C, $66, $66, $3C, $00
	.byte	$3C, $66, $66, $3E, $06, $66, $3C, $00
	.byte	$00, $00, $18, $00, $00, $18, $00, $00
	.byte	$00, $00, $18, $00, $00, $18, $18, $30
	.byte	$0E, $18, $30, $60, $30, $18, $0E, $00
	.byte	$00, $00, $7E, $00, $7E, $00, $00, $00
	.byte	$70, $18, $0C, $06, $0C, $18, $70, $00
	.byte	$3C, $66, $06, $0C, $18, $00, $18, $00
	
	; Uppercase
	.byte	$1C, $22, $2E, $2A, $2E, $20, $1C, $00   ; @
	.byte	$18, $3C, $66, $7E, $66, $66, $66, $00   ; A
	.byte	$7C, $66, $66, $7C, $66, $66, $7C, $00   ; B
	.byte	$3C, $66, $60, $60, $60, $66, $3C, $00   ; C
	.byte	$78, $6C, $66, $66, $66, $6C, $78, $00   ; D
	.byte	$7E, $60, $60, $78, $60, $60, $7E, $00   ; E
	.byte	$7E, $60, $60, $78, $60, $60, $60, $00   ; F
	.byte	$3C, $66, $60, $6E, $66, $66, $3C, $00   ; G
	.byte	$66, $66, $66, $7E, $66, $66, $66, $00   ; H
	.byte	$3C, $18, $18, $18, $18, $18, $3C, $00   ; I
	.byte	$1E, $0C, $0C, $0C, $0C, $6C, $38, $00   ; J
	.byte	$66, $6C, $78, $70, $78, $6C, $66, $00   ; K
	.byte	$60, $60, $60, $60, $60, $60, $7E, $00   ; L
	.byte	$63, $77, $7F, $6B, $63, $63, $63, $00   ; M
	.byte	$66, $76, $7E, $7E, $6E, $66, $66, $00   ; N
	.byte	$3C, $66, $66, $66, $66, $66, $3C, $00   ; O
	.byte	$7C, $66, $66, $7C, $60, $60, $60, $00   ; P
	.byte	$3C, $66, $66, $66, $66, $3C, $0E, $00   ; Q
	.byte	$7C, $66, $66, $7C, $78, $6C, $66, $00   ; R
	.byte	$3C, $66, $60, $3C, $06, $66, $3C, $00   ; S
	.byte	$7E, $18, $18, $18, $18, $18, $18, $00   ; T
	.byte	$66, $66, $66, $66, $66, $66, $3C, $00   ; U
	.byte	$66, $66, $66, $66, $66, $3C, $18, $00   ; V
	.byte	$63, $63, $63, $6B, $7F, $77, $63, $00   ; W
	.byte	$66, $66, $3C, $18, $3C, $66, $66, $00   ; X
	.byte	$66, $66, $66, $3C, $18, $18, $18, $00   ; Y
	.byte	$7E, $06, $0C, $18, $30, $60, $7E, $00   ; Z
	.byte	$1C, $10, $10, $10, $10, $10, $1C, $00   ; [
	.byte	$40, $20, $10, $08, $04, $02, $01, $00   ; \ 
	.byte	$1C, $04, $04, $04, $04, $04, $1C, $00   ; ]
	.byte	$08, $14, $22, $00, $00, $00, $00, $00   ; ^
	.byte	$00, $00, $00, $00, $00, $00, $00, $7F   ; _
	; Lower case
	.byte	$10, $08, $00, $00, $00, $00, $00, $00   ; `
	.byte	$00, $00, $3C, $06, $3E, $66, $3E, $00
	.byte	$00, $60, $60, $7C, $66, $66, $7C, $00
	.byte	$00, $00, $3C, $60, $60, $60, $3C, $00
	.byte	$00, $06, $06, $3E, $66, $66, $3E, $00
	.byte	$00, $00, $3C, $66, $7E, $60, $3C, $00
	.byte	$00, $0E, $18, $3E, $18, $18, $18, $00
	.byte	$00, $00, $3E, $66, $66, $3E, $06, $7C
	.byte	$00, $60, $60, $7C, $66, $66, $66, $00
	.byte	$00, $18, $00, $38, $18, $18, $3C, $00
	.byte	$00, $06, $00, $06, $06, $06, $06, $3C
	.byte	$00, $60, $60, $6C, $78, $6C, $66, $00
	.byte	$00, $38, $18, $18, $18, $18, $3C, $00
	.byte	$00, $00, $66, $7F, $7F, $6B, $63, $00
	.byte	$00, $00, $7C, $66, $66, $66, $66, $00
	.byte	$00, $00, $3C, $66, $66, $66, $3C, $00
	.byte	$00, $00, $7C, $66, $66, $7C, $60, $60
	.byte	$00, $00, $3E, $66, $66, $3E, $06, $06
	.byte	$00, $00, $7C, $66, $60, $60, $60, $00
	.byte	$00, $00, $3E, $60, $3C, $06, $7C, $00
	.byte	$00, $18, $7E, $18, $18, $18, $0E, $00
	.byte	$00, $00, $66, $66, $66, $66, $3E, $00
	.byte	$00, $00, $66, $66, $66, $3C, $18, $00
	.byte	$00, $00, $63, $6B, $7F, $3E, $36, $00
	.byte	$00, $00, $66, $3C, $18, $3C, $66, $00
	.byte	$00, $00, $66, $66, $66, $3E, $0C, $78
	.byte	$00, $00, $7E, $0C, $18, $30, $7E, $00
	.byte	$0C, $10, $10, $20, $10, $10, $0C, $00   ; {
	.byte	$08, $08, $08, $08, $08, $08, $08, $00   ; |
	.byte	$30, $08, $08, $04, $08, $08, $30, $00   ; }
	.byte	$00, $00, $30, $49, $06, $00, $00, $00   ; ~
	.byte	$FF, $FF, $FF, $FF, $FF, $FF, $FF, $FF    ; $7F  127  Solid block
	.byte	$00, $00, $00, $00, $00, $00, $00, $00

	;        ----|--10|----|--20|----|--30|----|--40|
welcomeString:
	.byte	"EasyFlash banking test by Peter Wendrich"
	.byte	"Mode Bank 8000-9FFF A000-BFFF E000-FFFF ", $00
spaceString:
	.byte	"Hold spacebar for modes 4-7.", $00
	
testroutines:
	.org  testloc
hextbl:
	.byte	"0123456789ABCDEF"

printnibble:
	and	#$0f
	tax
	lda	hextbl,x
printchar:
	ldx	#$00
	sta	(cursorL,x)
printnext:
	inc	cursorL
	bne	printnext1
	inc	cursorH
printnext1:
	rts

printhex:
	pha
	lsr
	lsr
	lsr
	lsr
	jsr	printnibble
	pla
	jmp	printnibble

printstring:
	stx	stringL
	sty	stringH
	ldy	#$00
printstring2:
	lda	(stringL),y
	beq	printstring1
	iny
	jsr	printchar
	jmp	printstring2
printstring1:
	rts

spaces3:
	lda	#$20
	jsr	printchar
	jsr	printchar
	jmp	printchar
	
singleTest:
	lda mode
	sta	$DE02
	jsr	printhex
	jsr spaces3
	lda	bank
	sta	$DE00
	jsr	printhex
	jsr spaces3

	lda	$8000
	jsr	printhex
	lda	$8001
	jsr	printhex
	lda	$8002
	jsr	printhex
	lda	$8003
	jsr	printhex
	lda	#$20
	jsr	printchar
	jsr	printchar

	lda	$A000
	jsr	printhex
	lda	$A001
	jsr	printhex
	lda	$A002
	jsr	printhex
	lda	$A003
	jsr	printhex
	lda	#$20
	jsr	printchar
	jsr	printchar

	lda	$E000
	jsr	printhex
	lda	$E001
	jsr	printhex
	lda	$E002
	jsr	printhex
	lda	$E003
	jsr	printhex
	lda	#$20
	jsr	printchar
	jsr	printchar
	rts
	
runBankTest:
	lda	#$00
	sta bank
	jsr	singleTest
	inc bank
	jsr	singleTest
	inc bank
	jsr	singleTest
	inc bank
	jmp	singleTest

runTest:
	lda	#80
	sta cursorL
	lda	#$04
	sta cursorH

	; Check spacebar and switch to mode 4-7
	ldx	#$00
	lda	$DC01
	and	#$10
	bne noSpacebar
	ldx	#$04

noSpacebar:
	stx	mode
	jsr runBankTest

	inc mode
	jsr runBankTest
	
	inc mode
	jsr runBankTest

	inc mode
	jsr runBankTest

;	jsr	singleTest
;	jsr	singleTest

endcart:
	jmp runTest
	


	.reloc
copyTestRoutines:
	; Copy print routines from ROM into RAM.
	ldx	#$00
copyTest1:
	lda	testroutines,x
	sta testloc,x
	lda	testroutines + $100,x
	sta testloc + $100,x
	inx
	bne	copyTest1
	rts

initVIC:
	; Black border
	lda	#$00
	sta	$D020
	sta	$D021
	
	; Enable VIC
	lda	#$1B
	sta	$D011
	; No sprites
	lda	#$00
	sta	$D015
	; 40 columns
	lda	#$08
	sta	$D016
	; Screen at 0x0400, characters at 0x0800
	lda	#$12
	sta	$D018

	; Copy character data into memory
	ldx	#$00
initVIC1:
	lda	characters,x
	sta	$0900,x
	lda	characters + $0100,x
	sta	$0A00,x
	lda	characters + $0200,x
	sta	$0B00,x

	; Fill screen with space ($20) characters
	lda	#$20
	sta	$0400,x
	sta	$0500,x
	sta	$0600,x
	sta	$0700,x
	; Green text color
	lda	#$03
	sta	$D800,x
	sta	$D900,x
	sta	$DA00,x
	sta	$DB00,x
	inx
	bne	initVIC1
	
	rts

initCIA:
	; Initialize CIA for detecting spacebar
	lda	#$FF
	sta	$DC02
	lda	#$00
	sta	$DC03
	lda	#$7F
	sta	$DC00
	rts

cursorHome:
	lda	#$04
	sta	cursorH
	lda	#$00
	sta	cursorL
	rts

spacemessage:
	lda	#$07
	sta	cursorH
	lda #$C0
	sta	cursorL
	ldx	#<spaceString
	ldy	#>spaceString
	jmp	printstring

welcome:
	; Welcome message
	jsr cursorHome
	ldx	#<welcomeString
	ldy	#>welcomeString
	jmp	printstring


freezeNmi:
freezeIrq:
freezeReset:
	; Happify CPU ;-)
	sei
	cld
	ldx	#$ff
	txs

	; disable irq sources
	lda #$00
	sta $D01A
	lda #$1F
	sta $DC0D
	sta $DD0D
	; clear pending irqs
	lda $D019
	sta $D019
	lda $DC0D
	lda $DD0D
	
	jsr copyTestRoutines
	jsr initVIC
	jsr initCIA
	jsr spacemessage
	jsr welcome
	jmp	runTest


	
	.segment "VECTORS0"
	.word	0, freezeNmi, freezeReset, freezeIrq
