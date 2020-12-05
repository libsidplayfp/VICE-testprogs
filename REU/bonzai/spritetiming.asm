; SpriteTiming.asm by Walt of Bonzai - Version 1.1
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

Result:         !byte 0,0

!src "common.inc"

Main:           jsr $ff81                   ; Init screen

                lda $dd00                   ; Ensure VIC at $0000-$3fff
                ora #3
                sta $dd00

                lda #14
                sta VIC_ScreenColor
                lda #6
                sta VIC_BorderColor
                lda #$16
                sta VIC_ScreenMemory

                lda #1
                sta VIC_Sprite_Priority     ; Put sprites behind test char, for show only, not needed for testing...

                jsr SetupIRQ                ; Setup a normal raster IRQ that does nothing

                jsr TestREU                 ; Do the test

                lda VIC_BorderColor
                sta VIC_ScreenColor

                lda #<Table                 ; Init table pointer
                sta Ptr
                lda #>Table
                sta Ptr+1

                ldy #0
TableLoop:      lda (Ptr),y
                beq Found                   ; At end of table (unknown values)

                cmp Result                  ; Compare result 1
                bne Next                    ; If not the same, try next entry

                iny
                lda (Ptr),y
                cmp Result+1                ; Compare result 2
                beq Found                   ; Found it?

Next:           lda Ptr                     ; Next table entry
                clc
                adc #4
                sta Ptr
                lda Ptr+1
                adc #0
                sta Ptr+1
                jmp TableLoop               ; Look up again

Found:          ldx #0
                lda #1
TextColor:      sta ColorRAM,x              ; Screen text color
                sta ColorRAM+$100,x
                sta ColorRAM+$200,x
                sta ColorRAM+$300,x
                inx
                bne TextColor
CopyText:       lda #15
                sta ColorRAM,x              ; Grey text
                lda Text,x
                sta $0400,x                 ; Header text
                cmp #CR
                bne +

                lda #1                      ; White at selected "_" places
                sta ColorRAM,x

+               inx
                cpx #40
                bne CopyText

                lda Result
                ldx #19
                jsr DisplayHex              ; Print result 1

                lda Result+1
                ldx #28
                jsr DisplayHex              ; Print result 2

                lda Result+1
                sec
                sbc Result                  ; Print result 2 minus result 1.
                ldx #38
                jsr DisplayHex

                lda #80
                sta Scr
                lda #4
                sta Scr+1                   ; Screen pointer

                ldy #2
                lda (Ptr),y                 ; Text data pointer
                tax
                iny
                lda (Ptr),y
                stx Ptr
                sta Ptr+1
                ldy #0
CopyText2:      lda (Ptr),y                 ; Get text byte
                beq textend                 ; End reached when text byte is 0

                cmp #CR                     ; Is it CR
                beq NewLine                 ; if so, advance to next line

                sta (Scr),y                 ; Store to screen
                iny
                cpy #40                     ; End of line?
                bne CopyText2

NewLine:        iny
                tya
                clc
                adc Ptr
                sta Ptr                     ; Advance text pointer
                lda Ptr+1
                adc #0
                sta Ptr+1

                lda Scr
                clc
                adc #80                     ; Advance screen pointer
                sta Scr
                lda Scr+1
                adc #0
                sta Scr+1

                ldy #0

                jmp CopyText2               ; Continue text copy

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
                jmp *                       ; endless loop :)


DisplayHex:     sta temp                    ; Store value
                lsr
                lsr
                lsr
                lsr                         ; Divide by 16
                tay
                lda Hex,y                   ; Get upper nibble
                sta $0400,x
                lda temp
                and #15                     ; AND by 15
                tay
                lda Hex,y                   ; Get lower nibble
                sta $0401,x

                rts

Hex:            !scr "0123456789abcdef"
Text:           !scr "REU detected: 1st $__, 2nd $__, diff $__"

Table:          !byte $59, $85              ; Table format is result 1 (byte), result 2 (byte), Text entry (word)
                !word Text5985

                !byte $5a, $86
                !word Text5a86

                !byte $5b, $88
                !word Text5b88

                !byte 0,0                   ; 0,0 end of table
                !word TextUnknown

TextUnknown:    !scr "Unknown! Please send info to Walt/Bonzai", CR
                !scr "See Readme.txt for contact info.", CR
                !byte 0

Text5985:       !scr "C64 Ultimate fw. 1.24, 1.34", CR
                !scr "Chameleon Beta-9j", CR
                !scr "The C64 1.3.2-amora", CR
                !scr "VICE x64 and x128 v. 2.4, 3.1, 3.4", CR
                !scr "VICE x64sc v. 2.4", CR
                !byte 0

Text5a86:       !scr "1541 Ultimate-II Plus 3.6 (115)", CR
                !byte 0

Text5b88:       !scr "Commodore RAM Expansion Unit", CR
                !scr "VICE x64sc v. 3.1, 3.4", CR
                !byte 0

;----------------------------------------------------------------------------------------------------

TestPos:        !byte 70                        ; Byte in data stream to test
TestByte:       !byte 60                        ; Byte to use for testing
TestIndex:      !byte 0                         ; Result index

TestREU:        lda #255                        ; Enable all sprites
                sta VIC_Sprite_Enable
                sta TestSprite                  ; First byte in sprite

                lda #70                         ; Init vars
                sta TestPos
                lda #0
                sta TestIndex
                sta TestSprite+3                ; Redundant, unless you want to test again

                lda #24                         ; Place sprite 0 at position 24 (first char row)
                sta VIC_Sprite0_X
                lda #50-21
                sta VIC_Sprite0_Y               ; Place all sprites just below screen area
                sta VIC_Sprite1_Y
                sta VIC_Sprite2_Y
                sta VIC_Sprite3_Y
                sta VIC_Sprite4_Y
                sta VIC_Sprite5_Y
                sta VIC_Sprite6_Y
                sta VIC_Sprite7_Y
                lda #TestSprite/64              ; Set sprite 0 pointer
                sta $07f8

                lda #0
                sta Magic                       ; Clear magic byte

                lda #REUAddrFixedC64            ; REU reads the same location from C64
                sta REUAddrMode
                lda #<Magic                     ; REU reads from Magic byte
                sta REUC64
                lda #>Magic
                sta REUC64+1
                lda #0
                sta REUREU                      ; REU address $000000
                sta REUREU+1
                sta REUREU+2
                lda #0
                sta REUTransLen                 ; Transfer length is $100 bytes
                lda #1
                sta REUTransLen+1
                lda #REUCMDExecute+REUCMDTransToREU ; Transfer $100 bytes from Magic byte to REU $000000-$0000ff
                sta REUCommand

                jsr WaitForRetrace
                lda #27
                sta VIC_Screen_YPos             ; Normal screen Y position
                jsr WaitForRetrace
                +SetIRQ_SEI TIRQ3, 250          ; Change to TIRQ3 at rasterline 250 (for opening the border)

WaitTest:       lda TestIndex
                cmp #2
                bne WaitTest                    ; Wait for the two test results to complete

                +RestoreIRQ_SEI                 ; Back to default IRQ

                lda #0
                sta VIC_Sprite_Enable           ; Turn off sprites

                rts

TIRQ1:          +BeginIRQ                       ; IRQ for preparing stable raster
                +SetIRQ_NoSEI TIRQ2, 27
                lda VIC_Sprite_Back_Coll
                cli
                !fill 80,234
                jmp StackRTI

TIRQ2:          +BeginIRQ
                lda #0                          ; Set REU address to $000000
                sta REUREU
                sta REUREU+1
                sta REUREU+2
                lda #REUAddrFixedC64            ; Set REU to fixed C64 address (We want to write REU values just to magic byte)
                sta REUAddrMode
                nop
                nop
                bit 0
                lda VIC_Raster_Position         ; Stable raster
                cmp VIC_Raster_Position
                beq	+
+                 lda #0
                sta REUTransLen
                lda #1                          ; REU transfer length is $100 bytes
                sta REUTransLen+1
                lda #<Magic                     ; Store to magic byte
                sta REUC64
                lda #>Magic
                sta REUC64+1
                lda #REUCMDExecute+REUCMDTransToC64 ; Start transfer from REU $000000-$0000ff to Magic byte
                sta REUCommand

                ; Remove these blocks to have it run at normal speed. This block is only for slowing it down to show it more clearly...

                lda 2
                and #7
                bne NoColl

                ; ...end of block 1/2

                lda VIC_Sprite_Back_Coll        ; Char-sprite collision detect
                beq NoColl

                lda TestSprite                  ; We hit the magic byte char
                sta TestSprite+3                ; Move the test byte in the sprite down one pixel
                lda #0
                sta TestSprite

                ldx TestIndex                   ; Get text index,
                lda TestPos                     ; get test value,
                sta Result,x                    ; store it and
                inc TestIndex                   ; Prepare for next test result

                lda TestPos
                clc
                adc #32
                sta TestPos                     ; Skip 32 chars to speed up the process

NoColl:         lda #0
                sta REUAddrMode                 ; Normal REU operation (not needed here as we only transfer 1 byte but good idea anyway :))
                lda TestPos
                sta REUREU
                lda #0
                sta REUREU+1
                sta REUREU+2                    ; Set REU address to TestPos
                lda #<TestByte
                sta REUC64
                lda #>TestByte
                sta REUC64+1                    ; Set C64 address to TestByte
                lda #1
                sta REUTransLen                 ; Transfer length is 1 byte
                lda #0
                sta REUTransLen+1
                lda #REUCMDExecute+REUCMDTransToREU ; Do the transfer
                sta REUCommand

                ; Remove these blocks to have it run at normal speed. This block is only for slowing it down to show it more clearly...

                inc 2
                lda 2
                and #7
                bne +

                ; ...end of block 2/2

                inc TestPos                     ; Advance TestPos

+               +NextIRQ TIRQ3, 250             ; Change IRQ to open the border

TIRQ3:          +BeginIRQ
                lda #16
                sta VIC_Screen_YPos
-               lda VIC_Screen_YPos             ; Open upper/lower border
                bpl -
                lda #27
                sta VIC_Screen_YPos

                +NextIRQ TIRQ1, 25              ; Back to test IRQ

;----------------------------------------------------------------------------------------------------

                !align $3f,0
TestSprite:     !fill 64,0                      ; Empty sprite

;----------------------------------------------------------------------------------------------------

                * = $3fff
Magic:          !byte 0
