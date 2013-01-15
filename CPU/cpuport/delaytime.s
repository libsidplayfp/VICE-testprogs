    .macpack longbranch
    .export Start

scp = $02

Start:
        sei

        lda #$20
        ldx #0
lp1:
        sta $0400,x
        sta $0500,x
        sta $0600,x
        sta $0700,x
        inx
        bne lp1

mainloop:
        ; stop timers
        lda #%00000000
        sta $dc0e
        lda #%01000000
        sta $dc0f
        
        lda #$ff
        sta $dc04
        sta $dc05
        sta $dc06
        sta $dc07

        ; force load and start chained timers
        lda #%00010001
        sta $dc0e
        lda #%01010001
        sta $dc0f

        lda #$ff
        sta 0
        sta 1
        lda #$00
        sta 0

loop:
        jsr gettimers

        lda #>$0400
        sta scp+1
        lda #<$0400
        sta scp+0
        jsr timerout

        lda 1
        sta tmp1+1
        ldy #10
        jsr hexout

tmp1:   lda #0
        and #$80
        jne loop

        ; stop timers
        lda #%00000000
        sta $dc0e
        lda #%01000000
        sta $dc0f

        jsr gettimers

        lda #>$0428
        sta scp+1
        lda #<$0428
        sta scp+0
        jsr timerout

        lda 1
        ldy #10
        jsr hexout

        jmp mainloop

gettimers:
        lda $dc04
        eor #$ff
        sta val+3
        lda $dc05
        eor #$ff
        sta val+2
        lda $dc06
        eor #$ff
        sta val+1
        lda $dc07
        eor #$ff
        sta val+0
        rts

timerout:
        ldy #0
        lda val+0
        jsr hexout
        lda val+1
        jsr hexout
        lda val+2
        jsr hexout
        lda val+3
        jsr hexout
        rts
        
hexout:
        pha
        lsr
        lsr
        lsr
        lsr
        tax
        lda hexval,x
        sta (scp),y
        iny
        pla
        and #$0f
        tax
        lda hexval,x
        sta (scp),y
        iny
        rts

hexval:
        .byte "0123456789"
        .byte 1,2,3,4,5,6
        
val:
        .byte 0,0,0,0