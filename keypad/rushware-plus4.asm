*=$1001

PLUS4_TED_KBD = 0xFF08
PLUS4_SIDCART_JOY = 0xFD80
USERPORT_DATA = 0xfd10

SCANKEY = 0xff9f
KEYS = $ef
KEY_QUEUE = $0527

basic: !by $0b,$08,$01,$00,$9e,$34,$31,$30,$39,$00,$00,$00

start:
	ldx #$00
	stx $FF15	; border
	stx $FF19	; background
	lda #$05
	jsr $ffd2
	jsr choose_port

mainloop:
	jsr print_main_screen
	jsr print_test_name_screen
	jsr print_joy_device_screen
	lda #$00
	sta KEYS
check_loop:
	jsr check_port
	and #$1f
	jsr show_key
	jmp check_loop

show_key:
	ldy #$00
	ldx #$00
	cmp #8
	bne check_key_8
	ldy #42
	bne invert_key_c
check_key_8:
	cmp #7
	bne check_key_9
	ldy #46
	bne invert_key_c
check_key_9:
	cmp #6
	bne check_key_mult
	ldy #50
	bne invert_key_c
check_key_mult:
	cmp #2
	bne check_key_4
	ldy #54
	bne invert_key_c
check_key_4:
	cmp #11
	bne check_key_5
	ldy #122
	bne invert_key_c
check_key_5:
	cmp #10
	bne check_key_6
	ldy #126
	bne invert_key_c
check_key_6:
	cmp #9
	bne check_key_div
	ldy #130
	bne invert_key_c
check_key_div:
	cmp #3
	bne check_key_1
	ldy #134
	bne invert_key_c
check_key_1:
	cmp #14
	bne check_key_2
	ldy #202
	bne invert_key_c
check_key_2:
	cmp #13
	bne check_key_3
	ldy #206
	bne invert_key_c
check_key_3:
	cmp #12
	bne check_key_minus
	ldy #210
	bne invert_key_c
check_key_minus:
	cmp #4
	bne check_key_dot
	ldy #214
invert_key_c:
	ldx #$0c
	bne invert_key
check_key_dot:
	cmp #1
	bne check_key_0
	ldy #26
	bne invert_key_d
check_key_0:
	cmp #15
	bne check_key_e
	ldy #30
	bne invert_key_d
check_key_e:
	cmp #0
	bne check_key_plus
	ldy #34
	bne invert_key_d
check_key_plus:
	cmp #5
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
	ldy #$00
	pha
invert_key_peek:
	lda ($fb),y
	ora #$80
	sta ($fb),y
release_key_loop:
	jsr check_port
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

check_port:
	ldx port
	cpx #1
	beq read_native_2
	cpx #16
	beq read_hummer
	cpx #17
	beq read_oem
	cpx #50
	beq read_pet_1
	cpx #51
	beq read_pet_2
	cpx #128
	beq read_sidcard
read_native_1:
	jmp read_native_1_code

read_native_2:
	jmp read_native_2_code
read_hummer:
	jmp read_hummer_code
read_oem:
	jmp read_oem_code
read_pet_1:
	jmp read_pet_1_code
read_pet_2:
	jmp read_pet_2_code
read_sidcard:
	jmp read_sidcard_code

read_native_1_code:
	ldx #$fa
	stx PLUS4_TED_KBD
	lda PLUS4_TED_KBD
	tay
	and #$0f
	sta tmp
	tya
	and #$40
	beq no64
	lda #$10
	ora tmp
	rts
no64:
	lda tmp
	rts

read_native_2_code:
	ldx #$fd
	stx PLUS4_TED_KBD
	lda PLUS4_TED_KBD
	tay
	and #$0f
	sta tmp
	tya
	and #$80
	beq no128
	lda #$10
	ora tmp
	rts
no128:
	lda tmp
	rts

read_sidcard_code:
	lda PLUS4_SIDCART_JOY
	and #$1f
	rts

read_hummer_code:
	lda USERPORT_DATA
	rts

read_oem_code:
	lda USERPORT_DATA
	tay
	lsr
	lsr
	lsr
	lsr
	lsr
	lsr
	lsr
	sta tmp
	tya
	and #$40
	lsr
	lsr
	lsr
	lsr
	lsr
	ora tmp
	sta tmp
	tya
	and #$20
	lsr
	lsr
	lsr
	ora tmp
	sta tmp
	tya
	and #$10
	lsr
	ora tmp
	sta tmp
	tya
	and #$08
	asl
	ora tmp
	rts

read_pet_1_code:
	lda USERPORT_DATA
read_pet_code:
	and #$0f
	cmp #$0c
	bne notc
	lda #$0f
	rts
notc:
	ora #$10
	rts

read_pet_2_code:
	lda USERPORT_DATA
	lsr
	lsr
	lsr
	lsr
	jmp read_pet_code

choose_port:
	ldx #$00
print_change_port_screen_loop:
	lda change_port_screen,x
	beq check_change_port_key
	jsr $ffd2
	inx
	bne print_change_port_screen_loop
check_change_port_key:
	ldx #$00
	stx KEYS
port_key_loop:
	jsr SCANKEY
	ldx KEYS
	beq port_key_loop
	ldx KEY_QUEUE
	cpx #'1'
	bne check2
	ldx #0
	beq new_port
check2:
	cpx #'2'
	bne check3
	ldx #1
	bne new_port
check3:
	cpx #'3'
	bne check4
	ldx #50
	bne new_port
check4:
	cpx #'4'
	bne check5
	ldx #51
	bne new_port
check5:
	cpx #'5'
	bne check6
	ldx #16
	bne new_port
check6:
	cpx #'6'
	bne check7
	ldx #17
	bne new_port
check7:
	cpx #'7'
	bne check_change_port_key
	ldx #128
new_port:
	stx port
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

print_test_name_screen:
	ldx #$00
test_name_screen_loop:
	lda test_name_screen,x
	beq end_loop
	jsr $ffd2
	inx
	bne test_name_screen_loop

print_joy_device_screen:
	ldx #$00
	lda port
	cmp #$80
	beq print_sidcard_loop
	and #$10
	beq print_native_device_loop
print_userport_device_loop:
	lda userport_device_screen,x
	beq print_userport_type
	jsr $ffd2
	inx
	bne print_userport_device_loop
print_native_device_loop:
	lda native_device_screen,x
	beq print_port_number
	jsr $ffd2
	inx
	bne print_native_device_loop
print_sidcard_loop:
	lda sidcard_screen,x
	beq end_device_print
	jsr $ffd2
	inx
	bne print_sidcard_loop
print_userport_type:
	lda #$20
	jsr $ffd2
	lda port
	cmp #17
	beq is_oem_device
	and #$fe
	cmp #50
	beq is_pet_device
	ldy #<hummer_screen
	ldx #>hummer_screen
	jmp print_type
is_oem_device:
	ldy #<oem_screen
	ldx #>oem_screen
	jmp print_type
is_pet_device:
	ldy #<pet_screen
	ldx #>pet_screen
print_type:
	sty $fb
	stx $fc
	ldy #$00
print_type_loop:
	lda ($fb),y
	beq end_print_type_loop
	jsr $ffd2
	iny
	bne print_type_loop
end_print_type_loop:
	lda port
	and #$20
	beq end_device_print
print_port_number:
	lda #$20
	jsr $ffd2
	lda port
	and #$01
	clc
	adc #'1'
	jsr $ffd2
end_device_print:
	lda #13
	jmp $ffd2

port:	!by 0

tmp:	!by 0

main_screen:
	!by 147
	!by 176,195,195,195,178,195,195,195,178,195,195,195,178,195,195,195,174,13
	!by 194, 32,'7', 32,194, 32,'8', 32,194, 32,'9', 32,194, 32,'*', 32,194,13
	!by 171,195,195,195,219,195,195,195,219,195,195,195,219,195,195,195,179,13
	!by 194, 32,'4', 32,194, 32,'5', 32,194, 32,'6', 32,194, 32,'/', 32,194,13
	!by 171,195,195,195,219,195,195,195,219,195,195,195,219,195,195,195,179,13
	!by 194, 32,'1', 32,194, 32,'2', 32,194, 32,'3', 32,194, 32,'-', 32,194,13
	!by 171,195,195,195,219,195,195,195,219,195,195,195,219,195,195,195,179,13
	!by 194, 32,'.', 32,194, 32,'0', 32,194, 32,'E', 32,194, 32,'+', 32,194,13
	!by 173,195,195,195,177,195,195,195,177,195,195,195,177,195,195,195,189,13
	!by 0

test_name_screen:
	!by 13,'R','U','S','H','W','A','R','E',' ','K','E','Y','P','A','D',' ','I','N',13,0

userport_device_screen:
	!by 'U','S','E','R','P','O','R','T',0

hummer_screen:
	!by 'H','U','M','M','E','R',0

oem_screen:
	!by 'O','E','M',0

pet_screen:
	!by 'P','E','T',0

native_device_screen:
	!by 'N','A','T','I','V','E',0

sidcard_screen:
	!by 'S','I','D','C','A','R','D',0

change_port_screen:
	!by 147,'P','L','E','A','S','E',' ','C','H','O','O','S','E',' ','T','H','E',' ','N','E','W',' ','P','O','R','T',':',13
	!by '1',')',' ','N','A','T','I','V','E',' ','1',13
	!by '2',')',' ','N','A','T','I','V','E',' ','2',13
	!by '3',')',' ','U','S','E','R','P','O','R','T',' ','P','E','T',' ','1',13
	!by '4',')',' ','U','S','E','R','P','O','R','T',' ','P','E','T',' ','2',13
	!by '5',')',' ','U','S','E','R','P','O','R','T',' ','H','U','M','M','E','R',13
	!by '6',')',' ','U','S','E','R','P','O','R','T',' ','O','E','M',13
	!by '7',')',' ','S','I','D','C','A','R','D',13,0
