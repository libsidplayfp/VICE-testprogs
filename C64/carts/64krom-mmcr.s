 

	fillvalue=$00
	
	!initmem 	fillvalue
	!cpu 6502
	!to "64krom-mmcr.bin", plain

	*= $8000

	!WORD start
	!WORD start2
	!BYTE $c3,$c2,$cd,$38,$30	; cbm80
			
	*= $8080
	!scr "70ro"
			
	*= $8090
			
sptr=$02
dptr=$04			
			
start:
	sei
start2:
	sei
			
	lda #$2F
	sta $00
	lda #$37
	sta $01
		
	lda #>data
	sta sptr+1
	lda #<data
	sta sptr
		
	lda #>($0810-2)
	sta dptr+1
	lda #<($0810-2)
	sta dptr
		
l2
	ldy #0
l1		
	lda(sptr),y
	sta(dptr),y
	iny
	bne l1
			
	lda sptr+1
	cmp #>dataend
	beq l2s
			
	inc dptr+1
	inc sptr+1
	jmp l2
l2s	
			
	ldx #0
er:			
	sta $d000,x
	inx
	cpx #$23
	bne er
			
	lda #$1b
	sta $d011
	lda #$c8
	sta $d016
	lda #$15
	sta $d018
	lda #0
	sta $d020
	sta $d021
			
	lda #3		; data port a
	sta $dd00
	lda #$3F	; ddr port a
	sta $dd02
	lda #$7f
	sta $dc0d
	sta $dd0d
			
	jmp $0810
data:
	!bin "mmcrplugin.prg"
	!BYTE 0,0
dataend:

	*= $9e80
	!scr "70ro"
	*= $9f80
	!scr "70ro"
	*= $9fff
	!byte 0
		