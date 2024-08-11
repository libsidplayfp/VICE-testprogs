*=$1001

; The following logic is used:
;
; keypad  pin write  pin read
; ------- ---------  --------
;  1       1  up      5  POT AY
;  2       1  up      9  POT AX
;  3       1  up      6  FIRE
;  4       2  down    5  POT AY
;  5       2  down    9  POT AX
;  6       2  down    6  FIRE
;  7       3  left    5  POT AY
;  8       3  left    9  POT AX
;  9       3  left    6  FIRE
;  *       4  right   5  POT AY
;  0       4  right   9  POT AX
;  #       4  right   6  FIRE

VIC20_VIA1_PRA = 0x9111     ; bit5-2: fire/down/left/up
VIC20_VIA1_DDRA = 0x9113
VIC20_VIA2_PRB = 0x9120     ; bit7: right
VIC20_VIA2_DDRB = 0x9122

POTX = $9008
POTY = $9009

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

	sei

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
	ldy #<((1*22)+10)
	bne invert_key
check_key_2:
	cmp #2
	bne check_key_1
	ldy #<((1*22)+6)
	bne invert_key
check_key_1:
	cmp #3
	bne check_key_6
	ldy #<((1*22)+2)
	bne invert_key
check_key_6:
	cmp #4
	bne check_key_5
	ldy #<((3*22)+10)
	bne invert_key
check_key_5:
	cmp #5
	bne check_key_4
	ldy #<((3*22)+6)
	bne invert_key
check_key_4:
	cmp #6
	bne check_key_9
	ldy #<((3*22)+2)
	bne invert_key
check_key_9:
	cmp #7
	bne check_key_8
	ldy #<((5*22)+10)
	bne invert_key
check_key_8:
	cmp #8
	bne check_key_7
	ldy #<((5*22)+6)
	bne invert_key
check_key_7:
	cmp #9
	bne check_key_hash
	ldy #<((5*22)+2)
	bne invert_key
check_key_hash:
	cmp #10
	bne check_key_0
	ldy #<((7*22)+10)
	bne invert_key
check_key_0:
	cmp #11
	bne check_key_star
	ldy #<((7*22)+6)
	bne invert_key
check_key_star:
	cmp #12
	bne no_key_pressed
	ldy #<((7*22)+2)
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

	lda VIC20_VIA2_DDRB
	pha
	lda VIC20_VIA2_PRB
	pha

	; fire = input, left/down/up = output
	lda VIC20_VIA1_DDRA
	and #%11000011
	ora #%00011100
	sta VIC20_VIA1_DDRA

	; right = output
	lda VIC20_VIA2_DDRB
	;and #$7f
	ora #%10000000
	sta VIC20_VIA2_DDRB

	; first row
	lda #$80   ; right = 1
	sta VIC20_VIA2_PRB
	lda #$18   ; left = 1, down = 1, up = 0
	sta VIC20_VIA1_PRA

	lda VIC20_VIA1_PRA
	and #$20   ; check fire
	bne native_key_2
	ldx #1
	bne found_native_key
native_key_2:
	lda POTX
	beq native_key_1
	ldx #2
	bne found_native_key
native_key_1:
	lda POTY
	beq native_key_6
	ldx #3
	bne found_native_key
native_key_6:

    ; second row
	lda #$14   ; left = 1, down = 0, up = 1
	sta VIC20_VIA1_PRA

	lda VIC20_VIA1_PRA
	and #$20   ; check fire
	bne native_key_5
	ldx #4
	bne found_native_key
native_key_5:
	lda POTX
	beq native_key_4
	ldx #5
	bne found_native_key
native_key_4:
	lda POTY
	beq native_key_9
	ldx #6
	bne found_native_key
native_key_9:

    ; third row
	lda #$0c   ; left = 0, down = 1, up = 1
	sta VIC20_VIA1_PRA

	lda VIC20_VIA1_PRA
	and #$20   ; check fire
	bne native_key_8
	ldx #7
	bne found_native_key
native_key_8:
	lda POTX
	beq native_key_7
	ldx #8
	bne found_native_key
native_key_7:
	lda POTY
	beq native_key_hash
	ldx #9
	bne found_native_key
native_key_hash:

    ; fourth row

	lda #$00   ; right = 0
	sta VIC20_VIA2_PRB
	lda #$1c   ; left = 1, down = 1, up = 1
	sta VIC20_VIA1_PRA

	lda VIC20_VIA1_PRA
	and #$20       ; check fire
	bne native_key_0
	ldx #10
	bne found_native_key
native_key_0:
	lda POTX
	beq native_key_star
	ldx #11
	bne found_native_key
native_key_star:
	lda POTY
	beq nothing_pressed
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
	!by 176,192,192,192,178,192,192,192,178,192,192,192,174,13
	!by 221, 32,'1', 32,221, 32,'2', 32,221, 32,'3', 32,221,13
	!by 171,192,192,192,219,192,192,192,219,192,192,192,179,13
	!by 221, 32,'4', 32,221, 32,'5', 32,221, 32,'6', 32,221,13
	!by 171,192,192,192,219,192,192,192,219,192,192,192,179,13
	!by 221, 32,'7', 32,221, 32,'8', 32,221, 32,'9', 32,221,13
	!by 171,192,192,192,219,192,192,192,219,192,192,192,179,13
	!by 221, 32,'*', 32,221, 32,'0', 32,221, 32,'#', 32,221,13
	!by 173,192,192,192,177,192,192,192,177,192,192,192,189,13
	!by 13,'A','T','A','R','I',' ','C','X','2','1',' ','K','E','Y','P','A','D',' ','I','N',13
	!by 'N','A','T','I','V','E',0
