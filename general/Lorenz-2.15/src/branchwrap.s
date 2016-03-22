; original source file: n/a (broken), this was recreated from a disassembly
; FIXME: this test can not fail?!
;-------------------------------------------------------------------------------
        * = $0801

        .byte $12, $08, $08, $00
        .byte $97, $37, $38, $30
        .byte $2c, $30, $3a, $9e
        .byte $32, $30, $37, $33
        .byte 0,0,0

        lda #$01
        sta $030c
        jmp main

irqdisable
        lda #$7f
        sta $dc0d
        lda #$e3
        sta $00
        lda #$34
        sta $01
        rts

irqenable
        lda #$2f
        sta $00
        lda #$37
        sta $01
        lda #$81
        sta $dc0d
        rts

main
        jsr print
        .byte $0d
        .text "{up}branchwrap"
        .byte 0

        jsr irqdisable
        lda #$10  ; bpl
        sta $ffbe
        lda #$42  ; $0002
        sta $ffbf
        lda #$60  ; rts
        sta $ffc0
        sta $02
i085c
        lda #$30
        pha
        plp
        jsr $ffbe
        lda #$f3
        pha
        plp
        jsr $ffbe
        clc
        lda $ffbe
        adc #$20
        sta $ffbe
        bcc i085c

        jsr irqenable

        jsr print
        .text " - ok"
        .byte $0d, 0

        lda #0         ; success
        sta $d7ff
load
        lda #$2f
        sta $00
        jsr print

name     .text "mmufetch"
namelen  = *-name
         .byte 0
         lda #0
         sta $0a
         sta $b9
         lda #namelen
         sta $b7
         lda #<name
         sta $bb
         lda #>name
         sta $bc
         pla
         pla
         jmp $e16f

print    pla
         .block
         sta print0+1
         pla
         sta print0+2
         ldx #1
print0   lda !*,x
         beq print1
         jsr $ffd2
         inx
         bne print0
print1   sec
         txa
         adc print0+1
         sta print2+1
         lda #0
         adc print0+2
         sta print2+2
print2   jmp !*
         .bend
