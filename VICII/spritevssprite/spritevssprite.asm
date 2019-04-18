
	.code

	.word	basicLoader
basicLoader:
	; 2019 SYS(2080):PW.SOFT.
	.byte	$18, $08, $e3, $07, $9e, $28, $32, $30
	.byte	$38, $30, $29, $3a, $8f, $20, $50, $57
	.byte	$2E, $53, $4F, $46, $54, $2E, $00, $00
	.byte	$00, $00, $00, $00, $00, $00, $00

	.code
	jmp main

SPRITEPOS = $0340
REGENPOS = $0400
SPRBASE0 = REGENPOS+1016
SPRBASE1 = REGENPOS+1017
SPRBASE2 = REGENPOS+1018
SPRBASE3 = REGENPOS+1019
SPRBASE4 = REGENPOS+1020
SPRBASE5 = REGENPOS+1021
SPRBASE6 = REGENPOS+1022
SPRBASE7 = REGENPOS+1023
MX8      = $D010  ; Mob 8th bit
YSCROLL  = $D011
RASTER   = $D012
ME       = $D015  ; Mob enable
XSCROLL  = $D016
MYE      = $D017  ; Mob Y-expand
MEMPTR   = $D018
MMC      = $D01C  ; Mob multicolor mode
MXE      = $D01D  ; Mob X-expand
M2M      = $D01E  ; Mob 2 Mob collision
M2D      = $D01F  ; Mob 2 data collision
EC       = $D020  ; Exterior color
BC0      = $D021  ; Background color #0
BC1      = $D022  ; Background color #1
BC2      = $D023  ; Background color #2
BC3      = $D024  ; Background color #3
MM0      = $D025  ; Mob multicolor #0
MM1      = $D026  ; Mob multicolor #1
MC0      = $D027  ; Mob color #0
MC1      = $D028  ; Mob color #1
MC2      = $D029  ; Mob color #2
MC3      = $D02A  ; Mob color #3
MC4      = $D02B  ; Mob color #4
MC5      = $D02C  ; Mob color #5
MC6      = $D02D  ; Mob color #6
MC7      = $D02E  ; Mob color #7


	.macro cycles nr_cycles
		.if ((nr_cycles .mod 2) = 1)
			cmp	$ff
			.repeat ((nr_cycles-3) / 2)
				cld
			.endrep
		.else
			.repeat (nr_cycles / 2)
				cld
			.endrep
		.endif
	.endmacro
	
	.macro test_mmc yval,res_addr
		lda	#yval
		sta	YSCROLL
		lda	M2M
		lda	M2M
		sta	res_addr,x
		inc	BC0
		cycles 31
	.endmacro

stable:
	cmp RASTER
	bne	stable
	ldx	#$0B
	nop
	nop
	nop
;	nop
stable1:
	inc	EC
	lda	RASTER
	dec	EC
	lda	RASTER
	lda	RASTER
	lda	RASTER
	lda	RASTER
	lda	RASTER
	lda	RASTER
	inc	$ff
	nop
	nop
	nop
	cmp	RASTER
	beq	stable2
stable2:
	dex
	bne stable1
	rts

main:
	jsr	init_sprite
	jsr	init_colorram
testagain:
	lda	#$00
	sta	test_pos
	sta passfail
	lda #$CC
	sta $3FFF
	
	lda	#SPRITEPOS/64
	sta	SPRBASE0
	sta	SPRBASE1
	lda	#$03
	sta	ME
	
	lda	#60
	sta	$D000
	sta	$D002
	lda	#50
	sta	$D001
	sta	$D003
main_loop:

	sei
	lda	#38
	jsr	stable
;	cycles 63
	cycles 39
	
	inc	EC
	lda	test_pos
	tax
	clc
	adc	#60
	sta	$D000
	sta	$D002
	
	test_mmc $10,REGENPOS+ 0*40
	test_mmc $11,REGENPOS+ 1*40
	test_mmc $12,REGENPOS+ 2*40
	test_mmc $13,REGENPOS+ 3*40
	test_mmc $14,REGENPOS+ 4*40
	test_mmc $15,REGENPOS+ 5*40
	test_mmc $16,REGENPOS+ 6*40
	test_mmc $17,REGENPOS+ 7*40
	test_mmc $10,REGENPOS+ 8*40
	test_mmc $11,REGENPOS+ 9*40
	test_mmc $12,REGENPOS+10*40
	test_mmc $13,REGENPOS+11*40
	test_mmc $14,REGENPOS+12*40
	test_mmc $15,REGENPOS+13*40
	test_mmc $16,REGENPOS+14*40
	test_mmc $17,REGENPOS+15*40
	test_mmc $10,REGENPOS+16*40
	test_mmc $11,REGENPOS+17*40
	test_mmc $12,REGENPOS+18*40
	test_mmc $13,REGENPOS+19*40
	
	lda	#$00
	sta	EC
	sta	BC0
	
	lda cycle_nrs,x
	sta	REGENPOS+20*40,x
	
;	lda	#$1
;	sta	YSCROLL
	
	
	ldx	test_pos
	inx
	cpx	#40
	beq	verify
	stx	test_pos

	; ========= Lower  Border =========
	; Use $D011 register to detect start of new frame
	;
raster_end:
	lda	$D011
	and	#$80
	beq	raster_end
raster_begin:
	lda	$D011
	and	#$80
	bne	raster_begin

	jmp	main_loop
	
verify:
	ldx #$00
verify_loop:
	lda #$05
	sta $D800,x	
	sta $D900,x	
	sta $DA00,x	
	sta $DA20,x	
	lda REGENPOS,x
	cmp expected_result,x
	beq verify_ok0
	lda #$02
	sta $D800,x
	lda #$ff
	sta passfail
verify_ok0:
	lda REGENPOS+$0100,x
	cmp expected_result+$0100,x
	beq verify_ok1
	lda #$02
	sta $D900,x
	lda #$ff
	sta passfail
verify_ok1:
	lda REGENPOS+$0200,x
	cmp expected_result+$0200,x
	beq verify_ok2
	lda #$02
	sta $DA00,x
	lda #$ff
	sta passfail
verify_ok2:
	lda REGENPOS+$0220,x
	cmp expected_result+$0220,x
	beq verify_ok_last
	lda #$02
	sta $DA20,x
	lda #$ff
	sta passfail
verify_ok_last:
	inx
	bne verify_loop
	
; 	; Restore yscroll value
; 	lda #$1B
; 	sta YSCROLL
; 	
; 	; Disable sprites
; 	lda #$00
; 	sta ME
; 	
; 	; Position cursor
; 	clc
; 	ldx #20
; 	ldy #0
; 	jsr $E50A

	; Output results
	ldx #$05
	lda passfail
	sta $d7ff
	beq noerror
	ldx #$02
noerror:
	stx $d020

	jmp	testagain
	
	; Return to basic (or whatever called us)
	sei
	jmp *

test_pos:
	.byte	$00
	
passfail:
	.byte	$00
	
cycle_nrs:
	.byte	$30,$31,$32,$33,$34,$35,$36,$37,$38,$39
	.byte	$30,$31,$32,$33,$34,$35,$36,$37,$38,$39
	.byte	$30,$31,$32,$33,$34,$35,$36,$37,$38,$39
	.byte	$30,$31,$32,$33,$34,$35,$36,$37,$38,$39
	
sprite_bytes:
	.byte	$80,$00,$00
	.byte	$40,$00,$00
	.byte	$20,$00,$00
	.byte	$10,$00,$00
	.byte	$08,$00,$00
	.byte	$04,$00,$00
	.byte	$02,$00,$00
	.byte	$01,$00,$00
	.byte	$00,$80,$00
	.byte	$00,$40,$00
	.byte	$00,$20,$00
	.byte	$00,$10,$00
	.byte	$00,$08,$00
	.byte	$00,$04,$00
	.byte	$00,$02,$00
	.byte	$00,$01,$00
	.byte	$00,$00,$80
	.byte	$00,$00,$40
	.byte	$00,$00,$20
	.byte	$00,$00,$10
	.byte	$00,$00,$08

init_sprite:
	ldx	#$00
init_sprite_1:
	lda	sprite_bytes,x
	sta	SPRITEPOS,x
	inx
	bne	init_sprite_1
	rts

init_colorram:
	ldx	#$00
	lda	#$0F
init_colorram_1:
	sta	$D800,x
	sta	$D900,x	
	sta	$DA00,x	
	sta	$DB00,x	
	inx
	bne	init_colorram_1
	rts
	
expected_result:
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03
	.byte	$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$03
	.byte	$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$03,$03
	.byte	$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$03,$03,$03
	.byte	$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$03,$03,$03,$03
	.byte	$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$03,$03,$03,$03,$03
	.byte	$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$03,$03,$03,$03,$03,$03
	.byte	$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$03,$03,$03,$03,$03,$03,$03
	.byte	$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.byte	$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.byte	$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$00,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.byte	$03,$03,$03,$03,$03,$03,$03,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$00,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.byte	$03,$03,$03,$03,$03,$03,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$00,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.byte	$03,$03,$03,$03,$03,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
	.byte	$00,$00,$00,$00,$00,$00,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03
	.byte	$03,$03,$03,$03,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
