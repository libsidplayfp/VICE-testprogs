
zp_temp		= $02
zp_temp2	= $03
zp_temp3	= $fb
zp_temp4	= $fc
zp_temp5	= $fd


	* = $801
	!byte	$b,$8,<1,>1,$9e
	!text "2061"
	!byte 0,0,0

;-------------------------------------------------------------------------------

	ldx #0
-
	lda #$20
	sta $0400,x
	sta $0500,x
	sta $0600,x
	sta $0700,x
	lda #$01
	sta $d800,x
	sta $d900,x
	sta $da00,x
	sta $db00,x
	inx
	bne -
	
	ldx #(testnameend-testname)-1
-
	lda testname,x
	sta $0400+(40*24),x
    dex
	bpl -

	lda	#2     ; sec.addr
	sta	zp_temp

loop

;	ldx	#<fname2
;	ldy	#>fname2
;	lda	#fnameend2-fname2
;	jsr	$ffbd          ; Set Filename

;	lda	zp_temp
;	ldx	#8
;	tay
;	jsr	$ffba          ; Set Logical File Parameters

;	jsr	$ffc0          ; Open

;	ldx	zp_temp
;	jsr	$ffc6          ; Set Input

;	jsr	$ffb7          ; Read I/O Status
;	sta zp_temp3
;	beq	openok
;
;	lda	zp_temp
;	jsr	$ffc3          ; Close
;	jsr	$ffcc          ; Restore I/O
	
	ldx	#<fname
	ldy	#>fname
	lda	#fnameend-fname
	jsr	$ffbd          ; Set Filename

	lda	zp_temp
	ldx	#8
	tay
	jsr	$ffba          ; Set Logical File Parameters

	jsr	$ffc0          ; Open

	ldx	zp_temp
	jsr	$ffc6          ; Set Input

	jsr	$ffb7          ; Read I/O Status
	sta zp_temp3
	bne	red

openok:
	jsr	$ffcf          ; chrin
	sta zp_temp4
	
	jsr	$ffb7          ; Read I/O Status
	sta zp_temp5
	bne	red

	lda zp_temp4
	cmp	#1
	beq	green

	lda	#$7    ; yellow
	sta	zp_temp2
	jmp	done1
green
	lda	#$5    ; green
	sta	zp_temp2
	jmp	done1

red
	lda	#$2    ; red
	sta	zp_temp2

done1

	lda	zp_temp
	jsr	$ffc3          ; Close
	jsr	$ffcc          ; Restore I/O

	ldx	zp_temp
	txa
	sta	$400+(0*40),x
	lda	zp_temp2
	sta	$d800+(0*40),x
	sta	$d800+(1*40),x
	sta	$d800+(2*40),x
	sta	$d800+(3*40),x
	sta	$d800+(4*40),x
	lda	zp_temp2
	sta	$400+(1*40),x
	lda	zp_temp3
	sta	$400+(2*40),x
	lda	zp_temp4
	sta	$400+(3*40),x
	lda	zp_temp5
	sta	$400+(4*40),x
	inx
	stx	zp_temp
	cpx	#15
	bcs +
	jmp loop
+

    ldx #12
-
    lda $d800+(0*40)+2,x
    and #$0f
    cmp #5
    bne failed
    dex
    bpl -

    lda #0
    sta $d7ff
    lda #5
    sta $d020
    
	jmp	*
	
failed:
    lda #$ff
    sta $d7ff
    lda #2
    sta $d020
    jmp *

;-------------------------------------------------------------------------------
fname
	!text "SACHECK.PRG"
fnameend

testname:
    !scr "sa check"
testnameend:
