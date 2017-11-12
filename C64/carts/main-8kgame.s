CRTID = 0 ; normal
;CRTID = 36 ; retro replay
;CRTID = 53 ; pagefox

ROMSTART = $8000

    * = ROMSTART

    !word copycode
    !word copycode
    !byte $c3, $c2, $cd, $38, $30
		 
		 
copycode:
            sei
            ldx #$ff
            txs
            cld

            ; we must set data first, then update DDR
            lda #$37
            sta $01
            lda #$2f
            sta $00

            ; enable VIC (e.g. RAM refresh)
            lda #8
            sta $d016

            ; write to RAM to make sure it starts up correctly (=> RAM datasheets)
lp1:
            sta $0100, x
            dex
            bne lp1

            jsr $ff84   ; Initialise I/O
            jsr $ff87   ; Initialise System Constants
            jsr $ff8a   ; Restore Kernal Vectors
            jsr $ff81   ; Initialize screen editor

            sei
            lda #>codestart
            sta $fa+1
            lda #<codestart
            sta $fa

            lda #>$0800
            sta $fc+1
            lda #<$0800
            sta $fc

            ldx #$40
lp3:
            ldy #0
lp2:
            lda ($fa),y
            sta ($fc),y
            iny
            bne lp2
            
            inc $fa+1
            inc $fc+1
            dex
            bne lp3

            jmp $0800
    
    * = ROMSTART + $80
    !scr "ca80"

        ;-----------------------------------------------------
codestart:
	!pseudopc $0800 {

tagoffset = $80 ; fixup tables must match this offset
taglen = 4
	
	jmp start
			
	!src "keyboard_scanner.inc"			
	!src "keyboard_scanner.s"
			
start:
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
	lda #$30
	sta $01

        lda #$03
        jsr tag_c64ram

        lda #$70
        jsr tag_c64ram

	lda #$80
	jsr tag_c64ram
	lda #$90
	jsr tag_c64ram
			
	lda #$a0
	jsr tag_c64ram
	lda #$b0
	jsr tag_c64ram

        lda #$c0
        jsr tag_c64ram
        lda #$d0
        jsr tag_c64ram
        
        lda #$d8
        jsr tag_c64ram
        
        lda #$de
        jsr tag_c64ram
        lda #$df
        jsr tag_c64ram

	lda #$e0
	jsr tag_c64ram
	lda #$f0
	jsr tag_c64ram
			
}			
	; all rom
	lda #$37
	sta $01

        lda #$d0
        jsr tag_c64io
        lda #$d8
        jsr tag_c64colram

        ldx #0
        ldy #2
        jsr set_cursor
        lda #>str_header0
        ldx #<str_header0
        jsr out_str

	jmp mainloop
			
update_blocks:

        ldx #$30
blklp:
        txa
        pha

        and #$0f
        asl
        clc
        adc #4
        tay      ; get y
        txa      ; get $01 value back in A
        
        sta $01

        ldx #0
        ; gets pos in X/Y
        jsr printoneline

        pla
        tax
        inx
        cpx #$38
        bne blklp
        
        jsr colorize
        rts

printoneline:
	jsr set_cursor ; must be first in this function!
			
        lda #$03
        ldy #>tagtmp00
        ldx #<tagtmp00
        jsr get_tag

        lda #$70
        ldy #>tagtmp10
        ldx #<tagtmp10
        jsr get_tag

        lda #$80
        ldy #>tagtmp80
        ldx #<tagtmp80
        jsr get_tag

			
	; all ram
;	lda #$34
;	sta $01
			
			
	lda #$a0
	ldy #>tagtmpA0
	ldx #<tagtmpA0
	jsr get_tag

        lda #$c0
        ldy #>tagtmpC0
        ldx #<tagtmpC0
        jsr get_tag

        lda #$d0
        ldy #>tagtmpD0
        ldx #<tagtmpD0
        jsr get_tag

        lda #$d8
        ldy #>tagtmpD8
        ldx #<tagtmpD8
        jsr get_tag

	lda #$de
	ldy #>tagtmpDE
	ldx #<tagtmpDE
	jsr get_tag
			
	lda #$df
	ldy #>tagtmpDF
	ldx #<tagtmpDF
	jsr get_tag
!if 1 {			
	lda #$e0
	ldy #>tagtmpE0
	ldx #<tagtmpE0
	jsr get_tag
}			
			
	lda #$37
	sta $01

	; now print all the info
			
	lda #5
	jsr scr_setcol
			
        lda #>tagtmp00
        ldx #<tagtmp00
        ldy #4
        jsr str_out

        lda #>tagtmp10
        ldx #<tagtmp10
        ldy #4
        jsr str_out

        lda #13
        jsr scr_setcol

        lda #>tagtmp80
        ldx #<tagtmp80
        ldy #4
        jsr str_out

        lda #>tagtmpA0
        ldx #<tagtmpA0
        ldy #4
        jsr str_out

        lda #5
        jsr scr_setcol

        lda #>tagtmpC0
        ldx #<tagtmpC0
        ldy #4
        jsr str_out

        lda #13
        jsr scr_setcol

        lda #>tagtmpD0
        ldx #<tagtmpD0
        ldy #4
        jsr str_out

        lda #>tagtmpD8
        ldx #<tagtmpD8
        ldy #4
        jsr str_out

        lda #5
        jsr scr_setcol

	lda #>tagtmpDE
	ldx #<tagtmpDE
	ldy #4
	jsr str_out
			
	lda #>tagtmpDF
	ldx #<tagtmpDF
	ldy #4
	jsr str_out

        lda #13
        jsr scr_setcol

	lda #>tagtmpE0
	ldx #<tagtmpE0
	ldy #4
	jsr str_out
	rts

colorize:
        ; check tags and colorize
        lda #>tagexp00
        ldx #<tagexp00
        ldy #4+(0*2)
        jsr color_line
        lda #>tagexp01
        ldx #<tagexp01
        ldy #4+(1*2)
        jsr color_line
;        jmp *
        lda #>tagexp02
        ldx #<tagexp02
        ldy #4+(2*2)
        jsr color_line
;        jmp *
        lda #>tagexp03
        ldx #<tagexp03
        ldy #4+(3*2)
        jsr color_line
        lda #>tagexp04
        ldx #<tagexp04
        ldy #4+(4*2)
        jsr color_line
        lda #>tagexp05
        ldx #<tagexp05
        ldy #4+(5*2)
        jsr color_line
        lda #>tagexp06
        ldx #<tagexp06
        ldy #4+(6*2)
        jsr color_line
        lda #>tagexp07
        ldx #<tagexp07
        ldy #4+(7*2)
        jsr color_line
        rts

;--------------------------------------------------------------------------			

scrzp=$02;
colzp=$fe;
strzp=$04

color_line:
        sta strzp+1
        stx strzp
        
        ldx #0
        jsr set_cursor

        ldy #$0
lap
        lda (strzp),y
        cmp (scrzp),y
        beq skf
        cmp #'.'
        beq skf
        lda #10
        sta (colzp),y
        sta $d020

        lda (scrzp),y
        eor #$80
        sta (scrzp),y
skf:
        iny
;       inx
;strm=*+1
        cpy #40
        bne lap
        
        lda scrzp
        clc
        adc #40*2
        sta scrzp
        bcc straskp
        inc scrzp+1
straskp
        jmp scr_adj_colptr




scr_init:
			
	lda #5
	sta $d020
        lda #0
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


tagc64common:
        lda tgaddrh
        lsr
        lsr
        lsr
        lsr
        tax
        lda hexnum,x
        sta tagtmp+2

        lda tgaddrh
        and #$0f
        tax
        lda hexnum,x
        sta tagtmp+3

tagc64common_nohex:
        ldx #0
tglp1:
        lda tagtmp,x
tgaddrh=*+2
        sta $ff00+tagoffset,x
        inx
        cpx #taglen
        bne tglp1

;	ldx #0
;	ldy #(3*4)	; offset to tag	(c64 ram)
;tglp1:			
;	lda tags,y
;tgaddrh=*+2
;	sta $ff80,x
;	iny
;	inx
;	cpx #4
;	bne tglp1
	rts

tag_c64io:
        sta tgaddrh

        lda tags+(4*4)+0
        sta tagtmp+0
        lda tags+(4*4)+1
        sta tagtmp+1

        jmp tagc64common

tag_c64ram:
        sta tgaddrh

        lda tags+(3*4)+0
        sta tagtmp+0
        lda tags+(3*4)+1
        sta tagtmp+1

        jmp tagc64common

tag_c64colram:
        sta tgaddrh

        lda #$0c
        lda #$01
        sta tagtmp+0
        lda #$05
        lda #$02
        sta tagtmp+1
        lda #$0d
        lda #$03
        sta tagtmp+2
        lda #$08
        lda #$04
        sta tagtmp+3

        jmp tagc64common_nohex

hexnum: !scr "0123456789abcdef"

gettmp: !byte 0,0,0,0

get_tag:
	sta gtgaddrh
        stx gtgaddr2l
        sty gtgaddr2h
        stx gtgaddr2lx
        sty gtgaddr2hx

        ldy #0
        
	; read tag from memory into buffer
	ldx #0
gtglp1:			
gtgaddrh=*+2
	lda $ff00+tagoffset,x
gtgaddr2l=*+1
gtgaddr2h=*+2
	sta tagtmp,x
        and #$0f
	sta gettmp,x
	inx
	cpx #taglen
	bne gtglp1

        lda gettmp+0
        cmp #$01
        bne skpc

;        lda gettmp+1
;        and #$0f
;        cmp #$02
;        bne skpc

;        lda gettmp+2
;        and #$0f
;        cmp #$03
;        bne skpc

;        lda gettmp+3
;        and #$0f
;        cmp #$04
;        bne skpc

        ldx #0
gtglp1x:
        lda colramtag,x
gtgaddr2lx=*+1
gtgaddr2hx=*+2
        sta tagtmp,x
        inx
        cpx #taglen
        bne gtglp1x

        lda gtgaddrh
        ldx gtgaddr2l
        ldy gtgaddr2h
        rts

colramtag
        !scr "crd8"
        
skpc
        ; find a tag, and eventually replace it by a string
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
			
fixup_entries=6
fixup_tags:			
	!BYTE $79,$69,$b8,$79 ; basic rom
	!BYTE $72,$20,$67,$b8 ; kernal rom
	!BYTE $7c,$66,$66,$7c ; char rom 0x0080
        !BYTE $00,$00,$7c,$66 ; char rom 0x0880
	!BYTE $83,$99,$99,$83 ; char rom 0x1e80
	!BYTE $ff,$ff,$ff,$e0 ; char rom 0x1f80

fixup_strings:
	!scr "basi"  ; 0 internal c64 rom
	!scr "kern"  ; 1 internal c64 rom
	!scr "char"  ; 2 internal c64 rom
        !scr "char"  ; 2 internal c64 rom
        !scr "char"  ; 2 internal c64 rom
	!scr "char"  ; 2 internal c64 rom

tags:
	!scr "basi"  ; 0 internal c64 rom
	!scr "kern"  ; 1 internal c64 rom
	!scr "char"  ; 2 internal c64 rom
		
        !scr "ra00"  ; 3 internal c64 ram
        !scr "io00"  ; 4 internal c64 io
        !scr "crd8"  ; 5 internal c64 ram
	!scr " io1"  ; 6 cart io1
	!scr " io2"  ; 7 cart io2
		
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
	cpx #taglen
	bne gtglp5
			
	rts			
			

tagtmp:
	!scr "-----"
tagtmp00: ; 0000-3fff
        !scr "-----"
tagtmp10: ; 1000-7fff
        !scr "-----"
tagtmp80: ; 8000-9fff
        !scr "-----"
tagtmpA0: ; a000-bfff
        !scr "-----"
tagtmpC0: ; c000-cfff
        !scr "-----"
tagtmpD0: ; d000-d7ff
        !scr "-----"
tagtmpD8: ; d800-dfff
        !scr "-----"
tagtmpDE: ; io1
        !scr "-----"
tagtmpDF: ; io2
        !scr "-----"
tagtmpE0: ; e000-ffff
        !scr "-----"
		
;----------------------------------------------------------------------------------------------------------------

;	!byte "t","a","g"
;	!byte "t","a","g"

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

        ldx #0          ; success
        lda $d020
        and #$f
        cmp #5
        beq nofail
        ldx #$ff        ; failure
nofail:
        stx $d7ff

	;-------------------------
			
	jsr minikey
	sta thiskey
	cmp #$ff
	beq mainloop
			
;	lda thiskey
;	cmp #keycode_c
;	bne kcskp
;			
;	lda charromon
;	eor #$04
;	sta charromon
;	jmp kallskp
;			
;			
;kallskp	

	;-------------------------		
	jsr update_blocks

keywait
	jsr minikey
	cmp #$ff
	bne keywait
			
	jmp mainloop
			
thiskey:
	!byte 0			

str_header0:
          !scr "00- 10- 80- a0- c0- d0- d8- de- df- e0- ",0

tagexp00: !scr "ra03ra70ra80raa0rac0rad0rad8raderadfrae0"
tagexp01: !scr "ra03ra70ra80raa0rac0charcharcharcharrae0"
tagexp02: !scr "ra03ra70ra80raa0rac0charcharcharcharkern"
tagexp03: !scr "ra03ra70ca80basirac0charcharcharcharkern"
tagexp04: !scr "ra03ra70ra80raa0rac0rad0rad8raderadfrae0"
tagexp05: !scr "ra03ra70ra80raa0rac0iod0crd8........rae0"
tagexp06: !scr "ra03ra70ra80raa0rac0iod0crd8........kern"
tagexp07: !scr "ra03ra70ca80basirac0iod0crd8........kern"

}
    * = ROMSTART + (4 * 1024) + $80
    !scr "ca90"
