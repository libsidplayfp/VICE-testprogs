	.word *+2 ;start address

result	=	$1bfe

basicstart
        .word basicend ; link to next line
	.word 10 ; line number
	.byte $9e ; sys code
; generate PETSCII sys value
	.byte start/1000+$30
	.byte start/100-(start/1000)*10+$30
	.byte start/10-(start/100)*10+$30
	.byte start-(start/10)*10+$30
	.byte 0 ;end of line
basicend
	.word 0

error
	bcc start
	jsr $ff7d
	.byte "load error"
	.byte 0
	jmp *
	
start
	ldy #0
loop
	lda fname,y
	jsr $ffd2
	iny
	cpy #fnext-fname
	bne loop

loop0
	cpy #26
	bcs loop1
	lda #" "
	jsr $ffd2
	iny
	jmp loop0

loop1
	sei 
	lda #$be
	sta $ff00
	lda #$00
	sta $d030
	lda #$c3
	sta $ffee
	lda #<z80start
	sta $ffef
	lda #>z80start
	sta $fff0
	lda #$b0
	sta $d505
	nop 
	lda #$cf
	sta $ffee
	lda #$00
	sta $ff00
	cli 

	lda result
	ldx result+1
	cmp #<$EXPECTED
	bne bad
	cpx #>$EXPECTED
	bne bad
good
	jsr $b89f
	jsr $ff7d
	.byte "good"
	.byte 13,0
	lda #5
	sta $d020
	lda #0
	sta $d7ff

; load next

	lda fnext
	cmp #"-"
	beq done

	lda #0
	ldx #0
	jsr $ff68

	lda #fend-fnext
	ldx #<fnext
	ldy #>fnext
	jsr $ffbd

; Use previous settings
;	lda #0
;	ldx #8
;	ldy #1
;	jsr $ffba

	lda #>(error-1)
	pha
	lda #<(error-1)
	pha

	lda #0
	jmp $ffd5
	
bad
	jsr $b89f
	jsr $ff7d
	.byte "bad "
	.byte 0
	lda #<$EXPECTED
	ldx #>$EXPECTED
	jsr $b89f
	jsr $ff7d
	.byte 13,0
	lda #2
	sta $d020
	lda #1
	sta $d7ff
	jmp *

done
	jsr $ff7d
	.byte "done"
	.byte 0
	rts

fname
	.byte NAME
fnext
	.byte NEXT
fend

z80start

