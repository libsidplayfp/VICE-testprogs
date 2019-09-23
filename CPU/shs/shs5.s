
testline  =$90 ; must have low nybble of 4, and be after $38
spriteline=$90-19

res_sp =$0407
res_mem=$042f
res_cc =$0457
ref_sp =$0407+160
ref_mem=$042f+160
ref_cc =$0457+160


	*= $0801
	!byte $0b,$08,$0a,$00,$9e,$32,$30,$36,$31,0,0,0

    ; clear screen to green on black
	lda #5
	sta $d021
	jsr $e536
    lda#0
    sta $d021
    ldx#200
cpp:
    lda screen-1,x
    sta $0400 -1,x
    lda screen+79,x
    sta $0400 +79,x
    dex
    bne cpp
    lda #$16
    sta $d018

    ; deactivate CIA interrupt
	lda #$7f 
	sta $dc0d 

    ; turn on sprites 2 and 3, placing them on on testline
    lda#$0c
    sta $d015
    lda #spriteline
    sta $d001+2*2
    sta $d001+3*2

    lda#$ff
    sta $dd04
    sta $dd05

    bit $d011
    bpl *-3
    bit $d011
    bmi *-3



lp:
    lda counter
    and#31
    ; the lower this value is, the earlier the insruction is executed
    sta counter
    eor#31
    sta bp+1
    lda#$0f
    sta $3fff

    ldx#0
    txs
    stx $0614 ; ensure we detect if target address is not written to by SHS


    lda#testline
    cmp$d012
    bne *-3      ; wait for the first raster the sprites are on
    nop
    nop
    nop
    ldy#$18+(testline&7)
    lda#$11
    sty $d011  ; force DMA to stabilise
    sta $dd0e ; restart timer S

    ldy#$18+((testline+2)&7)
    sty $d011 

    ldy#$8f
    lda#$ee
    ldx#$77
bp:
    bne *+4
    !fill 55,$80
    !byte $04,$ea  ; nop zp
    !byte $9b,$85,$0e   ; SP = A & X,   {addr},y = SP & {H+1} 

    ldy counter
    lda#91+ 48+48
    nop
    sec
    sbc counter
    sec
    sbc $dd04
    sta res_cc,y
    cmp ref_cc,y
    beq pass_cc
    lda#2
    sta res_cc+$d400,y
    inc errcount
pass_cc:

    lda $0614
    sta res_mem,y
    cmp ref_mem,y
    beq pass_mem
    lda#2
    sta res_mem+$d400,y
    inc errcount
pass_mem:

    tsx
    txa
    sta res_sp,y
    cmp ref_sp,y
    beq pass_sp
    lda#2
    sta res_sp+$d400,y
    inc errcount
pass_sp:

    inc $d021
    !fill 4,$ea
    dec $d021
    lda#$1b
    sta $d011

    dec counter
    bpl jlp
    lda errcount
    bne error
    lda #13 ; green
    sta $d020
    lda #$00
    sta $d7ff
jlp:
    jmp lp

error::
    lda #10 ; red
    sta $d020
    lda #$ff
    sta $d7ff
    jmp *

counter:
    !byte 31
errcount:
    !byte 0

screen:
    !ct scr
    !tx "    sp:"
    !fill 33,32
    !tx "   mem:"
    !fill 33,32
    !tx "cycles:"
    !fill 33,32

    !fill 40,32

    !tx " ideal:"
    !fill 32,$66
    !byte 32

    !tx "       "
    !fill 11,$06
    !byte    $66
    !fill  8,$06
    !byte    $66
    !fill 11,$06
    !byte 32

    !tx "       "
    !fill 10,$35
    !byte    $34
    !fill  8,$35
    !byte    $34
    !fill 12,$35
    !byte 32

escreen:
