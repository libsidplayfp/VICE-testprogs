
!macro basic_header {
	!byte $b, $08, $EF, $00, $9E, $32, $30, $36,$31, $00, $00, $00 
}

!to "yusblend3.prg", cbm    ; set output file and format
	*= $0801		; Start at C64 BASIC start
	+basic_header		; Call program header macro
    
        sei
	lda	$d0
	lda     $D016 ;enable multicolor
	ora     #$10
	sta     $D016

        lda     #0
        sta     $D020
        lda     #0
        sta     $D021

	lda     #$BB ;enable bitmap mode
	sta     $D011


.loop
        lda #$f0
-
        cmp $d012
        bne -

        ;inc $d020
        ldx     #0
-
        lda     colors1, x
        sta     $d800,x
        lda     colors1+$100, x
        sta     $d900,x
        dex
        bne     -
        ;inc $d020

        lda     #$03  ;vic base = $0000
        sta     $DD00

        lda     #$38 ; video matrix = 0c00, bitmap base = 2000
        sta     $D018


        ldx     #0
-
        lda     colors1+$200, x
        sta     $da00,x
        lda     colors1+$300, x
        sta     $db00,x
        dex
        bne     -
        ;dec $d020
        ;dec $d020

        lda #$f0
-
        cmp $d012
        bne -

        lda     #$03  ;vic base = $4000
        sta     $DD00

        lda     #$38 ; video matrix = 0c00, bitmap base = 2000
        sta     $D018

        ;inc $d020
        ldx     #0
-
        lda     colors2, x
        sta     $d800,x
        lda     colors2+$100, x
        sta     $d900,x
        dex
        bne     -
        ;inc $d020

        lda     #$02  ;vic base = $4000
        sta     $DD00

        lda     #$80 ; video matrix = 6000, bitmap base = 4000
        sta     $D018


        ldx     #0
-
        lda     colors2+$200, x
        sta     $da00,x
        lda     colors2+$300, x
        sta     $db00,x
        dex
        bne     -
        ;dec $d020
        ;dec $d020

	jmp	.loop




*= $0c00
!bin "yb1.png-v.bin"

*= $2000
!bin "yb1.png.bin"

*= $4000
!bin "yb2.png.bin"

*= $6000
!bin "yb2.png-v.bin"


colors1:
!bin "yb1.png-c.bin"

colors2:
!bin "yb2.png-c.bin"
