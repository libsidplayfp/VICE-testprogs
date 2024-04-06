framecount = $02

    !pseudopc PAYLOADLOC {

        ; Happify CPU ;-)
        sei
        cld
        ldx	#$ff
        txs

        ; we must set data first, then update DDR
        lda #$e7
        sta $01
        lda #$2f
        sta $00

        ; disable irq sources
        lda #$00
        sta $D01A
        lda #$1F
        sta $DC0D
        sta $DD0D
        ; clear pending irqs
        lda $D019
        sta $D019
        lda $DC0D
        lda $DD0D
        
        lda #$1b
        sta $d011
        
        lda #$3f
        sta $dd02
        lda #$03
        sta $dd00
        
        lda #$c8
        sta $d016
        
        lda #0
        sta $d021

        lda #$33
        sta $01
        
        !if CARTTYPE = 0 {  ; easyflash
        lda #%00000110      ; 8k game
        sta $de02
        }
        !if CARTTYPE = 1 {  ; retro replay
        lda #%00000001      ; 8k game
        sta $de00
        }
        
        ldy #$10
        ldx #0
-
        txa
        and #$0f
hb1:    sta $1000,x
        clc
        adc #$0f
hb2:    sta $2000,x
        clc
        adc #$0f
hb3:    sta $3000,x
        clc
        adc #$0f
hb4:    sta $4000,x
        clc
        adc #$0f
hb5:    sta $5000,x
        clc
        adc #$0f
hb6:    sta $6000,x
        clc
        adc #$0f
hb7:    sta $7000,x
        clc
        adc #$0f
hb8:    sta $8000,x
        clc
        adc #$0f
hb9:    sta $9000,x
        clc
        adc #$0f
hba:    sta $a000,x
        clc
        adc #$0f
hbb:    sta $b000,x
        clc
        adc #$0f
hbc:    sta $c000,x
        clc
        adc #$0f
hbd:    sta $d000,x
        clc
        adc #$0f
hbe:    sta $e000,x
        clc
        adc #$0f
hbf:    sta $f000,x
        inx
        bne -
        
        inc hb1+2
        inc hb2+2
        inc hb3+2
        inc hb4+2
        inc hb5+2
        inc hb6+2
        inc hb7+2
        inc hb8+2
        inc hb9+2
        inc hba+2
        inc hbb+2
        inc hbc+2
        inc hbd+2
        inc hbe+2
        inc hbf+2
        
        dey
        beq +
        jmp -
+
        lda #$35
        sta $01

        !if CARTTYPE = 0 {  ; easyflash
        !if MODE = 0 {
        lda #%00000101      ; ultimax
        }
        !if MODE = 1 {
        lda #%00000110      ; 8k
        }
        !if MODE = 2 {
        lda #%00000111      ; 16k
        }
        sta $de02
        }
        !if CARTTYPE = 1 {  ; retro replay
        !if MODE = 0 {
        lda #%00000011      ; ultimax
        }
        !if MODE = 1 {
        lda #%00000001      ; 8k
        }
        !if MODE = 2 {
        lda #%00000000      ; 16k
        }
        sta $de00
        }

        lda #$00
        ldx #0
-
        sta $da00,x
        sta $db00,x
        inx
        bne -

        ldx #0
-
        lda #1
        sta $d800,x
        lda #12
        sta $d800+(1*40),x
        lda #3
        sta $d800+(2*40),x
        lda #15
        sta $d800+(3*40),x
        lda #1
        sta $d800+(4*40),x
        lda #12
        sta $d800+(5*40),x
        lda #3
        sta $d800+(6*40),x
        lda #15
        sta $d800+(7*40),x
        lda #1
        sta $d800+(8*40),x
        lda #12
        sta $d800+(9*40),x
        lda #3 
        sta $d800+(10*40),x
        lda #15
        sta $d800+(11*40),x
        lda #1 
        sta $d800+(12*40),x
        lda #12
        sta $d800+(13*40),x
        lda #3 
        sta $d800+(14*40),x
        lda #15
        sta $d800+(15*40),x
        inx
        cpx #40
        bne -

        lda #0
        sta $d020
        
        lda #5
        sta framecount

        jmp freezestart
        
        !align 255,0,0
freezestart:
        
loop:

-       lda $d011
        bpl -
-       lda $d011
        bmi -

        ;lda #0
        ;sta $d020

        ldy #3
        sty $dd00
        ldx #$22        ; screen $0800 char $0800 
        stx $d018

        lda #$31+(0*8)
-       cmp $d012
        bne -
-       cmp $d012
        beq -

        ; inc $d020
        ldx #$66        ; screen $1800 char $1800

        lda #$31+(1*8)
-       cmp $d012
        bne -
-       cmp $d012
        beq -

        stx $d018
        ; inc $d020
        ldx #$aa        ; screen $2800 char $2800

        lda #$31+(2*8)
-       cmp $d012
        bne -
-       cmp $d012
        beq -

        stx $d018
;         inc $d020
        ldx #$ee        ; screen $3800 char $3800

        lda #$31+(3*8)
-       cmp $d012
        bne -
-       cmp $d012
        beq -

        stx $d018
        ; inc $d020
        ldy #2
        ldx #$22        ; screen $4800 char $4800

        lda #$31+(4*8)
-       cmp $d012
        bne -
;-       cmp $d012
;        beq -

        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        nop
        nop

        sty $dd00
        stx $d018
        
;         inc $d020
        ldx #$66        ; screen $5800 char $5800

        lda #$31+(5*8)
-       cmp $d012
        bne -
-       cmp $d012
        beq -

        stx $d018
        ; inc $d020
        ldx #$aa        ; screen $6800 char $6800

        lda #$31+(6*8)
-       cmp $d012
        bne -
-       cmp $d012
        beq -

        stx $d018
        ; inc $d020
        ldx #$ee        ; screen $7800 char $7800

        lda #$31+(7*8)
-       cmp $d012
        bne -
-       cmp $d012
        beq -

        stx $d018
        ; inc $d020
        ldy #1
        ldx #$22        ; screen $8800 char $8800

        lda #$31+(8*8)
-       cmp $d012
        bne -
;-       cmp $d012
;        beq -

        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        nop
        nop
        
        sty $dd00
        stx $d018

        ; inc $d020
        ldx #$66        ; screen $9800 char $9800

        lda #$31+(9*8)
-       cmp $d012
        bne -
-       cmp $d012
        beq -

        stx $d018
        ; inc $d020
        ldx #$aa        ; screen $a800 char $a800

        lda #$31+(10*8)
-       cmp $d012
        bne -
-       cmp $d012
        beq -

        stx $d018
        ; inc $d020
        ldx #$ee        ; screen $b800 char $b800

        lda #$31+(11*8)
-       cmp $d012
        bne -
-       cmp $d012
        beq -

        stx $d018
        ; inc $d020
        ldy #0
        ldx #$22        ; screen $c800 char $c800

        lda #$31+(12*8)
-       cmp $d012
        bne -
;-       cmp $d012
;        beq -

        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        bit $eaea
        nop
        nop
        
        sty $dd00
        stx $d018
        ; inc $d020
        ldx #$66        ; screen $d800 char $d800

        lda #$31+(13*8)
-       cmp $d012
        bne -
-       cmp $d012
        beq -

        stx $d018
        ; inc $d020
        ldx #$aa        ; screen $e800 char $e800

        lda #$31+(14*8)
-       cmp $d012
        bne -
-       cmp $d012
        beq -

        stx $d018
        ; inc $d020
        ldx #$ee        ; screen $f800 char $f800

        lda #$31+(15*8)
-       cmp $d012
        bne -
-       cmp $d012
        beq -

        stx $d018
        ; inc $d020

        lda #$31+(16*8)
-       cmp $d012
        bne -
-       cmp $d012
        beq -

        ; inc $d020
        
        lda #$ff
-       cmp $d012
        bne -
-       cmp $d012
        beq -

        ;lda #0
        ;sta $d020

        lda #$ff
        sta $dc02
        lda #$00
        sta $dc03
        
        lda #$7f
        sta $dc00
        
        lda $dc01
        cmp #%11111101 ; arrow left
        bne +

        !if CARTTYPE = 0 {  ; easyflash
        ldx #%00000101      ; ultimax
        stx $de02
        }
        !if CARTTYPE = 1 {  ; retro replay
        ldx #%00000011      ; ultimax
        stx $de00
        }
        
+
        cmp #%11111110 ; 1
        bne +
        
        !if CARTTYPE = 0 {  ; easyflash
        ldx #%00000110      ; 8k game
        stx $de02
        }
        !if CARTTYPE = 1 {  ; retro replay
        ldx #%00000001      ; 8k game
        stx $de00
        }
        
+
        cmp #%11110111 ; 2
        bne +
        
        !if CARTTYPE = 0 {  ; easyflash
        ldx #%00000111      ; 16k game
        stx $de02
        }
        !if CARTTYPE = 1 {  ; retro replay
        ldx #%00000000      ; 16k game
        stx $de00
        }
        
+
        dec framecount
        bne +
        lda #0
        sta $d7ff
+
        jmp loop

}
