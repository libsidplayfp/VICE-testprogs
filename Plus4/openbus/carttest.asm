!to"carttest.prg",cbm 

;--------------------------------------------------
; Commodore 16 and Plus/4
; Test program to determine
; behaviour when reading from
; cartridge area when a cartridge
; is not connected
;
; by Marko Solajic in 2021
;--------------------------------------------------

colourram    = $0800
screenram    = $0c00
tedback      = $ff15  
tedcol1      = $ff16  
tedcol2      = $ff17  
tedcol3      = $ff18  
tedborder    = $ff19
banking      = $fdd0

*=$1001
!by $0b, $10, $00, $00, $9e, $34, $31, $31, $32, $00, $00, $00
; Basic start at 4112 dec / 1010 hex

*=$1010
start		sei
		ldx #$00	;basic, kernal
		sta $fdd0,x
		lda #$80
		sta caddr+2
		jsr copy

		ldx #$01	;function lo, kernal
		sta $fdd0,x
		lda #$80
		sta caddr+2
		inc maddr+2
		jsr copy

		ldx #$02	;cartridge 1 lo, kernal
		sta $fdd0,x
		lda #$80
		sta caddr+2
		inc maddr+2
		jsr copy

		ldx #$03	;cartridge 2 lo, kernal
		sta $fdd0,x
		lda #$80
		sta caddr+2
		inc maddr+2
		jsr copy

		lda #$00	;basic, kernal
		sta $fdd0,x
		rts

copy		sei
		ldx #$00    ;program length lo
		ldy #$40    ;program length hi
caddr		lda $8000  ;cartridge start adr
maddr		sta screenram   ;c64 memory start adr
		dex
		cpx #$ff
		bne cc1
		dey
		cpy #$ff
		beq fin
cc1		inc maddr+1
		bne cc2
cc2		inc caddr+1
		bne caddr
		inc caddr+2
		lda caddr+2
		cmp #$c0        ;next bank?
		bne caddr
fin		cli
		rts