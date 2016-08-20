*=$1001

VIC20_VIA1_PRA = 0x9111
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
	cmp #24
	bne check_key_8
	ldy #24
	bne invert_key
check_key_8:
	cmp #23
	bne check_key_9
	ldy #28
	bne invert_key
check_key_9:
	cmp #22
	bne check_key_mult
	ldy #32
	bne invert_key
check_key_mult:
	cmp #18
	bne check_key_4
	ldy #36
	bne invert_key
check_key_4:
	cmp #27
	bne check_key_5
	ldy #68
	bne invert_key
check_key_5:
	cmp #26
	bne check_key_6
	ldy #72
	bne invert_key
check_key_6:
	cmp #25
	bne check_key_div
	ldy #76
	bne invert_key
check_key_div:
	cmp #19
	bne check_key_1
	ldy #80
	bne invert_key
check_key_1:
	cmp #30
	bne check_key_2
	ldy #112
	bne invert_key
check_key_2:
	cmp #29
	bne check_key_3
	ldy #116
	bne invert_key
check_key_3:
	cmp #28
	bne check_key_minus
	ldy #120
	bne invert_key
check_key_minus:
	cmp #20
	bne check_key_dot
	ldy #124
	bne invert_key
check_key_dot:
	cmp #17
	bne check_key_0
	ldy #156
	bne invert_key
check_key_0:
	cmp #31
	bne check_key_e
	ldy #160
	bne invert_key
check_key_e:
	cmp #16
	bne check_key_plus
	ldy #164
	bne invert_key
check_key_plus:
	cmp #21
	bne no_key_pressed
	ldy #168
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
	lda $9009
	bne read_key
	rts
read_key:
	lda VIC20_VIA1_PRA
	tay
	and #$1c
	lsr
	lsr
	sta $0201
	tya
	and #$20
	lsr
	ora $0201
	sta $0201
	lda VIC20_VIA2_DDRB
	and #$7f
	sta VIC20_VIA2_DDRB
	lda VIC20_VIA2_PRB
	and #$80
	lsr
	lsr
	lsr
	lsr
	ora $0201
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
	!by 176,192,192,192,178,192,192,192,178,192,192,192,178,192,192,192,174,13
	!by 221, 32,'7', 32,221, 32,'8', 32,221, 32,'9', 32,221, 32,'*', 32,221,13
	!by 171,192,192,192,219,192,192,192,219,192,192,192,219,192,192,192,179,13
	!by 221, 32,'4', 32,221, 32,'5', 32,221, 32,'6', 32,221, 32,'/', 32,221,13
	!by 171,192,192,192,219,192,192,192,219,192,192,192,219,192,192,192,179,13
	!by 221, 32,'1', 32,221, 32,'2', 32,221, 32,'3', 32,221, 32,'-', 32,221,13
	!by 171,192,192,192,219,192,192,192,219,192,192,192,219,192,192,192,179,13
	!by 221, 32,'.', 32,221, 32,'0', 32,221, 32,'E', 32,221, 32,'+', 32,221,13
	!by 173,192,192,192,177,192,192,192,177,192,192,192,177,192,192,192,189,13
	!by 13,'C','A','R','D','C','O',' ','C','A','R','D','K','E','Y',' ','K','E','Y','P','A','D',' ','I','N',13
	!by 'N','A','T','I','V','E',0
