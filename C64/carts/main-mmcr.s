
	;-----------------------------------------------------
	*=$0810
	
	jmp start
			
	!src "keyboard_scanner.inc"			
	!src "keyboard_scanner.s"
			
charromon:	; scanner config, $00 or $04 (OR mask for $01)
	!byte $04

cartmode:
	!byte $00
carttype:
	!byte $00
			
cartromlbanks:
	!byte $08	; MMC REPLAY
cartromlbank_and:
	!byte $07	; MMC REPLAY
cartromhbank_and:
;	!byte $00	; regular AR has one 8K ram bank
;	!byte $00	; regular RR has 4 8K ram banks
	!byte $07	; MMC REPLAY
cartrambanks:
;	!byte $01	; regular AR has one 8K ram bank
;	!byte $04	; regular RR has 4 8K ram banks
	!byte $08	; MMC REPLAY
cartrambank_and:
	!byte $07	; MMC REPLAY
			
cart_banklo:    ; $de00 cart bank reg lo (A13-A15)
	!byte $00
			
cart_allow_io_ram_banking:
	!byte (1<<1) ; default for Super Mapper
cart_alternative_io_mapping:
	!byte $00
			
; de01 is write once so it should be triggered seperatly
cart_set_de01:
	ldx cart_banklo
	lda bankloconfigs,x	; mirrored from $de00
	ora cart_allow_io_ram_banking
	ora cart_alternative_io_mapping
	sta $de01
	rts			
			
cart_bios_mode:         ; bit 0:	0 = MMC BIOS enabled, 1 = MMC BIOS disabled
	!byte $01 ; default for super mapper scanning
cart_disable_rr_rom:	; bit 5:	0 = allow RR rom when MMC BIOS disabled , 1 = disable RR ROM
	!byte $00
			
cart_set_df11:
	lda cart_bios_mode
	ora cart_disable_rr_rom
	sta $df11
	rts
			
cart_extended_mode:	; bit 6, 0 = RR compatibility mode, $40 = Extended mode
	!byte $40 ; default for super mapper scanning	
			
cart_set_df12:
	lda cart_extended_mode
	sta $df12
	rts
			
cart_bankhi:    	; $df13 cart bank reg hi (A16-A18)
	!byte $07
			
cart_16k_mode:		; bit 5:	16K rom mapping
	!byte (1<<5) ; default for super mapper scanning
			
cart_set_df13:
	lda cart_bankhi
	and #7
	ora cart_16k_mode
	ora #(1<<6) ; enable ar register
	sta $df13
	rts
			
			
			
start:			
;ff
;	inc $d020
;	jmp ff
			
	sei	
			
	; all rom
	lda #$37
	sta $01
			
	jsr scr_init
			
;ert			
;	inc $d020
;	jmp ert
			
!if 1 {			
	; all ram
	lda #$34
	sta $01
			
	jsr set_cartconfig_normal			
			
	lda #$80
	jsr tag_c64ram
	lda #$90
	jsr tag_c64ram
			
	lda #$a0
	jsr tag_c64ram
	lda #$b0
	jsr tag_c64ram
			
	lda #$e0
	jsr tag_c64ram
	lda #$f0
	jsr tag_c64ram
			
	lda #$de
	jsr tag_c64ram
	lda #$df
	jsr tag_c64ram
}			
	; all rom
	lda #$37
	sta $01
			
;	jsr set_cartconfig_normal			
			
	; switch to 16k super mapper mode
			
	lda #(1<<6)  ; extended mode
	sta $df12
	lda #(1<<5)|(1<<6) ; enable rr regs and 16k mode
	sta $df13
			
	lda #$21    ; ram enable and 16k game config
	lda #$23    ; ram enable and 16k game config
	sta $de00
	lda #(1<<1) ; enable ram banking
	sta $de01
	lda #(1)|(1<<5)|(1<<1)
	sta $df11

;erta			
;	inc $d020
;	jmp erta
			
!if 1 {
		
	ldx #0
tgclp1b			
	txa
	tay	
	pha
	
	ora #(1<<5)|(1<<6)
	sta $df13
			
	ldx #0
	
tgclp1			
	lda #$80
	jsr tag_cartram
	lda #$80+$1e
	jsr tag_cartram
	lda #$80+$1f
	jsr tag_cartram
	inx
	lda #$e0
	jsr tag_cartram
	lda #$e0+$1e
	jsr tag_cartram
	lda #$e0+$1f
	jsr tag_cartram
;	lda #$de
;	jsr tag_cartram
;	lda #$df
;	jsr tag_cartram
;	inx
	inx
;;	cpx #1		; regular AR has one 8K ram bank
;	cpx #4		; regular RR has 4 8K ram banks
	cpx cartrambanks
	bne tgclp1
			
	pla
	tax
	inx
	cpx #8
	bne tgclp1b
			
} 			
;loo			
;	inc $07c0
;	jmp loo
			
	jsr set_cartconfig_normal			
			
;offs=0
	jsr update_menu
	jmp mainloop
			
update_blocks:
	; all rom + io
	lda #$33
	ora charromon
	ldx #0
	ldy #1
	jsr printblock
			
;	inc $d020
			
	; all rom off + io
	lda #$32
	ora charromon
	ldx #20
	ldy #1
	jsr printblock
			
	; basic rom off + io
	lda #$31
	ora charromon
	ldx #0
	ldy #10
	jsr printblock
			
	; all rom off + io off
	lda #$30
	ora charromon
	ldx #20
	ldy #10
	jsr printblock
			
	ldx #0
	ldy #0
	jsr set_cursor
	lda #$33
	ora charromon
	jsr out_8bithex
	ldx #20
	ldy #0
	jsr set_cursor
	lda #$32
	ora charromon
	jsr out_8bithex
	ldx #0
	ldy #9
	jsr set_cursor
	lda #$31
	ora charromon
	jsr out_8bithex
	ldx #20
	ldy #9
	jsr set_cursor
	lda #$30
	ora charromon
	jsr out_8bithex
			
			
	rts
			
			
			
;-------------------------------------------------------------------------------------------
; print one scan block for all game/exrom/ram-enable combinations
;-------------------------------------------------------------------------------------------
			
blockconfigs:
	!byte $00,$01,$02,$03, $20,$21,$22,$23
			
bankloconfigs:
	!byte (0<<3),(1<<3),(2<<3),(3<<3),(1<<7)|(0<<3),(1<<7)|(1<<3),(1<<7)|(2<<3),(1<<7)|(3<<3)
			
curr01: !byte $00
			
printblock:			
;	sta $01
	sta curr01	
		
	stx blkx
	sty blky
			
		
	; loops over lines
	ldy #0
printblocklp1
	tya
	pha
			
	lda curr01	
	sta $01
sta $07c8
		
	ldx cart_banklo
	lda bankloconfigs,x
	ora blockconfigs,y
	sta $de00
			
;	inc $d020
			
blkx=*+1						
	ldx #0
	tya
	clc
blky=*+1						
	adc #0
	tay
	; gets pos in X/Y
	jsr printoneline
			
	pla
	tay
			
	iny
;	cpy #4 ; TEST
	cpy #8
	bne printblocklp1

	ldx blkx
	rts
			
printoneline:
	jsr set_cursor ; must be first in this function!
			
	lda #$80
	ldy #>tagtmp1
	ldx #<tagtmp1
	jsr get_tag
			
			
	; all ram
;	lda #$34
;	sta $01
			
			
	lda #$a0
	ldy #>tagtmp2
	ldx #<tagtmp2
	jsr get_tag
			
	lda #$de
	ldy #>tagtmp3
	ldx #<tagtmp3
	jsr get_tag
			
	lda #$df
	ldy #>tagtmp4
	ldx #<tagtmp4
	jsr get_tag
!if 1 {			
	lda #$e0
	ldy #>tagtmp5
	ldx #<tagtmp5
	jsr get_tag
}			
			
	lda #$37
	sta $01
			
	jsr set_cartconfig_normal			
			
	lda #12
	jsr scr_setcol
			
	lda #>tagtmp1
	ldx #<tagtmp1
	ldy #4
	jsr str_out
			
	lda #1
	jsr scr_setcol
			
	lda #>tagtmp2
	ldx #<tagtmp2
	ldy #4
	jsr str_out
			
	lda #15
	jsr scr_setcol
			
	lda #>tagtmp3
	ldx #<tagtmp3
	ldy #4
	jsr str_out
			
	lda #>tagtmp4
	ldx #<tagtmp4
	ldy #4
	jsr str_out
			
	lda #1
	jsr scr_setcol
			
	lda #>tagtmp5
	ldx #<tagtmp5
	ldy #4
	jsr str_out
			
	rts
			
;--------------------------------------------------------------------------			
			
scrzp=$02;
colzp=$fe;
			
scr_init:
			
	lda #0
	sta $d020
	sta $d021
		
	ldx #0
inlp:			
	lda #1
	sta $d800,x
	sta $d900,x
	sta $da00,x
	sta $db00,x
	lda #$20
	sta $0400,x
	sta $0500,x
	sta $0600,x
	sta $0700,x
	inx
	bne inlp
			
			
	lda #>$0400
	sta scrzp+1
	lda #<$0400
	sta scrzp
	lda #>$d800
	sta colzp+1
	lda #<$d800
	sta colzp
	rts
			
scr_setcol:
	sta currcol
	rts
			
currcol: !BYTE $01
			
scr_adj_colptr:
	pha
	lda scrzp
	sta colzp
	lda scrzp+1
	clc
	adc #($d8-$04)
	sta colzp+1
	pla
	rts
			
; output 0 terminated string
; A: high X: low
out_str:
	sta str3h
	stx str3l
			
	ldy #$0
lp2a
str3h=*+2
str3l=*+1
	lda tagtmp,y
	beq strskp2a
	sta (scrzp),y
	lda currcol
	sta (colzp),y
			
	iny
	bne lp2a
strskp2a
	tya			
	clc
	adc scrzp
	sta scrzp
	bcc strskp2b
	inc scrzp+1
strskp2b			
	jmp scr_adj_colptr			
			
str_out:
	sta strh
	stx strl
	sty strm
			
;;	jmp *
			
	ldy #$0
lp
strh=*+2
strl=*+1
	lda tagtmp,y
	sta (scrzp),y
	lda currcol
	sta (colzp),y
			
	iny
;	inx
strm=*+1
	cpy #4
	bne lp
			
	lda scrzp
	clc
	adc strm
	sta scrzp
	bcc strskp
	inc scrzp+1
strskp			
	jmp scr_adj_colptr			
			
char_out:
	pha
	sty strsy

	ldy #0
	sta (scrzp),y
	lda currcol
	sta (colzp),y
			
	inc colzp
	inc scrzp
	bne strskp2
	inc colzp+1
	inc scrzp+1
strskp2	
			
strsy=*+1
	ldy #0
	pla
	rts			
			
set_cursor:
	stx strc
					
	tya
	asl
	tay
			
	lda mul40,y ; lo
	clc
strc=*+1
	adc #0 ; col
	sta scrzp
			
	lda mul40+1,y ; hi
	adc #0
	sta scrzp+1
	jmp scr_adj_colptr
						
out_4bithex			
	stx strsx
	tax
	lda hexnum,x
	jsr char_out
strsx=*+1
	ldx #0
	rts
			
out_8bithex			
	stx strsx2
	sta strsa2
			
	lsr
	lsr
	lsr
	lsr
	tax
	lda hexnum,x
	sta $07c3
	jsr char_out
			
	lda strsa2
			
	and #$f
	tax
	lda hexnum,x
	sta $07c4
	jsr char_out
			
strsx2=*+1
	ldx #0
strsa2=*+1
	lda #0
	rts
			
screen_base=$0400
			
mul40:
	!word screen_base+(0*40)
	!word screen_base+(1*40)
	!word screen_base+(2*40)
	!word screen_base+(3*40)
	!word screen_base+(4*40)
	!word screen_base+(5*40)
	!word screen_base+(6*40)
	!word screen_base+(7*40)
	!word screen_base+(8*40)
	!word screen_base+(9*40)
	!word screen_base+(10*40)
	!word screen_base+(11*40)
	!word screen_base+(12*40)
	!word screen_base+(13*40)
	!word screen_base+(14*40)
	!word screen_base+(15*40)
	!word screen_base+(16*40)
	!word screen_base+(17*40)
	!word screen_base+(18*40)
	!word screen_base+(19*40)
	!word screen_base+(20*40)
	!word screen_base+(21*40)
	!word screen_base+(22*40)
	!word screen_base+(23*40)
	!word screen_base+(24*40)
			
;--------------------------------------------------------------------------			
			
tag_c64ram:
	sta tgaddrh
	ldx #0
	ldy #(3*4)	; offset to tag	(c64 ram)
tglp1:			
	lda tags,y
tgaddrh=*+2
	sta $de80,x
	iny
	inx
	cpx #4
	bne tglp1
	rts			
			
; AR has 8k RAM (one bank)
			
; AR has one register at $de00
; 0 - game
; 1 - exrom
; 2 - write 1 to disable ar
; 3 - A13 of ROM/RAM addr
			
; 4 - A14 of ROM/RAM addr
; 5 - export ram
			
crtramconfigs_ar:
	!byte (0<<3),(1<<3),(2<<3),(3<<3) ,(1<<7)|(0<<3),(1<<7)|(1<<3),(1<<7)|(2<<3),(1<<7)|(3<<3)
hexnum: !scr "0123456789abcdef"			
			
set_cartconfig_normal:
	lda #(0<<5)|($2)	; ($22) disable rom/ram, enable ram in i/o
	sta $de00
	rts			
			
tag_cartram:
	sty tgy2		; bankh
	stx tgx2		; bankl
	sta tgaddrh2		; addr hi
			
;	txa
;	lsr
;	lsr
;	lsr
;	lsr
;	tax
	lda hexnum,y
	sta tags+(6*4)
			
;	lda tgx2
;	tax
	lda hexnum,x
	sta tags+(6*4)+1
		
			
	ldx tgx2
			
	; AR mode
;	lda bankloconfigs,x
;	ora #($23)|($0)	; export ram, enable ram at $8000 and in i/o
;	sta $de00
			
	; map ram to $8000 in MMC Bios Mode
;	lda #$20
;	sta $de00
;	lda #$22
;	sta $df11
			
	lda crtramconfigs_ar,x
;	ora #($23)|($0)	; MMC BIOS export ram, enable ram at $8000 and in i/o
	ora #$23	; super mapper
	sta $de00
			
;erde			
;	inc $d020
;	jmp erde
			
	ldx #0
	ldy #(0*4)	; offset to tag	
tglp2:			
	lda tags+(6*4),y
tgaddrh2=*+2
	sta $de80,x
	iny
	inx
	cpx #4
	bne tglp2
			
;	jsr set_cartconfig_normal			
tgx2=*+1			
	ldx #0
tgy2=*+1			
	ldy #0
	rts			
			
			
get_tag:
	sta gtgaddrh
	stx gtgaddr2l
	sty gtgaddr2h
	ldy #0
	ldx #0
gtglp1:			
gtgaddrh=*+2
	lda $de80,x
gtgaddr2l=*+1
gtgaddr2h=*+2
	sta tagtmp,x
	inx
	cpx #4
	bne gtglp1
			
	ldx gtgaddr2l
	ldy gtgaddr2h
	jsr cmp_tag
	beq nf1
	tya
	ldx gtgaddr2l
	ldy gtgaddr2h
	jsr cpy_tag
nf1			
	lda gtgaddrh
	ldx gtgaddr2l
	ldy gtgaddr2h
	rts			
			
fixup_entries=3 +3 +3+3 +(3*8)
fixup_tags:			
	!BYTE $79,$69,$b8,$79 ; basic rom
	!BYTE $72,$20,$67,$b8 ; kernal rom
	!BYTE $7c,$66,$66,$7c ; char rom 0x0080
	!BYTE $83,$99,$99,$83 ; char rom 0x1e80
	!BYTE $ff,$ff,$ff,$e0 ; char rom 0x1f80
				
	!BYTE $dc,$29,$04,$f0 ; ar50pro-pal offs 0x0080
	!BYTE $9f,$ee,$63,$9f ; ar50pro-pal offs 0x1f80
			
	!BYTE $86,$a6,$84,$a7 ; ar50pro-pal offs 0x4080
			
	;rr38ppal - bank 0
	!BYTE $52,$52,$33,$38 ;rr38ppal 0x0080
	!BYTE $48,$a9,$fb,$cd ;rr38ppal 0x1e80
	!BYTE $f6,$a2,$00,$a4 ;rr38ppal 0x1f80
	;rr38ppal - bank 1
	!BYTE $e3,$48,$a9,$85 ;rr38ppal 0x2080
	!BYTE $20,$97,$de,$4c ;rr38ppal 0x3e80
	!BYTE $a9,$08,$48,$a9 ;rr38ppal 0x3f80
			
			
	;mmcreplay 0.53 		
	!BYTE $ad, $01, $dc, $c9
	!BYTE $99, $00, $02, $c8
	!BYTE $22, $8d, $11, $df
	!BYTE $d5, $a2, $01, $86
	!BYTE $31, $00, $20, $20
	!BYTE $61, $74, $65, $21
	!BYTE $a9, $04, $85, $21
	!BYTE $ff, $ff, $ff, $ff
	!BYTE $00, $01, $02, $03
	!BYTE $20, $85, $1e, $a9
	!BYTE $ff, $ff, $ff, $ff
	!BYTE $00, $01, $02, $03
	!BYTE $ff, $e8, $e0, $24
	!BYTE $8d, $11, $df, $a5
	!BYTE $ff, $ff, $ff, $ff
	!BYTE $31, $85, $20, $a9
	!BYTE $ff, $ff, $ff, $ff
	!BYTE $00, $01, $02, $03
	!BYTE $ff, $ff, $ff, $ff
	!BYTE $ff, $ff, $ff, $ff
	!BYTE $ff, $ff, $ff, $ff
	!BYTE $ff, $ff, $ff, $ff
	!BYTE $ff, $ff, $ff, $ff
	!BYTE $ff, $ff, $ff, $ff
			
fixup_strings:			
	!scr "basi"  ; 0 internal c64 rom
	!scr "kern"  ; 1 internal c64 rom
	!scr "char"  ; 2 internal c64 rom
	!scr "char"  ; 2 internal c64 rom
	!scr "char"  ; 2 internal c64 rom
		
	!scr "00ro"  ; 6 external crt rom
	!scr "00ro"  ; 6 external crt rom
	!scr "01ro"  ; 6 external crt rom
			
	;rr38ppal - bank 0
	!scr "00ro"  ; 6 external crt rom
	!scr "00ro"  ; 6 external crt rom
	!scr "00ro"  ; 6 external crt rom
	;rr38ppal - bank 1
	!scr "01ro"  ; 6 external crt rom
	!scr "01ro"  ; 6 external crt rom
	!scr "01ro"  ; 6 external crt rom
		
	;mmcreplay - bank 0
	!scr "00ro"  ; 6 external crt rom
	!scr "00ro"  ; 6 external crt rom
	!scr "00ro"  ; 6 external crt rom
	!scr "01ro"  ; 6 external crt rom
	!scr "01ro"  ; 6 external crt rom
	!scr "01ro"  ; 6 external crt rom
	!scr "02ro"  ; 6 external crt rom
	!scr "02ro"  ; 6 external crt rom
	!scr "02ro"  ; 6 external crt rom
	!scr "03ro"  ; 6 external crt rom
	!scr "03ro"  ; 6 external crt rom
	!scr "03ro"  ; 6 external crt rom
	!scr "04ro"  ; 6 external crt rom
	!scr "04ro"  ; 6 external crt rom
	!scr "04ro"  ; 6 external crt rom
	!scr "05ro"  ; 6 external crt rom
	!scr "05ro"  ; 6 external crt rom
	!scr "05ro"  ; 6 external crt rom
	!scr "06ro"  ; 6 external crt rom
	!scr "06ro"  ; 6 external crt rom
	!scr "06ro"  ; 6 external crt rom
	!scr "07ro"  ; 6 external crt rom
	!scr "07ro"  ; 6 external crt rom
	!scr "07ro"  ; 6 external crt rom
		
tags:
	!scr "basi"  ; 0 internal c64 rom
	!scr "kern"  ; 1 internal c64 rom
	!scr "char"  ; 2 internal c64 rom
		
	!scr " ram"  ; 3 internal c64 ram
	!scr " io1"  ; 4 internal c64 io1
	!scr " io2"  ; 5 internal c64 io2
		
	!scr "00ra"  ; 6 external crt ram
	!scr "00ro"  ; 7 external crt rom
			
;kernal_fixup:
		
cmp_tag:
		
	stx gtgaddr4l
	sty gtgaddr4h
		
	ldy #0
gtglp4a:		
	tya
	pha
		
	asl
	asl
	tay
		
	ldx #0
gtglp4:			
gtgaddr4l=*+1
gtgaddr4h=*+2
	lda tagtmp,x
	cmp fixup_tags,y
	bne sa
	iny
	inx
	cpx #4
	bne gtglp4
			
	; equal, get number from stack and return
			
	pla
	tay
			
	lda #1
	rts			
			
sa
	; not equal, check next
	pla
	tay
	iny
	cpy #fixup_entries
	bne gtglp4a
			
	; not equal
	lda #0
	rts			
			
cpy_tag:
		
	stx gtgaddr5l
	sty gtgaddr5h
;	ldy #0
	asl
	asl
	tay
	ldx #0
gtglp5:			
	lda fixup_strings,y
gtgaddr5l=*+1
gtgaddr5h=*+2
	sta tagtmp,x
	iny
	inx
	cpx #4
	bne gtglp5
			
	rts			
			

tagtmp:
	!scr "--------",0
		
tagtmp1:
	!scr "--------",0
tagtmp2:
	!scr "--------",0
tagtmp3:
	!scr "--------",0
tagtmp4:
	!scr "--------",0
tagtmp5:
	!scr "--------",0
		
;----------------------------------------------------------------------------------------------------------------

	!byte "t","a","g"
	!byte "t","a","g"

update_menu:			
	; lo bank
	ldx #0
	ldy #19
	jsr set_cursor
	lda #>str_banklo
	ldx #<str_banklo
	jsr out_str
	lda cart_banklo
	jsr out_8bithex
			
	; hi bank
	lda #>str_bankhi
	ldx #<str_bankhi
	jsr out_str
	lda cart_bankhi
	jsr out_8bithex
			
	ldx #0
	ldy #20
	jsr set_cursor
	lda #>str_allowbank
	ldx #<str_allowbank
	jsr out_str
	lda cart_allow_io_ram_banking
	jsr out_8bithex
			
;	ldx #0+(2*3)
;	ldy #21
;	jsr set_cursor
	lda #>str_reubank
	ldx #<str_reubank
	jsr out_str
	lda cart_alternative_io_mapping
	jsr out_8bithex
			
	lda #>str_write
	ldx #<str_write
	jsr out_str
			
	ldx #0
	ldy #21
	jsr set_cursor
	lda #>str_extended
	ldx #<str_extended
	jsr out_str
	lda cart_extended_mode
	jsr out_8bithex
			
;	ldx #0+(4*3)
;	ldy #22
;,	jsr set_cursor
	lda #>str_optional
	ldx #<str_optional
	jsr out_str
	lda cart_disable_rr_rom
	jsr out_8bithex
			
	ldx #0
	ldy #22
	jsr set_cursor
	lda #>str_supermapper
	ldx #<str_supermapper
	jsr out_str
	lda cart_16k_mode
	jsr out_8bithex
	lda #>str_bios
	ldx #<str_bios
	jsr out_str
	lda cart_bios_mode
	jsr out_8bithex
			
	rts
			
mainloop:
	jsr update_blocks
			
;	inc $d020
			
	; all rom + io
	lda #$37
	sta $01
			
	lda #$f8
wtfrm:			
	cmp $d012
	bcs wtfrm
	lda #$f8
wtfrm2:			
	cmp $d012
	bcc wtfrm2
			
	;-------------------------
			
	jsr minikey
	sta thiskey
	cmp #$ff
	beq mainloop
			
	lda thiskey
	cmp #keycode_c
	bne kcskp
			
	lda charromon
	eor #$04
	sta charromon
	jmp kallskp
			
kcskp:
			
	; de01
			
	cmp #keycode_r
	bne krskp
			
	lda cart_allow_io_ram_banking
	eor #(1<<1)
	sta cart_allow_io_ram_banking
			
	jmp kallskp
			
krskp:
	cmp #keycode_i
	bne kiskp
			
	lda cart_alternative_io_mapping
	eor #(1<<6)
	sta cart_alternative_io_mapping
			
	jmp kallskp
			
kiskp:
			
	cmp #keycode_w
	bne kwskp
	jsr cart_set_de01
	jmp kallskp
			
kwskp:
			
	; df11
			
	cmp #keycode_b
	bne kbskp
			
	lda cart_bios_mode
	eor #(1)
	sta cart_bios_mode
	jsr cart_set_df11
			
	jmp kallskp
			
kbskp:
			
	cmp #keycode_o
	bne koskp
			
	lda cart_disable_rr_rom
	eor #(1<<5)
	sta cart_disable_rr_rom
	jsr cart_set_df11
			
	jmp kallskp
			
koskp:
			
	; df12
			
	cmp #keycode_e
	bne keskp
			
	lda cart_extended_mode
	eor #(1<<6)
	sta cart_extended_mode
	jsr cart_set_df12
			
	jmp kallskp
			
keskp:
			
	; df13
	cmp #keycode_f5
	bne kf5skp
			
	ldx cart_bankhi
	inx
	txa
	and cartromhbank_and
	sta cart_bankhi
	jsr cart_set_df13
	jmp kallskp
			
kf5skp:
	cmp #keycode_f7
	bne kf7skp
			
	ldx cart_bankhi
	dex
	txa
	and cartromhbank_and
	sta cart_bankhi
	jsr cart_set_df13
	jmp kallskp
			
kf7skp:
			
	cmp #keycode_s
	bne ksskp
			
	lda cart_16k_mode
	eor #(1<<5)
	sta cart_16k_mode
	jsr cart_set_df13
			
	jmp kallskp
			
ksskp:
			
	; other
			
	cmp #keycode_f1
	bne kf1skp
			
	ldx cart_banklo
	inx
	txa
	and cartromlbank_and
	sta cart_banklo
	jmp kallskp
			
kf1skp:
			
	cmp #keycode_f3
	bne kf2skp
			
	ldx cart_banklo
	dex
	txa
	and cartromlbank_and
	sta cart_banklo
	jmp kallskp
			
kf2skp:
			
kallskp	

	;-------------------------		
						
	jsr update_menu
	jsr update_blocks
			
keywait			
	jsr minikey
	cmp #$ff
	bne keywait
			
	jmp mainloop
			
thiskey:
	!byte 0			
			
;----------------------------------------------------------------------------------------------------------------
; menu strings
str_banklo:
	!scr "[f1/f3]bank lo:",0
str_bankhi:
	!scr " [f5/f7]bank hi:",0
		
str_allowbank:
	!scr "[r]ram banking:",0
str_reubank:
	!scr " [i]io1 banking:",0
str_write:
	!scr " [w]",0
		
str_extended:
	!scr "[e]ext.mode:",0
str_optional:
	!scr " [o]opt.banking:",0
str_supermapper:
	!scr "[s]16k mode:",0
str_bios:
	!scr " [b]bios mode:",0
		
		