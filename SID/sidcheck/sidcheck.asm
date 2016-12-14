            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0
;-------------------------------------------------------------------------------

start	sei
	lda #$0b
	sta $d011
	lda $d012
wait1	bit $d011
	bmi wait1
wait2	bit $d011
	bpl wait2
	jsr check
	lda #$9b
	sta $d011
;stop	jmp stop
	cli
	rts
;----------------------------------------
xxx1	lda #$00
	sta $d40f		; sid: voice 3 frequency high
	sta $d40e		; sid: voice 3 frequency low
	lda #$80
	ldx #$f8
	ldy #$07
loop1	sta $d412		; sid: voice 3 control register
	stx $d412		; sid: voice 3 control register
	dey
	bne loop1
	ldy #$05
	ldx #$88
loop2	stx $d412		; sid: voice 3 control register
	sta $d412		; sid: voice 3 control register
	dey
	bne loop2
	ldx #$f0
	stx $d412		; sid: voice 3 control register
	sta $d412		; sid: voice 3 control register
	ldx #$88
	stx $d412		; sid: voice 3 control register
	sta $d412		; sid: voice 3 control register
	stx $d412		; sid: voice 3 control register
	sta $d412		; sid: voice 3 control register
	ldx #$f0
	stx $d412		; sid: voice 3 control register
	sta $d412		; sid: voice 3 control register
	rts

xxx2	lda #$00
	sta $d40f		; sid: voice 3 frequency high
	sta $d40e		; sid: voice 3 frequency low
	lda #$08
	sta $d412		; sid: voice 3 control register
	lda #$00
	sta $d412		; sid: voice 3 control register
	rts

xxx3	lda #$f0
	sta $d40f		; sid: voice 3 frequency high
	nop
	nop
	nop
	ldx #$2d
loop3	dex
	bne loop3
	lda #$20
	sta $d40f		; sid: voice 3 frequency high
	lda #$10
	sta $d40f		; sid: voice 3 frequency high
	lda #$00
	nop
	nop
	nop
	nop
	sta $d40f		; sid: voice 3 frequency high
	sta $d411		; sid: voice 3 pulsewidth high
	sta $d410		; sid: voice 3 pulsewidth low
	rts

check	jsr xxx5
	bne skip2
	ldx #$0e
	jsr xxx1
	lda #$80
	sta $d412		; sid: voice 3 control register
	lda $d41b		; sid: read oscillator 3 output
	sta fix1+1
	jsr xxx3
fix1	lda #$00
	bne skip1
	lda $d41b		; sid: read oscillator 3 output
	cmp #$82
	bne skip1
	lda #$02
	jsr xxx4
	rts
;----------------------------------------
skip1	lda #$01
	jsr xxx4
	rts
;----------------------------------------
skip2	ldx #$0e
	jsr xxx2
	jsr xxx3
	lda #$60
	sta $d412		; sid: voice 3 control register
	lda $d41b		; sid: read oscillator 3 output
	lsr
	lsr
	lsr
	lsr
	and #$0c
	sta fix2+1
	lda #$70
	sta $d412		; sid: voice 3 control register
	lda $d41b		; sid: read oscillator 3 output
	rol
	rol
	rol
	and #$03
fix2	ora #$00
	tay
	lda result,y
	bne p1
	lda #$3f
	sta p1+1
	sta p2+1
	sta p3+1
p1	lda #$38
	sta text+14
	sta text+16
p2	lda #$35
	sta text+15
p3	lda #$30
	sta text+17
	lda result,y
xxx4	ora #$30
	sta text+9
	ldx #$00
next	lda text,x
	jsr $ffd2
	inx
	cpx #$13
	bne next
	rts

xxx5	lda #$ff
	sta $d412		; sid: voice 3 control register
	sta $d40e		; sid: voice 3 frequency low
	sta $d40f		; sid: voice 3 frequency high
	lda #$20
	sta $d412		; sid: voice 3 control register
	lda $d41b		; sid: read oscillator 3 output
	cmp #$03
	beq skip3
	lda #$01
	rts

skip3	lda #$00
	rts

result	!byte $03,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$04,$00,$05,$00
text	!text "QUALITY: 0/5 (6581)"

;05 = Best (8580)
;07 = Good (8580)
;02 = Bad (8580)
;0c = Unknown (8580)
;0b = Bad (6581)
;00 = Awful (6581)
