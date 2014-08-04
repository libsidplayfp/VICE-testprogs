;----------------------------------------------------------------------------
; SHS "stable" behaviour check
; inspired by emulamers "bad copy"
;----------------------------------------------------------------------------

basicstart = $0801

                * = basicstart
                !word basicstart + $0c
                !byte $0a, $00
                !byte $9e

                !byte $32, $30, $36, $32

                !byte 0,0,0

                * = basicstart + $0d

;----------------------------------------------------------------------------

zp_testbase = $f0

testbase = $c0ff

start:

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

                lda     #<testbase
                sta     zp_testbase
                lda     #>testbase
                sta     zp_testbase+1

; disable sprites and wait for border area
                LDA     #0
                STA     $D015
                JSR     waitvbl

                tsx
                stx     spsave+1

; do the actual test
                LDA     #$FF
                STA     $C201

                ;TAX
                ;LDY     #2
                ;SHS     $C0FF,Y

                TAX
                LDY     #2

                ; SP = A & X
                ; addr + Y = SP & H+1

                ; testbase + Y = (SP = A & X) & $c1

                ; SHS     testbase,Y    ; 5 cycles
                !byte $9b, <testbase, >testbase

                DEY
                LDA     $C201
                CMP     #$FF
                BNE     skpfail
                LDA     $C101
                CMP     #$C1
                BNE     skpfail
                DEY
skpfail:

spsave:         ldx     #0
                txs

; show result
                TYA
                sta     $0400

                ldy     #10     ; fail
                cmp     #0
                bne     +
                ldy     #5      ; pass
+
                sty     $d020

                jmp *

;----------------------------------------------------------------------------

irq0:
nmi0:
                rti

waitvbl:
                LDA     $D011
                BMI     waitvbl

-
                LDA     $D011
                BPL     -
                RTS

