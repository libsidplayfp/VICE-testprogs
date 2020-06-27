
#ifdef STANDALONE
    #include "common.inc"
    #include "basicstart.asm"
    
#if IOMODE == 1    
        ; enable REU mapping and banking RAM (RR)
        lda #$42
        sta $de01
#endif
    
        jsr ramsizedetect
        ldy #10 ; fail
        ldx #$ff
#if IOMODE == 1    
        cmp #32  ; 32 for RR, 8 for AR/NP
#else
        cmp #8   ; 32 for RR, 8 for AR/NP
#endif
        bne skp
        ldy #13 ; pass
        ldx #$00
skp:     
        sty $d020
        stx $d7ff
    jmp *
    
#endif

;========================================================= ramsizedetect

; think about and test on plain machine
ramsizedetect:
		jsr println
		.dw Test2
		lda #clrval
		sta $de00
		jsr c64ramclr
		jsr c64ramsetup
		lda #$23	; %00100011
		sta $de00
		jsr c64ramclr    ; clears AR ram now
		jsr arramsetup

                lda #$23
                sta $de00       ; enable ram bank 0
                ldx #$01
                stx $8000       ; write ram

; CCS fails this, so just let it happen - ouch
;		lda #%00001010
;               sta $de00       ; restore to ROM bank 1
;               lda $8000
;               cmp #$01
;               bne skip        ;
;               jmp nothing     ; nothing check - prints -nocart?-
                                ; done whenever nothing worked
;skip:
                lda #$2b	; %00101011
                sta $de00       ; enable ram bank 1
                inx
                stx $8000

                lda #$33	; %00110011
                sta $de00       ; enable ram bank 2
                inx
                stx $8000

                lda #$3b	; %00111011
                sta $de00       ; enable ram bank 3
                inx
                stx $8000       ; fill other ram banks with values


                lda #%10100011
                sta $de00       ; enable ram bank 4
		inx
                stx $8000

                lda #%10101011
                sta $de00       ; enable ram bank 5
		inx
                stx $8000

                lda #%10110011
                sta $de00       ; enable ram bank 6
                inx
                stx $8000

                lda #%10111011
                sta $de00       ; enable ram bank 7
                inx
                stx $8000       ; fill other ram banks with values



                lda #clrval
                sta $de00
                inx
                stx $8000	; writing this to c64 ram ($09) may serve a later purpose, but not necessary

                lda #$23	; %00100011	; enable ram bank 0
                sta $de00

		ldx $8000	; fetch final value
                lda #clrval
                sta $de00	; restore to ROM bank 1
                cpx #$08	; all values went to the same bank: 8kb plain
                beq acht
                cpx #$05	; 32kb - one bank rotation was done
                beq zweindreiss
                cpx #$01	; 64kb - all banks received one value
                bne null	; found back the 9 from before maybe? so no cart at all?
                jmp viernsechzig   ; check for 8 and 32 kb ram ... 32 kb means rr

null:
;                lda #$ff		; first check passed, but this one didnt ?
;		.byte $2c
		lda #00		; 0kb
		.byte $2c
acht:		lda #08		; 8kb
		.byte $2c
zweindreiss:    lda #32		; 32kb
		.byte $2c
viernsechzig:   lda #64		; 64kb

		sta resultTest2
		pha

; here we determine future IO RAM accesses !
		cmp #$08
		bne setio1
		ldx #$df
		.byte $2c
setio1:
		ldx #$de
		stx baseio
		stx $f9
		ldx #$20
		stx $f8

; output detected ramsize
		tax
		lda #$00
		jsr $bdcd
		sei
		jsr println
		.dw Note2
		pla
		rts

#ifdef STANDALONE
    #include "test-common.asm"
    #include "common.asm"
    #include "text-common.asm"
    #include "text-ramsizedetect.asm"
resultTest2:	.db $fe ; 0, 8, 32, 64 kb        >= 8 required
baseio:		.db $ff ; de or df for RAM IO
#endif 
		
