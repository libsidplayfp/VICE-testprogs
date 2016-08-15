    * = $0801
    !byte $0c, $08, $00, $00, $9e, $20, $34, $30, $39, $36
    !byte 0,0,0
 
    * = $1000

    sei
    lda #$35
    sta $01

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

    lda #$f8
-
    cmp $d012
    bne -

    lda $dc0d
    lda $dd0d
    inc $d019

    cli

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

        LDA #>$0100
        STA $DF08 ; length hi
        LDA #<$0100
        STA $DF07 ; length lo

        LDA #$80
        STA $DF0A ; addr control  fixed c64 addr

        LDA #$92 ; command     execute, immediately, swap
        STA $DF01


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


        LDA #$00
        STA $DF09 ; interrupt mask
        STA $DF04 ; REU lo
        STA $DF05 ; REU hi
        STA $DF06 ; REU bank
        LDA #>$0450
        STA $DF03 ; c64 hi
        LDA #<$0450
        STA $DF02 ; c64 lo
        LDA #>$0100
        STA $DF08 ; length hi
        LDA #<$0100
        STA $DF07 ; length lo
        LDA #$00
        STA $DF0A ; addr control
        LDA #$91
        STA $DF01 ; command     execute, immediately, REU -> C64

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

    lda #$20
    sta $d012

    inc $d019

    pla
    tay
    pla
    tax
    pla
    rti

expected:
!byte $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26
!byte $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $26, $27
!byte $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27
!byte $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $27, $28
!byte $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28
!byte $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $28, $29, $29
!byte $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29
!byte $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $29, $2a, $2a
!byte $2a, $2a, $2a, $2a, $2a, $2a, $2a, $2a, $2a, $2a, $2a, $2a, $2a, $2a, $2a, $2a
!byte $2a, $2a, $2a, $2a, $2a, $2a, $2a, $2a, $2a, $2a, $2a, $2a, $2a, $2b, $2b, $2b
!byte $2b, $2b, $2b, $2b, $2b, $2b, $2b, $2b, $2b, $2b, $2b, $2b, $2b, $2b, $2b, $2b
!byte $2b, $2b, $2b, $2b, $2b, $2b, $2b, $2b, $2b, $2b, $2b, $2b, $2b, $2c, $2c, $2c
!byte $2c, $2c, $2c, $2c, $2c, $2c, $2c, $2c, $2c, $2c, $2c, $2c, $2c, $2c, $2c, $2c
!byte $2c, $2c, $2c, $2c, $2c, $2c, $2c, $2c, $2c, $2c, $2c, $2c, $2d, $2d, $2d, $2d
!byte $2d, $2d, $2d, $2d, $2d, $2d, $2d, $2d, $2d, $2d, $2d, $2d, $2d, $2d, $2d, $2d
!byte $2d, $2d, $2d, $2d, $2d, $2d, $2d, $2d, $2d, $2d, $2d, $2d, $2e, $2e, $2e, $2e


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


