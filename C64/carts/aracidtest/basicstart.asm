		*= $0801
		.setpet
		.db $10,$08,$da,$07,$9e,$20,$32,$30,$36,$34,$20,$20,$20,$20,$00
		;$43,$50,$58,$00
		; basic line --- 2001 sys 2064 cpx

start:		ldy #$00	; basic end, don't change


		sei
		lda #$37
		sta $01
		iny
		sty $d021
		jsr $e3bf
		jsr $e453
		jsr $fd15
		jsr $ff5b
		sei
		ldx #$01
		stx $0286
		lda #$16
		sta $d018
		lda #$01
clrcol:		sta $d800,x
		sta $d900,x
		sta $da00,x
		sta $dae8,x
		inx
		bne clrcol
		stx $d020
 
