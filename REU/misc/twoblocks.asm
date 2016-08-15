
testpattern = $0400+(16*40)
testpattern2 = $0400+(17*40)
testpattern3 = $0400+(18*40)
testpattern4 = $0400+(19*40)
testpattern5 = $0400+(20*40)
testpattern6 = $0400+(21*40)
testpattern7 = $0400+(22*40)
testpattern8 = $0400+(23*40)
testpattern9 = $0400+(24*40)

    * = $0801
    !byte $0c, $08, $00, $00, $9e, $20, $34, $30, $39, $36
    !byte 0,0,0

    * = $1000
lp:

    sei
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
    sta $0a00,x
    sta $0b00,x
    inx
    bne -

    ldx #2
-
    lda #12
    sta $d800,x
    sta $d801,x
    sta $d800+(200),x
    sta $d801+(200),x
    sta $d800+(340),x
    sta $d801+(340),x
    txa
    clc
    adc #4
    tax
    bcc -
    
    ldx #0
-
    txa
    sta testpattern,x
    sta testpattern5,x
    sta testpattern6,x
    sta testpattern7,x
    sta testpattern8,x
    sta testpattern9,x
    sta testpattern5+$10,x
    ora #$80
    sta testpattern+$10,x
    sta testpattern6+$10,x
    sta testpattern7+$10,x
    sta testpattern8+$10,x
    sta testpattern9+$10,x
    inx
    cpx #$10
    bne -

    lda #$30
    sta testpattern6+$1f
    sta testpattern7+$1e
    sta testpattern8+$1d
    sta testpattern9+$1c

    ldx #0
-
    txa
    sta testpattern3+$10,x
    ora #$80
    sta testpattern3,x
    inx
    cpx #$10
    bne -

    ldx #$30
    stx testpattern+$20
    inx
    stx testpattern2+$20
    inx
    stx testpattern3+$20
    inx
    stx testpattern4+$20
    inx
    stx testpattern5+$20
    inx
    stx testpattern6+$20
    inx
    stx testpattern7+$20
    inx
    stx testpattern8+$20
    inx
    stx testpattern9+$20
    
    lda #$ff
-   cmp $d012
    bne -

    inc $d020

    ; c64 -> reu
    lda #<testpattern
    ldx #>testpattern
    jsr reu_setc64addr
    lda #0
    tax
    tay
    jsr reu_setreuaddr
    lda #<$10
    ldx #>$10
    jsr reu_setlen
    jsr c642reu

    lda #<($0400 + (40 * 0))
    ldx #>($0400 + (40 * 0))
    jsr printregs

    ; c64 -> reu
    lda #<(testpattern+$10)
    ldx #>(testpattern+$10)
    jsr reu_setc64addr
    lda #<$10
    ldx #>$10
    jsr reu_setlen
    jsr c642reu

    lda #<($0400 + (40 * 1))
    ldx #>($0400 + (40 * 1))
    jsr printregs
    
    ; reu -> c64
    lda #<testpattern2
    ldx #>testpattern2
    jsr reu_setc64addr
    lda #0
    tax
    tay
    jsr reu_setreuaddr
    lda #<$20
    ldx #>$20
    jsr reu_setlen
    jsr reu2c64

    lda #<($0400 + (40 * 2))
    ldx #>($0400 + (40 * 2))
    jsr printregs

;    jsr waitspace
    
    ; swap
    lda #<testpattern3
    ldx #>testpattern3
    jsr reu_setc64addr
    lda #0
    tax
    tay
    jsr reu_setreuaddr
    lda #<$20
    ldx #>$20
    jsr reu_setlen
    jsr swap

    lda #<($0400 + (40 * 3))
    ldx #>($0400 + (40 * 3))
    jsr printregs

;    jsr waitspace
    
    ; swap
    lda #<testpattern4
    ldx #>testpattern4
    jsr reu_setc64addr
    lda #0
    tax
    tay
    jsr reu_setreuaddr
    lda #<$20
    ldx #>$20
    jsr reu_setlen
    jsr swap

    lda #<($0400 + (40 * 4))
    ldx #>($0400 + (40 * 4))
    jsr printregs

    !if (INTERACTIVE = 1) {
    jsr waitspace
    }
    
    ; c64 -> reu
    lda #<testpattern
    ldx #>testpattern
    jsr reu_setc64addr
    lda #0
    tax
    tay
    jsr reu_setreuaddr
    lda #<$20
    ldx #>$20
    jsr reu_setlen
    jsr c642reu

    lda #<($0400 + (40 * 5))
    ldx #>($0400 + (40 * 5))
    jsr printregs

    ; verify
    lda #<testpattern
    ldx #>testpattern
    jsr reu_setc64addr
    lda #0
    tax
    tay
    jsr reu_setreuaddr
    lda #<$20
    ldx #>$20
    jsr reu_setlen
    jsr verify

    lda #<($0400 + (40 * 6))
    ldx #>($0400 + (40 * 6))
    jsr printregs

    ; verify
    lda #<testpattern5
    ldx #>testpattern5
    jsr reu_setc64addr
    lda #0
    tax
    tay
    jsr reu_setreuaddr
    lda #<$20
    ldx #>$20
    jsr reu_setlen
    jsr verify

    lda #<($0400 + (40 * 7))
    ldx #>($0400 + (40 * 7))
    jsr printregs

    ; verify
    lda #<testpattern6
    ldx #>testpattern6
    jsr reu_setc64addr
    lda #0
    tax
    tay
    jsr reu_setreuaddr
    lda #<$20
    ldx #>$20
    jsr reu_setlen
    jsr verify

    lda #<($0400 + (40 * 8))
    ldx #>($0400 + (40 * 8))
    jsr printregs

    ; verify
    lda #<testpattern7
    ldx #>testpattern7
    jsr reu_setc64addr
    lda #0
    tax
    tay
    jsr reu_setreuaddr
    lda #<$20
    ldx #>$20
    jsr reu_setlen
    jsr verify

    lda #<($0400 + (40 * 9))
    ldx #>($0400 + (40 * 9))
    jsr printregs

    ; verify
    lda #<testpattern8
    ldx #>testpattern8
    jsr reu_setc64addr
    lda #0
    tax
    tay
    jsr reu_setreuaddr
    lda #<$20
    ldx #>$20
    jsr reu_setlen
    jsr verify

    lda #<($0400 + (40 * 10))
    ldx #>($0400 + (40 * 10))
    jsr printregs

    ; verify
    lda #<testpattern9
    ldx #>testpattern9
    jsr reu_setc64addr
    lda #0
    tax
    tay
    jsr reu_setreuaddr
    lda #<$20
    ldx #>$20
    jsr reu_setlen
    jsr verify

    lda #<($0400 + (40 * 11))
    ldx #>($0400 + (40 * 11))
    jsr printregs

    dec $d020

    jsr checkscreen
    
    ldy #0      ; success
    lda $d020
    and #$0f
    cmp #5
    beq +
    ldy #$ff    ; failure
+
    sty $d7ff
    
    !if (INTERACTIVE = 1) {
    jsr waitspace
    
    jmp lp
    } else {
    jmp *
    }

reu_setc64addr:
    STX $DF03 ; c64 addr
    STA $DF02 ; c64 addr
    rts

reu_setreuaddr
    sty $df06
    stx $df05
    sta $df04
    rts

reu_setlen
    stx $df08
    sta $df07
    rts

!if USEFF00 = 0 {
reu2c64:
    LDY #$91
c642reu = * + 1
    BIT $90A0
swap = * + 1
    BIT $92A0
verify = * + 1
    BIT $93A0
}
!if USEFF00 = 1 {
reu2c64:
    LDY #$81
c642reu = * + 1
    BIT $80A0
swap = * + 1
    BIT $82A0
verify = * + 1
    BIT $83A0
}
    LDA #$00
    STA $DF09 ; imr
    STA $DF0A ; acr
    STY $DF01 ; ctrl
!if USEFF00 = 1 {
    sta $ff00
}
    RTS
    
printregs:
    sta $02
    stx $03

    ldy #0
    ldx #0
-
    txa
    pha
    
    lda $df00,x
    pha
    lsr
    lsr
    lsr
    lsr
    tax
    lda hex,x
    sta ($02),y
    iny
    pla
    and #$0f
    tax
    lda hex,x
    sta ($02),y
    iny

    pla
    tax
;    iny
    inx
    cpx #$10
    bne -
    rts

waitspace:
-
    lda $dc01
    cmp #$ef
    beq -

    ldx #0
-   dex
    bne -
-
    lda $dc01
    cmp #$ef
    bne -
    rts
    
hex: !scr "0123456789abcdef"

checkscreen:
    lda #5
    sta $d020

    ldx #0
-
    lda $0400,x
    cmp expected,x
    beq +
    lda #10
    sta $d800,x
    sta $d020
+
    lda $0500,x
    cmp expected+$100,x
    beq +
    lda #10
    sta $d900,x
    sta $d020
+
    lda $0600-(4*40),x
    cmp expected+$200-(4*40),x
    beq +
    lda #10
    sta $da00-(4*40),x
    sta $d020
;    sta $0600-(4*40),x
+
    inx
    bne -

    rts

expected:
       ;1234567890123456789012345678901234567890
  !scr "501090061000f801001f3fffffffffff        "
  !scr "5010a0062000f801001f3fffffffffff        "
  !scr "5011c8062000f801001f3fffffffffff        "
  !scr "5012f0062000f801001f3fffffffffff        "
  !scr "501218072000f801001f3fffffffffff        "
  !scr "5010a0062000f801001f3fffffffffff        "
  !scr "5013a0062000f801001f3fffffffffff        "
  !scr "301331071100f80f001f3fffffffffff        "
  !scr "701368072000f801001f3fffffffffff        "
  !scr "70138f071f00f801001f3fffffffffff        "
  !scr "3013b6071e00f802001f3fffffffffff        "
  !scr "3013dd071d00f803001f3fffffffffff        "
  !scr "                                        "
  !scr "                                        "
  !scr "                                        "
  !scr "                                        "
