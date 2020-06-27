;=========================================================
;=========================================================
; ram test subs
;=========================================================
;=========================================================
/*
stressram:

		ldx #$80
		stx $ff
		ldx #$00
		stx $fe
		ldx #$20
		
		ldy #$00
clr2:		sta ($fe),y
		iny
		bne clr2
		inc $ff
		dex
		bpl clr2

		rts


*/
;=========================================================
c64ramclr:
		ldx #$20
		lda #$80
		sta $ff
		lda #$00
		sta $fe
		tay
clr1:		sta ($fe),y
		iny
		bne clr1
		inc $ff
		dex
		bpl clr1
		rts
;=========================================================
c64ramsetup:
		ldx #$00
		lda #$ff
r1:		sta $8000,x
		sta $9e00,x
		sta $9f00,x
		inx
		cpx #$80
		bne r1
		lda #$80
r2:		sta $8000,x
		sta $9e00,x
		sta $9f00,x
		inx
		bne r2
		rts
;=========================================================
c64ramverify:
		ldx #$00
		lda #$ff
vr1:		cmp $8000,x
		bne failc64vrfy
		cmp $9e00,x
		bne failc64vrfy
		cmp $9f00,x
		bne failc64vrfy
		inx
		cpx #$80
		bne vr1
		
		lda #$80
vr2:		cmp $8000,x
		bne failc64vrfy
		cmp $9e00,x
		bne failc64vrfy
		cmp $9f00,x
		bne failc64vrfy
		inx
		bne vr2

		lda #$00
		rts

failc64vrfy:
#ifdef DEBUG	; wtf ???
		ldy #$00
debug0:
		lda $8040,y
		sta $0400,y
		lda $9e40,y
		sta $0480,y
		lda $9f40,y
		sta $0500,y
		iny
		cpy #$80
		bne debug0
#endif

		lda #$01
		rts
;=========================================================
; AR IO WRITE - to be called with correct de00 and f8/f9 setting

ariowrite:
		ldy #$00
		lda #$be
ariow1:
		sta ($f8),y
		iny
		cpy #$40
		bne ariow1
		lda #$80
ariow2:
		sta ($f8),y
		iny
		cpy #$80
		bne ariow2
		rts
;=========================================================
arramioreadsetup:
		ldy #$00
		lda #$be
ariow1a:
		sta $9e20,y
		sta $9f20,y
		iny
		cpy #$40
		bne ariow1a
		lda #$80
ariow2a:
		sta $9e20,y
		sta $9f20,y
		iny
		cpy #$80
		bne ariow2a
		rts
;=========================================================
; AR IO VRFY - to be called with correct de00 and f8/f9 setting
arioverify:
		ldy #$00
arior1:
		lda ($f8),y
		cmp #$be
		bne failariovrfy
		iny
		cpy #$40
		bne arior1
arior2:
		lda ($f8),y
		cmp #$80
		bne failariovrfy
		iny
		cpy #$80
		bne arior2
		lda #$00
		rts
failariovrfy:

#ifdef DEBUG	; wtf???
		ldy #$00
debug1:
		lda ($f8),y
		sta $0400,y
		iny
		cpy #$80
		bne debug1
#endif
		lda #$01
		rts

;=========================================================
arioramverify:
		lda $f9
		sec
		sbc #$40
		sta $ff			; get the c64/AR ram address from the IO check before
		lda #$20
		sta $fe

		ldy #$00
arioramr1:
		lda ($fe),y
		cmp #$be
		bne failarioramvrfy
		iny
		cpy #$40
		bne arioramr1
arioramr2:
		lda ($fe),y
		cmp #$80
		bne failarioramvrfy
		iny
		cpy #$80
		bne arioramr2
		lda #$00
		rts

failarioramvrfy:
#ifdef DEBUG	; wtf ???
		ldy #$00
debug2:
		lda ($fe),y
		sta $0480,y
		iny
		cpy #$80
		bne debug2
#endif
		lda #$01
		rts
;========================================================= for test 5
arioramverify2:
		lda $f9
		sec
		sbc #$40
		sta $ff			; get the c64/AR ram address from the IO check before
		lda #$40
		sta $fe

		ldy #$00
arioramr11:
		lda ($fe),y
		cmp #$55
		bne failarioramvrfy2
		iny
		cpy #$40
		bne arioramr11
arioramr22:
		lda ($fe),y
		cmp #$aa
		bne failarioramvrfy2
		iny
		cpy #$80
		bne arioramr22
		lda #$00
		rts

failarioramvrfy2:
#ifdef DEBUG
		ldy #$00
debug3:
		lda ($fe),y
		sta $0480,y
		iny
		cpy #$80
		bne debug3
#endif
		lda #$01
		rts
;=========================================================
arramsetup:
		ldx #$00
		lda #$55
ar1:		sta $8000,x
		sta $9e00,x
		sta $9f00,x
		inx
		cpx #$80
		bne ar1
		lda #$aa
ar2:		sta $8000,x
		sta $9e00,x
		sta $9f00,x
		inx
		bne ar2
		rts
;=========================================================
arramverify:
		ldx #$00
		lda #$55
var1:		cmp $8000,x
		bne failarvrfy
		cmp $9e00,x
		bne failarvrfy
		cmp $9f00,x
		bne failarvrfy
		inx
		cpx #$80
		bne var1
		
		lda #$aa
var2:		cmp $8000,x
		bne failarvrfy
		cmp $9e00,x
		bne failarvrfy
		cmp $9f00,x
		bne failarvrfy
		inx
		bne var2

		lda #$00
		rts

failarvrfy:
		lda #$01
		rts

 
