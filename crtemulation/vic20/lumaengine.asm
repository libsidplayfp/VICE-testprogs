

    * = $1800

    jmp start

colortable:
    !byte $08,$68,$28,$48,$88,$58,$38,$98,$a8,$c8,$e8,$78,$b8,$d8,$f8,$18
    !byte $08

start:
    sei

lp:

!if NTSC = 1 {
    ldy #33
} else {
    ldy #38+(2*4)
}

    ldx #0
--
    tya
-   cmp $9004
    bne -
    lda colortable,x
!if NTSC = 1 {
    bit $eaea
    bit $eaea
    bit $eaea
    bit $eaea
    nop
}
    sta $900f

    tya
    clc
    adc #4
    tay

    inx
    cpx #16+1
    bne --

    jmp lp

linetable:
    !byte $00,$10,$20,$30,$40,$50,$60,$70
    !byte $80,$90,$a0,$b0,$c0,$d0,$e0,$f0

