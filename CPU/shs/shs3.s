;----------------------------------------------------------------------------
; SHX/SHY "unstable" behaviour check
; inspired by emulamers "bad copy"
;----------------------------------------------------------------------------

basicstart = $0801

;testpatternlen = 21 + 2
;testpatternlen = $18

                * = basicstart
                !word basicstart + $0c
                !byte $0a, $00
                !byte $9e

                !byte $32, $30, $36, $32

                !byte 0,0,0

                * = basicstart + $0d

;----------------------------------------------------------------------------

zp_testbase = $f0
;patternbase = $f3

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
                lda #$ff
                sta $0c00,x
                dex
                bne -

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
                LDA     #$1C
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
                LDA     #$A0 ;
                STA     $D006
                LDA     #$1E
                STA     $D007

                LDA     #$33 ;sprite pointer
                STA     $7FB

                LDA     #$D
                STA     $D02A
                LDA     #$16
                STA     $D018
                LDA     #$1B
                STA     $D011

                LDA     #8
                STA     $D015

 ;               lda     #<testpattern
 ;               STA     patternbase
 ;               lda     #>testpattern
 ;               STA     patternbase+1

                lda     #<testbase
                sta     zp_testbase
                lda     #>testbase
                sta     zp_testbase+1

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
                inc     $d019

                cli
                jmp *

;----------------------------------------------------------------------------

nmi0:
                rti

waitvbl:
                LDA     $D011
                BMI     waitvbl

loc_E35:
                LDA     $D011
                BPL     loc_E35
                RTS

;----------------------------------------------------------------------------

                * = $0900
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


                LDA     #$01
                STA     $D020

offs:           lda     #0
                jsr docycles

                inc $d020

; second test
                tsx
                stx     spsave+1

                LDA #$ff
                tax
                ldy offs+1

                !if (opcode = $9b) {
                ; SP = A & X
                ; addr + Y = SP & H+1

                ; testbase + Y = (SP = A & X) & $11

                ; in cycles where sprite dma stops the opcode the & H+1 drops off

                ; SP = A & X
                ; addr + Y = SP

                ; testbase + Y = (SP = A & X)

                ; SHS     testbase,Y    ; 5 cycles
                !byte $9b, <testbase, >testbase
                }
                tsx
                stx spres+1

spsave:         ldx     #0
                txs

                ; show result
                inc $d020

                ;ldx #0
                ldx offs+1

spres:          lda #0
                sta $0400+(40*18),x

                lda testbase,x
                sta $0400+(40*10),x

                ldy #5
                cmp reference,x
                beq +
                ldy #10
                sty bordercolor+1
+
                tya
                sta $d800+(40*10),x

                lda reference,x
                sta $0400+(40*2),x

                inc offs+1
                bne notlast

bordercolor:
                lda #5
                sta realbordercolor+1

    ldx #0 ; success
    cmp #5
    beq nofail
    ldx #$ff ; failure
nofail:
    stx $d7ff

notlast:

realbordercolor:
                lda #0
                sta $d020

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

                LDA     #$1B
                STA     $D011

; set IRQ back to IRQ0
                LDA     #$1C
                STA     $D012

                LDA     #<irq0
                LDX     #>irq0
                STA     $FFFE
                STX     $FFFF
                ASL     $D019
                RTI

                * = $0f00
docycles:

         lsr                    ; 2
         sta timeout+1          ; 4
         bcc timing             ; 2+1   (one additional cycle for odd counts)
timing:  clv                    ; 2
timeout: bvc timeout            ; 3     (jumps always)
         !for i,127 {
         nop                    ; 2
         }
         rts                    ; 6
                                ; = 19 (min, A=$ff) ... 274 (max, A=$00)

                * = $1000
reference:
                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $ff

                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12, $12, $ff

                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12, $12, $ff, $12

                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12, $ff, $12

                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12
                !byte $12, $12, $12, $12, $12, $12, $12, $12, $12, $12
                !byte $12, $12, $12, $ff, $12

                * = $1100
testbase: