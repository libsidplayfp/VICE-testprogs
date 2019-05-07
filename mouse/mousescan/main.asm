buffer = $2000

show0 = line0
show1 = line2
show2 = line1
show3 = line3

        * =  $801
        !byte  $B
        !byte	8
        !byte	0
        !byte	0
        !byte $9E
        !byte $32 ; 2
        !byte $30 ; 0
        !byte $36 ; 6
        !byte $34 ; 4
        !byte	0
        !byte	0
        !byte	0

        * = $0810
 
        ldx #0
-
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
        bne -
 
        lda #$0f
        ldx #40*2
-
        sta $d800+(2*40)-1,x
        sta $d800+(6*40)-1,x
        sta $d800+(10*40)-1,x
        sta $d800+(14*40)-1,x
        sta $d800+(18*40)-1,x
        dex
        bne -
 
        sei
        lda #$ff
        sta $dc00
        sta $dc01
        lda #0
        sta $dc02 ; port A input
        ;lda #0
        sta $dc03 ; port B input

        lda #>irq
        sta $0315
        lda #<irq
        sta $0314
        
        lda #<((63*312 / 32)-1)
        sta $dc04
        lda #>((63*312 / 32)-1)
        sta $dc05
        lda $dc0d
        cli
        
mainloop:
        ldy #0
-
        ldx buffer+(0*40),y
        lda show0,x
        sta $0400+(0*40),y
        lda show1,x
        sta $0400+(1*40),y
        lda show2,x
        sta $0400+(2*40),y
        lda show3,x
        sta $0400+(3*40),y
;        iny
;        cpy #40
;        bne -
;
;        ldy #0
;-
        ldx buffer+(1*40),y
        lda show0,x
        sta $0400+(0*40)+(1*160),y
        lda show1,x
        sta $0400+(1*40)+(1*160),y
        lda show2,x
        sta $0400+(2*40)+(1*160),y
        lda show3,x
        sta $0400+(3*40)+(1*160),y
;        iny
;        cpy #40
;        bne -
;
;        ldy #0
;-
        ldx buffer+(2*40),y
        lda show0,x
        sta $0400+(0*40)+(2*160),y
        lda show1,x
        sta $0400+(1*40)+(2*160),y
        lda show2,x
        sta $0400+(2*40)+(2*160),y
        lda show3,x
        sta $0400+(3*40)+(2*160),y
;        iny
;        cpy #40
;        bne -
;        
;        ldy #0
;-
        ldx buffer+(3*40),y
        lda show0,x
        sta $0400+(0*40)+(3*160),y
        lda show1,x
        sta $0400+(1*40)+(3*160),y
        lda show2,x
        sta $0400+(2*40)+(3*160),y
        lda show3,x
        sta $0400+(3*40)+(3*160),y
        iny
        cpy #40
        bne -

        ldy #0
-
        ldx buffer+(4*40),y
        lda show0,x
        sta $0400+(0*40)+(4*160),y
        lda show1,x
        sta $0400+(1*40)+(4*160),y
        lda show2,x
        sta $0400+(2*40)+(4*160),y
        lda show3,x
        sta $0400+(3*40)+(4*160),y
        iny
        cpy #40
        bne -

-       lda $dc00 ; Port A (Joy 2)
        and #$10
        bne -
        
        jmp mainloop
        
irq:
        inc $d020
        lda $dc00
bufferptr:
        sta buffer
        inc bufferptr+1
        dec $d020
        lda $dc0d
        jmp $febc
        
        
        * = $1000
        
line0:
    !for i, 0, 255 {
        !if (i and 1) {
            !byte "*"
        } else {
            !byte "."
        }
    }
line1:
    !for i, 0, 255 {
        !if (i and 2) {
            !byte "*"
        } else {
            !byte "."
        }
    }
line2:
    !for i, 0, 255 {
        !if (i and 4) {
            !byte "*"
        } else {
            !byte "."
        }
    }
line3:
    !for i, 0, 255 {
        !if (i and 8) {
            !byte "*"
        } else {
            !byte "."
        }
    }
