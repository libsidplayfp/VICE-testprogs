
.if .def(PROP_AMIGA)
	;; this is for the Amiga mouse
	prop_map = amiga_map
	prop_decode = amiga_decode
.elseif .def(PROP_ST)
	;; This setting is for the Atari ST mouse and the later versions
	;; of the Atari CX80 Trak ball
	prop_map = st_map
	prop_decode = st_decode
.elseif .def(PROP_CX22)
	;; This setting is for the Atari CX22 Trak ball and early
	;; versions of the Atari CX80 Trak ball
	prop_map = cx22_map
	prop_decode = cx22_decode
.else
	.error "Must define either PROP_AMIGA, PROP_ST or PROP_CX22"
.endif

.export prop_init
.export prop_update
.export prop_x
.export prop_y
.export prop_err
	;; these two are exported for debugging purposes
.export prop_state_x
.export prop_state_y

	.code

prop_init:
	lda #0
	jsr prop_update
	lda #0
	sta prop_x
	sta prop_y
	sta prop_state_x
	sta prop_state_y
	sta prop_err
	sta prop_err + 1
	rts

prop_update:
	and #$0f
	tax
	lda prop_map,x
	pha
	and #$03
	ora prop_state_y
	tax
	asl
	asl
	and #$0c
	sta prop_state_y
	lda prop_decode,x
	beq :++
	cmp #$80
	bne :+
	inc prop_err
	bne :++
	inc prop_err + 1
	bne :++
:
	clc
	adc prop_y
	sta prop_y
:

	pla
	and #$0c
	ora prop_state_x
	tax
	lsr
	lsr
	and #$03
	sta prop_state_x
	lda prop_decode,x
	beq @earlyexit
	cmp #$80
	beq @invalid
	clc
	adc prop_x
	sta prop_x
@earlyexit:
	rts
@invalid:
	inc prop_err
	bne :+
	inc prop_err + 1
:
	rts

	.rodata
	;; decoder table values
	;; $00 no change
	;; $01 increase coordinate
	;; $80 error
	;; $ff decrease coordinate
amiga_decode:
	;; decode offset bits: 3=hq',2:h',1=hq,0=h or
	;;                     3=v',2:vq',1=v,0=vq
st_decode:
	;; decode offset bits: 3=yb',2:ya',1=yb,0=ya or
	;;                     3=xb',2:xa',1=xb,0=xa
	.byt $00, $ff, $01, $80
	.byt $01, $00, $80, $ff
	.byt $ff, $80, $00, $01
	.byt $80, $01, $ff, $00
cx22_decode:
	;; decode offset bits: 3=x',2:xdir',1=x,0=x_dir or
	;;                     3=y',2:ydir',1=y,0=y_dir
	.byt $00, $80, $ff, $80
	.byt $ff, $00, $80, $01
	.byt $ff, $80, $00, $01
	.byt $80, $01, $80, $00
amiga_map:
	;; map from bits 3=hq,2=vq,1=h,0=v to
	;;               3=hq,2=h,1=v,0=vq,
	.byt %0000
	.byt %0010
	.byt %0100
	.byt %0110
	.byt %0001
	.byt %0011
	.byt %0101
	.byt %0111
	.byt %1000
	.byt %1010
	.byt %1100
	.byt %1110
	.byt %1001
	.byt %1011
	.byt %1101
	.byt %1111
st_map:
	;; map from bits 3=yb,2=ya,1=xa,0=xb to
	;;               3=xb,2=xa,1=yb,0=ya,
	.byt %0000
	.byt %1000
	.byt %0100
	.byt %1100
	.byt %0001
	.byt %1001
	.byt %0101
	.byt %1101
	.byt %0010
	.byt %1010
	.byt %0110
	.byt %1110
	.byt %0011
	.byt %1011
	.byt %0111
	.byt %1111
cx22_map:
	;; map from bits 3=y,2=ydir,1=x,0=xdir to
	;;               3=x,2=xdir,1=y,0=ydir,
	.byt %0000
	.byt %0100
	.byt %1000
	.byt %1100
	.byt %0001
	.byt %0101
	.byt %1001
	.byt %1101
	.byt %0010
	.byt %0110
	.byt %1010
	.byt %1110
	.byt %0011
	.byt %0111
	.byt %1011
	.byt %1111

	.bss

prop_state_x:
	.byt 0
prop_state_y:
	.byt 0
prop_x:
	.byt 0
prop_y:
	.byt 0
prop_err:
	.word 0
