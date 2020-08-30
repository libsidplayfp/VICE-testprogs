bitmap = $2000
vram = $0400
xposlo = $10
xposhi = $11

initplot:
        ldy #13
--
        ldx #0
        lda #$1b
-
        lda clearline,x
clearaddr=*+1
        sta vram,x
        lda clearline2,x
clearaddr2=*+1
        sta vram+40,x
        inx
        cpx #40
        bne -

        lda clearaddr
        clc
        adc #40*2
        sta clearaddr
        bcc +
        inc clearaddr+1
+
        lda clearaddr2
        clc
        adc #40*2
        sta clearaddr2
        bcc +
        inc clearaddr2+1
+
        dey
        bne --
    
        lda #0
        ldy #$20
        ldx #0
-
bitmaphiaddr=*+2
        sta bitmap,x
        inx
        bne -
        inc bitmaphiaddr
        dey
        bne -

        lda #$3b
        sta $d011
        lda #$18
        sta $d018

        lda #0
        sta xposlo
        sta xposhi

        rts
;-------------------------------------------------------------------------------
doplot:
        lda #%11111110
        sta $dc00
        lda $dc01
        cmp #%11101111  ; f1
        bne +
        ldy #0
        sty divlevel
        sty $d020
+
        cmp #%11011111  ; f3
        bne +
        ldy #1
        sty divlevel
        sty $d020
+
        cmp #%10111111  ; f5
        bne +
        ldy #2
        sty divlevel
        sty $d020
+
        cmp #%11110111  ; f7
        bne +
        ldy #3
        sty divlevel
        sty $d020
+


calibrating=*+1
        lda #$20
        beq ++
        cmp #$20
        beq +
        lda timerlo
        clc
        adc compensatelo
        sta compensatelo
        lda timerhi
        adc compensatehi
        sta compensatehi

        ror compensatehi
        ror compensatelo

        dec calibrating
        rts
+
        ; first value
        lda timerlo
        sta compensatelo
        lda timerhi
        sta compensatehi
        dec calibrating
        rts
++
        lda timerlo
        sec
compensatelo=*+1
        sbc #0
        sta xposlo
        lda timerhi
compensatehi=*+1
        sbc #0
        sta xposhi

divlevel=*+1
        ldy #3
        beq nodiv
        
-
        lda xposhi
        cmp #$80
        ror xposhi
        ror xposlo
        
        dey
        bpl -
        
nodiv:
        
        lda #160
        clc
        adc xposlo
        sta xposlo
        lda #0
        adc xposhi
        sta xposhi

        ; clear the line
        ldx #0
-
        lda #0
lineaddr=*+1
        sta bitmap + (0 * 8),x
lineaddr2=*+1
        sta bitmap + (20 * 8),x
        txa
        clc
        adc #8
        tax
        cpx #(20*8)
        bne -

        lda xposlo
        and #%00000111
        tax

        lda xposlo
        and #%11111000
        clc
        adc lineaddr+0
        sta lineaddr3+0

        lda xposhi
        adc lineaddr+1
        sta lineaddr3+1

        lda bitmapbits,x

lineaddr3=*+1
        sta bitmap + (0 * 8)
    
        ; go to next line

        jsr nextline
        clc
        lda lineaddr+0
        adc #<(20*8)
        sta lineaddr2+0
        lda lineaddr+1
        adc #>(20*8)
        sta lineaddr2+1
        
        rts
    
nextline:
        inc linecount
        lda linecount
        cmp #(25*8)
        bne +
        lda #0
        sta linecount
        lda #<bitmap
        sta lineaddr+0
        lda #>bitmap
        sta lineaddr+1
        rts
+
    
linecount=*+1
        lda #0
        and #$07
        bne plus1
    
plus320:
        clc
        lda lineaddr+0
        adc #<(320-7)
        sta lineaddr+0
        lda lineaddr+1
        adc #>(320-7)
        sta lineaddr+1
        rts

plus1:
        inc lineaddr+0
        bne +
        inc lineaddr+1
+
        rts

;-------------------------------------------------------------------------------

bitmapbits:
    !byte %10000000
    !byte %01000000
    !byte %00100000
    !byte %00010000
    !byte %00001000
    !byte %00000100
    !byte %00000010
    !byte %00000001
    
clearline:
    !byte $10,$1b,$10,$1b,$10,$1b,$10,$1b,$10,$1b
    !byte $10,$1b,$10,$1b,$10,$1b,$10,$1b,$10,$05
    !byte $0d,$10,$1b,$10,$1b,$10,$1b,$10,$1b,$10
    !byte $1b,$10,$1b,$10,$1b,$10,$1b,$10,$1b,$10
clearline2:
    !byte $1b,$10,$1b,$10,$1b,$10,$1b,$10,$1b,$10
    !byte $1b,$10,$1b,$10,$1b,$10,$1b,$10,$1b,$0d
    !byte $05,$1b,$10,$1b,$10,$1b,$10,$1b,$10,$1b
    !byte $10,$1b,$10,$1b,$10,$1b,$10,$1b,$10,$1b
