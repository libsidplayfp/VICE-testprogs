      *=$0801             ; basic start
      !WORD +
      !WORD 10
      !BYTE $9E
      !TEXT "2061"
      !BYTE 0
+     !WORD 0
results = $2000
	lda #$93
	jsr $ffd2

l3  bit $d011
	bpl l3
l4	bit $d011
	bmi l4
	lda #$00
	sta dl+1
	sta sr+1
	sta status
	
	lda $d011
	and #%11101111
	sta $d011	; disable screen
	
l5	bit $d011
	bpl l5
l6	bit $d011
	bmi l6

	ldx #21		; 21 times
loop
	sei

	; setup ICR and CRx
	lda #%0111111
	sta $dd0d	; disable interrupts

	lda $dd0e
	and #%10000000
	sta $dd0e	; stop TA (keep 50Hz flag)
	
	lda #%00000000	
	sta $dd0f	; stop TB

	lda #<50
	sta $dd04	; TA low
	lda #>50
	sta $dd05	; TA hi

	lda #<65530
	sta $dd06	; TB low
	lda #>65530
	sta $dd07	; TB hi
	
		; start TB
	lda $dd0f
	ora #%00010001	; force load and start TB
	sta $dd0f

	; setup SDR
	lda #%01010001	; TA started, force load, SDR output
	sta $dd0e
dl	jsr delay

	lda #$55
	sta $dd0c	; send 

	; wait for SDR empty
	lda #%00001000
l1	bit $dd0d
	beq l1

	; save TB value
	lda #%00000000	
	sta $dd0f	; stop TB
	lda $dd06
	jsr sr
	pha
	lda $dd07
	jsr sr
	jsr hexout
	pla
	jsr hexout

	lda #13
	jsr $ffd2

	cli
	inc dl+1
	dex
	bne loop
	ldx #(21*2)-1
lp	lda #$07
	jsr color
	dex
	bpl lp
	lda $d011
	ora #%00010000
	sta $d011	; enable screen
	
	ldx #(2*21)-1
	
clp 
    lda check,x
	cmp results,x
	beq ok
	lda #$02
	jsr color
	
	ldy #$ff   ; fail
	sty status 

ok	dex
	bpl clp
	
	ldy status
	sty $d7ff  ; testbench result
	bne failed 
    lda #13	   ; pass
    sta $d020
	jmp *
	
failed:
    lda #10	   ; fail
    sta $d020 
	jmp *
	
color
	pha
	txa
	and #$fe
	tax
	lda colpos,x
	sta screenpos+1
	lda colpos+1,x
	sta screenpos+2
	pla
	ldy #$03
screenpos
	sta $d800,y
	dey
	bpl screenpos
	rts

hexout	pha
	lsr
	lsr
	lsr
	lsr
	jsr nibout
	pla
	and #$0f
nibout	clc
	adc #246	; 0-9 -> 246-255,C=0; 10-15 -> 256-261=0-5,C=1
	bcc n1
	adc #$41-$3a-1
n1	sbc #246-$30-1
	jmp $ffd2

sr  
	sta results
	inc sr+1
	rts
	
	* = (*+$ff)&$ff00 
delay
	cmp #$c9	
	cmp #$c9
	cmp #$c9
	cmp #$c9
	cmp #$c9
	cmp #$c9
	cmp #$c9
	cmp #$c9
	cmp #$c9
	cmp #$c9
	cmp $ea
	rts	
status !byte 0	
colpos
!word $d800
!word $d800+40
!word $d800+(40*2)
!word $d800+(40*3)
!word $d800+(40*4)
!word $d800+(40*5)
!word $d800+(40*6)
!word $d800+(40*7)
!word $d800+(40*8)
!word $d800+(40*9)
!word $d800+(40*10)
!word $d800+(40*11)
!word $d800+(40*12)
!word $d800+(40*13)
!word $d800+(40*14)
!word $d800+(40*15)
!word $d800+(40*16)
!word $d800+(40*17)
!word $d800+(40*18)
!word $d800+(40*19)
!word $d800+(40*20)
!word $d800+(40*21)


check	
!word $fce6,$fce7,$fce8,$fce9,$fcea,$fce4,$fce5
!word $fce6,$fce7,$fce8,$fce9,$fcea,$fce4,$fce5
!word $fce6,$fce7,$fce8,$fce9,$fcea,$fce4,$fce5
