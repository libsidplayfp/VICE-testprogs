*=$0801

C64_CIA1_PRA = 0xDC00
C64_CIA1_PRB = 0xDC01
C64_CIA1_DDRA = 0xDC02
C64_CIA1_DDRB = 0xDC03
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
	sei    ; disable interrupt so the keyboard scanning doesn't disturb POT reads
check_loop:
	jsr check_port
	and #$1f
	jsr show_key
	jmp check_loop

show_key:
	ldy #$00
	ldx #$00
	cmp #1
	bne check_key_2
	ldy #<((1*40)+10)
	jmp invert_key_4
check_key_2:
	cmp #2
	bne check_key_1
	ldy #<((1*40)+6)
	jmp invert_key_4
check_key_1:
	cmp #3
	bne check_key_6
	ldy #<((1*40)+2)
	jmp invert_key_4
check_key_6:
	cmp #4
	bne check_key_5
	ldy #<((3*40)+10)
	jmp invert_key_4
check_key_5:
	cmp #5
	bne check_key_4
	ldy #<((3*40)+6)
	jmp invert_key_4
check_key_4:
	cmp #6
	bne check_key_9
	ldy #<((3*40)+2)
	jmp invert_key_4
check_key_9:
	cmp #7
	bne check_key_8
	ldy #<((5*40)+10)
	jmp invert_key_4
check_key_8:
	cmp #8
	bne check_key_7
	ldy #<((5*40)+6)
	jmp invert_key_4
check_key_7:
	cmp #9
	bne check_key_hash
	ldy #<((5*40)+2)
invert_key_4:
	ldx #4
	bne invert_key
check_key_hash:
	cmp #10
	bne check_key_0
	ldy #<((7*40)+10)
	bne invert_key_5
check_key_0:
	cmp #11
	bne check_key_star
	ldy #<((7*40)+6)
	bne invert_key_5
check_key_star:
	cmp #12
	bne no_key_pressed
	ldy #<((7*40)+2)
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

read_potx:
	txa
	pha
	ldx #$00
loopx:
	inx
	bne loopx
	pla
	tax
	lda $d419
	eor #$ff
	rts

read_poty:
	txa
	pha
	ldx #$00
loopy:
	inx
	bne loopy
	pla
	tax
	lda $d41a
	eor #$ff
	rts

read_native_1_code:
	ldx C64_CIA1_PRB
	ldy C64_CIA1_DDRB
	lda #$0f
	sta C64_CIA1_DDRB
	lda C64_CIA1_PRA
	and #$3f
	ora #$40
	sta C64_CIA1_PRA
	lda #$0e
	sta C64_CIA1_PRB
	lda C64_CIA1_PRB
	and #$10
	bne check_native_1_key_2
	lda #1
	bne found_native_1_key
check_native_1_key_2:
	jsr read_potx
	bne check_native_1_key_1
	lda #2
	bne found_native_1_key
check_native_1_key_1:
	jsr read_poty
	bne check_native_1_key_6
	lda #3
	bne found_native_1_key
check_native_1_key_6:
	lda #$0d
	sta C64_CIA1_PRB
	lda C64_CIA1_PRB
	and #$10
	bne check_native_1_key_5
	lda #4
	bne found_native_1_key
check_native_1_key_5:
	jsr read_potx
	bne check_native_1_key_4
	lda #5
	bne found_native_1_key
check_native_1_key_4:
	jsr read_poty
	bne check_native_1_key_9
	lda #6
	bne found_native_1_key
check_native_1_key_9:
	lda #$0b
	sta C64_CIA1_PRB
	lda C64_CIA1_PRB
	and #$10
	bne check_native_1_key_8
	lda #7
	bne found_native_1_key
check_native_1_key_8:
	jsr read_potx
	bne check_native_1_key_7
	lda #8
	bne found_native_1_key
check_native_1_key_7:
	jsr read_poty
	bne check_native_1_key_hash
	lda #9
	bne found_native_1_key
check_native_1_key_hash:
	lda #$07
	sta C64_CIA1_PRB
	lda C64_CIA1_PRB
	and #$10
	bne check_native_1_key_0
	lda #10
	bne found_native_1_key
check_native_1_key_0:
	jsr read_potx
	bne check_native_1_key_star
	lda #11
	bne found_native_1_key
check_native_1_key_star:
	jsr read_poty
	bne no_native_1_key_pressed
	lda #12
	bne found_native_1_key
no_native_1_key_pressed:
	lda #$00
found_native_1_key:
	sty C64_CIA1_DDRB
	stx C64_CIA1_PRB
	rts

read_native_2_code:
	ldx C64_CIA1_PRA
	ldy C64_CIA1_DDRA
	lda #$cf
	sta C64_CIA1_DDRA
	lda #$8e
	sta C64_CIA1_PRA
	lda C64_CIA1_PRA
	and #$10
	bne check_native_2_key_2
	lda #1
	bne found_native_2_key
check_native_2_key_2:
	jsr read_potx
	bne check_native_2_key_1
	lda #2
	bne found_native_2_key
check_native_2_key_1:
	jsr read_poty
	bne check_native_2_key_6
	lda #3
	bne found_native_2_key
check_native_2_key_6:
	lda #$8d
	sta C64_CIA1_PRA
	lda C64_CIA1_PRA
	and #$10
	bne check_native_2_key_5
	lda #4
	bne found_native_2_key
check_native_2_key_5:
	jsr read_potx
	bne check_native_2_key_4
	lda #5
	bne found_native_2_key
check_native_2_key_4:
	jsr read_poty
	bne check_native_2_key_9
	lda #6
	bne found_native_2_key
check_native_2_key_9:
	lda #$8b
	sta C64_CIA1_PRA
	lda C64_CIA1_PRA
	and #$10
	bne check_native_2_key_8
	lda #7
	bne found_native_2_key
check_native_2_key_8:
	jsr read_potx
	bne check_native_2_key_7
	lda #8
	bne found_native_2_key
check_native_2_key_7:
	jsr read_poty
	bne check_native_2_key_hash
	lda #9
	bne found_native_2_key
check_native_2_key_hash:
	lda #$87
	sta C64_CIA1_PRA
	lda C64_CIA1_PRA
	and #$10
	bne check_native_2_key_0
	lda #10
	bne found_native_2_key
check_native_2_key_0:
	jsr read_potx
	bne check_native_2_key_star
	lda #11
	bne found_native_2_key
check_native_2_key_star:
	jsr read_poty
	bne no_native_2_key_pressed
	lda #12
	bne found_native_2_key
no_native_2_key_pressed:
	lda #$00
found_native_2_key:
	sty C64_CIA1_DDRA
	stx C64_CIA1_PRA
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


; KEYPAD          KEYMAP KEYS
; -------------   ----------------
; | 1 | 2 | 3 |   |  1 |  2 |  3 |
; -------------   ----------------
; | 4 | 5 | 6 |   |  6 |  7 |  8 |
; -------------   ----------------
; | 7 | 8 | 9 |   | 11 | 12 | 13 |
; -------------   ----------------
; | * | 0 | # |   | 16 | 17 | 18 |
; -------------   ----------------

main_screen:
	!by 147
	!by 176,195,195,195,178,195,195,195,178,195,195,195,174,13
	!by 194, 32,'1', 32,194, 32,'2', 32,194, 32,'3', 32,194,13
	!by 171,195,195,195,219,195,195,195,219,195,195,195,179,13
	!by 194, 32,'4', 32,194, 32,'5', 32,194, 32,'6', 32,194,13
	!by 171,195,195,195,219,195,195,195,219,195,195,195,179,13
	!by 194, 32,'7', 32,194, 32,'8', 32,194, 32,'9', 32,194,13
	!by 171,195,195,195,219,195,195,195,219,195,195,195,179,13
	!by 194, 32,'*', 32,194, 32,'0', 32,194, 32,'#', 32,194,13
	!by 173,195,195,195,177,195,195,195,177,195,195,195,189,13
	!by 0

test_name_screen:
	!by 13,'A','T','A','R','I',' ','C','X','2','1',' ','K','E','Y','P','A','D',' ','I','N',13,0

native_device_screen:
	!by 'N','A','T','I','V','E',0

change_port_screen:
	!by 147,'P','L','E','A','S','E',' ','C','H','O','O','S','E',' ','T','H','E',' ','N','E','W',' ','P','O','R','T',':',13
	!by '1',')',' ','N','A','T','I','V','E',' ','1',13
	!by '2',')',' ','N','A','T','I','V','E',' ','2',13,0
