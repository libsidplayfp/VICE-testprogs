;this is for a easyflash cart!!

!to "tamtest.crt",plain

*= $8000-80

	!text "C64 CARTRIDGE   "
	!byte $00,$00 ;header length
	!byte $00,$40 ;header length
	!word $0001 ;version
	!word $2000 ;crt type (OCEAN $0500, MAGIC DESK $1300, EasyFlash $2000)
	!byte $01 ;exrom line
	!byte $00 ;game line
	!byte $00,$00,$00,$00,$00,$00 ;unused
	!text "TAMTEST",0

*= $8000-16
	;chip packets
	!text "CHIP"
	!byte $00,$00,$20,$10 ;chip length
	!byte $00,$02 ;chip type
	!byte $00,$00 ;bank
	!byte $80,$00 ;adress
	!byte $20,$00 ;length

;ROM part Bank 0 lo
;---------------------------------
*= $8000
.x8000
	lda #$00
	sta $dfff	; address for broken bits in RAM
	sta $dffb	; address for broken bits in color RAM
	ldx #$00
.lcopycheck
	lda .copy1,x	; copy ramtest code to $df00
	sta $df00,x
	inx
	cpx #<(.copy1ende-.copy1)
	bne .lcopycheck
	jmp $df00	; jmp to ramtest, broken bits in $dfff
.display
	; check color RAM with same routine an dirty modified code :-P
	lda #$d8
	sta .mcheckvalc4+1
	sta .mcheckvalc5+1
	lda #$04
	sta .mcheckvalc+1
	lda #$00
	sta .mcheckvalx+1
	lda #$fb
	sta .mcheckvalc1+1
	sta .mcheckvalc2+1
	lda #<.display2
	sta .mcheckvalc3+1
	lda #>.display2
	sta .mcheckvalc3+2
	jmp $df00
.display2
	; normal color RAM
	lda #$fe
	ldx #$00
.lnormalcolor
	sta $d800,x
	sta $d900,x
	sta $da00,x
	sta $db00,x
	inx
	bne .lnormalcolor
	; clr scr
	ldx #$00
	lda #$20
.lscre1
	sta $0400,x
	sta $0500,x
	sta $0600,x
	sta $0700,x
	inx
	bne .lscre1

	ldy #$ff	; read bits in $dfff an store #$ff in $0400-$0407 when broken
	lda $dfff	; $0400 = bit 7 // $0407 = bit 0
	asl
	bcc .lscre2
	sty $0400
.lscre2
	asl
	bcc .lscre3
	sty $0401
.lscre3
	asl
	bcc .lscre4
	sty $0402
.lscre4
	asl
	bcc .lscre5
	sty $0404
.lscre5
	asl
	bcc .lscre6
	sty $0404
.lscre6
	asl
	bcc .lscre7
	sty $0405
.lscre7
	asl
	bcc .lscre8
	sty $0406
.lscre8
	asl
	bcc .lscre81
	sty $0407
.lscre81
	ldy #$ff	; read bits in $dffb an store #$ff in $0428-$042f when broken
	lda $dffb	; $0428 = bit 7 // $042f = bit 0
	asl
	bcc .lscre82
	sty $0428
.lscre82
	asl
	bcc .lscre83
	sty $0429
.lscre83
	asl
	bcc .lscre84
	sty $042a
.lscre84
	asl
	bcc .lscre85
	sty $042b
.lscre85
	asl
	bcc .lscre86
	sty $042c
.lscre86
	asl
	bcc .lscre87
	sty $042d
.lscre87
	asl
	bcc .lscre88
	sty $042e
.lscre88
	asl
	bcc .lscre9
	sty $042f

.lscre9
	; LED blink for bit test
	lda #$00
	sta $dffc	; high-byte for loop
	lda #$80	; start with bit 7
	sta $dffe
	ldx #$08	; loop 8 bits
.bittest
	stx $dffd	; save x
	lda #$87
	sta $de02	; lights on
	lda #$ff
	sta $0450
	lda $dfff
	bit $dffe
	beq .kurz
.lang
	ldy #$06
	ldx #$00
.lang2
	dex
	bne .lang2
	dec $dffc
	bne .lang2
	dey
	bne .lang2
	beq .bittest2
.kurz
	ldy #$01
	ldx #$00
.kurz2
	dex
	bne .kurz2
	dec $dffc
	bne .kurz2
	dey
	bne .kurz2
.bittest2
	lda #$07
	sta $de02	; lights off
	lda #$20 
	sta $0450
	ldy #$02
	ldx #$00
.bittest3
	dex
	bne .bittest3
	dec $dffc
	bne .bittest3
	dey
	bne .bittest3
	ldx $dffd	; restore x
	lsr $dffe
	dex
	bne .bittest
	ldy #$06
	ldx #$00
.bittest4
	dex
	bne .bittest4
	dec $dffc
	bne .bittest4
	dey
	bne .bittest4

	; LED for color bit test
	lda #$00
	sta $dffc	; high-byte for loop
	lda #$80	; start with bit 7
	sta $dffe
	ldx #$08	; loop 8 bits
.bittestc
	stx $dffd	; save x
	lda #$87
	sta $de02	; lights on
	lda #$ff
	sta $0450
	lda $dffb
	bit $dffe
	beq .kurzc
.langc
	ldy #$06
	ldx #$00
.langc2
	dex
	bne .langc2
	dec $dffc
	bne .langc2
	dey
	bne .langc2
	beq .bittestc2
.kurzc
	ldy #$01
	ldx #$00
.kurzc2
	dex
	bne .kurzc2
	dec $dffc
	bne .kurzc2
	dey
	bne .kurzc2
.bittestc2
	lda #$07
	sta $de02	; lights off
	lda #$20 
	sta $0450
	ldy #$02
	ldx #$00
.bittestc3
	dex
	bne .bittestc3
	dec $dffc
	bne .bittestc3
	dey
	bne .bittestc3
	ldx $dffd	; restore x
	lsr $dffe
	dex
	bne .bittestc
	ldy #$06
	ldx #$00
.bittestc4
	dex
	bne .bittestc4
	dec $dffc
	bne .bittestc4
	dey
	bne .bittestc4

	lda #$00
	sta $d7ff
	
	jmp .lscre9

.copy1
!pseudopc $df00 {
.checkram
	lda #$35
	sta $01
	lda $01
	cmp #$35	; check if $01 can store #$35
	beq .lcheckram1
	lda #$01	; when broken border white
	sta $d020
	lda #$ff
	sta $d7ff
	jmp *
.lcheckram1
.mcheckvalc4
	lda #$00
	sta .mcheckval1+2
	sta .mcheckval2+2
	lda #<.hook1
	sta .mcheckval3+1
	lda #>.hook1
	sta .mcheckval3+2
	lda #$ff
	sta $dffe	; address with check value
	jmp .checkval
.hook1
.mcheckvalc5
	lda #$00
	sta .mcheckval1+2
	sta .mcheckval2+2
	lda #<.hook2
	sta .mcheckval3+1
	lda #>.hook2
	sta .mcheckval3+2
	lda #$00
	sta $dffe	; address with check value
	jmp .checkval
.hook2
	lda #$37
	sta $01
.mcheckvalc3
	jmp .display
.checkval
	ldy #$00
.mcheckvalx
	ldx #$02
.lcheckval1
	lda $dffe
.mcheckval1
	sta $0000,x
.mcheckval2
	lda $0000,x
	eor $dffe
.mcheckvalc1
	ora $dfff
.mcheckvalc2
	sta $dfff
	inx
	bne .lcheckval1
	inc .mcheckval1+2
	inc .mcheckval2+2
	iny
.mcheckvalc
	cpy #$00
	beq .lcheckval2
	cpy #$d0
	bne .lcheckval1
	ldy #$e0
	sty .mcheckval1+2
	sty .mcheckval2+2
	bne .lcheckval1
.lcheckval2
.mcheckval3
	jmp $ffff
.checkramende
}
.copy1ende
.x8000ende

!fill 8192-(.x8000ende-.x8000),$ff

	;chip packets
	!text "CHIP"
	!byte $00,$00,$20,$10 ;chip length
	!byte $00,$02 ;chip type
	!byte $00,$00 ;bank
	!byte $a0,$00 ;adress
	!byte $20,$00 ;length

;ROM part Bank 0 hi
;---------------------------------
.xa000
!fill $1f10,$ff		; number of $ff (.xstartcodeende must be $c010)

.xstartcode
!pseudopc .xstartcode+$3ff0 {
.xstart
	sei
	ldx #$ff
	txs
	cld
	lda #$08
	sta $d016
	lda #$85
	sta $de02	; lights on
	ldy #$00
	ldx #$00
.led
	dex
	bne .led
	dey
	bne .led
	lda #$05
	sta $de02	; lights off
	lda #$3f
	sta $dd02
	lda #$97
	sta $dd00
	ldx #$00
	txa
.linit1
	sta $d000,x	; init VIC
	inx
	cpx #$11
	bne .linit1
	sta $d013
	sta $d014
	sta $d015
	sta $d017
	lda #$c8
	sta $d016
	lda #$15
	sta $d018
	lda #$1b
	sta $d011
	ldx #$00
.linit2
	lda .values,x
	sta $d01b,x
	inx
	cpx #$14
	bne .linit2
.loop1
	ldx #$ff
	stx $dc02
	inx
	stx $dc03
	ldx #$7f
	stx $dc00
	lda $dc01
	cmp #$df	; C= key
	beq .normalboot
	stx $dc0d	; disable cia irqs
	stx $dd0d
	lda $dc0d
	lda $dd0d
	lda #$37	; prepate $00 / $01 for 16K mode
	sta $01
	lda #$2f
	sta $00
	ldy #$00
	lda $00		; check if $00 / $01 can store the values
	cmp #$2f
	beq .weiter1
	lda #$02	; border = red     => $00 is broken
	sta $d020
	iny
.weiter1
	lda $01
	cmp #$37
	beq .weiter2
	lda #$02	; background = red => $01 is broken (can't store #$37)
	sta $d021
	iny
.weiter2
	cpy #$00
	bne .errorloop
	ldx #<(.startende-.start-1)
.lcopy
	lda .start,x	; copy startcode for 16K mode switch to $df00 (Easyflash RAM)
	sta $df00,x
	dex
	bpl .lcopy
	jmp $df00
.start
	ldx #$00	; switch to 16K mode / leave ultimax
	lda #$07
	sta $de02
	stx $de00
	jmp $8000
.startende
.errorloop
    lda #$ff
    sta $d7ff
	jmp .errorloop
.normalboot
	ldx #<(.defcodeende-.defcode-1)
.lcopy2
	lda .defcode,x
	sta $df00,x
	dex
	bpl .lcopy2
	jmp $df00
.defcode
	lda #$04
	sta $de02
	jmp ($fffc)
.defcodeende

.values
	!byte $00,$00,$00,$00,$00,$fe,$f6,$f1,$f2,$f3,$f4,$f0,$f1,$f2,$f3,$f4,$f5,$f6,$f7,$fc
.vect
	!byte $fe, $ff, <.xstart, >.xstart, $40, $ff
}
.xstartcodeende

;!fill 8192-(.xstartcodeende-.xa000),$ff
