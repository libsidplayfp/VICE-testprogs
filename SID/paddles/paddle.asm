
;-----------------------------------------------------------------------------

    !ct scr

    * = $0801

    ; BASIC stub: "1 SYS 2061"
    !by $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00

;-----------------------------------------------------------------------------

start:

    sei
    lda #$35
    sta $01

    lda #6
    sta $d020
    sta $d021

    jmp main

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
    lda #1
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

loop:

    lda testnum
    asl
    asl
    asl
    tax
    ldy #0
ploop:
    lda ports,x
    sta $0400+(40*6)+10,y
    inx
    iny
    cpy #8
    bne ploop


    ; setup CIA1 to read paddle, port A -> port b
    lda #%11111111
    sta $dc02 ; port a ddr (all output)
    lda #%00000000
    sta $dc03 ; port b ddr (all input)
    ldx testnum
    lda testval,x
    sta $dc00 ; port a data

    lda $d419 ; adc 1
    sta adc1val
    ldx #<($0400+(40*3)+0)
    ldy #>($0400+(40*3)+0)
    jsr printhex

    lda adc1val
    sec
    sbc adc1val+1
    bcs adcskp1
    eor #$ff
    clc
    adc #1
adcskp1:
    ldx #<($0400+(40*3)+3)
    ldy #>($0400+(40*3)+3)
    jsr printhex

    lda adc1val
    sta adc1val+1

    lda $d41a ; adc 2
    sta adc2val
    ldx #<($0400+(40*3)+6)
    ldy #>($0400+(40*3)+6)
    jsr printhex
    lda adc2val
    sec
    sbc adc2val+1
    bcs adcskp2
    eor #$ff
    clc
    adc #1
adcskp2:
    ldx #<($0400+(40*3)+9)
    ldy #>($0400+(40*3)+9)
    jsr printhex

    lda adc2val
    sta adc2val+1

    ; setup CIA1 to read joystick #1, port A -> port b
    lda #%11111111
    sta $dc02 ; port a ddr (all output)
    lda #%00000000
    sta $dc03 ; port b ddr (all input)
    ldx testnum
    lda testval,x
    and #%11000000
    sta $dc00 ; port a data

    ; joy port 1
    lda $dc01 ; port b data
    ldx #<($0400+(40*3)+13)
    ldy #>($0400+(40*3)+13)
    jsr printbits

    ; setup CIA1 to read joystick #1, port B -> port A

    lda #%11100000
    sta $dc02 ; port a ddr (all input)
    lda #%00011111
    sta $dc03 ; port b ddr (all output)
    lda #$00
    sta $dc01 ; port b data

    ; joy port 2
    lda $dc00 ; port a data
    ldx #<($0400+(40*3)+22)
    ldy #>($0400+(40*3)+22)
    jsr printbits

    ; setup CIA1 to read keyboard, port A -> port b
    lda #%11111111
    sta $dc02 ; port a ddr (all output)
    lda #%00000000
    sta $dc03 ; port b ddr (all input)
    ldx testnum
    lda testval,x
    and #%11111110
    sta $dc00 ; port a data (all active)

    ; check return
    lda $dc01 ; port b data
    and #$02
    cmp #$02
    beq nokey
wait:
    lda $dc01 ; port b data
    and #$02
    cmp #$02
    bne wait

    ; select next test
    ldx testnum
    inx
    txa
    and #3
    sta testnum

nokey:

    jmp loop

;-----------------------------------------------------------------------------

testnum:
    !by 1

adc1val:
    !by 0,0
adc2val:
    !by 0,0

testval:
    !byte %00111111, %01111111, %10111111, %11111111

hextab:
    !scr "0123456789abcdef"

ports:
    !scr "none    "
    !scr "port 1  "
    !scr "port 2  "
    !scr "both    "

screen:
         ;0123456789012345678901234567890123456789
    !scr "simple paddle / sid adc test            " ;0
    !scr "                                        " ;1
    !scr "adc#1 adc#2  port1    port2             " ;2
    !scr "00    00     ........ ........          " ;3
    !scr "                43210    43210          " ;4
    !scr "                                        " ;5
    !scr "selected: ........ (return to change)   " ;6
    !scr "                                        "
    !scr "4  joy fire                mouse left   "
    !scr "3  joy right paddle 2 fire              "
    !scr "2  joy left  paddle 1 fire              "
    !scr "1  joy down                             "
    !scr "0  joy up                  mouse right  "
    !scr "                                        "
    !scr "use standard paddles or 1351 mouse.     "
    !scr "                                        "
    !scr "for details look at the readme.         "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
