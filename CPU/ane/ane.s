
        !cpu 6510

basicstart = $0801

        * = basicstart
        !word next
        !byte $0a, $00
        !byte $9e

        !byte $32, $30, $36, $31
next:
        !byte 0,0,0

        jmp start

;----------------------------------------------------------------------------

!if BORDER=0 {
irqline=$34
} else {
irqline=$1c
}

ane_constant = $02

spriteblock = $0800

        * = $0900
start:
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
        dex
        bne -

        lda #$ff
        ldx #$3f
-
        sta spriteblock,x
        dex
        bpl -

!if SPRITES=1{
        
!if BORDER=0{
coloffs1=0
}else{
coloffs1=5
}
        
        lda #12
        ldx #0
-
        sta $d800+(40*10)+coloffs1+5,x
        sta $d800+(40*11)+coloffs1+5,x
        sta $d800+(40*18)+coloffs1+5,x
        sta $d800+(40*19)+coloffs1+5,x
        dex
        bpl -

        lda #15
        ldx #1
-
        sta $d800+(40*10)+coloffs1+0,x
        sta $d800+(40*11)+coloffs1+0,x
        sta $d800+(40*18)+coloffs1+0,x
        sta $d800+(40*19)+coloffs1+0,x
        
        sta $d800+(40*10)+coloffs1+15,x
        sta $d800+(40*11)+coloffs1+15,x
        sta $d800+(40*18)+coloffs1+15,x
        sta $d800+(40*19)+coloffs1+15,x
        dex
        bpl -
}
        
        ; make sure this happens in border
-       lda $d011
        bpl -
-       lda $d011
        bmi -
        
        lda #0
        ldx #$ff
        ane #$ff
        sta ane_constant

        sei
        ; timer nmi and irq off
        lda     #$7f
        sta     $dc0d
        sta     $dd0d
        ; set nmi
        lda     #<nmi0
        ldx     #>nmi0
        sta     $fffa
        stx     $fffb
        ; set irq0
        lda     #<irq0
        ldx     #>irq0
        sta     $fffe
        stx     $ffff
        ; all ram
        lda     #$35
        sta     $01
        ; raster irq on
        lda     #1
        sta     $d01a

        lda     #irqline
        sta     $d012
        lda     #$1b
        sta     $d011
        ; timer nmi on
        ; it triggers on next cycle to disable restore
        ldx     #$81
        stx     $dd0d
        ldx     #0
        stx     $dd05
        inx
        stx     $dd04
        ldx     #$dd
        stx     $dd0e

        ; setup sprite
        ldx     #$a0 ;
        stx     $d000
        inx
        stx     $d002
        inx
        stx     $d004
        inx
        stx     $d006
        inx
        stx     $d008
        inx
        stx     $d00a
        inx
        stx     $d00c
        inx
        stx     $d00e
        ldx     #irqline+2
        stx     $d001
        inx
        stx     $d003
        inx
        stx     $d005
        inx
        stx     $d007
        inx
        stx     $d009
        inx
        stx     $d00b
        inx
        stx     $d00d
        inx
        stx     $d00f

        lda     #spriteblock / 64
        sta     $7f8
        sta     $7f9
        sta     $7fa
        sta     $7fb
        sta     $7fc
        sta     $7fd
        sta     $7fe
        sta     $7ff

        ldx     #$1
        stx     $d027
        inx
        stx     $d028
        inx
        stx     $d029
        inx
        stx     $d02a
        inx
        stx     $d02b
        inx
        stx     $d02c
        inx
        stx     $d02d
        inx
        stx     $d02e

        lda     #$16
        sta     $d018
        lda     #$1b
        sta     $d011
!if SPRITES=1 {
        lda     #$ff
} else {
        lda     #0
}
        sta     $d015

        lda     #0
        sta     $d010
        sta     $d017
        sta     $d01b
        sta     $d01c
        sta     $d01d
        sta     $d020
        sta     $d021

        lda     #$7f
        sta     $dc0d
        sta     $dd0d

        lda     $dc0d
        inc     $d019

        cli
        jmp *

;----------------------------------------------------------------------------

nmi0:
        rti

waitvbl:
        lda     $d011
        bmi     waitvbl

loc_e35:
        lda     $d011
        bpl     loc_e35
        rts

;----------------------------------------------------------------------------

        !align 255,0
irq0:
        ; stabilize (double irq)
        lda     #<irq1
        ldx     #>irq1
        sta     $fffe
        stx     $ffff
        inc     $d012
        asl     $d019
        tsx
        cli
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop

irq1:
        txs

        ldx     #8
-
        dex
        bne     -
        bit     $ea

        lda     $d012
        cmp     $d012
        beq     +
+
        ; irq is stable now
!if SPRITES=1 {
        lda     #$ff
} else {
        lda     #0
}
        sta $d015


        lda     #$01
        sta     $d020
        sta     $d021

        inc $d021
        inc $d021
        inc $d021
        
offs:           lda     #0
        jsr docycles

        inc $d021

        ; args for ane
        clc
        cld
ane_a = * + 1
        lda #$ff
ane_x = * + 1
        ldx #$ff
ane_imm = * + 1
        ane #$ff

        sta spres0+1
        
        php
        pla

        sta fpres0+1
        
        ; show result
        inc $d021

        ;ldx #0
        ldx offs+1

        lda testframes
        bne tf1
spres0:          lda #0
        sta $0400+(40*10),x

fpres0:          lda #0
        sta $0400+(40*18),x
tf1
        lda testframes
        beq tf2
        
        lda spres0+1
        cmp $0400+(40*10),x
        beq +
        inc $0400+(40*2),x
+
        lda fpres0+1
        cmp $0400+(40*18),x
        beq +
        inc $0400+(40*2),x
+
tf2

        lda $0400+(40*10)
        eor $0400+(40*10),x
        sta $0400+(40*10)+40,x

        lda $0400+(40*18)
        eor $0400+(40*18),x
        sta $0400+(40*18)+40,x

!if BORDER=0 {
        ldx #5
} else {
        ldx #10
}
        cpx offs+1
        bne notedge

        lda ane_a
        ora ane_constant
        and ane_x
        and ane_imm
        sta $0400+(40*10)+80-1,x

!if SPRITES=1 {
        ; rdy
        lda ane_a
        ora ane_constant
        and #$ee
        and ane_x
        and ane_imm
        sta $0400+(40*10)+80,x
} else {
        sta $0400+(40*10)+80,x
}
        
        lda $0400+(40*10)
        eor $0400+(40*10)+80-1,x
        sta $0400+(40*10)+40*3-1,x

        lda $0400+(40*10)
        eor $0400+(40*10)+80,x
        sta $0400+(40*10)+40*3,x

        ldy #13
        lda $0400+(40*10)+40-1,x
        cmp $0400+(40*10)+40*3-1,x
        beq +
        ldy #10
+
        tya
        sta $d800+(40*10)+40*3-1,x
        
        ldy #13
        lda $0400+(40*10)+40,x
        cmp $0400+(40*10)+40*3,x
        beq +
        ldy #10
+
        tya
        sta $d800+(40*10)+40*3,x

notedge

        sed
        lda ane_a
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+20
        lda ane_a
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+19
        cld
                
        sed
        lda ane_x
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+23
        lda ane_x
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+22
        cld
                
        sed
        lda ane_imm
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+26
        lda ane_imm
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+25
        cld
        
        inc testframes
        lda testframes
        cmp #2
        bne +

        lda #0
        sta testframes
        
        inc offs+1
        lda offs+1
        cmp #40
        bne +

        lda #0
        sta offs+1
        
        inc ane_a
        dec ane_x
        ;inc ane_imm
+
        
        lda #0
        sta $d020
        sta $d021
        
        ; open lower border
        lda     #$f8
-
        cmp     $d012
        bne     -

        lda     #$13
        sta     $d011

        lda     #$fc
-
        cmp     $d012
        bne     -

        inc $d020
        inc $d021

        lda #0
        sta $d015

        ; re-read the magic constant
        lda #0
        ldx #$ff
        ane #$ff
        sta ane_constant
                
        sed
        lda ane_constant
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+39
        lda ane_constant
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+38
        cld
                
        dec $d020
        dec $d021

        lda     #$1b
        sta     $d011

        ; set irq back to irq0
!if BORDER = 1 {
        lda     #$1c
} else {
        lda     #$34
}
        sta     $d012

        lda     #<irq0
        ldx     #>irq0
        sta     $fffe
        stx     $ffff
        asl     $d019
        rti

;-------------------------------------------------------------------------------
        !align 255, 0
docycles:
        lsr                    ; 2
        sta timeout+1          ; 4
        bcc timing             ; 2+1   (one additional cycle for odd counts)
timing: clv                    ; 2
timeout:
        bvc timeout            ; 3     (jumps always)
        !for i,127 {
        nop                    ; 2
        }
        rts                    ; 6
                               ; = 19 (min, a=$ff) ... 274 (max, a=$00)
;-------------------------------------------------------------------------------

testframes: !byte 0

