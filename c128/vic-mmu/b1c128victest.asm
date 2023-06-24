;This program tests VIC Bank 1 memory access in Commodore 128 when MMU common RAM is enabled.
;VIC access is set to bank 1 and it will not see the common RAM in bank 0.
;C128 kernal sets up the display memory in Bank 0, but VIC does not see RAM bank 0 and fetches data from Bank 1.
;Sprite collision is used to test where VIC fetches its data from. Test result: green = ok, red = failed
;Test has been confirmed on real hardware.

    * =  $1c01
    !byte $0c,$08,$0a,$00,$9e,$37,$31,$38,$31,$00,$00,$00
    lda #$00
    sta $ff00
    jsr $77c4 ;set slow mode
    jsr $c07b ;initialize screen
    sei
    lda #$06 ;8 kb common RAM bottom
    sta $d506   
    lda #$ff ;initialize sprite pointer
    sta $07f8
    lda #$7e ;set bank1
    sta $ff00
    ldx #21 ;copy bank 1 code
loop1:
    lda bank1code,x
    sta $3800,x
    dex
    bpl loop1   
    jsr $3800 ;execute bank 1 code
    ldx #$40 ;set up sprite data in bank 1
    lda #$aa
loop2:
    sta $3fbf,x
    dex
    bne loop2
    lda #24 ;set up sprite x-location
    sta $d000
    lda #50 ;set up sprite x-location
    sta $d001 ;initialize sprite 0
    lda #$00
    sta $d010 ;MSB of x-coordinate
    sta $d01d ;X-expansion
    sta $d017 ;Y-expansion
    sta $d01c ;multicolor
    sta $d01b ;data priority
    lda #$01
    sta $d027 ;color white
    sta $d015 ;turn on sprite 0
    ldy $d01f ;clear collision register
loop3:
    lda $d011 ;wait for one full frame 
    bpl loop3
loop4:
    lda $d011
    bmi loop4
loop5:
    lda $d011
    bpl loop5
    ldx #$02 ;red if no collision
    ldy #$ff ;test fails if no collision    
    lda #$01
    bit $d01f ;load collision register
    beq nocoll
    ldx #$05 ;green
    ldy #$00 ;test ok
nocoll:
    stx $d020
    sty $d7ff
loop6:
    jmp loop6 ;finished, just wait

bank1code:
    lda #$40 ;switch off common ram to access display memory area
    sta $d506   
    lda #$51 ;store a character to Bank1 display memory
    sta $0400 ;to ensure a collision
    lda #$ff ;set up sprite pointer
    sta $07f8
    lda #$46 ;re-enable common RAM
    sta $d506
    rts 
