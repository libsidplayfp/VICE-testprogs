c128detected = $30

            *=$0801
            !word bend
            !word 10
            !byte $9e
            !text "2061", 0
bend:       !word 0

;-------------------------------------------------------------------------------

    * = $080d

    sei
    lda #$37
    sta $01
    lda #$2f
    sta $00
    
    lda #$20
    ldx #0
-
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    inx
    bne -

    ; detect C128 in C64 mode
    ldx #0
    lda #$cc
    sta $d030
    lda $d030
    cmp #$fc
    beq isc128
    ldx #1
isc128:
    stx c128detected
    
    lda c128detected
    bne +
    ; no SID mirrors at d5/d7
    lda #$20
    sta refmask + (1 * 40) + 5
    sta refmask + (1 * 40) + 7
    sta refmask + (2 * 40) + 5
    sta refmask + (2 * 40) + 7
    sta refmask + (2 * 40) + 5 + 20
    sta refmask + (2 * 40) + 7 + 20
    
    ldx #5
-
    lda c128string,x
    sta $0400+(24*40)+34,x
    dex
    bpl -
    
+

loop:    
    lda #$d0
    sta page1+2
    sta page2+2
    sta page3+2
    sta page4+2
    sta page5+2
    sta page6+2
    sta page7+2
    sta page8+2
    sta page9+2
    sta page10+2

    lda #$37
    sta $01
    
    ; write into I/O
    lda #1
    ldx #0
-
page1:
    sta $d001
    inc page1+2
    inx
    cpx #$10
    bne -

    ; read from I/O
    ldx #0
-
page2:
    lda $d001
    sta $0400+(1*40),x
    inc page2+2
    inx
    cpx #$10
    bne -

    lda #$33
    sta $01     ; chargen

    ; write into RAM
    lda #2
    ldx #0
-
page3:
    sta $d001
    inc page3+2
    inx
    cpx #$10
    bne -

    lda #$37
    sta $01     ; I/O

    ; read from I/O
    ldx #0
-
page4:
    lda $d001
    sta $0400+(2*40),x
    inc page4+2
    inx
    cpx #$10
    bne -

    lda #$34
    sta $01     ; RAM

    ; read from RAM
    ldx #0
-
page5:
    lda $d001
    sta $0400+(3*40),x
    inc page5+2
    inx
    cpx #$10
    bne -

    lda #$33
    sta $01     ; chargen

    ; read from chargen
    ldx #0
-
page6:
    lda $d001
    sta $0400+(4*40),x
    inc page6+2
    inx
    cpx #$10
    bne -


    lda #$34
    sta $01     ; RAM

    ; write into RAM
    lda #3
    ldx #0
-
page7:
    sta $d001
    inc page7+2
    inx
    cpx #$10
    bne -

    lda #$37
    sta $01     ; I/O

    ; read from I/O
    ldx #0
-
page8:
    lda $d001
    sta $0400+(2*40)+20,x
    inc page8+2
    inx
    cpx #$10
    bne -

    lda #$34
    sta $01     ; RAM

    ; read from RAM
    ldx #0
-
page9:
    lda $d001
    sta $0400+(3*40)+20,x
    inc page9+2
    inx
    cpx #$10
    bne -

    lda #$33
    sta $01     ; chargen

    ; read from chargen
    ldx #0
-
page10:
    lda $d001
    sta $0400+(4*40)+20,x
    inc page10+2
    inx
    cpx #$10
    bne -

    lda #$37
    sta $01
    
    lda #5
    sta border+1

    ldx #0
-
    ldy #5
    lda refmask,x
    bne +
    lda reference,x
    cmp $0400,x
    beq +
    ldy #2
+
    tya
    sta $d800,x
    cmp #2
    bne +
    sta border+1
+
    inx
    bne -

border:
    lda #0
    sta $d020
    
    ldy #0 ; pass
    cmp #5
    beq +
    ldy #$ff ; fail
+
    sty $d7ff
    
    jmp loop

c128string: !scr "(c128)"
    
reference:
    !binary "reference.bin"

refmask:
          ;1234567890123456789012345678901234567890
    !scr  "                                        "
    !scr  "@@@@@@@@    @@                          "
    !scr  "@@@@@@@@    @@      @@@@@@@@    @@      "
    !scr  "@@@@@@@@@@@@@@@@    @@@@@@@@@@@@@@@@    "
    !scr  "@@@@@@@@@@@@@@@@    @@@@@@@@@@@@@@@@    "
    !scr  "                                        "
    !scr  "                                        "
    
