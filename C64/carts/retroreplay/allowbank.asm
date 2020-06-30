            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0

;-------------------------------------------------------------------------------

    * = $080d

    sei
    
    ldx #0
    stx $d020
    stx $d021
-
    lda #1
    sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $db00,x
    lda #$20
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    inx
    bne -
    
!if BANKING=0 {
    lda #0
} else {
    lda #%00000010  ; enable RAM banking in IO (write once!)
}
    sta $de01

    ; init RAM
    
    lda #'-'

    ldx #10
-
    ldy #%00100011 | %00000000
    sty $de00
    sta $9f00,x
    ldy #%00100011 | %00001000
    sty $de00
    sta $9f00,x
    ldy #%00100011 | %00010000
    sty $de00
    sta $9f00,x
    ldy #%00100011 | %00011000
    sty $de00
    sta $9f00,x
    
    dex
    bpl -
    
    ; write to $df00
    
    lda #%00100000 | %00000000
    sta $de00
    
    ldx #10
-
    lda bank0scr,x
    sta $df00,x
    dex
    bpl -
    
    lda #%00100000 | %00001000
    sta $de00

    ldx #10
-
    lda bank1scr,x
    sta $df00,x
    dex
    bpl -
    
    lda #%00100000 | %00010000
    sta $de00

    ldx #10
-
    lda bank2scr,x
    sta $df00,x
    dex
    bpl -
    
    lda #%00100000 | %00011000
    sta $de00

    ldx #10
-
    lda bank3scr,x
    sta $df00,x
    dex
    bpl -
    
    ; read from 9f00

    lda #%00100000 | %00000000
    sta $de00
    
    ldx #10
-
    lda $9f00,x
    sta $0400+(0*40),x
    dex
    bpl -
    
    lda #%00100000 | %00001000
    sta $de00
    
    ldx #10
-
    lda $9f00,x
    sta $0400+(1*40),x
    dex
    bpl -
    
    lda #%00100000 | %00010000
    sta $de00
    
    ldx #10
-
    lda $9f00,x
    sta $0400+(2*40),x
    dex
    bpl -

    lda #%00100000 | %00011000
    sta $de00
    
    ldx #10
-
    lda $9f00,x
    sta $0400+(3*40),x
    dex
    bpl -

    ; check result
    ldy #13
    ldx #10
-
    lda $0400+(0*40),x
    cmp bank0cmp,x
    beq +
    ldy #10 ; fail
    inc fail
+
    tya
    sta $d800+(0*40),x

    dex
    bpl -
    
    ldy #13
    ldx #10
-
    lda $0400+(1*40),x
    cmp bank1cmp,x
    beq +
    ldy #10 ; fail
    inc fail
+
    tya
    sta $d800+(1*40),x

    dex
    bpl -
    
    ldy #13
    ldx #10
-
    lda $0400+(2*40),x
    cmp bank2cmp,x
    beq +
    ldy #10 ; fail
    inc fail
+
    tya
    sta $d800+(2*40),x

    dex
    bpl -
    
    ldy #13
    ldx #10
-
    lda $0400+(3*40),x
    cmp bank3cmp,x
    beq +
    ldy #10 ; fail
    inc fail
+
    tya
    sta $d800+(3*40),x

    dex
    bpl -
    
    ldy #13
    ldx #0
    
fail=*+1
    lda #0
    beq +
    ldy #10
    ldx #$ff
+
    sty $d020
    stx $d7ff
    jmp *

bank0scr:   !scr "0bank0bank0bank0"    
bank1scr:   !scr "1bank1bank1bank1"    
bank2scr:   !scr "2bank2bank2bank2"    
bank3scr:   !scr "3bank3bank3bank3"    
    
!if BANKING=0 {
bank0cmp:   !scr "3bank3bank3bank3"    
bank1cmp:   !scr "----------------"    
bank2cmp:   !scr "----------------"    
bank3cmp:   !scr "----------------"    
} else {    
bank0cmp:   !scr "0bank0bank0bank0"    
bank1cmp:   !scr "1bank1bank1bank1"    
bank2cmp:   !scr "2bank2bank2bank2"    
bank3cmp:   !scr "3bank3bank3bank3"    
}
