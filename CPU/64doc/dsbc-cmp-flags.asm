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
		LDY	#0
		STY	$FB
		STY	$FC
		LDX	#3

loc_824:
		TXA
		CLC
		ADC	#$65
		TAY
		LDA	($2B),Y
		LDY	#$41
		STA	($2B),Y
		LDY	#$4C
		STA	($2B),Y
		TXA
		ADC	#$69
		TAY
		LDA	($2B),Y
		LDY	#$45
		STA	($2B),Y
		LDY	#$50
		STA	($2B),Y

loc_841:
		SED
		SEC
		CLV
		LDA	$FB
		SBC	$FC
		CLD
		PHP
		PLA
		STA	$FD
		SEC
		CLV
		LDA	$FB
		SBC	$FC
		PHP
		PLA
		EOR	$FD
		BEQ	loc_85A
		BRK
; --------------------------------------

loc_85A:
		INC	$FB
		BNE	loc_841
		INC	$FC
		BNE	loc_841
		DEX
		BPL	loc_824
		RTS
; --------------------------------------
		!byte $18
		!byte $38
		!byte $18
		!byte $38
		!byte $E5
		!byte $E5
		!byte $C5
		!byte $C5 
