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
    
    ldx #0
-
    lda text,x
    sta $0400,x
    lda #$20
    sta $0500,x
    sta $0600,x
    sta $0700,x
    lda colors,x
    sta $d800,x
    lda #$01
    sta $d900,x
    sta $da00,x
    sta $db00,x
    inx
    bne -
    
    lda #0
    sta $d020
    sta $d021

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
    sta refskip + (1 * 40) + 5
    sta refskip + (1 * 40) + 7
    sta refskip + (2 * 40) + 5
    sta refskip + (2 * 40) + 7
    sta refskip + (2 * 40) + 5 + 20
    sta refskip + (2 * 40) + 7 + 20
    
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

    ;-----------------------------
    
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
    sta $0400+(2*40)+4,x
    inc page2+2
    inx
    cpx #$10
    bne -

    ;-----------------------------
    
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
    sta $0400+(3*40)+4,x
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
    sta $0400+(4*40)+4,x
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
    sta $0400+(5*40)+4,x
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
    sta $0400+(3*40)+24,x
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
    sta $0400+(4*40)+24,x
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
    sta $0400+(5*40)+24,x
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
    lda refskip,x
    bne notest
    lda $0400+(2*40),x
    and refmask,x
    cmp reference,x
    beq +
    ldy #2
+
    tya
    sta $d800+(2*40),x
    cmp #2
    bne +
    sta border+1
+
notest:
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
;    !binary "reference.bin"
;!byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
!byte $20, $20, $20, $20, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $FF, $FF, $FF, $FF, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
!byte $20, $20, $20, $20, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $FF, $FF, $FF, $FF, $20, $20, $20, $20, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $FF, $FF, $FF, $FF
!byte $20, $20, $20, $20, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $20, $20, $20, $20, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03
!byte $20, $20, $20, $20, $66, $00, $00, $00, $99, $FF, $FF, $FF, $66, $00, $00, $00, $99, $FF, $FF, $FF, $20, $20, $20, $20, $66, $00, $00, $00, $99, $FF, $FF, $FF, $66, $00, $00, $00, $99, $FF, $FF, $FF
!byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
!byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20

refskip:
          ;1234567890123456789012345678901234567890
          ;    0123456789abcdef    0123456789abcdef
;    !scr  "                                        "
    !scr  "    @@@@    @@@@@@                      "
    !scr  "    @@@@    @@@@@@      @@@@    @@@@@@  "
    !scr  "    @@@@@@@@@@@@@@@@    @@@@@@@@@@@@@@@@"
    !scr  "    @@@@@@@@@@@@@@@@    @@@@@@@@@@@@@@@@"
    !scr  "                                        "
    !scr  "                                        "

refmask:    
!byte $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $0f, $0f, $0f, $0f, $ff, $ff, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
!byte $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $0f, $0f, $0f, $0f, $ff, $ff, $00, $00, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $0f, $0f, $0f, $0f, $ff, $ff, $00, $00
!byte $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
!byte $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $00, $00, $00, $00, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
!byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
!byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    

text:
          ;1234567890123456789012345678901234567890
          ;    0123456789abcdef    0123456789abcdef
    !scr  "                                        "
    !scr  "    0123456789abcdef    0123456789abcdef"
    !scr  "3737@@@@@@@@@@@@@@                      "
    !scr  "3337@@@@@@@@@@@@@@  3437@@@@@@@@@@@@@@  "
    !scr  "  34@@@@@@@@@@@@@@@@  34@@@@@@@@@@@@@@@@"
    !scr  "  33@@@@@@@@@@@@@@@@  33@@@@@@@@@@@@@@@@"
    !scr  "                                        "
    
colors:
          ;1234567890123456789012345678901234567890
          ;    0123456789abcdef    0123456789abcdef
    !scr  "                                        "
    !scr  "    aaaaaaaaaaaaaaaa    aaaaaaaaaaaaaaaa"
    !scr  "oollkkkkkkkkkkkkkkkkoollkkkkkkkkkkkkkkkk"
    !scr  "oollkkkkkkkkkkkkkkkkoollkkkkkkkkkkkkkkkk"
    !scr  "oollkkkkkkkkkkkkkkkkoollkkkkkkkkkkkkkkkk"
    !scr  "oollkkkkkkkkkkkkkkkkoollkkkkkkkkkkkkkkkk"
    !scr  "                                        "
    
