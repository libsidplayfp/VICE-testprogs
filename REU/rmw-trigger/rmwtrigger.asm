
    * = $0801
    !byte $0c, $08, $00, $00, $9e, $20, $34, $30, $39, $36
    !byte 0,0,0

    * = $1000

    sei
    ldx #0
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

    ldx #39
-
    lda message,x
    sta $0400+(24*40),x
    dex
    bpl -
    
!if KERNALOFF = 0 {
    lda $ff00
    sta ff00compare
}    
    lda #3
    sta $ff00

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
    sta $0400+(0*40)+20
    jsr mkhex
    sta $0400+(0*40)+22
    stx $0400+(0*40)+23
    
    jsr cleario

    ; REU -> I/O     $000000 -> $d000
    LDA #>$d000
    STA $03
    LDA #<$d000
    STA $02
    JSR copyREUtoC64
    sta $0400+(1*40)+20
    jsr mkhex
    sta $0400+(1*40)+22
    stx $0400+(1*40)+23

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
    sta $0400+(2*40)+20
    jsr mkhex
    sta $0400+(2*40)+22
    stx $0400+(2*40)+23

    jsr cleario
    
    ; REU -> I/O      $000100 -> $d000
    LDA #>$d000
    STA $03
    LDA #<$d000
    STA $02
    JSR copyREUtoC64
    sta $0400+(3*40)+20
    jsr mkhex
    sta $0400+(3*40)+22
    stx $0400+(3*40)+23
    

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
    sta $0400+(4*40)+20
    jsr mkhex
    sta $0400+(4*40)+22
    stx $0400+(4*40)+23
    
    lda $df00
    and #$20
    sta $0400+(3*40)
    
    dec $d020

    lda #$20
    sta $0400+(1*40)+17
    sta $0400+(2*40)+17
    sta $0400+(3*40)+17
    
    ; compare the results
    ldy #5
    
    ldx #$10
-
    lda $0400,x
    cmp $0400+(1*40),x
    beq +
    ldy #10
    inc $0400+(1*40)+17
+
    cmp $0400+(2*40),x
    beq +
    ldy #10
    inc $0400+(2*40)+17
+
    dex
    bpl -

    lda $0400+(3*40)        ; verify
    beq +
    ldy #10
    inc $0400+(3*40)+17
+
!if KERNALOFF = 1 {
    lda #1
} else {
ff00compare=*+1
    lda #$dd
}
    cmp $0400+(0*40)+20
    beq +
    ldy #10
    inc $0400+(0*40)+25
+
    cmp $0400+(1*40)+20
    beq +
    ldy #10
    inc $0400+(1*40)+25
+
    cmp $0400+(2*40)+20
    beq +
    ldy #10
    inc $0400+(2*40)+25
+
    cmp $0400+(3*40)+20
    beq +
    ldy #10
    inc $0400+(3*40)+25
+
    cmp $0400+(4*40)+20
    beq +
    ldy #10
    inc $0400+(4*40)+25
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
    LDY #%10000001
    !byte $2c   ; BIT
copyC64toREU:                  ; C64 -> REU
    LDY #%10100000
    !byte $2c   ; BIT
verifyC64toREU:                ; C64 -> REU
    LDY #%10100011

    ; disable the ff00 trigger
    lda #0
    sta $DF01
    
    ; disable kernal
    lda #$35
    sta $01
    
    lda #1
    sta $ff00

    ; enable kernal
    lda #$37
    sta $01
    
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
!if KERNALOFF = 1 {
    ; disable kernal
    ldx #$35
    stx $01
}    
    ; start the transfer with ff00 trigger
    inc $ff00

    ; disable the ff00 trigger
    lda #0
    sta $DF01
    
    ; disable kernal
    ldx #$35
    stx $01

    lda $ff00
    
    ; enable kernal
    ldx #$37
    stx $01
    
    RTS

mkhex:
    pha
    and #$0f
    tay
    lda hextab,y
    tax
    pla
    lsr
    lsr
    lsr
    lsr
    tay
    lda hextab,y
    rts

hextab:
    !scr "0123456789abcdef"

message:    
!if KERNALOFF = 0 {
         ;1234567890123456789012345678901234567890
    !scr "rmw trigger with kernal enabled/rom     "
} else {
         ;1234567890123456789012345678901234567890
    !scr "rmw trigger with kernal disabled/ram    "
}
