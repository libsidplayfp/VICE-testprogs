
    * = $0801
    !byte $0c, $08, $00, $00, $9e, $20, $34, $30, $39, $36
    !byte 0,0,0

    * = $1000

    sei
    ldx #0
-
    txa
    sta $0400,x
    sta $d800,x
    lda #$A0
    sta $0500,x
    sta $0600,x
    sta $0700,x
    lda #$00
    sta $d900,x
    sta $da00,x
    sta $db00,x
    inx
    bne -

lp:    
    inc dataadd

    ldx #0
-
    txa
    clc
dataadd = * + 1
    adc #00
    sta $0400,x
    sta $d800,x
    inx
    bne -

    lda $dc01
    cmp #$ef
    beq +
    inc waitline
+
waitline = * + 1
    lda #$00
-   cmp $d012
    bne -

    inc $d020

    ; screen -> REU     $0400 -> $000000

    LDA #>$0400
    STA $03
    LDA #<$0400
    STA $02

    LDA #$00
    STA $04
    STA $05
    STA $06

    LDA #$00
    STA $07
    LDA #$01
    STA $08
    JSR copyC64toREU

    ; REU -> colorram   $000000 -> $d900
    LDA #>$d900
    STA $03
    LDA #<$d900
    STA $02
    JSR copyREUtoC64

;    jmp *

    ; colorram -> REU   $d800 -> $000100

    LDA #>$d800
    STA $03
    LDA #<$d800
    STA $02

    lda #$01
    STA $05
    JSR copyC64toREU

    ; REU -> screen     $000100 -> $0600
    LDA #>$0600
    STA $03
    LDA #<$0600
    STA $02
    JSR copyREUtoC64

    ldy #5
    sty $d020

    ; check $0600

    ldx #0
-
    ldy #5
    txa
    clc
    adc dataadd
    and #$0f
    sta $ff
    lda $0600,x
    and #$0f
    cmp $ff
    beq +
    ldy #10
    sty $d020

+
    tya
    sta $da00,x

    inx
    bne -

    ; check $d900

    ldx #0
-
    ldy #5
    txa
    clc
    adc dataadd
    and #$0f
    sta $ff
    lda $d900,x
    and #$0f
    cmp $ff
    beq +
    ldy #10
    sty $d020

+
    tya
    sta $db00,x

    inx
    bne -

    lda $d020
    and #$0f
    cmp #5
    beq +
    
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

    lda #$00    ; success
    sta $d7ff
+

    jmp lp

copyREUtoC64:                  ; REU -> C64
    LDY #$91
copyC64toREU = * + 1           ; C64 -> REU
    BIT $90A0

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




