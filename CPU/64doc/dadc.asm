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
		LDA	#$18
		LDY	#0
		STY	$FB
		STY	$FC
		PHA
		LDY	#$2C
		STA	($2B),Y
		LDY	#$8D
		STA	($2B),Y

loc_82D:
		CLC
		PHP
		LDA	$FC
		AND	#$F
		STA	$FD
		LDA	$FB
		AND	#$F
		ADC	$FD
		CMP	#$A
		BCC	loc_841
		ADC	#5

loc_841:
		TAY
		AND	#$F
		STA	$FD
		LDA	$FB
		AND	#$F0
		ADC	$FC
		AND	#$F0
		PHP
		CPY	#$10
		BCC	loc_855
		ADC	#$F

loc_855:
		TAX
		BCS	loc_860
		PLP
		BCS	loc_862
		CMP	#$A0
		BCC	loc_865
		PHP

loc_860:
		PLP
		SEC

loc_862:
		ADC	#$5F
		SEC

loc_865:
		ORA	$FD
		STA	$FD
		PHP
		PLA
		AND	#$3D
		CPX	#0
		BPL	loc_873
		ORA	#$80

loc_873:
		TAY
		TXA
		EOR	$FB
		BPL	loc_883
		LDA	$FB
		EOR	$FC
		BMI	loc_883
		TYA
		ORA	#$40
		TAY

loc_883:
		PLP
		LDA	$FB
		ADC	$FC
		BNE	loc_88E
		TYA
		ORA	#2
		TAY

loc_88E:
		CLC
		CLV
		SED
		LDA	$FB
		ADC	$FC
		CLD
		PHP
		EOR	$FD
		BNE	loc_8C0+2
		PLA
		STY	$FD
		EOR	$FD
		BNE	loc_8C0+2
		INC	$FB
		BNE	loc_82D
		INC	$FC
		BNE	loc_82D
		PLA
		EOR	#$18
		BEQ	loc_8B1
		CLI
		RTS
; --------------------------------------

loc_8B1:
		LDA	#$1D
		CLC
		ADC	$2B
		STA	$FB
		LDA	#0
		ADC	$2C
		STA	$FC
		LDA	#$38

loc_8C0:
		JMP	($FB)

                BRK