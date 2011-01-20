
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
    lda #'1'
    jmp skp2
skp1:
    lda #'0'
skp2:
hlp2:
    sta $dead,y
    iny
    cpy #8
    bne bitlp

    rts

ptr = $f8

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

; b3c8 - detect mouse
detect:
;.C:b3c8   08         PHP
;.C:b3c9   78         SEI
                    LDA #$40
                    JSR checkport
                    BNE savemask40  ; found port 1

                    LDA #$80
                    JSR checkport
                    BNE savemaskC0  ; found port 2  <- BUG? wrong mask, should be 80
detectlp:

; setup CIA1 (port A -> port b)
                    LDX #$FF
                    STX $DC00  ; port a data = %11111111
; these two are odd
                    LDA $DC01  ; port b data
                    AND #$0F
                    BEQ deskp1
                    CMP #$0F
                    BNE savemask00 ; if (port b & $0f) is not 0 or $0f
deskp1:

                    LDA $DC00  ; port a data (output!)
                    AND #$1F
                    BEQ deskp2
                    CMP #$1F
                    BNE savemask80 ; if (port a & $1f) is not 0 or $1f
deskp2:

; setup CIA1 (port A -> port b)
                    LDX #$00
                    STX $DC03  ; port b ddr  = %00000000
                    DEX
                    STX $DC02  ; port a ddr  = %11111111
                    DEX
                    STX $DC00  ; port a data = %11111110
; check keyboard
                    LDX $DC01  ; port b data
                    CPX #$EF    ; f1
                    BEQ savemask00
                    CPX #$BF    ; f5
                    BEQ savemask00
                    CPX #$F7    ; f7
                    BEQ savemask00
                    CPX #$DF    ; f3
                    BNE detectlp   ; try again

savemask00:
                    LDA #$00
                    BEQ savemask ; save mask
savemask80:
                    LDA #$80
                    BNE savemask ; save mask
; <- found mouse port 1
savemask40:
                    LDA #$40
                    BNE savemask ; save mask
; <- found mouse port 2
savemaskC0:
                    LDA #$C0
savemask:
                    STA portmask
; make mask for keyboard scanner probably
;.C:b424   A5 BD      LDA $BD
;.C:b426   29 3F      AND #$3F
;.C:b428   0D 1B C0   ORA portmask
;.C:b42b   85 BD      STA $BD
; setup CIA1 (port A -> port b)
                    LDX #$00
;.C:b42f   8E 0E DC   STX $DC0E
;.C:b432   86 C6      STX $C6
                    STX $DC03 ; port b ddr  = %00000000
                    DEX
                    STX $DC02 ; port a ddr  = %11111111
                    STX $DC00 ; port a data = %11111111
                    STX $DC01 ; port b data = %11111111
; some delay
                    LDY #$04
dlp1:
                    DEX
                    BNE dlp1
                    DEY
                    BNE dlp1
; get potx/poty
                    LDX $D419
                    LDY $D41A
;.C:b44f   8E D3 03   STX $03D3
;.C:b452   8C D4 03   STY $03D4
;.C:b455   28         PLP
                    RTS

; b457 - test for $ff in potx/poty with given selected ports
checkport:
                    STA $DC00 ; port a data
; some delay
                    LDY #$04
                    LDX #$00
dlp2:
                    DEX
                    BNE dlp2
                    DEY
                    BNE dlp2
; get potx/poty
                    LDX $D419
                    LDY $D41A
; set N if both are $ff
                    CPX #$FF
                    BNE dskp2
                    CPY #$FF
dskp2:
                    RTS
; $C01B
portmask:
    !by 0

;-----------------------------------------------------------------------------

main:

    jsr printscreen

loop:
    jsr detect
    stx adc1val
    sty adc2val

    lda adc1val
    ldx #<($0400+(40*3)+0)
    ldy #>($0400+(40*3)+0)
    jsr printhex

    lda adc2val
    ldx #<($0400+(40*3)+6)
    ldy #>($0400+(40*3)+6)
    jsr printhex

    lda portmask
    ldx #<($0400+(40*3)+13)
    ldy #>($0400+(40*3)+13)
    jsr printbits

    jmp loop

;-----------------------------------------------------------------------------

adc1val:
    !by 0
adc2val:
    !by 0

hextab:
    !scr "0123456789abcdef"

screen:
         ;0123456789012345678901234567890123456789
    !scr "final cartridge 3 mouse detection test  " ;0
    !scr "                                        " ;1
    !scr "adc#1 adc#2  mask                       " ;2
    !scr "00    00     ........                   " ;3
    !scr "             12                         " ;4
    !scr "                                        " ;5
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
    !scr "                                        "
