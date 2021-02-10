srcbuffer = $07e8
checkbuffer = $0500
checkbuffer2 = $0600

result = $10

    * = $0801
    !byte $0c, $08, $00, $00, $9e, $20, $34, $30, $39, $36
    !byte 0,0,0

    * = $1000

    sei
    lda #1
    sta $0286
    lda #$93
    jsr $ffd2

    ldx #0
-
    lda #$20
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    lda #$01
    sta $d800,x
    sta $da00,x
    lda #$0c
    sta $d900,x
    sta $db00,x
    inx
    bne -

    ; first write the bank number into the first byte of each bank, in
    ; descending order.

    LDA #<$0001
    STA $07
    LDA #>$0001
    STA $08

    LDA #>srcbuffer
    STA $03
    LDA #<srcbuffer
    STA $02

    LDA #$00
    STA $04
    STA $05
    STA $06

    ldx #0
-
    txa
    eor #$ff
    sta $06     ; bank
    sta srcbuffer  ; value

    JSR copyC64toREU

    inx
    bne -

    ; read back the first byte of each bank

    ; REU -> screen
    LDA #>checkbuffer
    STA $03
    LDA #<checkbuffer
    STA $02

    ldx #0
-
    stx $02 ; buffer lowbyte
    stx $06 ; bank

    JSR copyREUtoC64

    inx
    bne -

    ; write a value to first byte of each byte and read it back to check if
    ; there is ram present (repeat with 2 different values to be sure)
    LDA #<$0002
    STA $07
    LDA #>$0002
    STA $08
    
    LDA #>srcbuffer
    STA $03
    LDA #<srcbuffer
    STA $02

    LDA #$00
    STA $04
    STA $05
    STA $06

    ldx #0
-
    lda #$00
    sta result

    stx $06        ; bank

    ; first transfer, use $5a
    LDA #>srcbuffer
    STA $03
    LDA #<srcbuffer
    STA $02

    lda #$5a
    sta srcbuffer    ; value
    lda #$42
    sta srcbuffer+1  ; dummy to load the floating bus

    JSR copyC64toREU

    LDA #>checkbuffer2
    STA $03
    ;ldx #<checkbuffer2
    stx $02

    JSR copyREUtoC64
    
    lda checkbuffer2,x
    cmp #$5a
    beq +
    lda #$ff
    sta result
+

    ; second transfer, use $a5
    LDA #>srcbuffer
    STA $03
    LDA #<srcbuffer
    STA $02

    lda #$a5
    sta srcbuffer  ; value
    lda #$23
    sta srcbuffer+1  ; dummy to load the floating bus

    JSR copyC64toREU

    LDA #>checkbuffer2
    STA $03
    ;ldx #<checkbuffer2
    stx $02

    JSR copyREUtoC64

    lda checkbuffer2,x
    cmp #$a5
    beq +
    lda #$ff
    sta result
+
    lda result
    sta checkbuffer2,x

    inx
    bne -

    ; check buffer in increasing order, compare value with expected bank number

    ldy #0
    ldx #0
-
    stx srcbuffer
    lda checkbuffer2,x
    bne +       ; if not 0, then there is no RAM
    lda checkbuffer,x
    cmp srcbuffer
    bne +       ; if not the same, X contains number of banks
    inx
    bne -

    iny
+
    stx srcbuffer
    sty srcbuffer+1
    
    ldx srcbuffer
    lda srcbuffer+1
    jsr $bdcd

    lda #$20
    jsr $ffd2

    ldx srcbuffer
    lda srcbuffer+1
    stx srcbuffer+2
    sta srcbuffer+3

    ; bank * 64
    ldx #6
-
    asl srcbuffer+2
    rol srcbuffer+3
    
    dex
    bne -
    
    ldx srcbuffer+2
    lda srcbuffer+3
    jsr $bdcd

    ldy #13 ; green
    
    !if TESTSIZE = 16384 {
    lda srcbuffer+1
    cmp #1
    }
    !if TESTSIZE = 8192 {
    lda srcbuffer+0
    cmp #128
    }
    !if TESTSIZE = 4096 {
    lda srcbuffer+0
    cmp #64
    }
    !if TESTSIZE = 2048 {
    lda srcbuffer+0
    cmp #32
    }
    !if TESTSIZE = 1024 {
    lda srcbuffer+0
    cmp #16
    }
    !if TESTSIZE = 512 {
    lda srcbuffer+0
    cmp #8
    }
    !if TESTSIZE = 256 {
    lda srcbuffer+0
    cmp #4
    }
    !if TESTSIZE = 128 {
    lda srcbuffer+0
    cmp #2
    }
    beq +
    ldy #10 ; red
+
    sty fail
    
    lda srcbuffer+1
    beq +
    jmp is16m
+
    lda srcbuffer+0
    cmp #2
    bne +
    jmp is128k
+
    lda srcbuffer+0
    cmp #4
    bne +
    jmp is256k
+
    lda srcbuffer+0
    cmp #8
    bne +
    jmp is512k
+
    lda srcbuffer+0
    cmp #16
    bne +
    jmp is1m
+
    lda srcbuffer+0
    cmp #32
    bne +
    jmp is2m
+
    lda srcbuffer+0
    cmp #64
    bne +
    jmp is4m
+
    lda srcbuffer+0
    cmp #128
    bne +
    jmp is8m
+
    ldy #10 ; red
    sty fail
    jmp testend

is128k:
    lda #>banks128k
    sta bankstest+1
    lda #<banks128k
    sta bankstest+0
    lda #>mirrors128k
    sta mirrorstest+1
    lda #<mirrors128k
    sta mirrorstest+0
    jmp testit

is256k:
    lda #>banks256k
    sta bankstest+1
    lda #<banks256k
    sta bankstest+0
    lda #>mirrors256k
    sta mirrorstest+1
    lda #<mirrors256k
    sta mirrorstest+0
    jmp testit

is512k:
    lda #>banks512k
    sta bankstest+1
    lda #<banks512k
    sta bankstest+0
    lda #>mirrors512k
    sta mirrorstest+1
    lda #<mirrors512k
    sta mirrorstest+0
    jmp testit

is1m:
    lda #>banks1MB
    sta bankstest+1
    lda #<banks1MB
    sta bankstest+0
    lda #>mirrors1MB
    sta mirrorstest+1
    lda #<mirrors1MB
    sta mirrorstest+0
    jmp testit

is2m:
    lda #>banks2MB
    sta bankstest+1
    lda #<banks2MB
    sta bankstest+0
    lda #>mirrors2MB
    sta mirrorstest+1
    lda #<mirrors2MB
    sta mirrorstest+0
    jmp testit

is4m:
    lda #>banks4MB
    sta bankstest+1
    lda #<banks4MB
    sta bankstest+0
    lda #>mirrors4MB
    sta mirrorstest+1
    lda #<mirrors4MB
    sta mirrorstest+0
    jmp testit

is8m:
    lda #>banks8MB
    sta bankstest+1
    lda #<banks8MB
    sta bankstest+0
    lda #>mirrors8MB
    sta mirrorstest+1
    lda #<mirrors8MB
    sta mirrorstest+0
    jmp testit

is16m:
    lda #>banks16MB
    sta bankstest+1
    lda #<banks16MB
    sta bankstest+0
    lda #>mirrors16MB
    sta mirrorstest+1
    lda #<mirrors16MB
    sta mirrorstest+0

testit:

    ldx #0
-
    ldy #13 ; green
bankstest=*+1
    lda banks128k,x
    cmp checkbuffer,x
    beq +
    ldy #10 ; red
    sty fail
+
    tya
    sta $d900,x

    ldy #13 ; green
mirrorstest=*+1
    lda mirrors128k,x
    cmp checkbuffer2,x
    beq +
    ldy #10 ; red
    sty fail
+
    tya
    sta $da00,x

    inx
    bne -

testend:

fail=*+1
    lda #13
    sta $d020

    ldy #0
    cmp #10 ; red
    bne +
    ldy #$ff
+
    sty $d7ff
    jmp *

;------------------------------------------------------------------------------
banks128k:
    !for i,0,127 {
        !byte 0,1
    }

banks256k:
    !for i,0,31 {
        !byte 0,1,2,3, $ff, $ff, $ff, $ff
    }

banks512k:
    !for i,0,31 {
        !byte 0,1,2,3,4,5,6,7
    }

banks1MB:
    !for i,0,255 {
        !byte i & $0f
    }
banks2MB:
    !for i,0,255 {
        !byte i & $1f
    }
banks4MB:
    !for i,0,255 {
        !byte i & $3f
    }
banks8MB:
    !for i,0,255 {
        !byte i & $7f
    }
banks16MB:
    !for i,0,255 {
        !byte i & $ff
    }

mirrors128k:
mirrors512k:
mirrors1MB:
mirrors2MB:
mirrors4MB:
mirrors8MB:
mirrors16MB:
    !for i,0,255 {
        !byte 0
    }

mirrors256k:
    !for i,0,32 {
        !byte 0,0,0,0, $ff, $ff, $ff, $ff
    }

;------------------------------------------------------------------------------

copyREUtoC64:                  ; REU -> C64
    LDY #$91
copyC64toREU = * + 1           ; C64 -> REU
    BIT $90A0

    ; C64 addr
    LDA $03
    STA $DF03
    LDA $02
    STA $DF02

    ; REU addr
    LDA $05
    STA $DF05
    LDA $04
    STA $DF04
    LDA $06
    STA $DF06

    ; length
    LDA $08
    STA $DF08
    LDA $07
    STA $DF07

    LDA #$00
    STA $DF09   ; IMR
    STA $DF0A   ; ACR
    STY $DF01   ; Command
    RTS




