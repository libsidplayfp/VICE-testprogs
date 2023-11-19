
    * = $0801
    !byte $0c, $08, $00, $00, $9e, $20, $34, $30, $39, $36
    !byte 0,0,0

buffer = $2000

    * = $1000

    sei
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
    sta $d900,x
    sta $da00,x
    sta $db00,x
    inx
    bne -

    ldx #6
-
    lda header,x
    sta $0400+(1*40)+0,x
    dex
    bpl -

    ; get whatever is there
    jsr get0001cpu
    sta $0400+(0*40)+0
    stx $0400+(0*40)+1

    jsr get0001reu
    sta $0400+(0*40)+4
    stx $0400+(0*40)+5

    ; set test pattern
    lda #'1'
    ldx #1
    jsr set0001cpu

    ; get test pattern back
    jsr get0001cpu
    sta $0400+(2*40)+0
    stx $0400+(2*40)+1

    jsr get0001reu
    sta $0400+(2*40)+4
    stx $0400+(2*40)+5

    lda #'3'
    ldx #'4'
    jsr set0001reu

    ; get test pattern back
    jsr get0001cpu
    sta $0400+(3*40)+0
    stx $0400+(3*40)+1

    jsr get0001reu
    sta $0400+(3*40)+4
    stx $0400+(3*40)+5

    ; set test pattern
    lda #'5'
    ldx #'6'
    jsr set0001reu

    ; get test pattern back
    jsr get0001cpu
    sta $0400+(4*40)+0
    stx $0400+(4*40)+1

    jsr get0001reu
    sta $0400+(4*40)+4
    stx $0400+(4*40)+5

    lda #'7'
    ldx #7
    jsr set0001cpu

    ; get test pattern back
    jsr get0001cpu
    sta $0400+(5*40)+0
    stx $0400+(5*40)+1

    jsr get0001reu
    sta $0400+(5*40)+4
    stx $0400+(5*40)+5

    lda #5
    sta border

    ldx #0
-
    ldy #5
    lda $0400+(2*40)+0,x
    cmp expected,x
    beq +
    ldy #10
    sty border
+
    tya
    sta $d800+(2*40)+0,x
    inx
    cpx #40*4
    bne -

    ldy #0      ; success
border=*+1
    lda #0
    sta $d020
    cmp #5
    beq +
    ldy #$ff    ; failure
+
    sty $d7ff

    jmp *

header:
    !scr "cpu reu"

expected:
    ;     1234567890123456789012345678901234567890
    !scr "1g  xx                                  "
    !scr "1g  34                                  "
    !scr "1g  56                                  "
    !scr "7g  xx                                  "
    !scr "                                        "
    !scr "                                        "

;------------------------------------------------------------------------------

get0001cpu:
    lda $00
    ldx $01
    rts

set0001cpu:
    ; NOTE: writing to addresses 0/1 will always write into RAM whatever was on
    ; the bus before, we make sure its the idle byte (and a defined value) here
    ldy #$18 ; 'X'
    sty $3fff
    jsr waitframe
    sta $00
    stx $01
    rts

waitframe:
    pha
    lda $0
    pha
    lda $1
    pha

    lda #$2f
    sta $00
    lda #$35
    sta $01

-   bit $d011
    bpl -
-   bit $d011
    bmi -

    pla
    sta $1
    pla
    sta $0
    pla
    rts

get0001reu:
    ; 0/1 -> REU     $0000 -> $000000
    LDA #>$0000
    STA $03
    LDA #<$0000
    STA $02

    LDA #$00
    STA $04
    STA $05
    STA $06

    LDA #<$0002
    STA $07
    LDA #>$0002
    STA $08
    jsr copyC64toREU

    ; REU -> buffer     $000000 -> buffer
    LDA #>buffer
    STA $03
    LDA #<buffer
    STA $02
    JSR copyREUtoC64

    lda buffer
    ldx buffer+1
    rts

set0001reu:
    sta buffer
    stx buffer+1

    ; buffer -> REU     buffer -> $000000

    LDA #>buffer
    STA $03
    LDA #<buffer
    STA $02

    JSR copyC64toREU

    ; REU -> 0/1      $000000 -> $0000
    LDA #>$0000
    STA $03
    LDA #<$0000
    STA $02
    jmp copyREUtoC64

;----------------------------------------------------------------


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




