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
		LDA	#0
		LDY	#$3D
		STA	($2B),Y
		LDY	#$3F
		STA	($2B),Y
		LDY	#$41
		STA	($2B),Y
		LDA	#7
		STA	$FB

loc_102D:
		CLC
		LDA	$FB
		ADC	#$7A
		TAY
		LDA	($2B),Y
		LDY	#$39
		STA	($2B),Y

loc_1039:
		LDA	#0
		PHA
		PLP
		LDA	#0
		LDX	#0
		SBX	#0
		PHP
		PLA
		CLD
		LDY	#$39
		EOR	($2B),Y
		AND	#$40
		BEQ	loc_1050
		CLI
		BRK
; --------------------------------------

loc_1050:
		LDY	#$3D
		LDA	($2B),Y
		SEC
		ADC	#0
		STA	($2B),Y
		BCC	loc_1039
		LDY	#$3F
		LDA	($2B),Y
		ADC	#0
		STA	($2B),Y
		BCC	loc_1039
		LDA	#$2E
		JSR	$FFD2
		SEC
		LDY	#$41
		LDA	($2B),Y
		ADC	#0
		STA	($2B),Y
		BCC	loc_1039
		DEC	$FB
		BPL	loc_102D
		CLI
		RTS
; --------------------------------------
		!byte $FF
		!byte $FE
		!byte $F7
		!byte $F6
		!byte $BF
		!byte $BE
		!byte $B7
		!byte $B6 
