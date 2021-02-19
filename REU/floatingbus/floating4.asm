
resbuffer = $0400
textstart = $0400+(2*40)

    * = $0801
    !byte $0c, $08, $00, $00, $9e, $20, $34, $30, $39, $36
    !byte 0,0,0

    *=$0900
currentaddr:
    !byte 0,0,0,0
    !byte 0,0,0,0
srcbuffer:
    !byte 0,0,0,0
    !byte 0,0,0,0

    * = $1000

    sei
    
    lda #$7f
    sta $dc0d
    lda $dc0d

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
    sta $d900,x
    sta $db00,x
    inx
    bne -

testloop:

!if INITRAM=1 {
    lda #2
    sta xferlen

    ldx #0
-
    lda #$00
    sta currentaddr+0
    sta currentaddr+1
    txa
    sta currentaddr+2

    clc
    adc #$80
    sta srcbuffer  ; value
    clc
    adc #1
    sta srcbuffer+1  ; value

    JSR copyC64toREU

    inx
    bne -

    lda #1
    sta xferlen
}

-   bit $d011
    bmi -
-   bit $d011
    bpl -

    inc $d020

    ; write a 0 to the first byte in bank 7
    lda #0
    sta srcbuffer  ; value

    lda #$00
    sta currentaddr+0
    sta currentaddr+1
    lda #$07
    sta currentaddr+2

    JSR copyC64toREU

    lda #$55
    sta srcbuffer  ; value

    ldy #0
--
    tya
    pha

    ldx #0
-
    lda #$00
    sta currentaddr+0
    sta currentaddr+1
!if INCBANK=1 {
    txa
} else {
    lda #$00
}
    sta currentaddr+2

    JSR copyREUtoC64

    inx
validreads=*+1
    cpx #1
    bne -
    
    pla
    tay
    iny
validreadsh=*+1
    cpy #1
    bne --

    lda #$aa
    sta srcbuffer  ; value

    ; read back the floating value
    lda #$00
    sta currentaddr+0
    sta currentaddr+1
    lda #$07
    sta currentaddr+2

    JSR copyREUtoC64

    dec $d020

;    jsr showtimes

rescount=*+1
    ldx #0
    lda srcbuffer
rescounth=*+2
    sta resbuffer,x
    
nexttest:

    ; stop if we did enough tests to fill the screen with results
    inc rescount
    bne +
    inc rescounth
+
    lda rescounth
    cmp #(>resbuffer)+4
    beq testend

    inc validreads
    bne +
    inc validreadsh
+

    jmp testloop

    ; TODO: if we know what to expect, check it here
testend:

    ldx #4
--
    txa
    pha

    ldx #0
-
    ldy #13 ; green
chkaddr1=*+2
    lda $0400,x
chkaddr2=*+2
    cmp refdata,x
    beq +
    ldy #10 ; red
    sty fail
+
    tya
chkaddr3=*+2
    sta $d800,x
    inx
    bne -

    inc chkaddr1
    inc chkaddr2
    inc chkaddr3
    
    pla
    tax
    dex
    bne --


fail=*+1
    lda #13
    sta $d020

    ldy #0
    cmp #10 ; red
    bne +
    ldy #$ff
+
    sty $d7ff
    jmp *

;------------------------------------------------------------------------------

copyREUtoC64:                  ; REU -> C64
    LDY #$b1    ; enable autoload
copyC64toREU = * + 1           ; C64 -> REU
    BIT $b0A0   ; enable autoload

    ; C64 addr
    LDA #>srcbuffer
    STA $DF03
    LDA #<srcbuffer
    STA $DF02

    ; REU addr
    LDA currentaddr+0
    STA $DF05
    LDA currentaddr+1
    STA $DF04
    LDA currentaddr+2
    STA $DF06

    ; length
    LDA #0
    STA $DF08
xferlen=*+1
    LDA #1
    STA $DF07

    LDA #$00
    STA $DF09   ; IMR
    lda #$c0    ; c64 and REU address is fixed
    STA $DF0A   ; ACR
    STY $DF01   ; Command
    RTS

;------------------------------------------------------------------------------
    !align 255,0
refdata:
!if (INCBANK = 0) & (INITRAM = 0) {
    !for i, 0, $400 / 8 {
        !byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
    }
}
!if (INCBANK = 1) & (INITRAM = 0) {
    !for i, 0, $400 / 8 {
        !byte $ff, $ff, $00, $00, $00, $00, $00, $00
    }
}
!if (INCBANK = 0) & (INITRAM = 1) {
    !for i, 0, $400 / 8 {
        !byte $78, $78, $78, $78, $78, $78, $78, $78
    }
}
!if (INCBANK = 1) & (INITRAM = 1) {
    !for i, 0, $400 / 8 {
        !byte $78, $79, $7a, $7b, $7b, $7b, $7b, $7b
    }
}
