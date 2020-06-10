
ramtarget = $900

    * = $8000

    !word start
    !word start

    !byte $c3,$c2,$cd,$38,$30

    !scr " ROML 8000 "
    
start:
    sei
    ; we must set data first, then update DDR
    lda #$37
    sta $01
    lda #$2f
    sta $00

    lda #$1b
    sta $d011

    lda #$03
    sta $dd00
    
    lda #$17
    sta $d018
    
    lda #$c8
    sta $d016
    
    lda #$ff
    sta $dc02
    lda #$00
    sta $dc03
    
    ldx #(40*3)-1
-
    lda #1
    sta $d800+(0*40),x
    sta $d800+(6*40),x
    sta $d800+(13*40),x
    sta $d800+(19*40),x
    lda #15
    sta $d800+(3*40),x
    sta $d800+(9*40),x
    sta $d800+(16*40),x
    sta $d800+(22*40),x
    dex
    bpl -
    
    ldx #0
-
    lda #$20
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    lda $8000,x
    sta ramtarget,x
    lda $8100,x
    sta ramtarget+$0100,x
    lda $8200,x
    sta ramtarget+$0200,x
    lda $8300,x
    sta ramtarget+$0300,x
    inx
    bne -

    lda #$33
    sta $01

    ldx #0
-
    lda #$08
    sta $8000,x
    lda #$0a
    sta $a000,x
    lda #$de
    sta $de00,x
    lda #$df
    sta $df00,x
    lda #$9e
    sta $9e00,x
    lda #$9f
    sta $9f00,x
    inx
    bne -
    
    lda #$37
    sta $01
    
    jmp go - ($8000-ramtarget)
    
go:
    lda #0
    sta $d020
    sta $d021
    
!if RRMODE = 1 {
    ; non REU mapping
    lda #0
    sta $de01
}
!if RRMODE = 2 {
    ; REU mapping
    lda #$40
    sta $de01
}
    
    ; enable RAM at $8000 (ultimax)
    lda #$23
    sta $de00
 
    ldx #$0a
-
    lda text_raml9e00-($8000-ramtarget),x
    sta $9e00,x
    lda text_raml9f00-($8000-ramtarget),x
    sta $9f00,x
    lda text_raml8000-($8000-ramtarget),x
    sta $8000,x
    dex
    bpl -

goloop:

    ; ROM at $8000
    ldx #$00
    stx $de00

    ldx #(3*40)-1
-
    lda $8000,x
    sta $0400 + (0*40),x
    lda $a000,x
    sta $0400 + (3*40),x
!if IO1READ=1 {
    lda $de00,x
    sta $0400 + (6*40),x
}
    lda $df00,x
    sta $0400 + (9*40),x
    dex
    bpl -

    ; "nordic power" mode
    ldx #$22
    stx $de00
    
    ldx #(3*40)-1
-
    lda $8000,x
    sta $0400 + (13*40),x
    lda $a000,x
    sta $0400 + (16*40),x
!if IO1READ=1 {
    lda $de00,x
    sta $0400 + (19*40),x
}
    lda $df00,x
    sta $0400 + (22*40),x
    dex
    bpl -

    ldy #13 ; green
    sty $02
    
    ldx #$0a
-
    ldy #13 ; green
    lda $0400 + (0*40) + 9,x
    cmp text_roml8000-($8000-ramtarget),x
    beq +
    ldy #10 ; red
    sty $02
+
    tya
    sta $d800 + (0*40) + 9,x

    dex
    bpl -

    ldx #7
-
    ldy #13 ; green
    lda $0400 + (3*40) + 4,x
    cmp text_basic-($8000-ramtarget),x
    beq +
    ldy #10 ; red
    sty $02
+
    tya
    sta $d800 + (3*40) + 4,x

    dex
    bpl -

!if RRMODE=2 {
    
    ldx #$0a-2
-
    ldy #13 ; green
    lda $0400 + (6*40) + 2,x
    cmp text_roml9e00-($8000-ramtarget)+2,x
    beq +
    ldy #10 ; red
    sty $02
+
    tya
    sta $d800 + (6*40) + 2,x

    dex
    bpl -
} else {    
    
    ldx #$0a
-
    ldy #13 ; green
    lda $0400 + (9*40) + 0,x
    cmp text_roml9f00-($8000-ramtarget),x
    beq +
    ldy #10 ; red
    sty $02
+
    tya
    sta $d800 + (9*40) + 0,x

    dex
    bpl -
}    
    ; NP mode

    ldx #$0a
-
    ldy #13 ; green
!if ARMODE=0 {
    lda $0400 + (13*40) + 9,x
    cmp text_roml8000-($8000-ramtarget),x
} 
!if ARMODE=1 {
    lda $0400 + (13*40) + 0,x
    cmp text_raml8000or-($8000-ramtarget),x
}
!if ARMODE=2 {
    lda $0400 + (13*40) + 9,x
    cmp text_hhh-($8000-ramtarget),x
}
    beq +
    ldy #10 ; red
    sty $02
+
    tya
!if ARMODE=0 {
    sta $d800 + (13*40) + 9,x
} else {
    sta $d800 + (13*40) + 0,x
}

    dex
    bpl -

!if (ARMODE=0) {
    ldx #$0a
} else {
    ldx #7
}
-
    ldy #13 ; green
!if (ARMODE=0) {
    lda $0400 + (16*40) + 0,x
    cmp text_raml8000-($8000-ramtarget),x
} else {
    lda $0400 + (16*40) + 4,x
    cmp text_basic-($8000-ramtarget),x
}
    beq +
    ldy #10 ; red
    sty $02
+
    tya
!if (ARMODE=0) {
    sta $d800 + (16*40) + 0,x
} else {
    sta $d800 + (16*40) + 4,x
}

    dex
    bpl -

!if RRMODE=2 {
    
    ldx #$0a-2
-
    ldy #13 ; green
    lda $0400 + (19*40) + 2,x
    cmp text_raml9e00-($8000-ramtarget)+2,x
    beq +
    ldy #10 ; red
    sty $02
+
    tya
    sta $d800 + (19*40) + 2,x

    dex
    bpl -
 
} else {
    
    ldx #$0a
-
    ldy #13 ; green
    lda $0400 + (22*40) + 0,x
    cmp text_raml9f00-($8000-ramtarget),x
    beq +
    ldy #10 ; red
    sty $02
+
    tya
    sta $d800 + (22*40) + 0,x

    dex
    bpl -
 
} 
 
    ldx #0 ; pass
    lda $02
    sta $d020
    cmp #13 ; green
    beq +
    ldx #$ff ; fail
+
    stx $d7ff
    
    jmp goloop - ($8000-ramtarget)

    !scr " ROML 8000 "

    * = $8200
text_raml9e00:
    !scr " RAML 9e00 "
text_raml9f00:
    !scr " RAML 9f00 "
text_raml8000:
    !scr " RAML 8000 "
text_roml8000:
    !scr " ROML 8000 "
text_raml8000or:
    !scr "(ZIML(8888("
text_basic:
    !scr "CBMBASIC"
text_roml9e00:
    !scr " ROML 9e00 "
text_roml9f00:
    !scr " ROML 9f00 "
text_hhh:
    !scr "hhhhhhhhhhh"
    
    * = $9e00
    !scr " ROML 9e00 "
    * = $9f00
    !scr " ROML 9f00 "
    
    * = $a000
    !scr " ROML a000 "
    * = $be00
    !scr " ROML be00 "
    * = $bf00
    !scr " ROML bf00 "
    
