bitmap = $2000
vram = $0400

xposlo = $fa
xposhi = $fb

linecount = $02


        *= $0801
        !byte $0c,$08,$0b,$00,$9e
        !byte $32,$30,$36,$34
        *= $0810

!if IRQ=0 {
        sei
}
        lda #0
        sta $d020
        sta $d021

        jsr initplot

        jmp doplot

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


paddlereg = $d419

doplot:

        ; get line address
        ldx linecount
        inx
        cpx #(25*8)
        bne +
        ldx #0
+       stx linecount

        lda bitmaphi,x
        sta lineaddr+1
        lda bitmaplo,x
        sta lineaddr+0

        ; clear the line
        ldx #0
-
        lda #0
lineaddr=*+1
        sta bitmap + (0 * 8),x

        lda add8,x
        tax
        bne -

        ; plot the plot
        lda paddlereg
        tax
        and #%11111000
        clc
        adc lineaddr+0
        sta lineaddr3+0

        lda #0
        adc lineaddr+1
        sta lineaddr3+1

        lda bitmapbits,x

lineaddr3=*+1
        sta bitmap + (0 * 8)

        jmp doplot

;-------------------------------------------------------------------------------

clearline:
    !byte $10,$1b,$10,$1b,$16,$1e,$16,$1e,$16,$1e
    !byte $16,$0d,$05,$0d,$05,$0d,$05,$0d,$05,$0d
    !byte $05,$0d,$05,$0d,$05,$0d,$05,$0d,$05,$1e
    !byte $16,$1e,$16,$1e,$16,$1e,$10,$1b,$10,$1b
clearline2:
    !byte $1b,$10,$1b,$10,$1e,$16,$1e,$16,$1e,$16
    !byte $1e,$05,$0d,$05,$0d,$05,$0d,$05,$0d,$05
    !byte $0d,$05,$0d,$05,$0d,$05,$0d,$05,$0d,$16
    !byte $1e,$16,$1e,$16,$1e,$16,$1b,$10,$1b,$10

!align 255,0

bitmapbits:
    !for n, 0, 31 {
    !byte %10000000
    !byte %01000000
    !byte %00100000
    !byte %00010000
    !byte %00001000
    !byte %00000100
    !byte %00000010
    !byte %00000001
    }

!align 255,0

bitmaphi:
    !for n, 0, 199 {
        !byte >(bitmap+32+(((n / 8) * 320) + (n & 7)))
    }

!align 255,0

bitmaplo:
    !for n, 0, 199 {
        !byte <(bitmap+32+(((n / 8) * 320) + (n & 7)))
    }

!align 255,0
add8:
    !for n, 0, 255 {
    !byte <(n+8)
    }
