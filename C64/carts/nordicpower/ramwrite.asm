!if MAKECRT = 1 {    

    * = $8000

    !word start
    !word start

    !byte $c3,$c2,$cd,$38,$30

} else {
    * = $0801

    !word +
    !word 2020
    !byte $9e
    !byte $32, $30, $36, $31
+
    !byte 0,0,0

    * = $080d
}

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
!if MAKECRT = 1 {    
    lda $8000,x
    sta $1000,x
    lda $8100,x
    sta $1100,x
}
    inx
    bne -

!if MAKECRT = 1 {    
    jmp go - $7000
}    
go:
    ; disable the cartridge
    ldx #$00
    stx $de00
    
    lda #$33
    sta $01

    ; we init the C64 ram with a certain pattern
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
    inx
    bne -
    
    lda #$37
    sta $01

    lda #0
    sta $d020
    sta $d021

    ; "nordic power" mode, RAM at A000
    ldx #$22
    stx $de00
    
    ldx #0
-
    lda #$c8
    sta $8000,x
    lda #$ca
    sta $a000,x
    inx
    bne -

    ldx #0
-
    lda $8000,x
    sta $0400,x
    lda $a000,x
    sta $0500,x
    inx
    bne -

    ; disable the cartridge
    ldx #$02
    stx $de00

    lda #$35
    sta $01
    
    ldx #0
-
    lda $8000,x
    sta $0600,x
    lda $a000,x
    sta $0700,x
    inx
    bne -

    ; check results
    ldy #13 ; green

    ldx #0
-
    lda $0600,x
    cmp #$c8   
    beq +
    ldy #10 ; red
+
    tya
    sta $da00,x
    inx
    bne -
    
    ldx #0
-
    lda $0700,x
    cmp #$0a   
    beq +
    ldy #10 ; red
+
    tya
    sta $db00,x
    inx
    bne -
    
    lda #$00    ; ok
    
    sty $d020
    cpy #13 ; green
    beq +
    lda #$ff    ; fail
+
    sta $d7ff

-    
    ; wait for space, on space reset
    lda #$0
    sta $dc00
    lda $dc01
    cmp #$ff
    beq +
    
    lda #$37
    sta $01
    jmp $fce2
    
+    
    
    bne -
    beq -

!if MAKECRT = 1 {    
    
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
    
}
