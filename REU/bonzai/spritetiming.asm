; SpriteTiming.asm by Walt of Bonzai - Version 1.0
; adapted for VICE testbench by gpz

!src "io.inc"
!src "reu.inc"

Ptr     = $f8
Scr     = $fa
temp    = $fc

CR  = $5e

;----------------------------------------------------------------------------------------------------

        * = $0801
        !word nextline
        !word 2016 
        !byte $9e
        !byte $30 + (Main / 10000)
        !byte $30 + (Main % 10000) / 1000
        !byte $30 + ((Main % 10000) % 1000) / 100
        !byte $30 + (((Main % 10000) % 1000) % 100) / 10
        !byte $30 + (((Main % 10000) % 1000) % 100) % 10
nextline:
        !byte 0,0,0

;----------------------------------------------------------------------------------------------------

Result:			!byte 0,0

!src "common.inc"

Main:			jsr $ff81

				lda #14
				sta VIC_ScreenColor
				lda #6
				sta VIC_BorderColor
				lda #$16
				sta VIC_ScreenMemory

				lda #1
				sta VIC_Sprite_Priority

				jsr SetupIRQ

				jsr TestREU

				lda VIC_BorderColor
				sta VIC_ScreenColor

				lda #<Table
				sta Ptr
				lda #>Table
				sta Ptr+1

				ldy #0
TableLoop:		lda (Ptr),y
				beq Found

				cmp Result
				bne Next

				iny
				lda (Ptr),y
				cmp Result+1
				beq Found

Next:			lda Ptr
				clc
				adc #4
				sta Ptr
				lda Ptr+1
				adc #0
				sta Ptr+1
				jmp TableLoop

Found:			ldx #0
				lda #1
TextColor:		sta ColorRAM,x
				sta ColorRAM+$100,x
				sta ColorRAM+$200,x
				sta ColorRAM+$300,x
				inx
				bne TextColor
CopyText:		lda #15
				sta ColorRAM,x
				lda Text,x
				sta $0400,x
				cmp #CR
				bne +

				lda #1
				sta ColorRAM,x

+ 				inx
				cpx #40
				bne CopyText

				lda Result
				ldx #19
				jsr DisplayHex

				lda Result+1
				ldx #28
				jsr DisplayHex

				lda Result+1
				sec
				sbc Result
				ldx #38
				jsr DisplayHex

				lda #80
				sta Scr
				lda #4
				sta Scr+1

				ldy #2
				lda (Ptr),y
				tax
				iny
				lda (Ptr),y
				stx Ptr
				sta Ptr+1
				ldy #0
CopyText2:		lda (Ptr),y
				beq textend

				cmp #CR
				beq NewLine

				sta (Scr),y
				iny
				cpy #40
				bne CopyText2

NewLine:		iny
				tya
				clc
				adc Ptr
				sta Ptr
				lda Ptr+1
				adc #0
				sta Ptr+1

				lda Scr
				clc
				adc #80
				sta Scr
				lda Scr+1
				adc #0
				sta Scr+1

				ldy #0

				jmp CopyText2

textend:
				ldx #0
				ldy #5
				lda Result
				cmp #$5b
				beq +
				ldx #$ff
				ldy #2
+
				lda Result+1
				cmp #$88
				beq +
				ldx #$ff
				ldy #2
+
                stx $d7ff
                sty $d020
				jmp *					; endless loop :)
                
				
DisplayHex:		sta temp
				lsr
				lsr
				lsr
				lsr
				tay
				lda Hex,y
				sta $0400,x
				lda temp
				and #15
				tay
				lda Hex,y
				sta $0401,x

				rts

Hex:			!scr "0123456789abcdef"
Text:			!scr "REU detected: 1st $__, 2nd $__, diff $__"

Table:			!byte $59, $85
				!word Text5985

				!byte $5a, $86
				!word Text5a86

				!byte $5b, $88
				!word Text5b88

				!byte 0,0
				!word TextUnknown

TextUnknown:	!scr "Unknown! Please send info to Walt/Bonzai", CR
				!scr "See Readme.txt for contact info.", CR
				!byte 0

Text5985:		!scr "C64 Ultimate fw. 1.24, 1.34", CR
				!scr "The C64 1.3.2-amora", CR
				!scr "VICE x64 and x128 v. 2.4, 3.1, 3.4", CR
				!scr "VICE x64sc v. 2.4", CR
				!byte 0

Text5a86:		!scr "1541 Ultimate-II Plus 3.6 (115)", CR
				!byte 0

Text5b88:		!scr "Commodore RAM Expansion Unit", CR
				!scr "VICE x64sc v. 3.1, 3.4", CR
				!byte 0

;----------------------------------------------------------------------------------------------------

TestPos:		!byte 70
TestByte:		!byte 60
TestIndex:		!byte 0

TestREU:		lda #255
				sta VIC_Sprite_Enable
				sta TestSprite

				lda #70
				sta TestPos
				lda #0
				sta TestIndex
				sta TestSprite+3

				lda #24
				sta VIC_Sprite0_X
				lda #50-21
				sta VIC_Sprite0_Y
				sta VIC_Sprite1_Y
				sta VIC_Sprite2_Y
				sta VIC_Sprite3_Y
				sta VIC_Sprite4_Y
				sta VIC_Sprite5_Y
				sta VIC_Sprite6_Y
				sta VIC_Sprite7_Y
				lda #TestSprite/64
				sta $07f8

				lda #0
				sta Magic

				lda #REUAddrFixedC64
				sta REUAddrMode
				lda #<Magic
				sta REUC64
				lda #>Magic
				sta REUC64+1
				lda #0
				sta REUREU
				sta REUREU+1
				sta REUREU+2
				lda #0
				sta REUTransLen
				lda #1
				sta REUTransLen+1
				lda #REUCMDExecute+REUCMDTransToREU
				sta REUCommand

				jsr WaitForRetrace
				lda #27
				sta VIC_Screen_YPos
				jsr WaitForRetrace
				+SetIRQ_SEI TIRQ3, 250

WaitTest:		lda TestIndex
				cmp #2
				bne WaitTest

				+RestoreIRQ_SEI

				lda #0
				sta VIC_Sprite_Enable

				rts

TIRQ1:			+BeginIRQ
				+SetIRQ_NoSEI TIRQ2, 27
				lda VIC_Sprite_Back_Coll
				cli
				!fill 80,234
				jmp StackRTI

TIRQ2:			+BeginIRQ
				lda #0
				sta REUREU
				sta REUREU+1
				sta REUREU+2
				lda #REUAddrFixedC64
				sta REUAddrMode
				nop
				nop
				bit 0
				lda VIC_Raster_Position
				cmp VIC_Raster_Position
				beq	+
+ 				lda #0
				sta REUTransLen
				lda #1
				sta REUTransLen+1
				lda #<Magic
				sta REUC64
				lda #>Magic
				sta REUC64+1
				lda #REUCMDExecute+REUCMDTransToC64
				sta REUCommand

			; Remove these blocks to have it run at normal speed. This block is only for slowing it down to show it more clearly...

					lda 2
					and #7
					bne NoColl

			; ...end of block 1/2

				lda VIC_Sprite_Back_Coll
				beq NoColl

				lda TestSprite
				sta TestSprite+3
				lda #0
				sta TestSprite

				ldx TestIndex
				lda TestPos
				sta Result,x
				inc TestIndex

				lda TestPos
				clc
				adc #32
				sta TestPos

NoColl:			lda #0
				sta REUAddrMode
				lda TestPos
				sta REUREU
				lda #0
				sta REUREU+1
				sta REUREU+2
				lda #<TestByte
				sta REUC64
				lda #>TestByte
				sta REUC64+1
				lda #1
				sta REUTransLen
				lda #0
				sta REUTransLen+1
				lda #REUCMDExecute+REUCMDTransToREU
				sta REUCommand

			; Remove these blocks to have it run at normal speed. This block is only for slowing it down to show it more clearly...

					inc 2
					lda 2
					and #7
					bne +

			; ...end of block 2/2

				inc TestPos

+				+NextIRQ TIRQ3, 250

TIRQ3:			+BeginIRQ
				lda #16
				sta VIC_Screen_YPos
- 				lda VIC_Screen_YPos
				bpl -
				lda #27
				sta VIC_Screen_YPos

				+NextIRQ TIRQ1, 25

;----------------------------------------------------------------------------------------------------

				!align $3f,0
TestSprite:		!fill 64,0

;----------------------------------------------------------------------------------------------------

				* = $3fff
Magic:			!byte 0
