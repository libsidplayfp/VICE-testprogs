;----------------------------------------------------------------------------
; SHX/SHY "stable" behaviour check
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

testpage = $c000
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

                ldx #0
-
                lda #0
                sta testpage,x
                sta testpage+$0100,x
                sta testpage+$0200,x
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

                ldx #1
                stx testpage+$0001
                inx
                stx testpage+$0101
                inx
                stx testpage+$0201

; disable sprites and wait for border area
                LDA     #0
                STA     $D015
                JSR     waitvbl

; do the actual test
                LDA     #$FF

                !if (opcode = $9c) {
                TAY
                LDX     #2
                ; addr + X     = Y   & H+1
                ; testbase + X = $ff & $c1

                ; SHY     testbase,X    ; 5 cycles
                !byte $9c, <testbase, >testbase
                }
                !if (opcode = $9e) {
                TAX
                LDY     #2
                ; addr + Y     = X   & H+1
                ; testbase + Y = $ff & $c1

                ; SHX     testbase,Y    ; 5 cycles
                !byte $9e, <testbase, >testbase
                }

                ldy     #3
                LDA     $C201
                CMP     #$03
                BNE     skpfail
                dey
                LDA     $C101
                CMP     #$C1
                BNE     skpfail
                DEY
                LDA     $C001
                CMP     #$01
                BNE     skpfail
                DEY
skpfail:

; show result
                TYA
                sta     $0400

                ldy     #10     ; fail
                cmp     #0
                bne     +
                ldy     #5      ; pass
+
                sty     $d020

                ldx #0
-
                lda testpage,x
                sta $0400+(1*40),x
                lda testpage+$0100,x
                sta $0400+(8*40),x
                lda testpage+$0200,x
                sta $0400+(15*40),x
                inx
                bne -

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

