*=$0801

C64_CIA1_PRA = 0xDC00
C64_CIA1_PRB = 0xDC01
C64_CIA1_DDRA = 0xDC02
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
	eor #$ff
	and #$1f
	jsr show_key
	jmp check_loop

; KEY PRESSED   KEY3 KEY2 KEY1 KEY0
; -----------   ---- ---- ---- ----
; 0               0    0    0    0
; 1               0    0    0    1
; 2               0    0    1    0
; 3               0    0    1    1
; 4               0    1    0    0
; 5               0    1    0    1
; 6               0    1    1    0
; 7               0    1    1    1
; 8               1    0    0    0
; 9               1    0    0    1
; +               1    0    1    0
; -               1    0    1    1
; /               1    1    0    0
; *               1    1    0    1
; .               1    1    1    0
; Enter           1    1    1    1

show_key:
	ldy #$00
	ldx #$00
	cmp #%00010111         ; 7
	bne check_key_8
	ldy #42
	bne invert_key_4
check_key_8:
	cmp #%00011000         ; 8
	bne check_key_9
	ldy #46
	bne invert_key_4
check_key_9:
	cmp #%00011001         ; 9
	bne check_key_mult
	ldy #50
	bne invert_key_4
check_key_mult:
	cmp #%00011101         ; *
	bne check_key_4
	ldy #54
	bne invert_key_4
check_key_4:
	cmp #%00010100         ; 4
	bne check_key_5
	ldy #122
	bne invert_key_4
check_key_5:
	cmp #%00010101         ; 5
	bne check_key_6
	ldy #126
	bne invert_key_4
check_key_6:
	cmp #%00010110         ; 6
	bne check_key_div
	ldy #130
	bne invert_key_4
check_key_div:
	cmp #%00011100         ; /
	bne check_key_1
	ldy #134
	bne invert_key_4
check_key_1:
	cmp #%00010001         ; 1
	bne check_key_2
	ldy #202
	bne invert_key_4
check_key_2:
	cmp #%00010010         ; 2
	bne check_key_3
	ldy #206
	bne invert_key_4
check_key_3:
	cmp #%00010011         ; 3
	bne check_key_minus
	ldy #210
	bne invert_key_4
check_key_minus:
	cmp #%00011011         ; -
	bne check_key_dot
	ldy #214
invert_key_4:
	ldx #4
	bne invert_key
check_key_dot:
	cmp #%00011110         ; .
	bne check_key_0
	ldy #26
	bne invert_key_5
check_key_0:
	cmp #%00010000         ; 0
	bne check_key_enter
	ldy #30
	bne invert_key_5
check_key_enter:
	cmp #%00011111         ; enter
	bne check_key_plus
	ldy #34
	bne invert_key_5
check_key_plus:
	cmp #%00011010         ; +
	bne no_key_pressed
	ldy #38
	bne invert_key_5
no_key_pressed:
	rts
invert_key_5:
	ldx #5
invert_key:
	sty $fb
	stx $fc
	pha
	ldy #$00
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
read_native_1:
	jmp read_native_1_code
read_native_2:
	jmp read_native_2_code

read_native_1_code:
read_key_1:
	ldx #$7f
	stx C64_CIA1_PRA
	lda C64_CIA1_PRB
	rts

read_native_2_code:
read_key_2:
	ldy C64_CIA1_DDRA
	ldx #$ff
	stx C64_CIA1_DDRA
	lda C64_CIA1_PRA
	sty C64_CIA1_DDRA
	rts

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
	bne check_change_port_key
	ldx #1
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
print_native_device_loop:
	lda native_device_screen,x
	beq print_port_number
	jsr $ffd2
	inx
	bne print_native_device_loop
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
	!by 13,'C','A','R','D','C','O',' ','C','A','R','D','K','E','Y',' ','K','E','Y','P','A','D',' ','I','N',13,0

native_device_screen:
	!by 'N','A','T','I','V','E',0

change_port_screen:
	!by 147,'P','L','E','A','S','E',' ','C','H','O','O','S','E',' ','T','H','E',' ','N','E','W',' ','P','O','R','T',':',13
	!by '1',')',' ','N','A','T','I','V','E',' ','1',13
	!by '2',')',' ','N','A','T','I','V','E',' ','2',13,0
