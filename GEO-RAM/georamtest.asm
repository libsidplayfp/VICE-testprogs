; GEO/NEO- AND BBGRAM-TEST v0.2 512K
; 
; This tool checks all 32 16 Kb-pages. Bytes will be read, verify, wrote and 
; verify again. 
; If an error occurs the programm will stop with a message like 
; "verify error ! at $0010 in page $04" .
; 
; The 16 K-buffer is located from $4000 up to $7fff in memory.
; 
; The mentioned NeoRAM (using SRAMs) ist still under construction by several people.
; 
; 2.8.2006
; 
; Michael Sachse (info@cbmhardware.de)

georampage = $de00
databuffer = $4000

*= $0800
!byte $00,$0c,$08,$0a,$00,$9e,$32,$30,$36,$34,$00,$00,$00,$00,$00,$00

*= $0810
; ---------------------------------------------------------------------------
                LDA #$17
                STA $D018
                LDX #0
                LDA #0
                STA $D020
                STA $D021
                STA $DFFF
                STA $DFFE

-
                LDA georampage,X
                STA $33C,X
                INX
                CPX #$BE
                BNE -
                LDX #0
                TXA

loc_833:
                STA georampage,X
                LDA georampage,X
                CMP georampage,X
                BNE loc_846
                INX
                CPX #$BE
                BNE loc_833
                JMP loc_849
loc_846:
                JMP	loc_9A5
; ---------------------------------------------------------------------------

loc_849:
                LDX	#0

loc_84B:
                LDA	$33C,X
                STA	georampage,X
                INX
                CPX	#$BE
                BNE	loc_84B

                LDA	#$D4
                STA	loc_9B5+1
                STA	loc_A7F+1
                STA	loc_AA0+1
                STA	loc_960+1
                STA	loc_A74+1
                STA	loc_965+1
                STA	loc_A6F+1
                LDA	#0
                STA	$33C
                STA	$A
                STA	$B
                STA	$C
                LDA	#$40
                STA	loc_9BF+2
                STA	loc_A89+2
                STA	loc_AAD+2
                LDA	#1
                STA	$286
                LDA	#$93
                JSR	$FFD2
                LDX	#1
                LDY	#0
                CLC
                JSR	$FFF0
                LDX	#0

loc_897:
                LDA	aGeoNeoAndBbgra,X ; "	geo/neo- AND bbgram-tEST 512k V0.2"
                BEQ	loc_8A3
                JSR	$FFD2
                INX
                JMP	loc_897
; ---------------------------------------------------------------------------

loc_8A3:
                LDX	#$10
                LDY	#1
                CLC
                JSR	$FFF0
                LDX	#0

loc_8AD:
                LDA	a123,X                ; "                1	  2	    3	  "...
                BEQ	loc_8B9
                JSR	$FFD2
                INX
                JMP	loc_8AD
; ---------------------------------------------------------------------------

loc_8B9:
                LDX	#$11
                LDY	#1
                CLC
                JSR	$FFF0
                LDX	#0

loc_8C3:
                LDA	a01234567890123,X ; "	01234567890123456789012345678901    "...
                BEQ	loc_8CE
                JSR	$FFD2
                INX
                BNE	loc_8C3

loc_8CE:
                LDX	#$14
                LDY	#1
                CLC
                JSR	$FFF0
                LDX	#0

loc_8D8:
                LDA	aSequenceRVWV,X	; " sEQUENCE : r - v - w - v                  "...
                BEQ	loc_8E3
                JSR	$FFD2
                INX
                BNE	loc_8D8

loc_8E3:
                LDX	#$A
                LDY	#1
                CLC
                JSR	$FFF0
                LDX	#0

loc_8ED:
                LDA	aSpaceToStartOr,X ; "	- sPACE	TO START OR x FOR EXIT -    "...
                BEQ	loc_8F8
                JSR	$FFD2
                INX
                BNE	loc_8ED

loc_8F8:
!if TESTBENCH = 0 {
                JSR	$FFE4
                CMP	#$20 ; ' '
                BEQ	loc_908
                CMP	#$58 ; 'X'
                BEQ	loc_905
                BNE	loc_8F8

loc_905:
                JMP	loc_994
}
; ---------------------------------------------------------------------------

loc_908:
                LDX	#$A
                LDY	#1
                CLC
                JSR	$FFF0
                LDX	#0

loc_912:
                LDA	aPleaseWait,X	; "	       pLEASE WAIT !                  "...
                BEQ	loc_91D
                JSR	$FFD2
                INX
                BNE	loc_912

loc_91D:
                LDA	#0
                STA	$DFFE
                STA	$DFFF

loc_925:
                JSR	loc_A9E
                LDA	#0
                STA	$DFFE
                LDA	$B
                STA	$DFFF
                JSR	loc_9B3
                LDA	$33C
                CMP	#$FF
                BEQ	loc_994
                LDA	#$40
                STA	loc_A89+2
                JSR	loc_A7D
                JSR	loc_9B3
                LDA	$33C
                CMP	#$FF
                BEQ	loc_994
                LDA	#0
                STA	$DFFE
                LDA	#$40
                STA	loc_AAD+2
                STA	loc_A89+2
                INC	loc_9B5+1
                LDA	#$7A

loc_960:
                STA	$6D4
                LDA	#$D

loc_965:
                STA	$DAD4
                INC	loc_960+1
                INC	loc_965+1
                INC	loc_A74+1
                INC	loc_A6F+1
                INC	$B
                LDA	$B
                STA	$DFFF
                CMP	#$20 ; ' '
                BNE	loc_925
                LDX	#$A
                LDY	#1
                CLC
                JSR	$FFF0
                LDX	#0

loc_989:
                LDA	aNoErrorFinishe,X ; "	     nO	eRROR -	fINISHED !	    "...
                BEQ	loc_994
                JSR	$FFD2
                INX
                BNE	loc_989

loc_994:

!if TESTBENCH = 1 {
                  lda #$00  ; success
                  sta $d7ff
}

                JMP	loc_997

loc_997:
                LDX	#$14
                LDY	#1
                CLC
                JSR	$FFF0
                LDA	#$E
                STA	$286
                RTS
; ---------------------------------------------------------------------------

loc_9A5:
                LDX	#0
-
                LDA	aSorryNoActiveR,X ; "sORRY, NO ACTIVE RAM-EXPANSION FOUND.  "...
                BEQ	locret_9B2
                JSR	$FFD2
                INX
                BNE	-

locret_9B2:
                RTS
; ---------------------------------------------------------------------------

loc_9B3:
                LDA	#$16

loc_9B5:
                STA	$6D4
                LDY	#0
                LDX	#0

loc_9BC:
                LDA	georampage,X

loc_9BF:
                CMP	databuffer,X
                BNE	loc_9D8
                INX
                BNE	loc_9BC
                INY
                STY	$DFFE
                INC	loc_9BF+2
                CPY	#$40
                BNE	loc_9BC
                LDA	#$40
                STA	loc_9BF+2
                RTS
; ---------------------------------------------------------------------------

loc_9D8:
                TXA
                STA	$C
                LDA	#2
                STA	$D020

!if TESTBENCH = 1 {
                  lda #$ff  ; failure
                  sta $d7ff
}

                LDX	#3
                LDY	#$B
                CLC
                JSR	$FFF0
                LDX	#0

-
                LDA	aVerifyError,X	; " vERIFY-eRROR ! "
                JSR	$FFD2
                INX
                CPX	#$11
                BNE	-

                LDX	#5
                LDY	#3
                CLC
                JSR	$FFF0
                LDX	#0

-
                LDA	aAtAddress,X	; "AT ADDRESS :	$"
                JSR	$FFD2
                INX
                CPX	#$E
                BNE	-

                LDA	loc_9BF+2
                SEC
                SBC	#$40 ; '@'
                LSR
                LSR
                LSR
                LSR
                JSR	loc_A5F
                LDA	loc_9BF+2
                JSR	loc_A5F
                LDA	$C
                LSR
                LSR
                LSR
                LSR
                JSR	loc_A5F
                LDA	$C
                JSR	loc_A5F
                LDX	#0

-
                LDA	aInPage,X	; " IN PAGE : $"
                JSR	$FFD2
                INX
                CPX	#$C
                BNE	-

                LDA	$B
                LSR
                LSR
                LSR
                LSR
                JSR	loc_A5F
                LDA	$B
                JSR	loc_A5F
                LDX	#$A
                LDY	#1
                CLC
                JSR	$FFF0
                LDX	#0

-
                LDA	aPleaseCheckThe,X ; "  pLEASE CHECK THE	ramS AND CIRCUIT !  "...
                BEQ	loc_A5B
                JSR	$FFD2
                INX
                BNE	-

loc_A5B:
                JMP	loc_994
; ---------------------------------------------------------------------------
;                RTS
; ---------------------------------------------------------------------------

loc_A5F:
                AND	#$F
                CMP	#$A
                CLC
                BMI	loc_A68
                ADC	#7

loc_A68:
                ADC	#$30 ; '0'
                JSR	$FFD2
                LDA	#2

loc_A6F:
                STA	$DAD4
                LDA	#$A1 ; '¡'

loc_A74:
                STA	$6D4
                LDA	#$FF
                STA	$33C
                RTS
; ---------------------------------------------------------------------------

loc_A7D:
                LDA	#$17

loc_A7F:
                STA	$6D4
                INC	loc_A7F+1
                LDY	#0
                LDX	#0

loc_A89:
                LDA	databuffer,X
                STA	georampage,X
                INX
                BNE	loc_A89
                INC	loc_A89+2
                INY
                STY	$DFFE
                CPY	#$40
                BNE	loc_A89
                RTS
; ---------------------------------------------------------------------------

loc_A9E:
                LDA	#$12

loc_AA0:
                STA	$6D4
                INC	loc_AA0+1
                LDY	#0
                LDX	#0

loc_AAA:
                LDA	georampage,X

loc_AAD:
                STA	databuffer,X
                INX
                BNE	loc_AAA
                INC	loc_AAD+2
                INY
                STY	$DFFE
                CPY	#$40 ; '@'
                BNE	loc_AAA
                RTS
; ---------------------------------------------------------------------------
                
                * = $2000
aGeoNeoAndBbgra:
                !text "   geo/neo- AND bbgram-tEST 512k V0.2",0
                !byte	0
                !byte	0
aVerifyError:	
                !text " vERIFY-eRROR ! ",0
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
                !byte	0
                !byte	0
                !byte	0
aAtAddress:	!text "AT ADDRESS : $",0
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
                !byte	0
                !byte	0
                !byte	0
                !byte	0
                !byte	0
aInPage:        !text " IN PAGE : $",0
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
                !byte	0
                !byte	0
                !byte	0
                !byte	0
                !byte	0
                !byte	0
                !byte	0
a123:           !text "             1         2         3     ",0
a01234567890123:!text "   01234567890123456789012345678901    ",0
aSequenceRVWV:	!text " sEQUENCE : r - v - w - v              ",0
aSpaceToStartOr:!text "   - sPACE TO START OR x FOR EXIT -    ",0
aPleaseWait:	!text "            pLEASE WAIT !              ",0
aNoErrorFinishe:!text "        nO eRROR - fINISHED !          ",0
aPleaseCheckThe:!text "  pLEASE CHECK THE ramS AND CIRCUIT !  ",0
aSorryNoActiveR:!text "sORRY, NO ACTIVE RAM-EXPANSION FOUND.  ",0
