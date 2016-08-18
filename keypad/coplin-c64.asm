*=$0801

C64_CIA1_PRA = 0xDC00
C64_CIA1_PRB = 0xDC01
C64_CIA1_DDRA = 0xDC02
C64_CIA1_TIMER_A_LOW = 0xDC04
C64_CIA1_TIMER_A_HIGH = 0xDC05
C64_CIA1_SR = 0xDC0C
C64_CIA1_CRA = 0xDC0E
C64_CIA2_PRA = 0xDD00
C64_CIA2_DDRA = 0xDD02
C64_CIA2_TIMER_A_LOW = 0xDD04
C64_CIA2_TIMER_A_HIGH = 0xDD05
C64_CIA2_SR = 0xDD0C
C64_CIA2_CRA = 0xDD0E
USERPORT_DDR = 0xDD03
USERPORT_DATA = 0xDD01

SCANKEY = 0xff9f
KEYS = $c6
KEY_QUEUE = $0277

basic: !by $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00

start:
	ldx #$00
	stx $D020	; border
	stx $D021	; background
	inx
	stx $0286	; cursor
	jsr choose_port

mainloop:
	jsr print_main_screen
	jsr print_test_name_screen
	jsr print_joy_device_screen
	lda #$00
	sta KEYS
check_loop:
	jsr check_port
	jsr show_key
	jmp check_loop

show_key:
	ldy #$00
	ldx #$00
	cmp #26
	bne check_key_8
	ldy #42
	bne invert_key_4
check_key_8:
	cmp #30
	bne check_key_9
	ldy #46
	bne invert_key_4
check_key_9:
	cmp #22
	bne check_key_4
	ldy #50
	bne invert_key_4
check_key_4:
	cmp #27
	bne check_key_5
	ldy #122
	bne invert_key_4
check_key_5:
	cmp #19
	bne check_key_6
	ldy #126
	bne invert_key_4
check_key_6:
	cmp #23
	bne check_key_1
	ldy #130
	bne invert_key_4
check_key_1:
	cmp #25
	bne check_key_2
	ldy #202
	bne invert_key_4
check_key_2:
	cmp #29
	bne check_key_3
	ldy #206
	bne invert_key_4
check_key_3:
	cmp #21
	bne check_key_0
	ldy #210
invert_key_4:
	ldx #4
	bne invert_key
check_key_0:
	cmp #17
	bne check_key_p
	ldy #26
	bne invert_key_5
check_key_p:
	cmp #18
	bne check_key_r
	ldy #30
	bne invert_key_5
check_key_r:
	cmp #15
	bne no_key_pressed
	ldy #34
	bne invert_key_5
no_key_pressed:
	rts
invert_key_5:
	ldx #5
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
	cpx #48
	beq read_cga_1
	cpx #49
	beq read_cga_2
	cpx #50
	beq read_pet_1
	cpx #51
	beq read_pet_2
	cpx #52
	beq read_hit_1
	cpx #53
	beq read_hit_2
	cpx #54
	beq read_kingsoft_1
	cpx #55
	beq read_kingsoft_2
	cpx #56
	beq read_starbyte_1
	cpx #57
	beq read_starbyte_2
read_native_1:
	jsr read_native_1_code
	and #$1f
	rts
read_native_2:
	jsr read_native_2_code
	and #$1f
	rts
read_hummer:
	jsr read_hummer_code
	and #$1f
	rts
read_oem:
	jsr read_oem_code
	and #$1f
	rts
read_cga_1:
	jsr read_cga_1_code
	and #$1f
	rts
read_cga_2:
	jsr read_cga_2_code
	and #$1f
	rts
read_pet_1:
	jsr read_pet_1_code
	and #$1f
	rts
read_pet_2:
	jsr read_pet_2_code
	and #$1f
	rts
read_hit_1:
	jsr read_hit_1_code
	and #$1f
	rts
read_hit_2:
	jsr read_hit_2_code
	and #$1f
	rts
read_kingsoft_1:
	jsr read_kingsoft_1_code
	and #$1f
	rts
read_kingsoft_2:
	jsr read_kingsoft_2_code
	and #$1f
	rts
read_starbyte_1:
	jsr read_starbyte_1_code
	and #$1f
	rts
read_starbyte_2:
	jsr read_starbyte_2_code
	and #$1f
	rts

read_native_1_code:
	ldx #$7f
	stx C64_CIA1_PRA
	lda C64_CIA1_PRB
	rts

read_native_2_code:
	ldy C64_CIA1_DDRA
	ldx #$ff
	stx C64_CIA1_DDRA
	lda C64_CIA1_PRA
	sty C64_CIA1_DDRA
	rts

read_hummer_code:
	ldx #$00
	stx USERPORT_DDR
	lda USERPORT_DATA
	rts

read_oem_code:
	ldx #$00
	stx USERPORT_DDR
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

read_cga_1_code:
	ldx #$80
	stx USERPORT_DDR
	stx USERPORT_DATA
	lda USERPORT_DATA
	rts

read_cga_2_code:
	ldx #$80
	stx USERPORT_DDR
	ldx #$00
	stx USERPORT_DATA
	lda USERPORT_DATA
	tay
	and #$0f
	sta tmp
	tya
	and #$20
	lsr
	ora tmp
	rts

read_pet_1_code:
	ldx #$00
	stx USERPORT_DDR
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
	ldx #$00
	stx USERPORT_DDR
	lda USERPORT_DATA
	lsr
	lsr
	lsr
	lsr
	jmp read_pet_code

read_hit_1_code:
	jsr setup_cnt12sp
	ldy C64_CIA2_PRA
	ldx C64_CIA2_DDRA
	lda USERPORT_DATA
	and #$0f
	sta tmp
	txa
	and #$fb
	sta C64_CIA2_DDRA
	lda C64_CIA2_PRA
	and #$04
	asl
	asl
	ora tmp
	sty C64_CIA2_PRA
	stx C64_CIA2_DDRA
	jmp restore_cnt12sp

read_hit_2_code:
	jsr setup_cnt12sp
	lda USERPORT_DATA
	lsr
	lsr
	lsr
	lsr
	ldx #$ff
	stx C64_CIA1_SR
	ldx C64_CIA2_SR
	beq notsr
	ora #$10
notsr:
	jmp restore_cnt12sp

read_kingsoft_1_code:
	jsr setup_cnt12sp
	ldx C64_CIA2_PRA
	ldy C64_CIA2_DDRA
	lda C64_CIA2_DDRA
	and #$fb
	sta C64_CIA2_DDRA
	lda C64_CIA2_PRA
	and #$04
	lsr
	lsr
	sta tmp
	lda USERPORT_DATA
	and #$80
	lsr
	lsr
	lsr
	lsr
	lsr
	lsr
	ora tmp
	sta tmp
	lda USERPORT_DATA
	and #$40
	lsr
	lsr
	lsr
	lsr
	ora tmp
	sta tmp
	lda USERPORT_DATA
	and #$20
	lsr
	lsr
	ora tmp
	sta tmp
	lda USERPORT_DATA
	and #$10
	ora tmp
	stx C64_CIA2_PRA
	sty C64_CIA2_DDRA
	jmp restore_cnt12sp

read_kingsoft_2_code:
	jsr setup_cnt12sp
	lda USERPORT_DATA
	tax
	and #$08
	lsr
	lsr
	lsr
	sta tmp
	txa
	and #$04
	lsr
	ora tmp
	sta tmp
	txa
	and #$02
	asl
	ora tmp
	sta tmp
	txa
	and #$01
	asl
	asl
	asl
	ora tmp
	ldx #$ff
	stx C64_CIA1_SR
	ldx C64_CIA2_SR
	beq notsr2
	ora #$10
notsr2:
	jmp restore_cnt12sp

read_starbyte_1_code:
	jsr setup_cnt12sp
	lda #$00
	sta tmp
	ldy C64_CIA2_DDRA
	ldx #$ff
	stx C64_CIA1_SR
	ldx C64_CIA2_SR
	beq notsr3
	lda #$10
	sta tmp
notsr3:
	lda USERPORT_DATA
	tax
	and #$01
	asl
	ora tmp
	sta tmp
	txa
	and #$02
	asl
	asl
	ora tmp
	sta tmp
	txa
	and #$04
	ora tmp
	sta tmp
	txa
	and #$08
	lsr
	lsr
	lsr
	ora tmp
	sty C64_CIA2_DDRA
	jmp restore_cnt12sp

read_starbyte_2_code:
	jsr setup_cnt12sp
	ldx C64_CIA2_PRA
	ldy C64_CIA2_DDRA
	lda USERPORT_DATA
	and #$20
	lsr
	lsr
	lsr
	lsr
	sta tmp
	lda USERPORT_DATA
	and #$40
	lsr
	lsr
	lsr
	ora tmp
	sta tmp
	lda USERPORT_DATA
	and #$80
	lsr
	lsr
	lsr
	lsr
	lsr
	ora tmp
	sta tmp
	lda USERPORT_DATA
	and #$10
	ora tmp
	sta tmp
	lda C64_CIA2_DDRA
	and #$fb
	sta C64_CIA2_DDRA
	lda C64_CIA2_PRA
	and #$04
	lsr
	lsr
	ora tmp
	sty C64_CIA2_PRA
	stx C64_CIA2_DDRA
	jmp restore_cnt12sp

setup_cnt12sp:
	sei
	ldx USERPORT_DDR
	stx tmp_ddr
	ldx #$00
	stx USERPORT_DDR
	inx
	ldy C64_CIA2_TIMER_A_LOW
	sty tmp_cia2_tal
	stx C64_CIA2_TIMER_A_LOW
	dex
	ldy C64_CIA2_TIMER_A_HIGH
	sty tmp_cia2_tah
	stx C64_CIA2_TIMER_A_HIGH
	ldx #$11
	ldy C64_CIA2_CRA
	sty tmp_cia2_cra
	stx C64_CIA2_CRA
	ldx #$01
	ldy C64_CIA1_TIMER_A_LOW
	sty tmp_cia1_tal
	stx C64_CIA1_TIMER_A_LOW
	dex
	ldy C64_CIA1_TIMER_A_HIGH
	sty tmp_cia1_tah
	stx C64_CIA1_TIMER_A_HIGH
	ldx #$51
	ldy C64_CIA1_CRA
	sty tmp_cia1_cra
	stx C64_CIA1_CRA
	rts

restore_cnt12sp:
	ldy tmp_cia1_cra
	sty C64_CIA1_CRA
	ldy tmp_cia1_tah
	sty C64_CIA1_TIMER_A_HIGH
	ldy tmp_cia1_tal
	sty C64_CIA1_TIMER_A_LOW
	ldy tmp_cia2_cra
	sty C64_CIA2_CRA
	ldy tmp_cia2_tah
	sty C64_CIA2_TIMER_A_HIGH
	ldy tmp_cia2_tal
	sty C64_CIA2_TIMER_A_LOW
	ldy tmp_ddr
	sty USERPORT_DDR
	rts

choose_port:
	ldx #$00
print_change_port_screen_loop1:
	lda change_port_screen_top,x
	beq print_change_port_screen2
	jsr $ffd2
	inx
	bne print_change_port_screen_loop1
print_change_port_screen2:
	ldx #$00
print_change_port_screen_loop2:
	lda change_port_screen_bottom,x
	beq check_change_port_key
	jsr $ffd2
	inx
	bne print_change_port_screen_loop2
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
	ldx #48
	bne new_port
check4:
	cpx #'4'
	bne check5
	ldx #49
	bne new_port
check5:
	cpx #'5'
	bne check6
	ldx #50
	bne new_port
check6:
	cpx #'6'
	bne check7
	ldx #51
	bne new_port
check7:
	cpx #'7'
	bne check8
	ldx #16
	bne new_port
check8:
	cpx #'8'
	bne check9
	ldx #17
	bne new_port
check9:
	cpx #'9'
	bne checkA
	ldx #52
	bne new_port
checkA:
	cpx #'A'
	bne checkB
	ldx #53
	bne new_port
checkB:
	cpx #'B'
	bne checkC
	ldx #54
	bne new_port
checkC:
	cpx #'C'
	bne checkD
	ldx #55
	bne new_port
checkD:
	cpx #'D'
	bne checkE
	ldx #56
	bne new_port
checkE:
	cpx #'E'
	bne check_change_port_key
	ldx #57
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
	and #$10
	beq print_native_device_loop
	lda port
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
print_userport_type:
	lda #$20
	jsr $ffd2
	lda port
	cmp #16
	beq is_hummer_device
	cmp #17
	beq is_oem_device
	and #$fe
	cmp #48
	beq is_cga_device
	cmp #50
	beq is_pet_device
	cmp #52
	beq is_hit_device
	cmp #54
	beq is_kingsoft_device
	ldy #<starbyte_screen
	ldx #>starbyte_screen
	jmp print_type
is_hummer_device:
	ldy #<hummer_screen
	ldx #>hummer_screen
	jmp print_type
is_oem_device:
	ldy #<oem_screen
	ldx #>oem_screen
	jmp print_type
is_cga_device:
	ldy #<cga_screen
	ldx #>cga_screen
	jmp print_type
is_pet_device:
	ldy #<pet_screen
	ldx #>pet_screen
	jmp print_type
is_hit_device:
	ldy #<hit_screen
	ldx #>hit_screen
	jmp print_type
is_kingsoft_device:
	ldy #<kingsoft_screen
	ldx #>kingsoft_screen
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

tmp_cia1_cra:	!by 0
tmp_cia1_tah:	!by 0
tmp_cia1_tal:	!by 0
tmp_cia2_cra:	!by 0
tmp_cia2_tah:	!by 0
tmp_cia2_tal:	!by 0
tmp_ddr:		!by 0

main_screen:
	!by 147
	!by 176,195,195,195,178,195,195,195,178,195,195,195,174,13
	!by 194, 32, 55, 32,194, 32, 56, 32,194, 32, 57, 32,194,13
	!by 171,195,195,195,219,195,195,195,219,195,195,195,179,13
	!by 194, 32, 52, 32,194, 32, 53, 32,194, 32, 54, 32,194,13
	!by 171,195,195,195,219,195,195,195,219,195,195,195,179,13
	!by 194, 32, 49, 32,194, 32, 50, 32,194, 32, 51, 32,194,13
	!by 171,195,195,195,219,195,195,195,219,195,195,195,179,13
	!by 194, 32, 48, 32,194, 32, 80, 32,194, 32, 82, 32,194,13
	!by 173,195,195,195,177,195,195,195,177,195,195,195,189,13
	!by 0

test_name_screen:
	!by 13,'C','O','P','L','I','N',' ','K','E','Y','P','A','D',' ','I','N',13,0

userport_device_screen:
	!by 'U','S','E','R','P','O','R','T',0

starbyte_screen:
	!by 'S','T','A','R','B','Y','T','E',0

hummer_screen:
	!by 'H','U','M','M','E','R',0

oem_screen:
	!by 'O','E','M',0

cga_screen:
	!by 'C','G','A',0

pet_screen:
	!by 'P','E','T',0

hit_screen:
	!by 'H','I','T',0

kingsoft_screen:
	!by 'K','I','N','G','S','O','F','T',0

native_device_screen:
	!by 'N','A','T','I','V','E',0

change_port_screen_top:
	!by 147,'P','L','E','A','S','E',' ','C','H','O','O','S','E',' ','T','H','E',' ','N','E','W',' ','P','O','R','T',':',13
	!by '1',')',' ','N','A','T','I','V','E',' ','1',13
	!by '2',')',' ','N','A','T','I','V','E',' ','2',13
	!by '3',')',' ','U','S','E','R','P','O','R','T',' ','C','G','A',' ','1',13
	!by '4',')',' ','U','S','E','R','P','O','R','T',' ','C','G','A',' ','2',13
	!by '5',')',' ','U','S','E','R','P','O','R','T',' ','P','E','T',' ','1',13
	!by '6',')',' ','U','S','E','R','P','O','R','T',' ','P','E','T',' ','2',13
	!by '7',')',' ','U','S','E','R','P','O','R','T',' ','H','U','M','M','E','R',13
	!by '8',')',' ','U','S','E','R','P','O','R','T',' ','O','E','M',13,0
change_port_screen_bottom:
	!by '9',')',' ','U','S','E','R','P','O','R','T',' ','H','I','T',' ','1',13
	!by 'A',')',' ','U','S','E','R','P','O','R','T',' ','H','I','T',' ','2',13
	!by 'B',')',' ','U','S','E','R','P','O','R','T',' ','K','I','N','G','S','O','F','T',' ','1',13
	!by 'C',')',' ','U','S','E','R','P','O','R','T',' ','K','I','N','G','S','O','F','T',' ','2',13
	!by 'D',')',' ','U','S','E','R','P','O','R','T',' ','S','T','A','R','B','Y','T','E',' ','1',13
	!by 'E',')',' ','U','S','E','R','P','O','R','T',' ','S','T','A','R','B','Y','T','E',' ','2',13,0
