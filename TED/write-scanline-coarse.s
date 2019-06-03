        .word   $1001
        *=$1001

        ;; Tests writes to #ff1d, which reassigns the scanline.
        ;; The intended result is to expand the border out and confuse
        ;; the line numebring.

        ;; WARNING: This code softlocks the console after running.
        ;; WARNING: This code has not been tested on actual hardware.
        .word   next, 10
        .byte   $de,$20,$9c,$3a,$9e,$20,"4114",0
next    .word   0

        ;; Set up screen
        ldy     #$00
textlp  lda     msg,y
        beq     textend
        jsr     $ffd2
        iny
        bne     textlp
textend        
        ;; Set up IRQ
        sei
        lda     #$02
        sta     $ff0a
        lda     #$00
        sta     $ff0b
        lda     #<irq
        sta     $0314
        lda     #>irq
        sta     $0315
        cli
        rts

irq     ldx     counter
        lda     sims,x
        sta     $ff1d
        lda     lines,x
        sta     $ff0b
        beq     loop
        inx
        stx     counter
        bne     irq_postlude
loop    sta     counter

        ;; Bug: This aborts normal IRQ processing so the system
        ;; remains in a softlocked state
irq_postlude
        pla
        tay
        pla
        tax
        pla
        inc     $ff09
        rti

lines   .byt    90,30,210,0
sims    .byt    10,0,190,130
        
colors  .byt    $e2,$e3,$e4,$e5,$e7,$e1,$ee        
        
counter .byt    0

msg     .byt    147,"0",13,"1",13,"2",13,"3",13,"4",13,"5",13,"6",13
        .byt    "7",13,"8",13,"9",13,"10",13,"11",13,"12",13,"13",13
        .byt    "14",13,"15",13,"16",13,"17",13,"18",13,"19",13,"20",13,0
