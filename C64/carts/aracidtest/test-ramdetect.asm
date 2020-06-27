
#ifdef STANDALONE
    #include "common.inc"
    #include "basicstart.asm"
    
#if IOMODE == 1    
        ; enable REU mapping and banking RAM (RR)
        lda #$42
        sta $de01
#endif
    
        jsr ramdetect
        
        ldy #10 ; fail
        ldx #$ff
        cmp #0  ; 0 means passed
        bne skp
        ldy #13 ; pass
        ldx #$00
skp:     
        sty $d020
        stx $d7ff
        jmp *
    
#endif

;========================================================= ramdetect
ramdetect:
		jsr println
		.dw Test1
		lda #$23
		jsr printarvalue
		jsr println
		.dw t_vrfyc64ram
		lda #clrval
		sta $de00
		jsr c64ramclr
		jsr c64ramsetup
		lda #$23
		sta $de00
		jsr c64ramclr    ; should clear AR ram now - destroys c64 ram on ccs :)
		jsr arramsetup

		lda #clrval
		sta $de00
		
		jsr c64ramverify
		jsr okfailout
		sta resultTest1a
		cmp #$01
		bne continue4
		ldx #clrval
		stx $de00
		jsr c64ramclr
		jsr c64ramsetup

continue4:
		jsr println
		.dw t_vrfyarram

		lda #$23
		sta $de00
		jsr arramverify
		ldx #clrval
		stx $de00
		jsr okfailout
		sta resultTest1b
		pha
		jsr println
		.dw Note1
		pla
		clc
		adc resultTest1a   ; add up the 2 results
		rts

#ifdef STANDALONE
    #include "test-common.asm"
    #include "common.asm"
    #include "text-common.asm"
    #include "text-ramdetect.asm"
resultTest1a:	.db $ff ; 0 - passed, 1 - failed == required
resultTest1b:	.db $ff ; 0 - passed, 1 - failed == required
#endif
