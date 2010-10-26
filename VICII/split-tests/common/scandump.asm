;**************************************************************************
;*
;* FILE  scandump.asm
;* Copyright (c) 2010 Daniel Kahlin <daniel@kahlin.net>
;* Written by Daniel Kahlin <daniel@kahlin.net>
;*
;* DESCRIPTION
;*   Common code for scanning tests providing a data-dump.
;*
;******
	processor 6502


;**************************************************************************
;*
;* NAME  test_prepare
;*
;* DESCRIPTION
;*   Update hex byte on the current line.
;*
;******
update_hex:
	pha
	lsr
	lsr
	lsr
	lsr
	jsr	uh_common
	pla
	and	#$0f
uh_common:
	tax
	lda	htab,x
	sta	($d1),y
	iny
	rts

htab:
	dc.b	"0123456789",1,2,3,4,5,6


;**************************************************************************
;*
;* NAME  save_file
;*
;* DESCRIPTION
;*   Save dump file.
;*
;******
sa_zp	equ	$fb

save_file:
; set device num to 8 if less than 8.
	lda	#8
	cmp	$ba
	bcc	sf_skp1
	sta	$ba
sf_skp1:

	lda	#<save_to_disk_msg
	ldy	#>save_to_disk_msg
	jsr	$ab1e
sf_lp1:
	jsr	$ffe4
	cmp	#"N"
	beq	sf_ex1
	cmp	#"Y"
	bne	sf_lp1

sf_lp3:
	if	0
	lda	#<filename_msg
	ldy	#>filename_msg
	jsr	$ab1e
	lda	$d3
	pha
	lda	#<nam
	ldy	#>nam
	jsr	$ab1e
	pla
	sta	$d3
sf_lp4:
	jsr	$ffcf
	cmp	#13
	bne	sf_lp4
	endif
	
	lda	#$80
	sta	$9d
	lda	#1
	ldx	$ba
	tay
	jsr	$ffba
	ldx	#<filename
	ldy	#>filename
	lda	#FILENAME_LEN
	jsr	$ffbd
	ldx	#<BUFFER
	ldy	#>BUFFER
	stx	sa_zp
	sty	sa_zp+1
	lda	#sa_zp
	ldx	#<BUFFER_END
	ldy	#>BUFFER_END
	jsr	$ffd8

	lda	#<ok_msg
	ldy	#>ok_msg
	jsr	$ab1e

	lda	#<again_msg
	ldy	#>again_msg
	jsr	$ab1e
	jmp	sf_lp1
sf_ex1:
	lda	#<ok_msg
	ldy	#>ok_msg
	jsr	$ab1e
	rts

save_to_disk_msg:
	dc.b	13,13,"SAVE TO DISK? ",0
again_msg:
	dc.b	13,"SAVE AGAIN? ",0
filename_msg:
	dc.b	13,"FILENAME: ",0
ok_msg:
	dc.b	13,"OK",13,0

; eof
