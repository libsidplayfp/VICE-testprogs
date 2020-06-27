
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
		jsr arramtest2

		lda #$21
		jsr arramtest2

		lda #$22
		jsr arramtest2

		lda #$23
		jsr arramtest2

        inc resultTest5+3   ; expected to pass
        inc resultTest5a+3
        inc resultTest5b+3
        
#if (CARTMODE == 3) || (CARTMODE == 0)
        inc resultTest5a+0
        inc resultTest5b+0
        inc resultTest5a+1
        inc resultTest5b+1
#endif
		
        lda #1
        ldx #0
lp:
        and resultTest5,x
        and resultTest5a,x
        and resultTest5b,x
        inx
        cpx #4
        bne lp

        ldy #10 ; fail
        ldx #$ff
        cmp #1  ; 0 means passed
        bne skp
        ldy #13 ; pass
        ldx #$00
skp:     
        sty $d020
        stx $d7ff
        
        jmp *
		
#endif

;========================================================= AR RAM test2
arramtest2:	pha
		jsr println
		.dw Test5
		pla

		sta runwith1b+1
		sta runwith2b+1
		sta runwith3b+1
		jsr printarvalue
		sec
		sbc #$20
		sta resultwith3a+1
		sta resultwith4a+1
		sta resultwith4b+1
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


; all setup - lets go
runwith1b:
		ldx #$23
		stx $de00        ; test 5 checks writeability of ram through "normal" mode
		jsr arramsetup

; ahh - ram thrashed (CCS) :)

		ldx #clrval
		stx $de00
		jsr println
		.dw t_vrfyc64ram
		ldx #clrval
		stx $de00
; c64 ram		
		jsr c64ramverify
		jsr okfailout
resultwith4b:
		ldx #$00
		sta resultTest5,x

		cmp #$01
		bne continue
		ldx #clrval
		stx $de00
		jsr c64ramclr
		jsr c64ramsetup
		
continue:

; ar io ram
		jsr println
		.dw t_vrfyarioram
runwith2b:
		ldx #$23
		stx $de00
		jsr arramverify
		ldx #clrval
		stx $de00
		jsr okfailout
resultwith3a:
		ldx #$00
		sta resultTest5a,x

; ar ram
		jsr println
		.dw t_vrfyarram

runwith3b:
		ldx #$23
		stx $de00
		jsr arioramverify2
		ldx #clrval
		stx $de00
		jsr okfailout

resultwith4a:
		ldx #$00
		sta resultTest5b,x
		rts

		jsr println
		.dw Note3
		rts

#ifdef STANDALONE
    #include "test-common.asm"
    #include "common.asm"
    #include "text-common.asm"
    #include "text-arramtest2.asm"
resultTest5:	.db $ff,$ff,$ff,$ff ; 0 - passed, 1 - failed    $20 - $23 c64 ram
resultTest5a:	.db $ff,$ff,$ff,$ff ; 0 - passed, 1 - failed    $20 - $23 ar io ram
resultTest5b:	.db $ff,$ff,$ff,$ff ; 0 - passed, 1 - failed    $20 - $23 ar ram
#endif 
 
