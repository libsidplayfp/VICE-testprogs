

ptr = $02

num00 = $04
numFF = $05
numXX = $06

fnum00 = $07
fnumFF = $08
fnumXX = $09
fptr   = $10

        *=$0801
        ; BASIC stub: "1 SYS 2061"
        !byte $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00
        jmp start

start:
        sei

        ldy #0
clrlp:
        lda #$20
        sta $0400,y
        sta $0500,y
        sta $0600,y
        sta $0700,y
        lda #14
        sta $d800,y
        lda #1
        sta $d800+(10*40),y
        iny
        bne clrlp

        lda #$34
        sta $01

        lda #$ff
        sta fnum00
        sta fnumFF
        sta fnumXX
restart:
        lda #$a0
        sta ptr+1
        sta fptr+1
        lda #$00
        sta ptr
        sta fptr

;        jsr showpage

        ldx #$a0
mlp:
        jsr countpage

        lda fnumXX
        sta $07e7
        cmp numXX
        beq notfound
        bcc notfound

        ; if numXX < fnumXX
        lda numXX
        sta fnumXX
        lda num00
        sta fnum00
        lda numFF
        sta fnumFF
        lda ptr+1
        sta fptr+1

        jsr showpage

notfound:
        inc ptr+1

        lda #$35
        sta $01

        lda $d011
        bpl *-3
        lda $d011
        bmi *-3

        lda #$34
        sta $01

        inx
        bne mlp

done:
;        inc $d020
        jmp restart

countpage:
        lda ptr+1
        and #$0f
        tay
        lda hextab,y
        sta $0400+(7*40)+39
        lda ptr+1
        lsr
        lsr
        lsr
        lsr
        tay
        lda hextab,y
        sta $0400+(7*40)+38

        lda #0
        sta num00
        sta numFF
        sta numXX

        ldy #0
countlp:
        lda (ptr),y
        sta $0400,y
        cmp #$00
        beq is00
        cmp #$ff
        beq isFF
        inc numXX
cont:
        iny
        bne countlp
        lda numXX
        sta $07e6
        rts
is00:
        inc num00
        jmp cont
isFF:
        inc numFF
        jmp cont


showpage:
        lda fptr+1
        and #$0f
        tay
        lda hextab,y
        sta $0400+(17*40)+39
        lda fptr+1
        lsr
        lsr
        lsr
        lsr
        tay
        lda hextab,y
        sta $0400+(17*40)+38

        ldy #0
showlp:
        lda (fptr),y
        sta $0400+(10*40),y
        iny
        bne showlp
        rts

hextab:
        !scr "0123456789abcdef"
