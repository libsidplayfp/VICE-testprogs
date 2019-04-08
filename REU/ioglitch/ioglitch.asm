
    * = $0801
    !byte $0c, $08, $00, $00, $9e, $20, $34, $30, $39, $36
    !byte 0,0,0

    * = $1000

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
    sta $da00,x
    sta $db00,x
    inx
    bne -

lp:    

    lda $dc01
    cmp #$ef
    beq +
    inc waitline
+
waitline = * + 1
    lda #$00
-   cmp $d012
    bne -

    inc dataadd

    ldx #$10
-
    txa
    clc
dataadd = * + 1
    adc #00
    
    ;txa
    sta $0400,x
    sta $d000,x
    dex
    bpl -

    inc $d020

    ; I/O -> REU     $d000 -> $000000

    LDA #>$d000
    STA $03
    LDA #<$d000
    STA $02

    LDA #$00
    STA $04
    STA $05
    STA $06

    LDA #<$0011
    STA $07
    LDA #>$0011
    STA $08
    JSR copyC64toREU
    
    jsr cleario

    ; REU -> I/O     $000000 -> $d000
    LDA #>$d000
    STA $03
    LDA #<$d000
    STA $02
    JSR copyREUtoC64

    ldx #$10
-
    lda $d000,x
    sta $0400+(1*40),x
    dex
    bpl -

    ; I/O -> REU     $d000 -> $000100

    LDA #>$d000
    STA $03
    LDA #<$d000
    STA $02

    lda #$01
    STA $05
    JSR copyC64toREU

    jsr cleario
    
    ; REU -> I/O      $000100 -> $d000
    LDA #>$d000
    STA $03
    LDA #<$d000
    STA $02
    JSR copyREUtoC64

    ldx #$10
-
    lda $d000,x
    sta $0400+(2*40),x
    dex
    bpl -

    ; REU <-> I/O      $000100 <-> $d000
    LDA #>$d000
    STA $03
    LDA #<$d000
    STA $02
    JSR verifyC64toREU
    
    lda $df00
    and #$20
    sta $0400+(3*40)
    
    dec $d020

    
    ; compare the results
    ldy #5
    
    ldx #$10
-
    lda $0400,x
    cmp $0400+(1*40),x
    beq +
    ldy #10
+
    cmp $0400+(2*40),x
    beq +
    ldy #10
+
    dex
    bpl -

    lda $0400+(3*40)        ; verify
    beq +
    ldy #10
+

    ; test result and exit if "green" or failure
    cpy #5
    beq +

    sty $d020
    
    lda #$ff    ; failure
    sta $d7ff
-
    lda $dc01
    cmp #$ef
    bne -
    
    jmp lp
+
    
    lda waitline
    bne +
    
    dec waitframes
    bne +

    sty $d020

    lda #$00    ; success
    sta $d7ff
+

    jmp lp

waitframes: !byte 10
    
;---------------------------------------

cleario:
    lda dataadd
    ldx #$10
-
    sta $d000,x
    dex
    bpl -
    rts
    
copyREUtoC64:                  ; REU -> C64
    LDY #$91
copyC64toREU = * + 1           ; C64 -> REU
    BIT $90A0
verifyC64toREU = * + 1         ; C64 -> REU
    BIT $90A3

    LDA $03
    STA $DF03
    LDA $02
    STA $DF02

    LDA $05
    STA $DF05
    LDA $04
    STA $DF04
    LDA $06
    STA $DF06

    LDA $08
    STA $DF08
    LDA $07
    STA $DF07

    LDA #$00
    STA $DF09
    STA $DF0A
    STY $DF01
    RTS




