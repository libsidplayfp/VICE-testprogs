*=$1001

PLUS4_TED_KBD = 0xFF08
PLUS4_SIDCART_JOY = 0xFD80
USERPORT_DATA = 0xfd10

basic: !by $0b,$08,$01,$00,$9e,$34,$31,$30,$39,$00,$00,$00

start:
	ldx #$00
	stx $FF15	; border
	stx $FF19	; background
	lda #$05
	jsr $ffd2

mainloop:
	jsr print_main_screen
check_loop:
	jsr read_sidcard_code
	and #$1f
	jsr show_key
	jmp check_loop

show_key:
	ldy #$00
	ldx #$00
	cmp #12
	bne check_key_7
	ldy #42
	bne invert_key_c
check_key_7:
	cmp #21
	bne check_key_8
	ldy #46
	bne invert_key_c
check_key_8:
	cmp #22
	bne check_key_9
	ldy #50
	bne invert_key_c
check_key_9:
	cmp #23
	bne check_key_minus
	ldy #54
	bne invert_key_c
check_key_minus:
	cmp #31
	bne check_key_n
	ldy #58
	bne invert_key_c
check_key_n:
	cmp #20
	bne check_key_4
	ldy #122
	bne invert_key_c
check_key_4:
	cmp #17
	bne check_key_5
	ldy #126
	bne invert_key_c
check_key_5:
	cmp #18
	bne check_key_6
	ldy #130
	bne invert_key_c
check_key_6:
	cmp #19
	bne check_key_e
	ldy #134
	bne invert_key_c
check_key_e:
	cmp #30
	bne check_key_d
	ldy #138
	bne invert_key_c
check_key_d:
	cmp #16
	bne check_key_1
	ldy #202
	bne invert_key_c
check_key_1:
	cmp #25
	bne check_key_2
	ldy #206
	bne invert_key_c
check_key_2:
	cmp #26
	bne check_key_3
	ldy #210
	bne invert_key_c
check_key_3:
	cmp #27
	bne check_key_y
	ldy #214
invert_key_c:
	ldx #$0c
	bne invert_key
check_key_y:
	cmp #28
	bne check_key_0
	ldy #26
	bne invert_key_d
check_key_0:
	cmp #28
	bne check_key_dot
	ldy #32
	bne invert_key_d
check_key_dot:
	cmp #29
	bne no_key_pressed
	ldy #38
	bne invert_key_d
no_key_pressed:
	rts
invert_key_d:
	ldx #$0d
invert_key:
	sty $fb
	stx $fc
	pha
	ldy #$00
	lda ($fb),y
	ora #$80
	sta ($fb),y
release_key_loop:
	jsr read_sidcard_code
	and #$1f
	sta tmp
	pla
	cmp tmp
	bne revert_back
	pha
	jmp release_key_loop
revert_back:
	ldy #$00
	lda ($fb),y
	and #$7f
	sta ($fb),y
	rts

read_sidcard_code:
	lda $fd5a
	bne read_key
	rts
read_key:
	lda PLUS4_SIDCART_JOY
	rts

print_main_screen:
	ldx #$00
screen_loop:
	lda main_screen,x
	beq end_loop
	jsr $ffd2
	inx
	bne screen_loop
end_loop:
	rts

tmp:	!by 0

main_screen:
	!by 147
	!by 176,195,195,195,178,195,195,195,178,195,195,195,178,195,195,195,178,195,195,195,174,13
	!by 194, 32,'S', 32,194, 32,'7', 32,194, 32,'8', 32,194, 32,'9', 32,194, 32,'-', 32,194,13
	!by 171,195,195,195,219,195,195,195,219,195,195,195,219,195,195,195,219,195,195,195,179,13
	!by 194, 32,'N', 32,194, 32,'4', 32,194, 32,'5', 32,194, 32,'6', 32,194, 32,'E', 32,194,13
	!by 171,195,195,195,219,195,195,195,219,195,195,195,219,195,195,195,179, 32,'N', 32,194,13
	!by 194, 32,'D', 32,194, 32,'1', 32,194, 32,'2', 32,194, 32,'3', 32,194, 32,'T', 32,194,13
	!by 171,195,195,195,219,195,195,195,177,195,195,195,219,195,195,195,179, 32,'E', 32,194,13
	!by 194, 32,'Y', 32,194, 32, 32, 32,'0', 32, 32, 32,194, 32,'.', 32,194, 32,'R', 32,194,13
	!by 173,195,195,195,177,195,195,195,195,195,195,195,177,195,195,195,177,195,195,195,189,13
	!by 13,'A','T','A','R','I',' ','C','X','8','5',' ','K','E','Y','P','A','D',' ','I','N',' ','S','I','D','C','A','R','D',13,0
