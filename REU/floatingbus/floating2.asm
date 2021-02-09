srcbuffer   = $0427

result = $10

    * = $0801
    !byte $0c, $08, $00, $00, $9e, $20, $34, $30, $39, $36
    !byte 0,0,0

    * = $1000

    sei
    lda #1
    sta $0286
    lda #$93
    jsr $ffd2

    ldx #0
    stx $d020
    stx $d021
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

testloop:
    ; reset and cascade timers
    lda #$ff
    sta $dc04
    sta $dc05
    sta $dc06
    sta $dc07

    lda #%00010000  ; timer A counts clock, stop
    sta $dc0e
    lda #%01010000  ; timer B counts timer A, stop
    sta $dc0f

    lda #$ff
    sta $dc04
    sta $dc05
    sta $dc06
    sta $dc07

    ; write a 0 to the first byte in bank 7
    LDA #<$0001
    STA $07
    LDA #>$0001
    STA $08

    LDA #>srcbuffer
    STA $03
    LDA #<srcbuffer
    STA $02

    LDA #$00
    STA $04
    STA $05

    lda #7
    STA $06        ; bank

    lda #0
    sta srcbuffer  ; value

    lda #%01010001  ; timer B counts timer A, start
    sta $dc0f
    lda #%00010001  ; timer A counts clock, start
    sta $dc0e

    JSR copyC64toREU

    ; repeatedly read back the floating value
    ldy #$b1
    STY $DF01   ; Command

    ldx #$00
-
    lda srcbuffer
    cmp #$ff
    beq endtest
    sta $0500,x

    STY $DF01   ; Command

    inx
    jmp -

endtest:

    ; stop timers
    lda #0
    sta $dc0e
    sta $dc0f
    
    lda $dc04
    eor #$ff
    tax
    lda $dc05   ; hi
    eor #$ff
    jsr $bdcd

    lda #$20
    jsr $ffd2
    
    lda $dc06
    eor #$ff
    tax
    lda $dc07   ; hi
    eor #$ff
    jsr $bdcd

    lda #$20
    jsr $ffd2

    lda #19
    jsr $ffd2

fail=*+1
    lda #13
    sta $d020

    ldy #0
    cmp #10 ; red
    bne +
    ldy #$ff
+
    sty $d7ff
    
    
-   lda $dc01
    cmp #$ef
    beq -
    
    jmp testloop

;------------------------------------------------------------------------------

copyREUtoC64:                  ; REU -> C64
    LDY #$b1    ; enable autoload
copyC64toREU = * + 1           ; C64 -> REU
    BIT $b0A0   ; enable autoload

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
    lda #$c0    ; c64 and REU address is fixed
    STA $DF0A   ; ACR
    STY $DF01   ; Command
    RTS




