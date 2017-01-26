
;-----------------------------------------------------------------------------

    !ct scr

    * = $0801

    ; BASIC stub: "1 SYS 2061"
    !by $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00

;-----------------------------------------------------------------------------

start:

    sei
;    lda #$35
;    sta $01

    lda #7
    sta $d020
    lda #1
    sta $d021

    jmp main

    * = $0980
sprite:
          ;12345678  90123456  78901234
    !byte %00000000,%00111110,%00000000
    !byte %00000000,%00001000,%00000000
    !byte %00000000,%00001000,%00000000
    !byte %00000000,%00001000,%00000000
    !byte %00000000,%00001000,%00000000
    !byte %00000000,%00001000,%00000000
    !byte %00000000,%00001000,%00000000
    !byte %00000000,%00001000,%00000000
    !byte %00100000,%00001000,%00000010
    !byte %00100000,%00001000,%00000010
    !byte %00111111,%11111111,%11111110
    !byte %00100000,%00001000,%00000010
    !byte %00100000,%00001000,%00000010
    !byte %00000000,%00001000,%00000000
    !byte %00000000,%00001000,%00000000
    !byte %00000000,%00001000,%00000000
    !byte %00000000,%00001000,%00000000
    !byte %00000000,%00001000,%00000000
    !byte %00000000,%00001000,%00000000
    !byte %00000000,%00001000,%00000000
    !byte %00000000,%00111110,%00000000
    
;-----------------------------------------------------------------------------

printscreen:
    ldx #0
lp:
    lda screen,x
    sta $0400,x
    lda screen+$0100,x
    sta $0500,x
    lda screen+$0200,x
    sta $0600,x
    lda screen+$02e8,x
    sta $06e8,x
    lda #3
    sta $d800,x
    sta $d900,x
    sta $da00,x
    sta $dae8,x
    inx
    bne lp
    rts

printbits:
    sta hlp+1
    stx hlp2+1
    sty hlp2+2

    ldy #0

bitlp:
hlp:
    lda #0
    asl hlp+1
    bcc skp1
    lda #'.'
    jmp skp2
skp1:
    lda #'*'
skp2:
hlp2:
    sta $dead,y
    iny
    cpy #8
    bne bitlp

    rts

ptr = $02

printhex:
    stx ptr
    sty ptr+1
    ldy #1
    pha
    and #$0f
    tax
    lda hextab,x
    sta (ptr),y
    dey
    pla
    lsr
    lsr
    lsr
    lsr
    tax
    lda hextab,x
    sta (ptr),y
    rts
    
;-----------------------------------------------------------------------------

main:

    jsr printscreen

    lda #1<<4
    sta $3fff
    ; First make sure the normal screen is shown.

    bit $d011
    bpl *-3
    bit $d011
    bmi *-3
    lda #$1b
    sta $d011
    
loop:

    lda $d013
    sta adc1val
    
    ldx #<($0400+(40*4)+1)
    ldy #>($0400+(40*4)+1)
    jsr printhex

    lda $d014
    sta adc2val
    
    ldx #<($0400+(40*4)+7)
    ldy #>($0400+(40*4)+7)
    jsr printhex

    lda $d419 ; adc 1
    ldx #<($0400+(40*7)+1)
    ldy #>($0400+(40*7)+1)
    jsr printhex
    
    lda $d41a ; adc 2
    ldx #<($0400+(40*7)+7)
    ldy #>($0400+(40*7)+7)
    jsr printhex
    
    ; setup CIA1 to read joystick #1, port A -> port b
    lda #%11111111
    sta $dc02 ; port a ddr (all output)
    lda #%00000000
    sta $dc03 ; port b ddr (all input)
    lda #%11000000
    sta $dc00 ; port a data

    ; joy port 1
    lda $dc01 ; port b data
    ldx #<($0400+(40*4)+14)
    ldy #>($0400+(40*4)+14)
    jsr printbits

    lda #1
    sta $d015
    lda #3
    sta $d027
    lda #sprite / 64
    sta $07f8

    ; at the left border of the text screen the value in the latch is $18,
    ; ie 48 "pixels". so to get the crosshair in place we must substract
    ; 24 + xoffs
    lda adc1val
    sec
    sbc #24 + 16
    asl
    sta $d000
    adc #0
    sta $d010

    ; the value in the latch is the active rasterline, so to get the crosshair
    ; in place we must substract 1 (because sprite starts 1 line later) + yoffs
    lda adc2val
    sec
    sbc #10 + 1
    sta $d001

    ; For each frame, set screen-mode to 24 lines at y-position $f9 - $fa..

    lda #$f9
    cmp $d012
    bne *-3
    lda $d011
    and #$f7
    sta $d011

    ; .. and below y-position $fc, set it back to 25 lines.
    bit $d011
    bpl *-3
    ora #8
    sta $d011    
    
    jmp loop

;-----------------------------------------------------------------------------

adc1val:
    !by 0,0
adc2val:
    !by 0,0

hextab:
    !scr "0123456789abcdef"

screen:
         ;0123456789012345678901234567890123456789
    !scr "                                        "
    !scr " lightpen/gun coordinates test          " ;0
    !scr "                                        " ;1
    !scr " xpos  ypos   port1                     " ;2
    !scr " 00    00     ........                  " ;3
    !scr "                 43210                  " ;4
    !scr " adc1  adc2                             " ;5
    !scr " 00    00                               "
    !scr "                                        "
    !scr " 4  joy fire                mouse left  "
    !scr " 3  joy right paddle 2 fire             "
    !scr " 2  joy left  paddle 1 fire             "
    !scr " 1  joy down                            "
    !scr " 0  joy up                  mouse right "
    !scr "                                        "
    !scr " this will currently work only with     "
    !scr " lightguns. remember coordinates will   "
    !scr " actually be slightly off!              "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "

    
