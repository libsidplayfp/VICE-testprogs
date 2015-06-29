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

loc_81E:
		LDY	#0
		STY	$FB
		STY	$FC

loc_824:
		PHA
		LDY	#$2C
		STA	($2B),Y
		LDY	#$76
		STA	($2B),Y

loc_82D:
		SEC
		PHP
		LDA	$FC
		AND	#$F
		STA	$FD
		LDA	$FB
		AND	#$F
		SBC	$FD
		BCS	loc_840
		SBC	#5
		CLC

loc_840:
		AND	#$F
		TAY
		LDA	$FC
		AND	#$F0
		STA	$FD
		LDA	$FB
		AND	#$F0
		PHP
		SEC
		SBC	$FD
		AND	#$F0
		BCS	loc_85F
		SBC	#$5F
		PLP
		BCS	loc_868
		SBC	#$F
		SEC
		BCS	loc_868

loc_85F:
		PLP
		BCS	loc_868
		SBC	#$F
		BCS	loc_868
		SBC	#$5F

loc_868:
		STY	$FD
		ORA	$FD
		STA	$FD
		PLP
		CLV
		LDA	$FB
		SBC	$FC
		PHP
		PLA
		TAY
		SEC
		CLV
		SED
		LDA	$FB
		SBC	$FC
		CLD
		PHP
		EOR	$FD
		BNE	loc_81E+1
		PLA
		STY	$FD
		EOR	$FD
		BNE	loc_81E+1
		INC	$FB
		BNE	loc_82D
		INC	$FC
		BNE	loc_82D
		PLA
		EOR	#$18
		BNE	loc_89C
		LDA	#$38 
		BNE	loc_824

loc_89C:
		CLI
		RTS
