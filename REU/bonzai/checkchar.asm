; CheckChar.asm by Walt of Bonzai - Version 1.2
; adapted for VICE testbench by gpz

SLOW = 1    ; Remove this to have it run at normal speed. This is only for slowing it down to show it more clearly...

!src "io.inc"
!src "reu.inc"

; REU char streaming test.
; 
; Use sprite to char collision to detect if REU to char streaming works.
; 
; It trashes the first 16 bytes of the REU memory.
; 
; Please note that REU is assumed to be present when running this :)
; 
; When using this in a demo use the same color for screen, chars and sprite :)

Sprite=$40          ; The sprite, blank except for a single byte
Char=Sprite+64      ; The char used to stream data into
TestRes=Char+8      ; The results, bit 1 of sprite to char collision detect VIC register
                    ; 8 of the chars should give a hit so doing a sum of the 16 values should equal 16 if it works!
SlowCounter=TestRes+16

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
;-------------------------------------------------------------------------------------------------------

!src "common.inc"

Result:			!byte 0			; 0 = Char streaming OK, 1 = Char streaming failed


Main:			jsr $ff81		; Restore VIC etc.

				jsr REUDetect

				jsr DetectMachine
				ldx MachineType
				lda TimingOpTable1,x
				sta _timing1_1				; Replace timing opcodes to match machine type
				sta _timing2_1
				lda TimingOpTable2,x
				sta _timing1_2
				sta _timing2_2

				jsr SetupIRQ	; Setup a default raster IRQ
				
				jsr CheckVICE	; Call the check

				lda MachineType
				asl
				asl
				asl
				tay
				ldx #0
MachineText:	lda MachineTypes,y
				sta $0400,x
				lda #1
				sta ColorRAM,x
				inx
				iny
				cpx #8
				bne MachineText
				
				lda #$16				; Normal screen
				sta VIC_ScreenMemory
				
				lda VIC_ScreenColor
				sta VIC_BorderColor

				ldx #27
CopyText:		lda Text,x				; Copy text
				sta $0400+8,x
				lda #15
				sta ColorRAM+8,x
				dex
				bpl CopyText

				lda Result				; Get result
				asl
				asl						; multiply by 4
				tay						; Use for lookup
				ldx #0
CopyResText:	lda ResText,y			; and copy result text
				sta $0400+36,x
				lda #1
				sta ColorRAM+36,x
				iny
				inx
				cpx #4
				bne CopyResText

				ldx #0
				ldy #5
				lda Result
				beq +
				ldx #$ff
				ldy #2
+
                stx $d7ff
                sty $d020
				jmp *					; endless loop :)

Text:			!scr "  REU to char streaming test :          "
ResText:		!scr "OK  Fail"

;-------------------------------------------------------------------------------------------------------

CheckVICE:		ldx #15
ClrScr:			lda #Char/8
				sta $0400,x		; Fill the first 16 chars of the screen with the test char
				lda #1
				sta ColorRAM,x
				dex
				bpl ClrScr
				
				lda #0
				ldx #63+8
ClearGfx:		sta Sprite,x	; Clear the sprite and char
				dex
				bpl ClearGfx

				lda #255		; Set a single sprite byte to use for detection
				sta Sprite

				lda #2
				sta VIC_Sprite_Enable		; enable the sprite

				lda #7
				sta VIC_Sprite1_Color

				lda #53
				sta VIC_Sprite1_Y			; and place it on the correct y pos to hit the char.

				lda #Sprite/$40
				sta $7f9					; Setup sprite pointer

				lda BankSelect
				ora #3
				sta BankSelect				; Make sure we are in the right VIC bank

				lda #$10
				sta VIC_ScreenMemory		; Use $0000-$07ff for font, $0400 for screen
				
				lda REUStatus				; Read REU status
				lda #0
				sta REUCommand				; Init REU
				sta REUREU					; Point REU to address $000000
				sta REUREU+1
				sta REUREU+2
				lda #<TestData				; Point REU C64 address to TestData
				sta REUC64
				lda #>TestData
				sta REUC64+1
				lda #16						; Transfer the 16 bytes test data to REU $000000-$00000f
				sta REUTransLen
				lda #0
				sta REUTransLen+1
				lda #0
				sta REUAddrMode				; Normal transfer with inc of both C64 and REU counters
				lda #REUCMDExecute+REUCMDTransToREU
				sta REUCommand				; Start the transfer

				lda #253					; Init our test counter. Start at 253 to have 3 frames to move the sprites on screen
				sta Pos						; and skip the first 3 detection result (a combo of laziness and uncertainty ;) )
				+SetIRQ_SEI IRQ1, 49		; Setup the test IRQ at rasterline 50

				jsr WaitOrgIRQ				; Wait for the original IRQ pointer to be restored to default (see Common.asm)

				lda #0						; We are done, disable the sprite
				sta VIC_Sprite_Enable				
				ldx #15
				clc
CalcRes:		adc TestRes,x				; Add up the test results (8 filled and 8 blank chars)
				dex
				bpl CalcRes

				ldx #0
				stx Result					; Assume all is okay

				cmp #16						; Is the result 8 x 2 (remember we use sprite 1 so detection result is 2) ?
				beq +

				inc Result					; No it wasn't, REU to char streaming is broken

+ 				rts

;-------------------------------------------------------------------------------------------------------

Pos:			!byte 0						; Testing position (0-15 is used)

IRQ1:			+BeginIRQ					; Macro, see Common.asm
				+SetIRQ_NoSEI IRQ2, 52
				lda #0						; Set REU address to $00000
				sta REUREU
				sta REUREU+1
				sta REUREU+2
				sta REUC64+1
				lda #<(Char+3)				; Point C64 address to Char+3.
				sta REUC64
				cli							; Nested interrupt, preparing stable raster
				!fill 80,234				; Ensure that we interrupt on a 2 cycle opcode
				jmp StackRTI

IRQ2:			+BeginIRQ
_timing1_1:		nop
				nop
_timing1_2:		nop
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
				bit 0
				lda VIC_Raster_Position
				cmp VIC_Raster_Position		; Stable raster check
				beq +
+ 				lda #>(Char+3)
				sta REUC64+1				
				lda #16						; Set transfer length to 16 bytes
				sta REUTransLen
				lda #0
				sta REUTransLen+1
				lda #REUAddrFixedC64		; Set REU to not increment (fix) the C64 address when transfering
				sta REUAddrMode				; (So that we always write to the char address)
_timing2_1:		nop
				nop
_timing2_2:		nop
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
				bit $ea
				lda #REUCMDTransToC64+REUCMDExecute
				sta REUCommand				; Start transfer exactly at char position 0, line 3 (raster line 53)

				lda #0
				sta REUAddrMode				; Reset address mode (forgetting to do this and then later assuming
											; it is 0 can make you suffer :( )
											
				ldx Pos						; Get our test pos
				lda VIC_Sprite_Back_Coll	; Read the sprite to char collision register (also resets it)
				and #2						; Get the bit for our test sprite
				cpx #16						
				bcs + 						; Are we in our test are (0-15)?

				sta TestRes,x				; If so, store the result
				sta VIC_BorderColor			; Show using the border (can be omitted :) )

+ 				
			; Remove this block to have it run at normal speed. This block is only for slowing it down to show it more clearly...
                !if (SLOW = 1) {
					inc 2
					lda 2
					and #7
					bne +
                }
			; ...end of block

				inc Pos						; Increase test pos
				
				lda VIC_Sprite1_X			
				clc
				adc #8						; Move the sprite one char to the right
				sta VIC_Sprite1_X

				lda Pos
				cmp #16
				beq IRQDone					; Are we done testing?

+				+NextIRQ IRQ1, 49			; If not, issue our original test IRQ at raster line 50

IRQDone:		+RestoreIRQ_NoSEI 		; Done, restore our IRQ to default
				jmp StackRTI				; And exit IRQ

TestData:		!byte 60,0,60,0,0,60,60,0,0,0,60,60,0,60,60,0	; Test data, 8 filled and 8 blanks

										; $24 = BIT zp, $ea = NOP
TimingOpTable1:	!byte $24,$ea,$24,$ea	; BIT $ea, BIT $ea			21 cycles timing code
TimingOpTable2:	!byte $ea,$ea,$24,$ea	; BIT $ea, NOP, NOP		22 cycles timing code
										; NOP, NOP, NOP, NOP		23 cycles timing code
