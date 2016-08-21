*=$1001

VIC20_VIA1_PRA = 0x9111
VIC20_VIA1_DDRA = 0x9113
VIC20_VIA2_PRB = 0x9120
VIC20_VIA2_DDRB = 0x9122

PICJMP = $0203

basic: !by $13,$10,$e0,$07,$9e,$c2,$28,$34,$34,$29,$ac,$32,$35,$36,$aa,$32,$31,$00,$00,$00

start:
	ldx #$08
	stx $900f	; border/background
	lda #$05
	jsr $ffd2

init_jsr_fixer:
; $0203	stx $021b
; $0206	lda $2c
; $0208	cmp #$10
; $020a	beq $020e
; $020c	iny
; $020d	iny
; $020e	sty $021c
; $0211	lda $0200
; $0214	ldx $0201
; $0217	ldy $0202
; $021a	jmp $xxxx
	ldx #$00
	stx $0212
	inx
	stx $0215
	inx
	stx $0205
	stx $020B
	stx $0210
	stx $0213
	stx $0216
	stx $0218
	stx $0219
	ldx #$10
	stx $0209
	ldx #$1b
	stx $0204
	inx
	stx $020F
	ldx #$2c
	stx $0207
	ldx #$4c
	stx $021A
	ldx #$8c
	stx $020E
	ldx #$8e
	stx $0203
	ldx #$a5
	stx $0206
	ldx #$ac
	stx $0217
	inx
	stx $0211
	inx
	stx $0214
	ldx #$c8
	stx $020C
	stx $020D
	inx
	stx $0208
	ldx #$f0
	stx $020A

mainloop:
	ldx #<print_main_screen
	ldy #>print_main_screen
	jsr PICJMP
check_loop:
	ldx #<read_native_code
	ldy #>read_native_code
	jsr PICJMP
	and #$1f
	sta $0200
	ldx #<show_key
	ldy #>show_key
	jsr PICJMP
	bne check_loop
	beq check_loop

show_key:
	ldy #$00
	ldx #$00
	cmp #1
	bne check_key_2
	ldy #24
	bne invert_key
check_key_2:
	cmp #2
	bne check_key_1
	ldy #28
	bne invert_key
check_key_1:
	cmp #3
	bne check_key_6
	ldy #32
	bne invert_key
check_key_6:
	cmp #4
	bne check_key_5
	ldy #68
	bne invert_key
check_key_5:
	cmp #5
	bne check_key_4
	ldy #72
	bne invert_key
check_key_4:
	cmp #6
	bne check_key_9
	ldy #76
	bne invert_key
check_key_9:
	cmp #7
	bne check_key_8
	ldy #112
	bne invert_key
check_key_8:
	cmp #8
	bne check_key_7
	ldy #116
	bne invert_key
check_key_7:
	cmp #9
	bne check_key_hash
	ldy #120
	bne invert_key
check_key_hash:
	cmp #10
	bne check_key_0
	ldy #156
	bne invert_key
check_key_0:
	cmp #11
	bne check_key_star
	ldy #160
	bne invert_key
check_key_star:
	cmp #12
	bne no_key_pressed
	ldy #164
invert_key:
	sty $fb
	ldx $2c
	cpx #$10
	beq invert_key_1e
	ldx #$10
	bne invert_store
invert_key_1e:
	ldx #$1e
invert_store:
	stx $fc
	sta $0201
invert_key_peek:
	ldy #$00
	lda ($fb),y
	ora #$80
	sta ($fb),y
release_key_loop:
	ldx #<read_native_code
	ldy #>read_native_code
	jsr PICJMP
	and #$1f
	sta $0200
	lda $0201
	cmp $0200
	bne revert_back
	beq release_key_loop
revert_back:
	ldy #$00
	lda ($fb),y
	and #$7f
	sta ($fb),y
	rts
no_key_pressed:
	rts

read_native_code:
	lda VIC20_VIA1_DDRA
	pha
	lda VIC20_VIA1_PRA
	pha
	lda VIC20_VIA1_DDRA
	and #$c3
	ora #$38
	sta VIC20_VIA1_DDRA
	lda VIC20_VIA2_DDRB
	pha
	lda VIC20_VIA2_PRB
	pha
	lda VIC20_VIA2_DDRB
	and #$7f
	ora #$80
	sta VIC20_VIA2_DDRB
	lda #$80
	sta VIC20_VIA2_PRB
	lda #$18
	sta VIC20_VIA1_PRA
	lda VIC20_VIA1_PRA
	and #$20
	bne native_key_2
	ldx #1
	bne found_native_key
native_key_2:
	lda $9008
	bne native_key_1
	ldx #2
	bne found_native_key
native_key_1:
	lda $9009
	bne native_key_6
	ldx #3
	bne found_native_key
native_key_6:
	lda #$14
	sta VIC20_VIA1_PRA
	lda VIC20_VIA1_PRA
	and #$20
	bne native_key_5
	ldx #4
	bne found_native_key
native_key_5:
	lda $9008
	bne native_key_4
	ldx #5
	bne found_native_key
native_key_4:
	lda $9009
	bne native_key_9
	ldx #6
	bne found_native_key
native_key_9:
	lda #$0c
	sta VIC20_VIA1_PRA
	lda VIC20_VIA1_PRA
	and #$20
	bne native_key_8
	ldx #7
	bne found_native_key
native_key_8:
	lda $9008
	bne native_key_7
	ldx #8
	bne found_native_key
native_key_7:
	lda $9009
	bne native_key_hash
	ldx #9
	bne found_native_key
native_key_hash:
	lda #$00
	sta VIC20_VIA2_PRB
	lda #$1c
	sta VIC20_VIA1_PRA
	lda VIC20_VIA1_PRA
	and #$20
	bne native_key_0
	ldx #10
	bne found_native_key
native_key_0:
	lda $9008
	bne native_key_star
	ldx #11
	bne found_native_key
native_key_star:
	lda $9009
	bne nothing_pressed
	ldx #12
	bne found_native_key
nothing_pressed:
	ldx #0
found_native_key:
	pla
	sta VIC20_VIA2_PRB
	pla
	sta VIC20_VIA2_DDRB
	pla
	sta VIC20_VIA1_PRA
	pla
	sta VIC20_VIA1_DDRA
	txa
	rts

print_main_screen:
	ldx #<main_screen
	stx $fb
	ldy #>main_screen
	lda $2c
	cmp #$10
	beq noiny_main_screen
	iny
	iny
noiny_main_screen:
	sty $fc
	ldy #$00
screen_loop:
	lda ($fb),y
	beq end_loop
	jsr $ffd2
	iny
	bne screen_loop
end_loop:
	rts

main_screen:
	!by 147
	!by 176,192,192,192,178,192,192,192,178,192,192,192,174,13
	!by 221, 32,'3', 32,221, 32,'2', 32,221, 32,'1', 32,221,13
	!by 171,192,192,192,219,192,192,192,219,192,192,192,179,13
	!by 221, 32,'6', 32,221, 32,'5', 32,221, 32,'4', 32,221,13
	!by 171,192,192,192,219,192,192,192,219,192,192,192,179,13
	!by 221, 32,'9', 32,221, 32,'8', 32,221, 32,'7', 32,221,13
	!by 171,192,192,192,219,192,192,192,219,192,192,192,179,13
	!by 221, 32,'#', 32,221, 32,'0', 32,221, 32,'*', 32,221,13
	!by 173,192,192,192,177,192,192,192,177,192,192,192,189,13
	!by 13,'A','T','A','R','I',' ','C','X','2','1',' ','K','E','Y','P','A','D',' ','I','N',13
	!by 'N','A','T','I','V','E',0
