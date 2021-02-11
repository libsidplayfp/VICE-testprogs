
;TWOTIMERS=1

resbuffer = $0400
textstart = $0400+(2*40)

    * = $0801
    !byte $0c, $08, $00, $00, $9e, $20, $34, $30, $39, $36
    !byte 0,0,0

    *=$0900
currenttime:
    !byte 0,0,0,0
    !byte 0,0,0,0
timeadd:
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

    lda #$ff
    sta currenttime+0
    lda #$ff
    sta currenttime+1
!if TWOTIMERS = 0 {
    lda #$00
} else {
    lda #$ff
}
    sta currenttime+2
    lda #$00
    sta currenttime+3

    ; timeadd = currenttime
    lda currenttime+0
    sta timeadd+0
    lda currenttime+1
    sta timeadd+1
    lda currenttime+2
    sta timeadd+2
    lda currenttime+3
    sta timeadd+3

    ; timeadd / 2
    lsr timeadd+3
    ror timeadd+2
    ror timeadd+1
    ror timeadd+0

testloop:

    lda #%00010000  ; timer A counts clock, stop
    sta $dc0e
    lda #%01010000  ; timer B counts timer A, stop
    sta $dc0f

    lda currenttime+3
    sta $dc07
    lda currenttime+2
    sta $dc06
    lda currenttime+1
    sta $dc05
    lda currenttime+0
    sta $dc04

    lda $dc0d

    ; write a 0 to the first byte in bank 7
    lda #0
    sta srcbuffer  ; value

    JSR copyC64toREU

    lda #$55
    sta srcbuffer  ; value

!if TWOTIMERS=1 {
    lda #%01010001  ; timer B counts timer A, force load, start
    sta $dc0f
}
    lda #%00010001  ; timer A counts clock, force load,  start
    sta $dc0e

    ; now wait until timer underflows
-
    lda $dc0d
!if TWOTIMERS=1 {
    and #%00000010
} else {
    and #%00000001
}
    beq -

    ; read back the floating value
    JSR copyREUtoC64

    jsr showtimes

rescount=*+1
    ldx #0
    lda srcbuffer
    sta resbuffer,x
 
    bne notzero

    ; still zero, increase the waiting time
    clc
    lda currenttime+0
    adc timeadd+0
    sta currenttime+0
    lda currenttime+1
    adc timeadd+1
    sta currenttime+1
    lda currenttime+2
    adc timeadd+2
    sta currenttime+2
    lda currenttime+3
    adc timeadd+3
    sta currenttime+3

    jmp nexttest
    
notzero:
    ; no more zero, decrease the waiting time

    sec
    lda currenttime+0
    sbc timeadd+0
    sta currenttime+0
    lda currenttime+1
    sbc timeadd+1
    sta currenttime+1
    lda currenttime+2
    sbc timeadd+2
    sta currenttime+2
    lda currenttime+3
    sbc timeadd+3
    sta currenttime+3

nexttest:

    ; timeadd / 2
    lsr timeadd+3
    ror timeadd+2
    ror timeadd+1
    ror timeadd+0

    ; stop if we did enough tests to fill the screen with results
    inc rescount
    lda rescount
    cmp #40+6
    beq testend

    ; make sure timeadd is always at least 1
    lda timeadd+3
    ora timeadd+2
    ora timeadd+1
    ora timeadd+0
    bne +
    inc timeadd+0
+

    jmp testloop

    ; TODO: if we know what to expect, check it here
testend:
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

charout:

charaddr=*+1
    sta textstart
    inc charaddr+0
    bne +
    inc charaddr+1
+
    rts

; print hex value in A
printhex1:
    pha
    lsr
    lsr
    lsr
    lsr
    tax
    lda hextab,x
    jsr charout
    pla
    and #$0f
    tax
    lda hextab,x
    jmp charout

; x: hi a: lo
printhex2:
    pha
    txa
    jsr printhex1
    pla
    jmp printhex1

hextab:
    !scr "0123456789abcdef"
    
showtimes:
    
    ldx timeadd+3
    lda timeadd+2
    jsr printhex2
    ldx timeadd+1
    lda timeadd+0
    jsr printhex2

    lda #$20
    jsr charout

    ldx currenttime+3
    lda currenttime+2
    jsr printhex2
    ldx currenttime+1
    lda currenttime+0
    jsr printhex2

    lda #$20
    jsr charout

    lda #'0'
    ldx srcbuffer
    beq +
    lda #6 ; F
+
    jsr charout

    lda #$20
    jsr charout

    rts
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
    LDA #0
    STA $DF05
    LDA #0
    STA $DF04
    LDA #7
    STA $DF06

    ; length
    LDA #0
    STA $DF08
    LDA #1
    STA $DF07

    LDA #$00
    STA $DF09   ; IMR
    lda #$c0    ; c64 and REU address is fixed
    STA $DF0A   ; ACR
    STY $DF01   ; Command
    RTS
