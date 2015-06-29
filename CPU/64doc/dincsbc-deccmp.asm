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
		ADC	#$77
		TAY
		LDA	($2B),Y
		LDY	#$4F
		STA	($2B),Y
		LDY	#$5C
		STA	($2B),Y
		TXA
		ADC	#$7B
		TAY
		LDA	($2B),Y
		LDY	#$53
		STA	($2B),Y
		LDY	#$60
		STA	($2B),Y
		TXA
		ADC	#$7F
		TAY
		LDA	($2B),Y
		LDY	#$55
		STA	($2B),Y
		LDY	#$62
		STA	($2B),Y

loc_84F:
		SED
		SEC
		CLV
		LDA	$FB
		INC	$FC
		DCP	$FC
		CLD
		PHP
		PLA
		STA	$FD
		SEC
		CLV
		LDA	$FB
		INC	$FC
		DCP	$FC
		PHP
		PLA
		EOR	$FD
		BEQ	loc_86C
		BRK
; --------------------------------------

loc_86C:
		INC	$FB
		BNE	loc_84F
		INC	$FC
		BNE	loc_84F
		DEX
		BPL	loc_824
		RTS
; --------------------------------------
		!byte $18
		!byte $38
		!byte $18
		!byte $38
		!byte $E6
		!byte $E6
		!byte $C6
		!byte $C6
		!byte $C7
		!byte $C7
		!byte $E7
		!byte $E7 
		!byte	0
