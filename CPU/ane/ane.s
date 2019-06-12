
NUM_TESTS = $20

STRIDE_A = 13
STRIDE_IMM = $100 - 1
STRIDE_X = $100 - 3

;STRIDE_A   = 0
;STRIDE_X   = 0
;STRIDE_IMM = 0

START_A    = 0
START_X    = $ff
START_IMM  = $ff

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

ane_constant          = $02
ane_unstable          = $03
ane_stable            = $04
ane_result            = $05
ane_expected_result   = $06
ane_status            = $07

spriteblock = $0800

        * = $0900
start:
        ldx #0
        stx $3fff
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

        ldx #39
-
        lda textline,x
        sta $0400+(24*40),x
        dex
        bpl -
        
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

textline:
         ;1234567890123456789012345678901234567890
    !scr "a:.. x:.. imm:.. con:.. res:.. unstbl:.."
        
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
        lda #$ff
} else {
        lda #0
}
        sta $d015


        lda #$01
        sta $d020
        sta $d021

        inc $d021
        inc $d021
        inc $d021
        
offs:   lda     #0
        jsr docycles

        inc $d021

        ; args for ane
        clc
        cld
ane_a = * + 1
        lda #START_A
ane_x = * + 1
        ldx #START_X
ane_imm = * + 1
        ane #START_IMM

        sta ane_result
        
        php
        pla

        sta ane_status
        
        ; show result
        inc $d021

        ;ldx #0
        ldx offs+1

        ; on first frame write results to screen
        lda testframes
        bne tf1

        lda ane_result
        sta $0400+(40*10),x   ;ane_result
        lda ane_status
        sta $0400+(40*18),x   ;status
tf1
        ; on second frame compare against from last frame
        lda testframes
        beq tf2
        
        lda ane_result
        cmp $0400+(40*10),x   ;ane_result
        beq +
        inc $0400+(40*2),x
+
        lda ane_status
        cmp $0400+(40*18),x
        beq +
        inc $0400+(40*2),x
+
tf2

        lda $0400+(40*10)      ;first ane_result
        eor $0400+(40*10),x    ;ane_result
        sta $0400+(40*10)+40,x ;different ane_result bits

        lda $0400+(40*18)      ;first status
        eor $0400+(40*18),x    ;status
        sta $0400+(40*18)+40,x ;different status bits

!if BORDER=0 {
        ldx #5
} else {
        ldx #10
}
        cpx offs+1
        bne notedge

        ; compute expected result
        lda ane_a
        ora ane_constant
        and ane_x
        and ane_imm
        sta $0400+(40*10)+80-1,x        ; expected ane_result

        lda $0400+(40*10)               ; first ane_result
        eor $0400+(40*10)+80-1,x        ; expected ane_result
        sta $0400+(40*10)+120-1,x       ; different bits

        ldy #13
        lda $0400+(40*10)+40-1,x       ;different ane_result bits
        cmp $0400+(40*10)+120-1,x
        beq +
        ldy #10
+
        tya
        sta $d800+(40*10)+120-1,x
        
!if SPRITES=1 {
        ; rdy
        lda ane_constant
        and #$ee                        ; bit 4 and bit 0 may drop in rdy cycle
        ora ane_a
        and ane_x
        and ane_imm
        sta $0400+(40*10)+80,x
} else {
        sta $0400+(40*10)+80-1,x        ; expected ane_result
        sta $0400+(40*10)+80,x
}
        lda $0400+(40*10)
        eor $0400+(40*10)+80,x
        sta $0400+(40*10)+120,x
        
        ldy #13
        lda $0400+(40*10)+40,x
        cmp $0400+(40*10)+120,x
        beq +
        ldy #10
+
        tya
        sta $d800+(40*10)+120,x

notedge

        inc $d020

        ; compute unstable bits
        lda ane_a
        eor #$ff
        and ane_x
        and ane_imm
        sta ane_unstable
        eor #$ff
        sta ane_stable

        ; compute expected result
        lda ane_a
        ora ane_constant
        and ane_x
        and ane_imm
        sta ane_expected_result

        inc $d020
        
        sed
        lda ane_a
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+3
        lda ane_a
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+2
        cld

        inc $d020
        
        sed
        lda ane_x
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+8
        lda ane_x
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+7
        cld

        inc $d020
        
        sed
        lda ane_imm
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+15
        lda ane_imm
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+14
        cld

        inc $d020
        
        sed
        lda ane_constant
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+22
        lda ane_constant
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+21
        cld

        inc $d020
        
        sed
        lda ane_result
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+29
        lda ane_result
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+28
        cld

        inc $d020
        
        sed
        lda ane_unstable
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+39
        lda ane_unstable
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+38
        cld

        inc $d020
        
        ; check if stable bits are the expected result
        ldy #10
        lda ane_result
        eor ane_expected_result
        and ane_stable
        bne +
        ldy #13
+
        sty $d800+(24*40)+28
        sty $d800+(24*40)+29

        cpy #10
        bne +
        lda #1
        sta failedtests
+        
        
        ; check if constant behaves as desired (works for spectipede and turrican3)
        ; for spectipede to load the high nybble of the constant must be $4,$5,$e or $f 
        ; and bit 0 must be 1, bits 3,2,1 are "don't care".
        ; for turrican3 bit0 and bit1 must be 1
        ldy #13
        ldx ane_constant
        lda constbits,x
        bne +
        ldy #10
+
        sty $d800+(24*40)+22
        sty $d800+(24*40)+21

        cpy #10
        bne +
        lda #1
        sta failedtests
+        
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
        
        jsr nexttest
        
+
        
bordercolor = * + 1
        lda #$00
        sta $d020
        sta $d021

        lda     #$f0
-
        cmp     $d012
        bne     -

        lda #$0b
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

        lda #0
        sta $d020
        sta $d021

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

nexttest:

        lda ane_imm
        clc
        adc #STRIDE_IMM
        sta ane_imm

        lda ane_a
        clc
        adc #STRIDE_A
        sta ane_a

        lda ane_x
        clc
        adc #STRIDE_X
        sta ane_x

testcount = * + 1
        lda #0
        cmp #NUM_TESTS
        bne ++

        ldy #0
        ldx #5
        
failedtests = * + 1
        lda #0
        beq +
        ldy #$ff
        ldx #2
+
        sty $d7ff
        stx bordercolor
++        
        inc testcount

        rts
        
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

        !align 255, 0
constbits:
    !for n, 0, 255 {
        !if (((n & 3) = 3) & (((n & $f0) = $40) | ((n & $f0) = $50) | ((n & $f0) = $e0) | ((n & $f0) = $f0))) {
            !byte 1
        } else {
            !byte 0
        }
    }
