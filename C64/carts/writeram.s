
;CRTID = 36 ; retro replay
CRTID = 53 ; pagefox

ROMSTART = $8000

    !to "writeram.bin",plain

    * = ROMSTART

    !word start
    !word start
    !byte $c3, $c2, $cd, $38, $30

start:
    sei
    lda #$1b
    sta $d011
    lda #$17
    sta $d018
    lda #$c8
    sta $d016

    lda #$2f
    sta $00

    ldx #0
lp:
    lda code,x
    sta $1000,x
    lda #1
    sta $d800,x
    lda #2
    sta $d900,x
    lda #3
    sta $da00,x
    lda #4
    sta $db00,x
    lda #$20
    sta $0400,x
    sta $0500,x
    sta $0600,x
    sta $0700,x
    inx
    bne lp
    jmp $1000

code:

    ; cart off, store pattern to c64 ram
    lda #$35
    sta $01
    lda #%00011100
    sta $de80

    ldx #0
lp2:
    txa
    sta $a000,x
    dex
    bne lp2

    ; cart on, store pattern to cart AND c64 ram
    lda #$37
    sta $01
    lda #%00001000
    sta $de80

    ldx #0
lp3:
    txa
    eor #$ff
    sta $a000,x
    dex
    bne lp3

    ; cart off, read pattern
    lda #$35
    sta $01
    lda #%00011100
    sta $de80

    ldx #0
lp4a:
    lda $a000,x
    sta $0400,x
    dex
    bne lp4a

    ; cart on, read pattern
    lda #$37
    sta $01
    lda #%00001000
    sta $de80

    ldx #0
lp4b:
    lda $a000,x
    sta $0500,x
    dex
    bne lp4b

    ; cart off, store pattern to c64 ram
    lda #$35
    sta $01
    lda #%00011100
    sta $de80

    ldx #0
lp2a:
    txa
    eor #%10101010
    sta $a000,x
    dex
    bne lp2a

    ; cart off, read pattern
    lda #$35
    sta $01
    lda #%00011100
    sta $de80

    ldx #0
lp4d:
    lda $a000,x
    sta $0600,x
    dex
    bne lp4d

    ; cart on, read pattern
    lda #$37
    sta $01
    lda #%00001000
    sta $de80

    ldx #0
lp4c:
    lda $a000,x
    sta $0700,x
    dex
    bne lp4c

    ldx #2
    
    lda $0400
    cmp #$ff
    bne doneerror
    
    lda $0500
    cmp #$ff
    bne doneerror
    
    lda $0600
    cmp #%10101010
    bne doneerror
    
    lda $0700
    cmp #$ff
    bne doneerror
    
    ldx #5
doneerror:
    stx $d020

    lda #0      ; success
    cpx #5
    beq nofail
    lda #$ff    ; failure
nofail:
    sta $d7ff

done
    beq done
    bne done

