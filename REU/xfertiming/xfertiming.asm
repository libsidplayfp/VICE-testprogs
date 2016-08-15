;buffer = $1000
xferlen = 63 * 8

    * = $0801
    !byte $0c, $08, $00, $00, $9e, $20, $34, $30, $39, $36
    !byte 0,0,0

    * = $1000

    sei
    lda #$35
    sta $01

        LDA #$00
        STA $DF09 ; interrupt mask
        STA $DF04 ; REU lo
        STA $DF05 ; REU hi
        STA $DF06 ; REU bank
        LDA #>buffer
        STA $DF03 ; c64 hi
        LDA #<buffer
        STA $DF02 ; c64 lo
!if TYPE = 1 {
        LDA #>xferlen
        STA $DF08 ; length hi
        LDA #<xferlen
        STA $DF07 ; length lo
}
!if TYPE = 2 {
        LDA #>(xferlen / 2)
        STA $DF08 ; length hi
        LDA #<(xferlen / 2)
        STA $DF07 ; length lo
}
        LDA #$00
        STA $DF0A ; addr control  normal
        LDA #$B0
        STA $DF01 ; command     execute, autoload, immediately, C64 -> REU

    lda #$01
    sta $d01a
    lda #$7f
    sta $dc0d
    lda #$1b
    sta $d011
    lda #$10
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
    sta $0428,x
    lda cols,x
    sta $d800,x
    sta $d828,x
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


tmp = $f0

        !align 255,0

irq:
    pha
    txa
    pha
    tya
    pha

    lda $d013
    sta tmp
    lda $d014
    sta tmp+1

    jsr rastersync_lp

    ldx #6
-
    dex
    bne -
    nop
    nop

    lda #0
    ldx #10
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

!if TYPE = 1 {
    ldx #20
-
    dex
    bne -
}
!if TYPE = 2 {
    ldx #19
-
    dex
    bne -
    bit $ea
}

        LDA #>$d020
        STA $DF03 ; c64 hi
        LDA #<$d020
        STA $DF02 ; c64 lo
        LDA #$80
        STA $DF0A ; addr control  fixed c64 addr
!if TYPE = 1 {
        LDA #$B1        ; REU -> C64
}
!if TYPE = 2 {
        LDA #$B2        ; swap
}
        STA $DF01 ; command     execute, autoload, immediately, type

    ldx #24
-
    dex
    bne -

!if TYPE = 1 {
    bit $ea
}
!if TYPE = 2 {
    bit $ea
    nop
}
    lda #0
    ldx #5
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

!if TYPE = 2 {
        LDA #$00
        STA $DF09 ; interrupt mask
        STA $DF04 ; REU lo
        STA $DF05 ; REU hi
        STA $DF06 ; REU bank
        LDA #>buffer
        STA $DF03 ; c64 hi
        LDA #<buffer
        STA $DF02 ; c64 lo
        LDA #>(xferlen / 2)
        STA $DF08 ; length hi
        LDA #<(xferlen / 2)
        STA $DF07 ; length lo
        LDA #$00
        STA $DF0A ; addr control  normal
        LDA #$B0
        STA $DF01 ; command     execute, autoload, immediately, C64 -> REU
}
    inc $d019




    pla
    tay
    pla
    tax
    pla
    rti

buffer:

!if TYPE = 1 {
    !for i, 10 {
        !byte 0,0,0,0,0,0,0
        !byte 1,1,1,1,1,1
        !byte 2,2,2,2,2,2
        !byte 0, 0,1,2,3,4,5
        !byte 6,7,8,9,10,11
        !byte 12,13,14,15,0
        !byte 6,6,6,6,6,6
        !byte 7,7,7,7,7,7
        !byte 0,0,0,0,0,0,0,0,0,0,0,0,0,0
    }
}

!if TYPE = 2 {
    !for i, 10 {
        !byte 0,0,0,0
        !byte 1,1,1
        !byte 2,2,2
        !byte 0, 1,2,3,4,5
        !byte 6,7,8
        !byte 6,6,6
        !byte 7,7,7
        !byte 0,0,0,0,0,0,0

        !byte 0,0,0,0
        !byte 1,1,1
        !byte 2,2,2
        !byte 0, 1,2,3,4,5
        !byte 6,7,8
        !byte 6,6,6
        !byte 7,7,7
        !byte 0,0,0,0,0,0

    }
}
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


