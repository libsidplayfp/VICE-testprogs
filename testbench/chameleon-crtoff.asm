
    * = $8000

    !word start
    !word start
    !byte $C3 ,$C2 ,$CD ,$38 ,$30

start:
    sei
    ldx #0
lp:
    lda payload,x
    sta $0400,x
    inx
    bne lp
    jmp $0400

payload:
    lda #42
    sta $d0fe       ; enable config mode
    lda #0
    sta $d0f0       ; disable cartridge

    lda #$22        ; MMU and I/O RAM
    sta $d0fa       ; enable config registers
    lda #$27        ; MMU Slot for I/O RAM
    sta $d0af
    lda #0
    ldx #1
    ; there is free memory at 0x00010000
    sta $d0a0
    sta $d0a1
    stx $d0a2
    sta $d0a3
    dec $d020
    lda #0
    sta $d7ff
    ; try to somewhat reset the TOD
    ldx #0
    ; cia 1 tod
    stx $dc08 ; 0 starts TOD clock
    stx $dc09 ; 0
    stx $dc0a ; 0

    ; cia 2 tod
    stx $dd08 ; 0 starts TOD clock
    stx $dd09 ; 0
    stx $dd0a ; 0
    inx
    stx $dc0b ; 1 (hour) stops TOD clock
    stx $dd0b ; 1 (hour) stops TOD clock

    lda $dc08 ; un-latch
    lda $dd08 ; un-latch

    ; clear pending flags
    lda $d01e ; Sprite to Sprite Collision Detect
    lda $d01f ; Sprite to Background Collision Detect

    ; clear pending irqs
    lda $d019
    sta $d019
    lda $dc0d
    lda $dd0d
    lda $df00 ; REU

    jmp $fce2