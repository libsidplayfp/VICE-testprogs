        .export _main

_main:
        sei

        lda #$7f
        sta $dc0d
        lda $dc0d
        
        ldx #$00
        stx $d020
        stx $d021
l240a:
        lda #$20
        sta $0400,x
        sta $0500,x
        sta $0600,x
        sta $0700,x
        lda #$01
        sta $d800,x
        sta $d900,x
        sta $da00,x
        sta $db00,x
        inx
        bne l240a
        
loop:
        bit $d011
        bpl *-3
        bit $d011
        bmi *-3

        inc $d020
        
        lda #%00000000  ; stop timer
        sta $dc0e
        
        lda #$ff
        sta $dc04
        sta $dc05

        ; setup reu regs, start transfer ($10 bytes to $0400)
        lda #$00 ; addr ctrl
        sta $df0a
        lda #$00 ; irq mask
        sta $df09
        lda #$00 
        sta $df08
        lda #$10 ; transfer len lo 
        sta $df07
        lda #$00 ; reu addr
        sta $df06
        sta $df05
        sta $df04
        lda #>$0400 ; c64 addr hi
        sta $df03
        lda #<$0400 ; c64 addr lo
        sta $df02

        lda #%00010001  ; start timer
        sta $dc0e

        lda #$91        ; 2     cmd (exec immediatly reu->c64)
        sta $df01       ; 4

        lda $dc04       ; 4
        pha
        tax
        and #$0f
        tay
        lda hextab,y
        sta $0400 + 40 + 5
        txa
        lsr
        lsr
        lsr
        lsr
        tay
        lda hextab,y
        sta $0400 + 40 + 4

        dec $d020
        
        pla
        sta $0400 + 40
        cmp #$ff - ($10 + 7)    ; $e8
        beq allok

        lda #2
        sta $d020
        lda #$ff ; failure
        sta $d7ff
        jmp loop

allok:
        lda #5
        sta $d020
        lda #$00 ; success
        sta $d7ff
        jmp loop

hextab:
        .byte "0123456789"
        .byte 1,2,3,4,5,6
