;**************************************************************************
;*
;* FILE  banking00.asm
;* Copyright (c) 2010 Daniel Kahlin <daniel@kahlin.net>
;* Written by Daniel Kahlin <daniel@kahlin.net>
;*
;* DESCRIPTION
;*
;******
	processor 6502

	seg.u	zp
;**************************************************************************
;*
;* SECTION  zero page
;*
;******
	org	$02
chk0_zp:
	ds.b	1
chk1_zp:
	ds.b	1
chk2_zp:
	ds.b	1
chk3_zp:
	ds.b	1

count_zp:
pass_zp:
	ds.b	4
ram2io_fail_zp:
	ds.b	4
io2ram_fail_zp:
	ds.b	4
COUNT_LEN	equ	.-count_zp

x_zp:
	ds.b	1
y_zp:
	ds.b	1
	
	seg	code
	org	$0801
;**************************************************************************
;*
;* Basic line!
;*
;******
StartOfFile:
	dc.w	EndLine
	dc.w	0
	dc.b	$9e,"2069 /T.L.R/",0
;	        0 SYS2069 /T.L.R/
EndLine:
	dc.w	0

;**************************************************************************
;*
;* SysAddress... When run we will enter here!
;*
;******
SysAddress:
	sei
	lda	#$7f
	sta	$dc0d
	lda	$dc0d

	jsr	test_present
	
	sei
	lda	#<nmi_entry
	sta	$fffa
	lda	#>nmi_entry
	sta	$fffb
	
	jsr	test_prepare
	
	jsr	test_perform
	jmp	$a474

nmi_entry:
	sei
	lda	#$37
	sta	$01
	jmp	$fe66


;**************************************************************************
;*
;* NAME  test_present
;*   
;******
test_present:
	lda	#14
	sta	646
	sta	$d020
	lda	#6
	sta	$d021

	lda	#<greet_msg
	ldy	#>greet_msg
	jsr	$ab1e
	lda	#<greet2_msg
	ldy	#>greet2_msg
	jsr	$ab1e

	lda	646
	ldx	#0
tpr_lp1:
	sta	$d800,x
	sta	$d900,x
	sta	$da00,x
	sta	$dae8,x
	inx
	bne	tpr_lp1
	
	rts

greet_msg:
	dc.b	147,"BANKING00 R01 / TLR",13,13
	dc.b	"VERIFY THAT 00=2F/01=34 -> 00=2E IS",13
	dc.b	"EQUIVALENT TO 01=34 -> 01=35.",13,13
	dc.b	"THIS IS DONE BY EXECUTING CODE AT D000",13
	dc.b	"MOVING BETWEEN RAM AND I/O.",13,13
	dc.b	"WILL DETECT GLITCHES IN THE TWO CYCLES",13
	dc.b	"IMMEDIATELY FOLLOWING THE CHANGE OF 00",13,13,13,13
	dc.b	0
	
greet2_msg:
	dc.b	"RUNNING CONTINUOUSLY...",13,13,13,13
	dc.b	"         PASSED        00000000",13
	dc.b	"         RAM->IO FAILS 00000000",13
	dc.b	"         IO->RAM FAILS 00000000",13
	dc.b	0

	
;**************************************************************************
;*
;* NAME  test_prepare
;*   
;******
test_prepare:
	sei
	lda	#$35
	sta	$01
	lda	#$2f
	sta	$00

	ldx	#DUT_RAM_LEN
tp_lp1:
	lda	dut_ram_st-1,x
	dec	$01
	sta	dut_ram-1,x
	inc	$01
	lda	dut_io_st-1,x
	sta	dut_io-1,x
	dex
	bne	tp_lp1

	ldx	#COUNT_LEN
	lda	#0
tp_lp2:
	sta	count_zp-1,x
	dex
	bne	tp_lp2

	rts


dut_ram_st:
	rorg	$d000
dut_ram:
; $01 = $34, under I/O
	dec	$00
; effective $01 = $35
	inc	chk0_zp
	inc	$00
; effective $01 = $34
	inc	chk1_zp
	rts
	rend
DUT_RAM_LEN	equ	.-dut_ram_st

dut_io_st:
	rorg	$d000
dut_io:
; $01 = $34, under I/O
	dec	$00
; effective $01 = $35
	lsr	chk2_zp
	inc	$00
; effective $01 = $34
	lsr	chk3_zp
	rts
	rend
DUT_IO_LEN	equ	.-dut_io_st


	
;**************************************************************************
;*
;* NAME  test_perform
;*   
;******
test_perform:
	jsr	do_test
	jmp	test_perform


	rts


chk_init:
	dc.b	$11,   $22,    $33,    $44
chk_ref:
	dc.b	$11,   $22+1,  $33>>1, $44
chk_flag:
	dc.b	$01,   $02,    $01,    $02

do_test:

	ldx	#4
dt_lp1:
	lda	chk_init-1,x
	sta	chk0_zp-1,x
	dex
	bne	dt_lp1

	lda	#$34
	sta	$01
	
	jsr	dut_ram

	lda	#$35
	sta	$01

	ldy	#0
	ldx	#4
dt_lp2:
	lda	chk_ref-1,x
	cmp	chk0_zp-1,x
	beq	dt_skp1
	tya
	ora	chk_flag-1,x
	tay
dt_skp1:
	dex
	bne	dt_lp2

	
	lda	$d020
	and	#8
	eor	#8
	cpy	#0
	bne	dt_skp2
	ora	#5
	dc.b	$2c
dt_skp2:
	ora	#2
	sta	$d020


	tya
	bne	dt_skp3
	jsr	update_passed

	jmp	dt_ex1
	
dt_skp3:
	lsr
	bcc	dt_skp4
	jsr	update_ram2io_fail
dt_skp4:
	lsr
	bcc	dt_ex1
	jsr	update_io2ram_fail
dt_ex1:
	rts

;**************************************************************************
;*
;* NAME  test_prepare
;*
;* DESCRIPTION
;*   Update counter.
;*
;******
update_passed:

    ; for automatic testing, exit with OK after $ff passed tests
testcount:
    lda #$ff
    bne notyet
    lda #$00
    sta $d7ff
notyet:
    dec testcount+1

	ldx	#pass_zp
	ldy	#40*0
	jmp	update_common

update_ram2io_fail:

    ; for automatic testing
    lda #$ff
    sta $d7ff

	ldx	#ram2io_fail_zp
	ldy	#40*1
	jmp	update_common

update_io2ram_fail:

    ; for automatic testing
    lda #$ff
    sta $d7ff

	ldx	#io2ram_fail_zp
	ldy	#40*2
	jmp	update_common

update_common:
	pha
	stx	x_zp
	sty	y_zp
	jsr	update_counter
	ldx	x_zp
	ldy	y_zp
	inx
	inx
	inx
	jsr	update_hex
	jsr	update_hex
	jsr	update_hex
	jsr	update_hex
	pla
	rts
	
update_counter:
 	ldy	#4
uc_lp1:
	inc	$00,x
	bne	uc_ex1
	inx
	dey
	bne	uc_lp1
	lda	#$ff
	ldy	#4
uc_lp2:
	dex
	sta	$00,x
	dey
	bne	uc_lp2
uc_ex1:
	rts
	
update_hex:
	lda	$00,x
	dex
	stx	x_zp
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
	sta	$0400+40*17+23,y
	iny
	ldx	x_zp
	rts

htab:
	dc.b	"0123456789",1,2,3,4,5,6
	
end:
; eof
