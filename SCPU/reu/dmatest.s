
        .MACPACK cbm
        .word basicstub         ; load address

da=$0400+52

basicstub:
        .byte $0b,$08,$0a,$00,$9e,$32,$30,$36,$31,0,0,0

    sei
    ldx#119
:
    lda#32
    sta $0400,x
    lda#7
    sta $d800,x
    dex
    bne :-

    jsr tx
    jsr rx

    ldx#15
:   lda da,x
    cmp sd,x
    bne fail
    dex
    bpl :-

    lda #5   ; green
    ldy #0   ; pass
    jmp store
fail:
    lda #2   ; red
    ldy #$ff ; fail
store:
    sta $d020
    sty $d7ff
    cli
    rts

tx:
    lda #<sd        ; C64 addr
    sta $df02
    lda #>sd
    sta $df03
    lda #$01        ; REU addr  $006001
    sta $df04
    lda #$60
    sta $df05
    lda #$00 
    sta $df06
    nop
    lda #$10        ; len $0010
    sta $df07
    nop
    lda #$00
    sta $df08
    lda #$90        ; execute C64->REU
    sta $df01
    rts
rx:
    lda #<da        ; C64 addr
    sta $df02
    lda #>da
    sta $df03
    lda #$01        ; REU addr  $006001
    sta $df04
    lda #$60
    sta $df05
    lda #$00
    sta $df06
    nop
    lda #$10        ; len $0010
    sta $df07
    nop
    lda #$00
    sta $df08
    lda #$91        ; execute REU->C64
    sta $df01
    rts
sd:
    scrcode "ANIMALS IN A ZOO"
