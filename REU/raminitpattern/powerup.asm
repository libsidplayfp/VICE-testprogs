
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
    sta $da00,x
    lda #$0c
    sta $d900,x
    sta $db00,x
    inx
    bne -

lp:
    ; copy one page
    LDA #$00
    STA $07
    LDA #$01
    STA $08

    ; REU -> screen     $000000 -> $0400 (+0k)
    LDA #>$0400
    STA $03
    LDA #<$0400
    STA $02

    LDA #$00
    STA $04
    STA $05
    STA $06
    JSR copyREUtoC64

    ; REU -> screen     $020000 -> $0500 (+128k)
    LDA #>$0500
    STA $03
    LDA #<$0500
    STA $02

    LDA #$00
    STA $04
    STA $05
    LDA #$02
    STA $06
    JSR copyREUtoC64

    ; REU -> screen     $040000 -> $0600 (+256k)
    LDA #>$0600
    STA $03
    LDA #<$0600
    STA $02

    LDA #$00
    STA $04
    STA $05
    LDA #$04
    STA $06
    JSR copyREUtoC64

    ; REU -> screen     $080000 -> $0700 (+512k)
    LDA #>$0700
    STA $03
    LDA #<$0700
    STA $02

    LDA #$00
    STA $04
    STA $05
    LDA #$08
    STA $06
    JSR copyREUtoC64

    jmp lp

;------------------------------------------------------------------------------

copyREUtoC64:                  ; REU -> C64
    LDY #$91
copyC64toREU = * + 1           ; C64 -> REU
    BIT $90A0

    ; C64 addr
    LDA $03
    STA $DF03
    LDA $02
    STA $DF02

    ; REU addr
    LDA $05
    STA $DF05
    LDA $04
    STA $DF04
    LDA $06
    STA $DF06

    ; length
    LDA $08
    STA $DF08
    LDA $07
    STA $DF07

    LDA #$00
    STA $DF09   ; IMR
    STA $DF0A   ; ACR
    STY $DF01   ; Command
    RTS




