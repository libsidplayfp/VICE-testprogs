
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
		jsr ariotest1
		
		lda #$21
		jsr ariotest1

		lda #$22
		jsr ariotest1

		lda #$23
		jsr ariotest1
    
        dec resultTest3b+2  ; expected to fail
    
        lda #0
        ldx #0
lp:
        ora resultTest3,x
        ora resultTest3a,x
        ora resultTest3b,x
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

;========================================================= AR IO test1
ariotest1:	
        pha
		jsr println
		.dw Test3
		pla

		sta runwith1+1
		sta runwith2+1
		sta runwith3+1
		jsr printarvalue
		sec
		sbc #$20
		sta resultwith+1
		sta resultwith2+1
		sta resultwith2a+1
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
; all setup - lets go
runwith1:
		ldx #$23
		stx $de00        ; test 3a checks writeability of ram through IO using normal mode
		jsr ariowrite
		ldx #clrval
		stx $de00
		jsr println
		.dw t_vrfyc64ram
		ldx #clrval
		stx $de00
; c64 ram		
		jsr c64ramverify
		jsr okfailout
resultwith2a:
		ldx #$00
		sta resultTest3,x
		cmp #$01
		bne continue3
		ldx #clrval
		stx $de00
		jsr c64ramclr
		jsr c64ramsetup
continue3:


; ar io ram
		jsr println
		.dw t_vrfyarioram
runwith2:
		ldx #$23
		stx $de00
		jsr arioverify
		ldx #clrval
		stx $de00
		jsr okfailout
resultwith:
		ldx #$00
		sta resultTest3a,x

; ar ram
		jsr println
		.dw t_vrfyarram

runwith3:
		ldx #$23
		stx $de00
		jsr arioramverify
		ldx #clrval
		stx $de00
		jsr okfailout

resultwith2:
		ldx #$00
		sta resultTest3b,x
		rts

		jsr println
		.dw Note3
		rts

#ifdef STANDALONE
    #include "test-common.asm"
    #include "common.asm"
    #include "text-common.asm"
    #include "text-ariotest1.asm"
resultTest3:	.db $ff,$ff,$ff,$ff ; 0 - passed, 1 - failed    $20 - $23 c64 ram
resultTest3a:	.db $ff,$ff,$ff,$ff ; 0 - passed, 1 - failed    $20 - $23 ar io ram
resultTest3b:	.db $ff,$ff,$ff,$ff ; 0 - passed, 1 - failed    $20 - $23 ar ram
#endif 
