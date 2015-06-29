                * =  $801
                !word nextline
                ; 1993 SYSPEEK(43)+256*PEEK(44)+26
                !word 1993
                !byte $9e, $c2, $28, $34, $33, $29, $aa
                !byte $32, $35, $36, $ac, $c2, $28, $34, $34
                !byte $29, $aa, $32, $36
                !byte 0
nextline:
                !word 0
; --------------------------------------
		SEI
		LDA	#0
		LDY	#$4D
		STA	($2B),Y
		LDY	#$4F
		STA	($2B),Y
		LDY	#$51
		STA	($2B),Y
		LDA	#3
		STA	$FB
		CLC

loc_102F:
		LDA	$FB
		LSR
		PHA
		BCC	loc_1037+1
		LDA	#$18

loc_1037:
		BIT	$38A9
		LDY	#$49
		STA	($2B),Y
		PLA
		LSR
		BCC	loc_1044+1
		LDA	#$F8

loc_1044:
		BIT	$D8A9
		INY
		STA	($2B),Y

loc_104A:
		CLC
		SED
		CLV
		LDA	#$F4
		LDX	#$63
		SBX	#9
		STX	$FC
		PHP
		PLA
		STA	$FD
		CLD
		SEC
		LDY	#$4D
		LDA	($2B),Y
		LDY	#$4F
		AND	($2B),Y
		LDY	#$51
		SBC	($2B),Y
		PHP
		EOR	$FC
		BEQ	loc_106D

loc_106C:
		BRK
; --------------------------------------

loc_106D:
		PLA
		EOR	$FD
		AND	#$B7
		BNE	loc_106C
		LDY	#$4D
		LDA	($2B),Y
		SEC
		ADC	#0
		STA	($2B),Y
		BCC	loc_104A
		LDY	#$4F
		LDA	($2B),Y
		ADC	#0
		STA	($2B),Y
		BCC	loc_104A
		LDA	#$2E
		JSR	$FFD2
		SEC
		LDY	#$51 
		LDA	($2B),Y
		ADC	#0
		STA	($2B),Y
		BCC	loc_104A
		DEC	$FB
		BPL	loc_102F
		CLI
		RTS
