

sp_code = $2000
test_area = $8000


*= $0801
    !byte $0B,$08,$90,$06,$9E,$32
    !byte $30,$34,$39,$00,$A0,$00

    sei
    ldx #$00
    stx store_byte+1
    lda #>sp_code
    sta store_byte+2

-
    lda #$80
    sta test_area,x

    lda #$7e            ; ror abs,x
    jsr store_byte
    txa
    jsr store_byte
    lda #>test_area
    jsr store_byte
    inx
    bne -

    lda #$60
    jsr store_byte
    clc

    ; main loop
--
    ; shift around the bits in the test area
    jsr sp_code
    bcc +
    ror test_area
+ 
    ; test if all bytes in the test area have the same value
    php
    ldy #5
    ldx #0
-
    lda test_area,x
    sta $0400,x
    cmp test_area
    beq +
    ldy #10
+
    sty $d020
    inx
    bne -
    plp

    lda $dc01
    and #$10
    bne --
    rts


store_byte 
    sta $8000
    inc store_byte+1
    bne +
    inc store_byte+2
+ 
    rts 
 
