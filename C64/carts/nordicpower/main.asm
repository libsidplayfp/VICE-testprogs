
    * = $8000

    !word start
    !word start

    !byte $c3,$c2,$cd,$38,$30

start:
    sei
    lda #$2f
    sta $00
    lda #$37
    sta $01

    lda #$1b
    sta $d011

    lda #$03
    sta $dd00
    
    lda #$17
    sta $d018
    
    lda #$ff
    sta $dc02
    lda #$00
    sta $dc03
    
    ldx #0
-
    lda #1
    sta $d800,x
    lda #15
    sta $d900,x
    lda #1
    sta $da00,x
    lda #15
    sta $db00,x
    lda #$20
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    lda $8000,x
    sta $1000,x
    lda $8100,x
    sta $1100,x
    inx
    bne -

    lda #$33
    sta $01

    ldx #0
-
    lda #8
    sta $8000,x
    lda #$0a
    sta $a000,x
    lda #$de
    sta $de00,x
    lda #$df
    sta $df00,x
    inx
    bne -
    
    lda #$37
    sta $01
    
    jmp go - $7000
    
go:
    lda #0
    sta $d020
    sta $d021

--
    ldx #0
-
    lda $8000,x
    sta $0400,x
    lda $a000,x
    sta $0500,x
    lda $de00,x
    sta $0600,x
    lda $df00,x
    sta $0700,x
    inx
    bne -

    ldx #$00
    
    lda #$0
    sta $dc00
    lda $dc01
    cmp #$ff
    beq +
    ldx #$22
+
    stx $de00
    beq -- 
    bne -- 

    !scr "ROML 8000"
    
    * = $9e00
    !scr "ROML 9e00"
    * = $9f00
    !scr "ROML 9f00"
    
    * = $a000
    !scr "ROML a000"
    * = $be00
    !scr "ROML be00"
    * = $bf00
    !scr "ROML bf00"
    
