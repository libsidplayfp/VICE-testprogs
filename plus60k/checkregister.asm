
        * = $0801
        !word $0801 + $0c
        !byte $0a, $00
        !byte $9e

        !byte $32, $30, $36, $34

        !byte 0,0,0

        * = $0810

		ldx	#$00
		ldy	#$80
		stx	$d100
		lda	#$a9
		sta	$6000
		sty	$d100
		lda	#$eb
		sta	$6000
		stx	$d100
		lda	$6000
		cmp	#$eb
		beq	no60k
		cmp	#$a9
		bne	ramerr
		lda	$d100
		sta	$2
		bne	writeonly
		sty	$d100
		lda	$d100
		sta	$2
		cmp	#$80
		stx	$d100
		bne	writeonly
		
        lda #$ff
        sta $d7ff
        lda #10
        sta $d020
		
		lda	#<strrw
		ldy	#>strrw
		jmp	$ab1e

no60k:	
        lda #$ff
        sta $d7ff
        lda #10
        sta $d020

        lda	#<strno60k
		ldy	#>strno60k
		jmp	$ab1e
		
ramerr:	
        lda #$ff
        sta $d7ff
        lda #10
        sta $d020

        lda	#<strramerr
		ldy	#>strramerr
		jmp	$ab1e
		
writeonly:	
        lda	#<strwo
		ldy	#>strwo
		jsr	$ab1e
		lda	$2
		lsr
		lsr
		lsr
		lsr
		clc
		adc	#$30
		cmp	#$3a
		bcc	out1
		adc	#'A'-'9'-2
out1:	jsr	$ffd2
		lda	$2
		and	#$f
		adc	#$30
		cmp	#$3a
		bcc	out2
		adc	#'A'-'9'-2
out2:	
        jsr	$ffd2

        ; should be write-only and return $ff on reads
        ldy #$00
        ldx #5
        lda $02
        cmp #$ff
        beq +
        ldy #$ff
        ldx #10
+
        sty $d7ff
        stx $d020
        rts
        

strrw:		!pet	"$d100 is r/w",0
strno60k:	!pet	"no +60k detected",0
strramerr:	!pet	"unknown ram error",0
strwo:		!pet	"$d100 is write only",$d,"value read is $",0 
