    * = $0801
    !byte $0c, $08, $00, $00, $9e, $20, $34, $30, $39, $36
    !byte 0,0,0

    * = $1000


!if TYPE = 2 {
        LDA #$00
        STA $DF09 ; interrupt mask
        STA $DF04 ; REU lo
        STA $DF05 ; REU hi
        STA $DF06 ; REU bank
        LDA #>expected
        STA $DF03 ; c64 hi
        LDA #<expected
        STA $DF02 ; c64 lo
        LDA #>$0100
        STA $DF08 ; length hi
        LDA #<$0100
        STA $DF07 ; length lo
        LDA #$00
        STA $DF0A ; addr control  normal
        LDA #$B0
        STA $DF01 ; command     execute, autoload, immediately, C64 -> REU
}

    sei
    lda #$35
    sta $01

    lda #$f8
-
    cmp $d012
    bne -

    lda #$01
    sta $d01a
    lda #$7f
    sta $dc0d
    lda #$1b
    sta $d011
    lda #$20
    sta $d012
    lda #>irq
    sta $ffff
    lda #<irq
    sta $fffe

    lda $dc0d
    lda $dd0d
    inc $d019

    cli

    lda #0
    sta $d020
    sta $d021

    ldx #0
-
    lda #$20
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $06e8,x
    lda #$1
    sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $dae8,x
    inx
    bne -

    ldx #0
-
    lda #$a0
    sta $0400,x
    lda cols,x
    sta $d800,x
    inx
    cpx #40
    bne -

-:
    nop         ; 2
    bit $ea     ; 3
    bit $eaea   ; 4

    lda ($ff),y ; 5+1
    lda ($ff,x) ; 6

;    inc $06e8,x ; 7

    inx
    iny

    jmp -

cols:
    !byte 1,1,1,1,1,1
    !byte 2,2,2,2,2,2
    !byte 3,3,3,3,3,3
    !byte 4,4,4,4,4,4
    !byte 5,5,5,5,5,5
    !byte 6,6,6,6,6,6
    !byte 7,7,7,7,7,7

        !align 255,0

irq:
    pha
    txa
    pha
    tya
    pha

    jsr rastersync_lp

    ldx #6
-
    dex
    bne -

    lda #0
    sta $d020

    ldx #2
-
    inc $d020
    inc $d020
    inc $d020
    inc $d020
    inc $d020
    inc $d020
    inc $d020
    inc $d020
    inc $d020
    sta $d020
    dex
    bne -


        LDA #$00
        STA $DF09 ; interrupt mask
        STA $DF04 ; REU lo
        STA $DF05 ; REU hi
        STA $DF06 ; REU bank

        LDA #>$d012
        STA $DF03 ; c64 hi
        LDA #<$d012
        STA $DF02 ; c64 lo

        LDA #>$0080
        STA $DF08 ; length hi
        LDA #<$0080
        STA $DF07 ; length lo

        LDA #$80
        STA $DF0A ; addr control  fixed c64 addr

!if TYPE = 1 {
        LDA #$90 ; command     execute, immediately, C64 -> REU
        STA $DF01
}
!if TYPE = 2 {
        LDA #$93 ; command     execute, immediately, compare
        STA $DF01

        lda $DF00 ; status
        sta $0450+0
        lda $DF04 ; REU lo
        sta $0450+1
        lda $DF05 ; REU hi
        sta $0450+2
}


        LDA #>$dc04
        STA $DF03 ; c64 hi
        LDA #<$dc04
        STA $DF02 ; c64 lo

        LDA #>$0080
        STA $DF08 ; length hi
        LDA #<$0080
        STA $DF07 ; length lo

        LDA #$80
        STA $DF0A ; addr control  fixed c64 addr

!if TYPE = 1 {

        lda #$10
        sta $dc0e
        lda #$80 + 4
        sta $dc05
        sta $dc04

        LDA #$90 ; command     execute, immediately, C64 -> REU
        ldx #$01
        stx $dc0e
        STA $DF01

        LDA #$00
        STA $DF09 ; interrupt mask
        STA $DF04 ; REU lo
        STA $DF05 ; REU hi
        STA $DF06 ; REU bank
b1:     LDA #>$0450
        STA $DF03 ; c64 hi
b2:     LDA #<$0450
        STA $DF02 ; c64 lo
        LDA #>$0100
        STA $DF08 ; length hi
        LDA #<$0100
        STA $DF07 ; length lo
        LDA #$00
        STA $DF0A ; addr control
        LDA #$91
        STA $DF01 ; command     execute, immediately, REU -> C64

        bit $eaea
        bit $eaea
        bit $eaea
        nop

}
!if TYPE = 2 {

        lda #$10
        sta $dc0e
        lda #$80 + 4
        sta $dc05
        sta $dc04

        LDA #$93 ; command     execute, immediately, compare
        ldx #$01
        stx $dc0e
        STA $DF01

        lda $DF00 ; status
        sta $0478+0
        lda $DF04 ; REU lo
        sta $0478+1
        lda $DF05 ; REU hi
        sta $0478+2

        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        nop
        nop

}


    lda #0
    inc $d020
    inc $d020
    inc $d020
    inc $d020
    inc $d020
    inc $d020
    inc $d020
    inc $d020
    inc $d020
    sta $d020

!if TYPE = 1 {
    ldx #0
-
    ldy #5
    lda $0450,x
    cmp expected,x
    beq +
    ldy #10
+
    tya
    sta $d850,x
    inx
    bne -
}
!if TYPE = 2 {
    ldy #10

    lda $0450+0
    and #$e0
    cmp #%01000000
    bne +
    lda $0478+0
    and #$e0
    cmp #%01000000
    bne +

    lda $0450+1
    cmp #$80
    bne +
    lda $0478+1
    cmp #$00
    bne +

    lda $0450+2
    cmp #$00
    bne +
    lda $0478+2
    cmp #$01
    bne +

    ldy #5
+
    sty $d020
}
    inc $d019

    pla
    tay
    pla
    tax
    pla
    rti

expected:
!byte $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26
!byte $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26
!byte $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26
!byte $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $27, $27
!byte $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27
!byte $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27
!byte $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27
!byte $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $28, $28, $28

!byte $81, $80, $7f, $7e, $7d, $7c, $7b, $7a, $79, $78, $77, $76, $75, $74, $73, $72
!byte $71, $70, $6f, $6e, $6d, $6c, $6b, $6a, $69, $68, $67, $66, $65, $64, $63, $62
!byte $61, $60, $5f, $5e, $5d, $5c, $5b, $5a, $59, $58, $57, $56, $55, $54, $53, $52
!byte $51, $50, $4f, $4e, $4d, $4c, $4b, $4a, $49, $48, $47, $46, $45, $44, $43, $42
!byte $41, $40, $3f, $3e, $3d, $3c, $3b, $3a, $39, $38, $37, $36, $35, $34, $33, $32
!byte $31, $30, $2f, $2e, $2d, $2c, $2b, $2a, $29, $28, $27, $26, $25, $24, $23, $22
!byte $21, $20, $1f, $1e, $1d, $1c, $1b, $1a, $19, $18, $17, $16, $15, $14, $13, $12
!byte $11, $10, $0f, $0e, $0d, $0c, $0b, $0a, $09, $08, $07, $06, $05, $04, $03, $02


        !align 255,0

; the lightpen is usually connected to pin 6 of joystick port 1, which is the
; same as used for fire on a regular joystick (and space on the keybpard)
; this line is then directly connected to both the cia (bit 4 of cia1 port B)
; and the lightpen input of the vic, which means that the lightpen line of the
; vic can be artificially written to by toggling said cia port bit.

rastersync_lp:

         ; acknowledge vic irq
;         lda $d019
;         sta $d019

         ldx #$ff
         ldy #$00
         ; prepare cia ports
         stx $dc00     ; port A = $ff (inactive)
         sty $dc02     ; ddr A = $00  (all input)
         stx $dc03     ; ddr B = $ff  (all output)
         stx $dc01     ; port B = $ff (inactive)
         ; now trigger the lp latch
         sty $dc01     ; port B = $00 (active)
         stx $dc01     ; port B = $ff (inactive)
         lda $d013     ; get x-position (pixels, divided by two)
         ; restore cia setup
         stx $dc02     ; ddr A = $ff  (all output)
         sty $dc03     ; ddr B = $00  (all input)
         stx $dc01     ; port B = $ff (inactive)
         ldx #$7f
         stx $dc00     ; port A = $7f

         ; divide x-pos by 4 to get x-position in cycles (0..62)
         lsr
         lsr
         ; delay 62 - n cycles
         lsr
         sta timeout+1
         bcc timing   ; 2, +1 extra cycle if even
timing:  clv
timeout: bvc timeout
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop
         nop

         rts


