		* =  $C100
		SEI
		LDY	#0
		STY	loc_C10D+1
		STY	loc_C10F+1
		STY	loc_C111+1

loc_C10C:
		CLV

loc_C10D:
		LDA	#$82

loc_C10F:
		LDX	#$82 

loc_C111:
		SBX	#$17
		STX	$FB
		PHP
		PLA
		STA	$FC
		CLV
		SEC
		LDA	loc_C10D+1
		AND	loc_C10F+1
		SBC	loc_C111+1
		PHP
		CMP	$FB
		BEQ	loc_C12B
		PLP
		BRK
; --------------------------------------

loc_C12B:
		PLA
		EOR	$FC
		BEQ	loc_C133
		JSR	sub_C150

loc_C133:
		INC	loc_C10D+1
		BNE	loc_C10C
		INC	loc_C10F+1
		BNE	loc_C10C
		DEC	$D020
		INC	loc_C111+1
		BNE	loc_C10C
		BRK
; --------------------------------------
		!byte	0
		!byte	0
		!byte	0
		!byte	0
		!byte	0
		!byte	0
		!byte	0
		!byte	0
		!byte	0
		!byte	0

; =============== S U B	R O U T	I N E ==


sub_C150:
		TYA
		TAX
		BEQ	loc_C16B

loc_C154:
		LDA	loc_C10D+1
		AND	loc_C10F+1
		CMP	$C1FF,X
		BNE	loc_C168
		LDA	loc_C111+1
		CMP	$C2FF,X
		BNE	loc_C168

locret_C167:
		RTS
; --------------------------------------

loc_C168:
		DEX
		BNE	loc_C154

loc_C16B:
		LDA	loc_C10D+1
		AND	loc_C10F+1
		STA	$C200,Y
		STA	$400,Y
		LDA	loc_C111+1
		STA	$C300,Y
		STA	$500,Y
		INY
		BNE	locret_C167
		BRK
