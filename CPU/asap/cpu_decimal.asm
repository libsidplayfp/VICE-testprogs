;-------------------------------------------------------------------------------
; 6502 Decimal Mode Test
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

; CRC-32 based on my implementation in cc65 / zlib

D_FLAG	=	8
C_FLAG	=	1
CRC_POLY3	=	$ed
CRC_POLY2	=	$b8
CRC_POLY1	=	$83
CRC_POLY0	=	$20

OK3	=	$3d
OK2	=	$d8
OK1	=	$4d
OK0	=	$2a

crc	=	$80	; 4 bytes
zpdata	=	$84
zpflags	=	$85
scrptr	=	$86	; 2 bytes
printptr	=	$88	; 2 bytes

;	org	f:$3000
        * = $3000
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
	
	jsr	init_crc
	lda	#0
	jsr	test_adc_sbc
	lda	#C_FLAG
	jsr	test_adc_sbc
	lda	#D_FLAG
	jsr	test_adc_sbc
	lda	#D_FLAG|C_FLAG
	jsr	test_adc_sbc

	lda	crc+3
	cmp	#OK3
	bne	error
	lda	crc+2
	cmp	#OK2
	bne	error
	lda	crc+1
	cmp	#OK1
	bne	error
	lda	crc
	cmp	#OK0
	bne	error
        lda     #<pass
        ldx     #>pass
        jsr     print
        lda     #5
        sta     $d020
        jmp     *

error
        lda     #<fail
        ldx     #>fail
        jsr     print

	lda	crc+3
	jsr	put_hex_byte
	lda	crc+2
	jsr	put_hex_byte
	lda	crc+1
	jsr	put_hex_byte
	lda	crc
	jsr	put_hex_byte
	lda	#$9b
	jsr	put_char
        lda     #10
        sta     $d020
        jmp     *

test_adc_sbc
	sta	zpflags
	lda	#0	
	sta     zpdata
	ldy	#0
test_adc_sbc_byte
	lda	zpdata	
	sta     arr+1

	lda     zpflags
	pha
	tya
	plp
	adc	zpdata
	php
	jsr	do_crc
	pla
	jsr	do_crc

	lda    	zpflags
	pha
	tya
	plp
	sbc	zpdata
	php
	jsr	do_crc
	pla
	jsr	do_crc

	lda    	zpflags
	pha
	tya
	plp
arr	!byte	$6b,0                   ; ARR imm
	php
	jsr	do_crc
	pla
	jsr	do_crc

	iny
	bne	test_adc_sbc_byte
	inc	zpdata
	bne	test_adc_sbc_byte
	rts

init_crc
	ldx	#0
init_crc_entry
	lda	#0
	sta	crc+1
	sta	crc+2
	sta	crc+3
	ldy	#8
	txa
init_crc_bit
	sta	crc
	lsr
	bcc	init_crc_noxor
	lda	crc+3
	lsr
	eor	#CRC_POLY3
	sta	crc+3
	lda	crc+2
	ror
	eor	#CRC_POLY2
	sta	crc+2
	lda	crc+1
	ror
	eor	#CRC_POLY1
	sta	crc+1
	lda	crc
	ror
	eor	#CRC_POLY0
	bcs	init_crc_nextbit ; branch always
init_crc_noxor
	rol
	lsr	crc+3
	ror	crc+2
	ror	crc+1
	ror
init_crc_nextbit
	dey
	bne	init_crc_bit
	sta	crc_table_0,x
	lda	crc+1	
	sta     crc_table_1,x
	lda	crc+2	
	sta     crc_table_2,x
	lda	crc+3	
	sta     crc_table_3,x
	inx
	bne	init_crc_entry
	lda	#0	
        sta     crc
        sta     crc+1
	sta	crc+2
	sta	crc+3
	rts

; crc = (crc >> 8) ^ crc_table[(crc & 0xff) ^ input];
do_crc
	eor	crc
	tax
	lda	crc_table_0,x
	eor	crc+1
	sta	crc
	lda	crc_table_1,x
	eor	crc+2
	sta	crc+1
	lda	crc_table_2,x
	sta	crc+3
	sta	crc+2
	lda	crc_table_3,x	
	sta     crc+3
	rts

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
        

title	!scr "CPU: Decimal mode...",0
pass	!scr "Pass",$9b,0
fail	!scr "FAIL.",$9b,0

        
crc_table_0	*=      *+256
crc_table_1	*= 	*+256
crc_table_2	*= 	*+256
crc_table_3	*= 	*+256

