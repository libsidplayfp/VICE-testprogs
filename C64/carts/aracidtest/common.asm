printarvalue:
		pha
		pha
		jsr println
		.dw Testval
		pla
		jsr printhex
		jsr println
		.dw Testval2
		pla
		rts


;---------------------------------------
printhex:
		pha
		lsr
		lsr
		lsr
		lsr
		jsr hexa
		pla
		and #$0f
hexa:		cmp #$0a
		bcc hexb
		adc #$06
hexb:		adc #$30
		jsr $e716
		sei
		rts
;---------------------------------------
/* printline routine */
;---------------------------------------

println:
printlow        = $fe
printhigh       = $ff
                pla
                CLC
                ADC #$02
                TAX
                sta printlow

                pla
                ADC #$00
                sta printhigh

                PHA
                TXA
                PHA

                LDA printlow

                BNE skip2
                DEC printhigh
skip2:          DEC printlow         ; stackwerte um 2 erhoehen

                ldy #0
                lda (printlow),y     ; ueber 0 page den pointer holen
                tax
                iny
                lda (printlow),y     ; ueber 0 page den pointer holen
                sta printhigh
                stx printlow         ; und neuen 0 page pointer auf text schreiben
                dey

aga:            lda (printlow),y     ; text lesen und printen
                beq endlich
                jsr $e716
                sei
                inc printlow
                bne aga
                inc printhigh
                bne aga
endlich:
		rts
;========================================================= keyboard

spacekey:
		jsr println
		.dw Space
spacekeyreal:
		lda #$7f
		sta $dc00
spacekeyc:
		LDA $DC01
                AND #$10                ; check 4 space
                BNE spacekeyc
spacekeyc2:
		lda $dc01
                and #$10
		beq spacekeyc2
		rts
;=========================================================
spacer:
                pla
                CLC
                ADC #$02
                TAX
                sta printlow

                pla
                ADC #$00
                sta printhigh

                PHA
                TXA
                PHA

                LDA printlow

                BNE skip2a
                DEC printhigh
skip2a:
		DEC printlow         ; stackwerte um 2 erhoehen

                ldy #0
                lda (printlow),y     ; ueber 0 page den pointer holen
                tax
                iny
                lda (printlow),y     ; ueber 0 page den pointer holen
                sta rerun+2
                stx rerun+1

		jsr println
		.dw Spacer
		sei
		lda #$7f
		sta $dc00
spacerkeyc:
		LDA $DC01
                AND #$10                ; check 4 space
                beq spacerkeyc2

		LDA $DC01
		and #$80
                bne spacerkeyc
spacerkeyc3:
		lda $dc01
                and #$80
		beq spacerkeyc3
		pla
		pla
rerun:
		jmp start


spacerkeyc2:
		lda $dc01
                and #$10
		beq spacerkeyc2
		rts

;=========================================================
okfailout:	pha
		cmp #$01
		beq failout
		jsr println
		.dw Ok
		pla
		rts
failout:
		jsr println
		.dw Fail
		pla
		rts
Ok:
		.pet $1e,"OK",5,13
		.db 0

Fail:
		.pet $96,"FAILED!",5,13
		.db 0
 
