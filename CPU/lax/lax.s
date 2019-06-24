
NUM_TESTS = $20

STRIDE_A   = 13
STRIDE_IMM = $100 - 1

START_A    = 0
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
irqline=$1C
}

lax_constant          = $02
lax_unstable          = $03
lax_stable            = $04
lax_resultX           = $05
lax_expected_resultX  = $06
lax_resultA           = $07
lax_expected_resultA  = $08

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
        
        lda #$0f
        ldx #0
-
        sta $d800+(40*5),x
        sta $d800+(40*15),x
        inx
        cpx #(40*4)
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


        ; make sure this happens in border
-       lda $d011
        bpl -
-       lda $d011
        bmi -
        
        lda #0
        ;lax #$ff
        !byte $ab
        !byte $ff
        sta lax_constant
                
        SEI
; timer NMI and IRQ off
        LDA     #$7F
        STA     $DC0D
        STA     $DD0D
; set NMI
        LDA     #<nmi0
        LDX     #>nmi0
        STA     $FFFA
        STX     $FFFB
; set IRQ0
        LDA     #<irq0
        LDX     #>irq0
        STA     $FFFE
        STX     $FFFF
; all RAM
        LDA     #$35
        STA     $01
; raster IRQ on
        LDA     #1
        STA     $D01A

        lda #irqline
        STA     $D012
        LDA     #$1B
        STA     $D011
; timer NMI on
; it triggers on next cycle to disable RESTORE
        LDX     #$81
        STX     $DD0D
        LDX     #0
        STX     $DD05
        INX
        STX     $DD04
        LDX     #$DD
        STX     $DD0E
; setup sprite
        LDx     #$A0 ;
        STx     $D000
        inx
        STx     $D002
        inx
        STx     $D004
        inx
        STx     $D006
        inx
        STx     $D008
        inx
        STx     $D00a
        inx
        STx     $D00c
        inx
        STx     $D00e
        LDx     #irqline+2
        STx     $D001
        inx
        STx     $D003
        inx
        STx     $D005
        inx
        STx     $D007
        inx
        STx     $D009
        inx
        STx     $D00b
        inx
        STx     $D00d
        inx
        STx     $D00f

        LDA     #spriteblock / 64
        STA     $7F8
        STA     $7F9
        STA     $7Fa
        STA     $7Fb
        STA     $7Fc
        STA     $7Fd
        STA     $7Fe
        STA     $7Ff

        LDx     #$1
        STx     $D027
        inx
        STx     $D028
        inx
        STx     $D029
        inx
        STx     $D02a
        inx
        STx     $D02b
        inx
        STx     $D02c
        inx
        STx     $D02d
        inx
        STx     $D02e

!if SPRITES=1 {
!if BORDER=0 {
        lda #11
        ldx #2
-
        sta $d800+(40*5)+6+43,x
        sta $d800+(40*10)+6+43,x
        sta $d800+(40*15)+6+43,x
        sta $d800+(40*20)+6+43,x
        dex
        bpl -
}
!if BORDER=0 {
COLSOFFS=0
}else{
COLSOFFS=5
}
        lda #12
        sta $d800+(40*5)+3+COLSOFFS
        sta $d800+(40*10)+3+COLSOFFS
        sta $d800+(40*15)+3+COLSOFFS
        sta $d800+(40*20)+3+COLSOFFS

        sta $d800+(40*5)+3+3+52
        sta $d800+(40*10)+3+3+52
        sta $d800+(40*15)+3+3+52
        sta $d800+(40*20)+3+3+52
        
        sta $d800+(40*5)+3+3+52+52
        sta $d800+(40*10)+3+3+52+52
        sta $d800+(40*15)+3+3+52+52
        sta $d800+(40*20)+3+3+52+52
}
        
        LDA     #$16
        STA     $D018
        LDA     #$1B
        STA     $D011

!if SPRITES=1 {
        LDA     #$ff
} else {
        LDA     #0
}
        STA     $D015

        LDA     #0
        STA     $D010
        STA     $D017
        STA     $D01B
        STA     $D01C
        STA     $D01D
        STA     $D020
        STA     $D021

        LDA     #$7F
        STA     $DC0D
        STA     $DD0D

        lda     $dc0d
        lda     $dd0d
        inc     $d019

        cli
        jmp *

textline:
         ;1234567890123456789012345678901234567890
    !scr "a:.. imm:.. con:.. rA:.. rX:.. unstbl:.."
        
;----------------------------------------------------------------------------

nmi0:
        rti

;----------------------------------------------------------------------------

        !align 255,0
irq0:
        ; stabilize (double irq)
        LDA     #<irq1
        LDX     #>irq1
        STA     $FFFE
        STX     $FFFF
        INC     $D012
        ASL     $D019
        TSX
        CLI
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP

irq1:
        TXS

        LDX     #8
-
        DEX
        BNE     -
        BIT     $ea

        LDA     $D012
        CMP     $D012
        BEQ     +
+
        ; irq is stable now
!if SPRITES=1 {
        LDA     #$ff
} else {
        LDA     #0
}
        sta $d015


        LDA     #$01
        STA     $D020
        STA     $D021

        inc $d021
        inc $d021
        inc $d021
        
offs:   lda     #0
        jsr docycles

        inc $d021

        ; args for LAX
        clc
        cld
                
lax_a = * + 1
        lda #START_A
lax_imm = * + 1
        ;lax #$ff
        !byte $ab, START_IMM

        sta lax_resultA
        stx lax_resultX
        
        php
        pla

        sta fpres0+1
        
        ; show result
        inc $d021

        ;ldx #0
        ldx offs+1

        ; on first frame write results to screen
        lda testframes
        bne tf1

        lda lax_resultA
        sta $0400+(40*5),x

        lda lax_resultX
        sta $0400+(40*15),x

fpres0: lda #0
        sta $0400+(40*20),x
tf1:

        ; on second frame compare against from last frame
        lda testframes
        beq tf2
        
        lda lax_resultA
        cmp $0400+(40*5),x
        beq +
        inc $0400+(40*0),x
+
        lda fpres0+1
        cmp $0400+(40*20),x
        beq +
        inc $0400+(40*0),x
+
tf2:

        lda $0400+(40*5)
        eor $0400+(40*5),x
        sta $0400+(40*10),x

        inc $d020
        
        ; compute expected result
        lda lax_a
        ora lax_constant
        and lax_imm
        sta lax_expected_resultA
        sta lax_expected_resultX
                
        ; compute unstable bits
        lda lax_a
        eor #$ff
        and lax_imm
        sta lax_unstable
        eor #$ff
        sta lax_stable

        inc $d020
        
        sed
        lda lax_a
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+3
        lda lax_a
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
        lda lax_imm
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+10
        lda lax_imm
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+9
        cld

        inc $d020
        
        sed
        lda lax_resultA
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+23
        lda lax_resultA
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+22
        cld

        inc $d020
        
        sed
        lda lax_resultX
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+29
        lda lax_resultX
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
        lda lax_constant
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+17
        lda lax_constant
        lsr
        lsr
        lsr
        lsr
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+16
        cld

        inc $d020
        
        sed
        lda lax_unstable
        and #$0f
        cmp #$0a
        adc #$30
        sta $0400+(24*40)+39
        lda lax_unstable
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
        ldy #13
        lda lax_resultA
        eor lax_expected_resultA
        and lax_stable
        beq +
        ldy #10
+
        ; result in A and X must be equal
        lda lax_resultA
        cmp lax_resultX
        beq +
        ldy #10
+
        sty $d800+(24*40)+22
        sty $d800+(24*40)+23
        sty $d800+(24*40)+28
        sty $d800+(24*40)+29

        cpy #10
        bne +
        lda #1
        sta failedtests
+ 
        ; check if constant behaves as desired (works for blackmail-fli)
        ; for blackmali-fli to work bits 0,1,2 must be 1s
        ldy #13
        ldx lax_constant
        lda constbits,x
        bne +
        ldy #10
+
        sty $d800+(24*40)+17
        sty $d800+(24*40)+16

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

        ; prepare first frame/offset
        lda #0
        sta offs+1

        jsr nexttest
+

bordercolor = * + 1
        lda #0
        sta $d020
        sta $d021

        LDA     #$F0
-
        CMP     $D012
        BNE     -

        lda #$0b
        sta $d020
        sta $d021
        
        ; open lower border
        LDA     #$F8

-
        CMP     $D012
        BNE     -

        LDA     #$13
        STA     $D011

        LDA     #$FC
-
        CMP     $D012
        BNE     -

        inc $d020
        inc $d021

        lda #0
        sta $d015

        lda #0
        ;lax #$ff
        !byte $ab
        !byte $ff
        sta lax_constant
                
        lda #$0
        sta $d020
        sta $d021
        
        
        LDA     #$1B
        STA     $D011

        ; set IRQ back to IRQ0
!if BORDER = 1 {
        LDA     #$1C
} else {
        LDA     #$34
}
        STA     $D012

        LDA     #<irq0
        LDX     #>irq0
        STA     $FFFE
        STX     $FFFF
        ASL     $D019
        RTI

nexttest:        
        lda lax_imm
        clc
        adc #STRIDE_IMM
        sta lax_imm

        lda lax_a
        clc
        adc #STRIDE_A
        sta lax_a
        
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
                               ; = 19 (min, A=$ff) ... 274 (max, A=$00)
;-------------------------------------------------------------------------------

testframes: !byte 0

        !align 255, 0
constbits:
    !for n, 0, 255 {
        !if ((n & 7) = 7) {
            !byte 1
        } else {
            !byte 0
        }
    }
