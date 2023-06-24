;This program tests VIC memory access in Commodore 128 Bank 1 C64-mode when MMU common RAM is enabled.
;VIC access is set to bank 1 and it will not see the common RAM in bank 0.
;C64 kernal sets up the display memory in Bank 0, but VIC does not see this and fetches data from Bank 1.
;Sprite collision is used to test where VIC fetches its data. Test result: green = ok, red = failed

        * = $1c01
        !byte $0c,$08,$0a,$00,$9e,$37,$31,$38,$31,$00,$00,$00
        sei
        lda #$3e
        sta $ff00
        lda #$06
        sta $d506
        ldx #$40
        lda #$ff
        sta $07f8
loop1: sta $3fbf,x
        dex
        bne loop1
        lda #$7e
        sta $ff00
        ldx #$23
loop2: lda bank1code,x
        sta $3800,x
        lda autostart,x
        sta $8000,x
        dex
        bpl loop2
        jmp $3800
_64code:
        stx $d016 ;C64 autostart code
        jsr $fda3
        jsr $fd50
        jsr $fd15
        jsr $ff5b
        cli
        jsr $e453
        jsr $e3bf
        jsr $e422
        ldx #$fb
        txs
        ldx #$40 ;set up sprite data
        lda #$aa
loop3: sta $3fbf,x
        dex
        bne loop3
        stx $d030
        lda #24 ;set up sprite x-location
        sta $d000
        lda #50 ;set up sprite x-location
        sta $d001 ;initialize sprite 0
        lda #$00
        sta $d010 ;MSB of x-coordinate
        sta $d01d ;X-expansion
        sta $d017 ;Y-expansion
        sta $d01c ;multicolor
        lda #$01
        sta $d027 ;color white
        sta $d015 ;turn on sprite 0
        ldy $d01f ;clear collision register
loop4: lda $d011 ;wait for one full frame
        bpl loop4
loop5: lda $d011
        bmi loop5
loop6: lda $d011
        bpl loop6
        ldx #$02 ;red if no collision
        ldy #$ff ;test fails if no collision
        lda #$01
        bit $d01f ;load collision register
        beq nocoll
        ldx #$05 ;green
        ldy #$00 ;test ok
nocoll: stx $d020
        sty $d7ff
loop7: jmp loop7 ;finished, just wait

bank1code: ;setting up Bank 1 C64 mode
        lda #$40 ;switch off common ram to access display memory
        sta $d506
        lda #$51 ;store a character to Bank1 display memory
        sta $0400 ;to ensure a collision
        lda #$ff ;set up sprite pointer
        sta $07f8
        lda #$46 ;re-enable common ram
        sta $d506
        lda #$e3
        sta $01
        lda #$2f
        sta $00
        lda #$f7 ;switch to C64 mode
        sta $d505
        jmp ($fffc) ;jump to reset vector

autostart:
        !byte <_64code
        !byte >_64code
        !byte <_64code
        !byte >_64code
        !byte $c3,$c2,$cD,$38,$30
