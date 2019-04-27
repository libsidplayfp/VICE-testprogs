
sptr = $02

    * = $8000

    !word start
    !word start
    !text "CBM80"

    
    
start:
;            sei

;            lda #$44        ; leave freeze mode
;            sta $de00
;            lda #$06        ; disable RR/AR
;            sta $de00

            ldy #0
lp1:
            lda #$20
            sta $0400,y
            sta $0500,y
            sta $0600,y
            sta $0700,y
            lda #1
            sta $d800,y
            sta $d900,y
            sta $da00,y
            sta $db00,y
            tya
            sta $8000,y
            iny
            bne lp1

mlp:
            inc $07e7

            ldy #0
lp11:
            lda $8000,y
            sta $0400+(3*40),y
            lda $de00,y
            sta $0400+(10*40),y
            lda $df00,y
            sta $0400+(17*40),y
            iny
            bne lp11

;             lda #0
;             sta reg+1

            lda #>$0400
            sta sptr+1
            lda #<$0400
            sta sptr


            ldy #0
            lda #$de
            jsr puthex
            lda #$00
            jsr puthex
            iny
            iny

            ldx #0
lp2:
            txa
            pha

reg:        lda $de00,x
            jsr puthex
            iny

            pla
            tax
            inx
            cpx #8
            bne lp2

            lda sptr
            clc
            adc #40
            sta sptr
            lda sptr+1
            adc #0
            sta sptr+1
            
            ldy #0
            lda #$df
            jsr puthex
            lda #$00
            jsr puthex
            iny
            iny

            ldx #0
lp2a:
            txa
            pha

rega:        lda $df00,x
            jsr puthex
            iny

            pla
            tax
            inx
            cpx #8
            bne lp2a

            jmp mlp

puthex:
            pha
            lsr 
            lsr 
            lsr 
            lsr 
            tax
            lda hextab,x
            sta (sptr),y
            iny
            pla
            and #$0f
            tax
            lda hextab,x
            sta (sptr),y
            iny
            rts

hextab:
            !text "0123456789"
            !byte 1,2,3,4,5,6
