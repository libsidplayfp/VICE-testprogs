
#ifdef STANDALONE
    #include "common.inc"
    #include "basicstart.asm"

#if IOMODE == 1    
        ; enable REU mapping and banking RAM (RR)
        lda #$42
        sta $de01
    
        ; set up location of RAM in I/O
		ldx #$de      ; RR
#else
		ldx #$df      ; AR/NP
#endif
		stx $f9
		ldx #$20
		stx $f8    
    
		lda #$20
		jsr ariotest2
		
		lda #$21
		jsr ariotest2

		lda #$22
		jsr ariotest2
		
		lda #$23
		jsr ariotest2

        dec resultTest4b+2  ; expected to fail
		
        lda #0
        ldx #0
lp:
        ora resultTest4,x
        ora resultTest4a,x
        ora resultTest4b,x
        inx
        cpx #4
        bne lp

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

;========================================================= AR IO test2
ariotest2:	pha
		jsr println
		.dw Test4
		pla

		sta runwith2a+1
		sta runwith3a+1
		jsr printarvalue
		sec
		sbc #$20
		sta resultwith3+1
		sta resultwith4+1
		sta resultwith8+1
		clc
		adc #$31
		sta $0427
		
		ldx #clrval
		stx $de00
		jsr c64ramclr
		jsr c64ramsetup
		ldx #$23
		stx $de00
		jsr c64ramclr    ; clears AR ram now
		jsr arramsetup

		jsr arramioreadsetup
		
; all setup - lets go

		ldx #clrval
		stx $de00
		jsr println
		.dw t_vrfyc64ram
		ldx #clrval
		stx $de00
; c64 ram		
		jsr c64ramverify
		jsr okfailout
resultwith8:
		ldx #$00
		sta resultTest4,x

		cmp #$01
		bne continue2
		ldx #clrval
		stx $de00
		jsr c64ramclr
		jsr c64ramsetup
		
continue2:
; ar io ram
		jsr println
		.dw t_vrfyarioram
runwith2a:
		ldx #$23
		stx $de00
		jsr arioverify
		ldx #clrval
		stx $de00
		jsr okfailout
resultwith3:
		ldx #$00
		sta resultTest4a,x

; ar ram
		jsr println
		.dw t_vrfyarram

runwith3a:
		ldx #$23
		stx $de00
		jsr arioramverify
		ldx #clrval
		stx $de00
		jsr okfailout

resultwith4:
		ldx #$00
		sta resultTest4b,x
		rts

		jsr println
		.dw Note3
		rts

#ifdef STANDALONE
    #include "test-common.asm"
    #include "common.asm"
    #include "text-common.asm"
    #include "text-ariotest2.asm"
resultTest4:	.db $ff,$ff,$ff,$ff ; 0 - passed, 1 - failed    $20 - $23 c64 ram
resultTest4a:	.db $ff,$ff,$ff,$ff ; 0 - passed, 1 - failed    $20 - $23 ar io ram
resultTest4b:	.db $ff,$ff,$ff,$ff ; 0 - passed, 1 - failed    $20 - $23 ar ram
#endif 
 
