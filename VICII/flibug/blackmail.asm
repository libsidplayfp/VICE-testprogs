
codeptr = $4d

flibugcolors = $3b00    ; lo nibble are rasterbars, hi nibble the colorram colors
colramdata = $3c00
screendata = $4000
bitmapdata = $6000

generatedcode = $2000

        * = $0801
        ; BASIC stub: "1 SYS 2061"
        !byte $0b,$08,$01,$00,$9e,$32,$30,$36,$31,$00,$00,$00

                ; fill bitmap with test pattern
                lda #%00011011
                ldy #$20
--
                ldx #0
-
bmph:           sta bitmapdata,x
                inx
                bne -
                inc bmph+2
                dey
                bne --

                ; colorram pattern
                ldx #0
-
                txa
                sta colramdata,x
                sta colramdata+$100,x
                sta colramdata+$200,x
                sta colramdata+$300,x
                inx
                bne -

                ; rasterbar pattern
                ldx #0
-
                txa
                eor #$0f
                sta flibugcolors,x
                inx
                cpx #200
                bne -

                ; vram pattern
                ldy #8
--
                tya
                pha

                ldx #0
-
                txa
                clc
scr1:           adc #1
scr2:           sta screendata,x
scr3:           sta screendata+$100,x
scr4:           sta screendata+$200,x
scr5:           sta screendata+$300,x
                inx
                bne -

                lda scr1+1
                clc
                adc #$44
                sta scr1+1

                lda scr2+2
                clc
                adc #4
                sta scr2+2
                tay
                iny
                sty scr3+2
                iny
                sty scr4+2
                iny
                sty scr5+2

                pla
                tay
                dey
                bne --

                jsr codegenerator
                jsr displayer
                jmp *

;-------------------------------------------------------------------------------
; disassembly of the display routine from Blackmails FLI Designer 2.2
;-------------------------------------------------------------------------------

codegenerator:
                LDY        #<generatedcode
                LDA        #>generatedcode
                STY        codeptr
                STA        codeptr+1

                ; generate helper tables
                LDX        #$1E
                LDY        #$BF
                LDA        #$3F
                STA        $57
-
                LDA        #3
                STY        $59,X
                STA        $5A,X
                TYA
                STA        $300,Y
                DEY
                DEX
                DEX
                BPL        -

                LDA        flibugcolors
                STA        flibugcolors-1
                STA        flibugcolors+$c8
                LSR
                LSR
                LSR
                LSR
                STA        colramdata
                STA        colramdata+1
                STA        colramdata+2

                LDA        #$FF
                STA        screendata
                STA        screendata+$1
                STA        screendata+$2

                LDX        #0

genloop:
                LDY        #0
                LDA        flibugcolors-1,X
                LSR
                LSR
                LSR
                LSR
                ORA        #$A0
                STA        (codeptr),Y
                ASL
                TAY
                LSR
                AND        #3
                ORA        #$8C
                STA        $4F
                LDA        loc_2AD6,Y
                STA        loc_29A1+1
                LDA        loc_2AD6+1,Y
                STA        loc_29A1+2

                LDA        flibugcolors,X
                AND        #$F
                LDY        #1

loc_29A1:       JSR        $FFFF

                CPX        #$C8
                BCS        genend

                LDA        #$A6 ; LDX zp
                STA        (codeptr),Y
                INY
                TXA
                AND        #7
                ORA        #$B8
                STA        $57
                AND        #7
                ASL
                ADC        #$69
                STA        (codeptr),Y
                INY
                LDA        #$A9 ; LDA
                STA        (codeptr),Y
                INY
                TXA
                AND        #7
                ASL
                ASL
                ASL
                ASL
                ORA        #8
                STA        (codeptr),Y
                INY
                LDA        #$8D ; STA abs
                STA        (codeptr),Y
                INY
                LDA        #<$D018
                STA        (codeptr),Y
                INY
                LDA        #>$D018
                STA        (codeptr),Y
                INY
                LDA        #$8E ; STA abs
                STA        (codeptr),Y
                INY
                LDA        #<$D011
                STA        (codeptr),Y
                INY
                LDA        #>$D011
                STA        (codeptr),Y
                SEC
                TYA
                ADC        codeptr
                STA        codeptr
                BCC        +
                INC        codeptr+1
+
                INX
                BNE        genloop

genend:
                LDA        #$60 ; RTS
                STA        (codeptr),Y
                rts

;-------------------------------------------------------------------------------

displayer:
                SEI
                LDA        #$7F
                STA        $DD0D
                LDY        #0
                STY        $DD0F
                STY        $D015
                LDA        #<$4CC7
                STA        $DD06
                LDA        #>$4CC7
                STA        $DD07
                LDA        #<nmihandler
                STA        $318
                LDA        #>nmihandler
                STA        $319

                LDX        #$C
-
                BIT        $D011
                BPL        -
-
                BIT        $D011
                BMI        -

loc_2A29:
                LDA        #$81
-
                DEX
                BNE        -

                CPY        $D012
                INY
                LDX        #$A
                BCC        loc_2A29
                DEX
                CPY        #$2E
                BCC        loc_2A29

                STA        $DD0F
                LDA        #$82
                STA        $DD0D
                LDA        #$18
                STA        $D016

                ; copy colorram
                LDY        #0
-
                LDA        colramdata,Y
                STA        $D800,Y
                LDA        colramdata+$100,Y
                STA        $D900,Y
                LDA        colramdata+$200,Y
                STA        $DA00,Y
                LDA        colramdata+$300,Y
                STA        $DB00,Y
                DEY
                BNE        -
                ; use videobank $4000-$7fff
                LDA        #2
                STA        $DD00
                RTS

; ---------------------------------------------------------------------------
func2A6B:
                JSR        storeD021write
                LDA        #$EA ; NOP
                JMP        store2bytesA

func2A73;
                ASL
                ADC        #$59
                SEC
                SBC        $57

storeD021write:
                STA        (codeptr),Y
                LDY        #2

sub_2A7D:
                LDA        $4F
                STA        (codeptr),Y
                INY
                LDA        #<$D021
                STA        (codeptr),Y
                INY
                LDA        #>$D021
                STA        (codeptr),Y
                INY
                RTS

func2A8D:
                ASL
                ADC        #$59
                JSR        storeD021write
                LDA        #$24

store2bytesA:
                STA        (codeptr),Y
                INY

loc_2A98:
                STA        (codeptr),Y
                INY
                RTS

func2A9C:
                ADC        #$B0
                STA        (codeptr),Y
                INY
                LDA        #3

loc_2AA3:
                STA        (codeptr),Y
                LDY        #3
                JSR        sub_2A7D
                LDA        #$EA ; NOP
                BNE        loc_2A98
func2AAE:
                INY
                STA        (codeptr),Y
                DEY
                LDA        $4F
                ADC        #$14
                BNE        loc_2AA3

;-------------------------------------------------------------------------------

nmihandler:
                PHA
                STX        $57
                LDA        $DD06
                STY        $58
                CLC
                ADC        #1
                AND        #$F
                EOR        #$F
                STA        loc_2ACA+1

loc_2ACA:
                BCC        loc_2ACC

loc_2ACC:
                CMP        #$C9
                CMP        #$C9
                CMP        #$C9
                CMP        #$C9
                CMP        #$C9

loc_2AD6:
                CMP        #$C9
                CMP        #$C9
                BIT        $EA
                CMP        (0,X)
                CMP        (0,X)
                CMP        (0,X)
                BIT        0
                NOP

                LDX        #$7F
                STX        $D011

                LDX        #$3F
                JSR        generatedcode

                LDX        #$7F
                STA        $D011

                LDA        #$FA
-
                CMP        $D012
                BNE        -

                LDA        #$77
                STA        $D011

                JSR        $FF9F        ; jmp $ea87
 
                LDA        #$7F
-
                BIT        $D011
                BPL        -

                STA        $D011
                
                jsr     docount
                
;                BIT        $DD0D
                LDX        $57
                LDY        $58
                PLA
                RTI

; ---------------------------------------------------------------------------
jumptable:      !word func2A6B
                !word func2A73
                !word func2A6B
                !word func2A73
                !word func2A8D
                !word func2A8D
                !word func2A8D
                !word func2A8D
                !word func2AAE
                !word func2A6B
                !word func2AAE
                !word func2A6B
                !word func2A9C
                !word func2A9C
                !word func2A9C
                !word func2A9C
; ---------------------------------------------------------------------------

framecount: !byte 5

docount:
                dec framecount
                bne +
                lda #0
                sta $d7ff
+
                BIT        $DD0D
                rts
