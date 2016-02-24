;-------------------------------------------------------------------------------
; 6502 Undocumented LAS Test
; originally written 27/11/2010 Piotr Fusik (0xF)
;-------------------------------------------------------------------------------

videoram = $0400
colorram = $d800

;-------------------------------------------------------------------------------
            *=$07ff
            !word $0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-------------------------------------------------------------------------------

            sei
            lda #$17
            sta $d018
            lda #$35
            sta $01
            lda #$7f
            sta $dc0d
            sta $dd0d
            lda $dc0d
            lda $dd0d
            ldx #0
-
            lda #$20
            sta videoram,x
            sta videoram+$0100,x
            sta videoram+$0200,x
            sta videoram+$0300,x
            lda #1
            sta colorram,x
            sta colorram+$0100,x
            sta colorram+$0200,x
            sta colorram+$0300,x
            inx
            bne -
            jmp main

;-------------------------------------------------------------------------------

regs	=	$80
regy	=	$81
addr	=	$82	; 2 bytes
data	=	$84
exp	=	$86
expnz	=	$87
pos	=	$89
scrptr	=	$8a	; 2 bytes
printptr	=	$8c	; 2 bytes

area	=	$2e00

;	org	f:$3000
main
        lda     #<(videoram+(8*40))
        sta     scrptr
        lda     #>(videoram+(8*40))
        sta     scrptr+1
        lda     #8
        sta     currline

	lda	#<title
	ldx	#>title
	jsr	print

	lda	#>area	
	sta     addr+1

	ldx	#0
loop
	stx	pos
	lda	input,x	
	sta     regs
	lda	input+1,x	
	sta     regy
	lda	input+2,x	
	sta     addr
	sta	las+1
	lda	input+3,x	
	sta     data

	lda	regs
	and	data
	sta	exp
	php
	pla
	sta	expnz

	ldy	regy
	lda	data	
	sta     (addr),y
	ldx	regs
	txs
las	!byte	$bb     ; las abs,y
        !word   area
	php
	cmp	exp
	bne	error
	cpx	exp
	bne	error
	pla
	eor	expnz
	and	#$80	; TODO: #$82, but Z is unstable
	bne	error
	tsx
	cpx	exp
	bne	error

	ldx	pos
	inx
	bne	loop

        lda     #<pass
        ldx     #>pass
        jsr     print
        lda     #5
        sta     $d020
        ldx #0 ; success
        stx $d7ff
        jmp     *

error
        lda     #<fail
        ldx     #>fail
        jsr     print

	lda	addr
	jsr	put_hex_byte
	lda	addr+1
	jsr	put_hex_byte
	lda	#<smsg
	ldx	#>smsg
	jsr	print
	lda	regs
	jsr	put_hex_byte
	lda	#<ymsg
	ldx	#>ymsg
	jsr	print
	lda	regy
	jsr	put_hex_byte
	lda	#$9b
	jsr	put_char
        lda     #10
        sta     $d020
        ldx #$ff ; failure
        stx $d7ff
        jmp     *

put_hex_byte
	pha
        lsr
        lsr
        lsr
        lsr
	jsr	put_hex_nibble
	pla
	and	#$f
put_hex_nibble
	cmp	#10
	sed
	adc	#'0'
	cld
put_char
        cmp     #$9b
        bne     +
nextline
        inc     currline
        lda     currline
        asl
        tax
        lda     lineaddr,x
        sta     scrptr
        lda     lineaddr+1,x
        sta     scrptr+1
        rts
+
        ldy     #0
        sta     (scrptr),y
        inc     scrptr
        bne +
        inc     scrptr+1
+
        rts

print
        sta     printptr
        stx     printptr+1
        jmp     print_2
print_1
        jsr     put_char
        inc     printptr
        bne     +
        inc     printptr+1
+
print_2
        ldy     #0
        lda     (printptr),y
        bne     print_1
        rts

currline: !byte 0
        
lineaddr:
        !word   ($0400+(0*40)),($0400+(1*40)),($0400+(2*40)),($0400+(3*40)),($0400+(4*40))
        !word   ($0400+(5*40)),($0400+(6*40)),($0400+(7*40)),($0400+(8*40)),($0400+(9*40))
        !word   ($0400+(10*40)),($0400+(11*40)),($0400+(12*40)),($0400+(13*40)),($0400+(14*40))
        !word   ($0400+(15*40)),($0400+(16*40)),($0400+(17*40)),($0400+(18*40)),($0400+(19*40))
        !word   ($0400+(20*40)),($0400+(21*40)),($0400+(22*40)),($0400+(23*40)),($0400+(24*40))
        
; just some random data
input
	!byte	$73,$c3,$26,$17,$3b,$9b,$82,$06,$6e,$f8,$c6,$74,$83,$6c,$d6,$7c
	!byte	$5b,$4f,$33,$72,$ef,$55,$69,$3f,$64,$f1,$02,$21,$ea,$51,$ad,$d8
	!byte	$55,$41,$bd,$cc,$c9,$b3,$a7,$30,$78,$41,$ab,$ac,$bc,$61,$49,$94
	!byte	$95,$a0,$b4,$37,$da,$aa,$e2,$50,$0f,$5f,$66,$12,$4d,$c4,$b7,$f4
	!byte	$1b,$1a,$18,$a2,$a2,$df,$b6,$36,$27,$f7,$33,$3a,$33,$e2,$49,$6e
	!byte	$4d,$25,$94,$f2,$b4,$c4,$50,$be,$f8,$0d,$10,$13,$e3,$82,$32,$cb
	!byte	$9a,$1a,$1e,$2a,$52,$bb,$14,$25,$90,$1d,$96,$b9,$54,$e8,$2d,$45
	!byte	$19,$5b,$9b,$86,$0e,$34,$3a,$2c,$77,$35,$9b,$91,$9d,$f8,$17,$a9
	!byte	$2a,$70,$7a,$9e,$6b,$ce,$6f,$35,$4e,$1d,$d2,$6c,$95,$53,$95,$77
	!byte	$17,$27,$5a,$83,$7e,$76,$74,$65,$6e,$74,$6a,$a5,$75,$79,$ac,$02
	!byte	$af,$b5,$a2,$e1,$89,$87,$be,$c3,$87,$cd,$ae,$41,$74,$ea,$69,$8e
	!byte	$ed,$d6,$2a,$1d,$a3,$eb,$17,$5a,$43,$d2,$a7,$0e,$6b,$43,$7b,$73
	!byte	$92,$ec,$d3,$7a,$50,$3b,$3e,$57,$e6,$65,$b9,$c9,$75,$5f,$d8,$3a
	!byte	$ca,$1e,$2c,$33,$26,$dd,$85,$28,$e9,$bd,$45,$34,$8a,$79,$59,$c1
	!byte	$c7,$7c,$10,$9d,$6b,$28,$75,$9e,$a0,$89,$4a,$40,$26,$49,$5b,$54
	!byte	$64,$1a,$48,$49,$b5,$7e,$68,$0f,$d6,$0e,$00,$27,$e2,$26,$62,$d7

title	!scr "CPU: LAS...",0
pass	!scr "Pass",$9b,0
fail	!scr "FAIL.",$9b,"Code:BB",0
smsg	!scr " S=",0
ymsg	!scr " Y=",0

