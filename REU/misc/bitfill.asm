;i5000 = $5000
;i5000 = $0400 + (7 * 40)
i5000 = $0600

;xferlen = $4000
;xferlen = 2
xferlen = $0100

SB = $fa

    * = $0801
    !byte $0c, $08, $00, $00, $9e, $20, $34, $30, $39, $36
    !byte 0,0,0

        * = $1000

restart:

        sei
        lda #$20
        ldx #0
-
        sta $0400,x
        sta $0500,x
        sta $0600,x
        sta $0700,x
        inx
        bne -

        lda #512 / 64
        sta $FB ; num banks
        
        ldx #0
        ldy #0
mainloop:
        stx SB

        txa
        sta $0400+40,y
        pha
        tya
        pha

        jsr bitfilltest

        pla
        tay

        ldx #5
        lda SB
        sta $0400,y
        beq +
        ldx #10
+
        txa
        sta $d800,y

        ldx #0
-
        lda #5
        sta $da00,x

        lda $0400+40,y
        cmp i5000,x
        beq +
        lda #10
        sta $da00,x
+
        inx
        bne -

        iny

        pla
        clc
        adc #17
        tax
        bcs end
  
        !if (INTERACTIVE = 1) {
        jsr waitspace
        }

        jmp mainloop

end:
        ldy #5

        ldx #0
-
        lda $d800,x
        and #$0f
        cmp #5
        beq +
        ldy #10
+
        inx
        cpx #16
        bne -

        sty $d020
        
        lda #0      ; success
        cpy #5
        beq +
        lda #$ff    ; failure
+
        sta $d7ff

        jsr waitspace

        jmp restart

waitspace:
-
        lda $dc01
        cmp #$ef
        bne -
-
        lda $dc01
        cmp #$ef
        beq -
        rts

;-------------------------------------------------------------------------------

bitfilltest:
        PHP
        SEI
        LDA #$0E
        STA $FF00
        LDA #$FF
        STA $D015

        LDA #$00
        STA $DF09 ; interrupt mask
        STA $DF02 ; c64 lo
        STA $DF04 ; REU lo
        STA $DF05 ; REU hi
        STA $DF06 ; REU bank
        STA $FE
        STA $FC
        LDA #>i5000
        STA $DF03 ; c64 hi
        STA $FF
        LDA #>xferlen
        STA $DF08 ; length hi
        LDA #<xferlen
        STA $DF07 ; length lo
loop:
        LDA #$80
        STA $DF0A ; addr control  fix C64 address 

        ; fill buffer with $80
        ldx #0
-
        lda #$80
        sta i5000,x
        inx
        cpx #$10
        bne -

        LDA SB
        STA i5000

        ; first transfer, C64 to REU memory
        inc $d020
        LDA #$B0
        STA $DF01 ; command     execute, autoload, immediately, C64 -> REU
        dec $d020


        ldx #0
-
        lda $df00,x
        sta $0400+(3*40),x
        lda i5000,x
        sta $0400+(3*40)+20,x
        lda #$81
        sta i5000+xferlen,x
        inx
        cpx #$10
        bne -

        LDA SB
        STA i5000
        
        ; second transfer, swap C64 with REU memory

        LDA #$00
        STA $DF0A ; addr control  normal
        inc $d020
        LDA #$B2
        STA $DF01 ; command     execute, autoload, immediately, swap
        dec $d020

        ldx #0
-
        lda $df00,x
        sta $0400+(4*40),x
        lda i5000,x
        sta $0400+(4*40)+20,x
        lda #$82
        sta i5000+xferlen,x
        inx
        cpx #$10
        bne -

        LDA SB
        STA i5000

        ; third transfer, C64 to REU memory

        inc $d020
        LDA #$B0
        STA $DF01 ; command     execute, autoload, immediately, C64 -> REU
        dec $d020

        ldx #0
-
        lda $df00,x
        sta $0400+(5*40),x
        lda i5000,x
        sta $0400+(5*40)+20,x
        lda #$82
        sta i5000+xferlen,x
        inx
        cpx #$10
        bne -

        LDA SB
        STA i5000

        ; fourth transfer, REU to C64 memory

        inc $d020
        LDA #$B1
        STA $DF01 ; command     execute, autoload, immediately, REU -> C64
        dec $d020

        LDA i5000
        CMP SB
        BNE i3498 ; fail 2

        ldx #0
-
        lda $df00,x
        sta $0400+(6*40),x
        lda i5000,x
        sta $0400+(6*40)+20,x
        lda #$83
        sta i5000+xferlen,x
        inx
        cpx #$10
        bne -

        LDA SB
        STA i5000

        ; fifth transfer, compare with fixed REU address

        LDA #$40
        STA $DF0A ; addr control  fix REU address 
        inc $d020
        LDA #$B3
        STA $DF01 ; command     execute, autoload, immediately, compare
        dec $d020

        LDA #$20
        BIT $DF00 ; status
        BNE i3498a ; fail 3

        ; sixth transfer, compare with fixed C64 address

        LDA #$80
        STA $DF0A ; addr control  fix C64 address
        inc $d020
        LDA #$B3
        STA $DF01 ; command     execute, autoload, immediately, compare
        dec $d020

        LDA #$20
        BIT $DF00 ; status
        BNE i3495 ; fail 1

        LDA #$40
        CLC
        ADC $DF05 ; REU hi
        STA $DF05 ; REU hi
        ;BNE loop
        beq sk1
        jmp loop
sk1:        


        INC $FC
        LDA $FC
        STA $DF06 ; REU bank
        CMP $FB ; num banks
        ;BCC loop
        bcs sk2
        jmp loop
sk2:        

        ; test done, return

        LDA #$00        ; return 0
i3495 = * + 1   ; fail 1
        BIT $01A9       ; lda #1
i3498 = * + 1   ; fail 2
        BIT $02A9       ; lda #2
i3498a = * + 1   ; fail 3
        BIT $03A9       ; lda #3
        STA SB

        ldx #0
-
        lda $df00,x
        sta $0400+(7*40),x
        lda i5000,x
        sta $0400+(7*40)+20,x
        lda #$84
        sta i5000+xferlen,x
        inx
        cpx #$10
        bne -

        LDA #$00
        STA $D015
        LDA #$00
        STA $FF00
        PLP
        RTS

