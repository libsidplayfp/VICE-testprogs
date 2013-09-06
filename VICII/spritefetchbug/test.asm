
*=$0801
basic:
; BASIC stub: "1 SYS 2061"
!by $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00

; ---------------------------------------------------------------------------

init:
                sei
                ldx #0
lp:
                lda #1
                sta $d800,x
                lda #$20
                sta $0400,x
                inx
                bne lp

                lda #$2a ; 36
                sta numlines

                LDX     #$2E
loc_1FE3:
                LDA     vicregtab,X
                STA     $D000,X
                DEX
                BPL     loc_1FE3

                LDX     #7
loc_1FEE:
                LDA     sprptrtab,X
                STA     $7F8,X
                DEX
                BPL     loc_1FEE

                LDX     #$C0
loc_1FF9:
                TXA
                STA     $380,X
                INX
                BNE     loc_1FF9

                jmp mainloop

; ---------------------------------------------------------------------------

sprptrtab:	!byte $11
		!byte $11
		!byte $11
		!byte $11
		!byte $11
		!byte $11
		!byte $11
		!byte $11

vicregtab:	!byte 0
		!byte $38
		!byte $40
		!byte $38
		!byte $80
		!byte $38
		!byte $C0
		!byte $38
		
		!byte 0
		!byte $38
		!byte $40
		!byte $38
		!byte $80
		!byte $38
		!byte $C0
		!byte $38

		!byte $F0
		!byte $1B
		!byte	0
		!byte	0
		!byte	0
		!byte $FF
		!byte $C8
		!byte $FF
		
		!byte $17
		!byte $70
		!byte $F1
		!byte	0
		!byte $FF
		!byte $FF
		!byte $C8
		!byte	0
		
		!byte $FD
		!byte $FB
		!byte $F1
		!byte $F2
		!byte $F3
		!byte $F0
		!byte $F1
		!byte $FF
		
		!byte $F3
		!byte $F3
		!byte $F3
		!byte $F3
		!byte $F3
		!byte $F3
		!byte $FF
		!byte $FF
; ---------------------------------------------------------------------------
                * = $0900
mainloop:

                ; wait for line $24
loc_2009:
		LDA	#$24
loc_200B:
		CMP	$D012
		BNE	loc_200B
		LDA	$D011
		BMI	loc_2009

		; stabilize (using lightpen)
		LDA	#$FF
		STA	$DC01
		STA	$DC03
		LDA	#$EF
		STA	$DC01
		LDA	#$FF
		STA	$DC01
		LDA	#0
		STA	$DC03
		LDA	$D013
		LSR
		LSR
		SEC
		SBC	#$C
		AND	#7
		STA	branchloc+1

branchloc:
		BPL	branchloc

		CMP	#$C9
		CMP	#$C9
		CMP	#$C9
		BIT	$EA
		BIT	$EA

                ; delay
		INC	$D021
		LDX	#$EC
loc_204A:
		DEX
		BNE	loc_204A

		DEC	$D021
		NOP

numlines = * + 1
		LDX	#$36 ; num lines

loc_2053:
		DEC	$D016
		INC	$D016
		LDA	$D011
		ADC	#1
		AND	#7
		ORA	#$18
		STA	$D011
		BIT	$EA
		INC	$D021
		DEC	$D021
		DEX
		BNE	loc_2053

		LDA	#$1B
		STA	$D011

                ; check keys
		LDA	$DC01
		LSR
		BCC	incspritepos    ; 1
		LSR
		BCC	decspritepos    ; <-
		LSR
		BCS	loc_2086        ; not CTRL
		
		INC	numlines

loc_2086:
		LSR
		BCS	loc_208C        ; not 2
		DEC	numlines

loc_208C:
                LSR
                BCS     sk1             ; not space
                jmp     init
sk1:
		JMP	printsprpos

; ---------------------------------------------------------------------------
incspritepos:
		LDA	$D010
		INC	$D000
		BNE	loc_209A
		EOR	#1
loc_209A:
		INC	$D002
		BNE	loc_20A1
		EOR	#2
loc_20A1:
		INC	$D004
		BNE	loc_20A8
		EOR	#4
loc_20A8:
		INC	$D006
		BNE	loc_20AF
		EOR	#8
loc_20AF:
		INC	$D008
		BNE	loc_20B6
		EOR	#$10
loc_20B6:
		INC	$D00A
		BNE	loc_20BD
		EOR	#$20
loc_20BD:
		INC	$D00C
		BNE	loc_20C4
		EOR	#$40
loc_20C4:
		INC	$D00E
		BNE	loc_20CB
		EOR	#$80
loc_20CB:
		STA	$D010
		JMP	printsprpos
		
; ---------------------------------------------------------------------------
decspritepos:
		LDA	$D010
		LDX	$D000
		BNE	loc_20EA
		EOR	#1
loc_20EA:
		LDX	$D002
		BNE	loc_20F1
		EOR	#2
loc_20F1:
		LDX	$D004
		BNE	loc_20F8
		EOR	#4
loc_20F8:
		LDX	$D006
		BNE	loc_20FF
		EOR	#8
loc_20FF:
		LDX	$D008
		BNE	loc_2106
		EOR	#$10
loc_2106:
		LDX	$D00A
		BNE	loc_210D
		EOR	#$20
loc_210D:
		LDX	$D00C
		BNE	loc_2114
		EOR	#$40
loc_2114:
		LDX	$D00E
		BNE	loc_211B
		EOR	#$80
loc_211B:
		STA	$D010
		DEC	$D000
		DEC	$D002
		DEC	$D004
		DEC	$D006
		DEC	$D008
		DEC	$D00A
		DEC	$D00C
		DEC	$D00E
		JMP	printsprpos

; ---------------------------------------------------------------------------

printsprpos:
		LDA	$D010
		AND	#1
		ORA	#$30 ; '0'
		STA	$400

		LDA	$D000
		AND	#$F
		TAX
		LDA	hextab,X
		STA	$402
		LDA	$D000
		LSR
		LSR
		LSR
		LSR
		TAX
		LDA	hextab,X
		STA	$401

		LDA	numlines
		AND	#$F
		TAX
		LDA	hextab,X
		STA	$405
		LDA	numlines
		LSR
		LSR
		LSR
		LSR
		TAX
		LDA	hextab,X
		STA	$404

		JMP	mainloop

hextab:		!byte $30
		!byte $31
		!byte $32
		!byte $33
		!byte $34
		!byte $35
		!byte $36
		!byte $37
		!byte $38
		!byte $39
		!byte 1
		!byte 2
		!byte 3
		!byte 4
		!byte 5
		!byte 6
