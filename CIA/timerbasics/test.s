
CIA	=$dc00
VIC	=$d000

        *= $0801
        !byte $0c,$08,$0b,$00,$9e
        !byte $34,$30,$39,$36
        !byte $00,$00,$00,$00

        ;-----------------------------------------------------

        *=$1000

	sei

	lda VIC+17
	and #%11101111
	sta VIC+17

l1	bit VIC+17
	bpl l1
l2	bit VIC+17
	bmi l2

	lda #$7f
	sta CIA+13

	lda #0
	sta CIA+14
	
	lda #<15
	sta CIA+4
	lda #>15
	sta CIA+5

	lda CIA+13
	lda #$81
	sta CIA+13

	lda #$11
	sta CIA+14

	ldx #0
l0	lda CIA+13
	sta $1200,x
	inx
	bne l0

	lda VIC+17
	ora #%00010000
	sta VIC+17

	lda #$7f
	sta CIA+13
	lda CIA+13

        ; done

        lda #$1b
        sta $d011
;       cli

        ldx #0
lp1:
        lda #$20
        sta $0400,x
        sta $0500,x
        sta $0600,x
        sta $0700,x
        lda #2
        sta $d800,x
        sta $d900,x
        sta $da00,x
        sta $db00,x
        inx
        bne lp1

        ldx #0
lp:
        lda $1200,x
        sta $0400,x
        cmp $2200,x
        bne sk
        lda #5
        sta $d800,x
sk
        inx
        bne lp
        jmp *



;The result should be at $1200:

;1200 00 81 01 00 81 81 81 81
;1208 81 81 01 00 81 81 81 81
;1210 81 81 01 00 81 81 81 81
;1218 81 81 01 00 81 81 81 81
;...



