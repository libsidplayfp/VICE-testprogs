

    * = $0801
    !byte $0c, $08, $00, $00, $9e, $20, $34, $30, $39, $36
    !byte 0,0,0

    * = $1000

    sei
    lda #$35
    sta $01

    lda #0
    sta $d020

        ; first fill 64k REU ram with $0a
        LDA #$00
        STA $DF09 ; interrupt mask
        STA $DF04 ; REU lo
        STA $DF05 ; REU hi
        STA $DF06 ; REU bank
        LDA #>buffer
        STA $DF03 ; c64 hi
        LDA #<buffer
        STA $DF02 ; c64 lo
        LDA #>$0000
        STA $DF08 ; length hi
        LDA #<$0000
        STA $DF07 ; length lo
        LDA #$80
        STA $DF0A ; addr control  C64 addr fixed
        LDA #$B0
        STA $DF01 ; command     execute, autoload, immediately, C64 -> REU

        ; transfer the last page with $0d as last byte
        LDA #$00
        STA $DF09 ; interrupt mask
        STA $DF04 ; REU lo
        STA $DF06 ; REU bank
        lda #$ff
        STA $DF05 ; REU hi
        LDA #>buffer
        STA $DF03 ; c64 hi
        LDA #<buffer
        STA $DF02 ; c64 lo
        LDA #>$0100
        STA $DF08 ; length hi
        LDA #<$0100
        STA $DF07 ; length lo
        LDA #$00
        STA $DF0A ; addr control  normal
        LDA #$B0
        STA $DF01 ; command     execute, autoload, immediately, C64 -> REU

        ; transfer 64k back to fixed target addr
        LDA #$00
        STA $DF09 ; interrupt mask
        STA $DF04 ; REU lo
        STA $DF05 ; REU hi
        STA $DF06 ; REU bank
        LDA #>target
        STA $DF03 ; c64 hi
        LDA #<target
        STA $DF02 ; c64 lo
        LDA #>$0000
        STA $DF08 ; length hi
        LDA #<$0000
        STA $DF07 ; length lo
        LDA #$80
        STA $DF0A ; addr control  C64 addr fixed
        LDA #$B1
        STA $DF01 ; command     execute, autoload, immediately, REU -> C64

        lda target
        sta $d020

        ldy #0
        cmp #$0d    ; OK
        beq ok
        ldy #$ff
ok:
        sty $d7ff
        jmp *

    !align 255,0
buffer:
    !for n, 255 {
        !byte $0a
    }
    !byte $0d
target:
    !byte 0
