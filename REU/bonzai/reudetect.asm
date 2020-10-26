; REUDetect.asm by Walt of Bonzai - Version 1.1
; Changes 1.0 => 1.1 : Do not prepare test data if REU is not present or too small
; adapted for VICE testbench by gpz

!src "reu.inc"
!src "io.inc"

				
ZP1 = $f8

REUTest = $f8     	; Upper 16 bits of 24 bit REU address (when testing)
RAM = $fa      		; Work address when creating test data

ZP2 = $fc

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

;---------------------------------------------------------------------------------------
;                                  *** Useful vars ***
;---------------------------------------------------------------------------------------

REUFound:		!byte 0		; 0 = No REU
RAMFailed:		!byte 0		; Status of RAM test, 0 = OK, REUStatusFault (See REU.asm) = RAM test failed
REUSize:		!byte 0		; Number of 64KB pages :
							; 2 = 128KB, 4 = 256KB, 8 = 512KB, 16 = 1MB, 32 = 2MB, 64 = 4MB, 128 = 8MB, 255=16MB

;---------------------------------------------------------------------------------------

!src "common.inc"

Byte:			!byte 0		; REU transfer address (when testing)

				; Clear zeropage

Main:			sei

				lda #0
				ldx #ZP1
ClearZP:		sta 0,x
				inx
				cpx #ZP2
				bne ClearZP

				; Setup bottom screen text

				ldx #39
SetupScreen:	lda #119
				sta $0400+21*40,x
				lda REUHeader,x
				sta $0400+22*40,x
				lda #32
				sta $0400+23*40,x
				sta $0400+24*40,x
				lda VIC_BorderColor
				sta ColorRAM+21*40,x
				lda #1
				sta ColorRAM+22*40,x
				lda #15
				sta ColorRAM+24*40,x
				dex
				bpl SetupScreen

				; More screen text

				ldx #11
- 				lda REUHeader+40,x
				sta $0400+24*40,x
				dex
				bpl -

				; Do the REU size check

				jsr CheckREUSize

				; Get bit position of REU size for looking up size text

				lda #0
				ldx REUFound		; Skip if no REU, use 0 as result
				beq Text

				lda #8
				ldx REUSize
				cpx #255			; Skip if 16MB, use 8 as result
				beq Text

				ldx #0				; Counter
				lda REUSize
BitLoop:		clc
				ror					; Divide by 2
				bcc + 				; Carry? If not, then lowest bit was 0

				stx Byte			; Store bit position in Byte

+ 				inx
				cpx #8
				bne BitLoop

				lda Byte			; Get stored bit position
Text:			asl					; Multiply by 4 to get the lookup position in REUText
				asl
				tay
				ldx #0
DrawText:		lda REUText,y		; Get the size text
				sta $0400+24*40+12,x	; and show it
				inx
				iny
				cpx #4
				bne DrawText

				lda REUSize
				cmp #8				; Is REU size minimum 512KB (8 * 64 KB) ?
				bcs SizeOK

				ldy #0
				jsr DisplayError	; If not, display error...

				lda #2
				sta $d020
				lda #$ff
				sta $d7ff
				
				jsr WaitSpace		; ...wait for space...

				lda #$37
				sta 1
				jmp ($fffc)			; ...and finally do a reset

WaitSpace:		lda $dc01
				and #$10
				bne WaitSpace

				rts

SizeOK:			jsr InitTestRAM		; Prepare the $8100 bytes of pseudo random test data

				; More screen text

				ldx #21
- 				lda REUCheckText,x
				sta $0400+24*40+18,x
				dex
				bpl -

				; Call the memory test

				jsr TestMemory

				lda RAMFailed
				beq Done

				; In case of error, wait for space press
				lda #2
				sta $d020
				lda #$ff
				sta $d7ff

				jmp WaitSpace

				; And we are done...

Done:
				lda #5
				sta $d020
				lda #$00
				sta $d7ff

                rts

;---------------------------------------------------------------------------------------

DisplayError:	ldx #0
DrawError:		lda ErrorTexts,y
				ora #$80
				sta $0400+11*40,x
				lda #3
				sta ColorRAM+11*40,x
				inx
				iny
				cpx #80
				bne DrawError

				ldx #39
DrawErrLines:	lda #98
				sta $0400+10*40,x
				ora #$80
				sta $0400+13*40,x
				lda #3
				sta ColorRAM+10*40,x
				sta ColorRAM+13*40,x
				dex
				bpl DrawErrLines

				rts

;---------------------------------------------------------------------------------------

TestMemory:		lda #<TestRAMArea	; Point REU to start of TestRAMArea
				sta REUC64
				lda #>TestRAMArea
				sta REUC64+1

				lda #0				; Point to REUTest*$100 REU address
				sta REUREU
				lda REUTest
				sta REUREU+1
				lda REUTest+1
				sta REUREU+2

				lda #0				; Transfer $8000 bytes
				sta REUTransLen
				lda #$80
				sta REUTransLen+1

				lda #REUCMDExecute+REUCMDTransToREU		; Do the transfer from C64 RAM to REU
				sta REUCommand

				lda REUStatus		; Clear reu status (might not be necessary)

				lda #<TestRAMArea	; Point REU to start of TestRAMArea
				sta REUC64
				lda #>TestRAMArea
				sta REUC64+1

				lda #0				; Point to REUTest*$100 REU address
				sta REUREU
				lda REUTest
				sta REUREU+1
				lda REUTest+1
				sta REUREU+2

				lda #0				; Verify $8000 bytes
				sta REUTransLen
				lda #$80
				sta REUTransLen+1

				lda #REUCMDExecute+REUCMDCompare	; Do the verify between C64 RAM and REU
				sta REUCommand

				lda REUStatus		; Get status
				and #REUStatusFault	; Test if verification went OK
				ora RAMFailed		; ORA it to RAMFailed
				sta RAMFailed		; and store it

				lda #<TestRAMArea+1	; Same procedure again but start at TestRAMArea+1 instead of TestRAMArea
				sta REUC64
				lda #>TestRAMArea+1
				sta REUC64+1
				lda #0
				sta REUREU
				lda REUTest
				sta REUREU+1
				lda REUTest+1
				sta REUREU+2
				lda #0
				sta REUTransLen
				lda #$80
				sta REUTransLen+1
				lda #REUCMDExecute+REUCMDTransToREU
				sta REUCommand

				lda REUStatus
				lda #<TestRAMArea+1
				sta REUC64
				lda #>TestRAMArea+1
				sta REUC64+1
				lda #0
				sta REUREU
				lda REUTest
				sta REUREU+1
				lda REUTest+1
				sta REUREU+2
				lda #0
				sta REUTransLen
				lda #$80
				sta REUTransLen+1
				lda #REUCMDExecute+REUCMDCompare
				sta REUCommand
				lda REUStatus
				and #REUStatusFault
				ora RAMFailed
				sta RAMFailed
				beq NoFail			; Still OK?

				ldy #80
				jsr DisplayError	; If not, display error

NoFail:			; Increase memory counter on screen by 32

				ldx #28
				jsr IncCounter		; Add one
				ldx #28
				jsr IncCounter		; Add one
				ldx #27
				jsr IncCounter		; Add ten
				ldx #27
				jsr IncCounter		; Add ten
				ldx #27
				jsr IncCounter		; Add ten

				; Increase REUTest by $80 (It is the 16 upper bits of the 24 bit REU address, so add $80 instead of $8000...)
				lda REUTest
				clc
				adc #$80
				sta REUTest
				lda REUTest+1
				adc #0
				sta REUTest+1
				cmp #8				; Have we reached 512KB ($80000) yet?
				beq +

				jmp TestMemory

+ 				rts

				; Increase screen counter subroutine

IncCounter:		inc $0400+(24*40),x
				lda $0400+(24*40),x
				cmp #58				; Have we passed '9'?
				bne +

				lda #48				; If so, reset to '0'
				sta $0400+(24*40),x
				dex
				bne IncCounter		; and increase the one left of where we are

+ 				rts

;---------------------------------------------------------------------------------------


; 		CheckREUSize writes all 256 of the highest byte value of the REU address (bit 16-23) into REU $xx0000
; 		and reads it back afterwards. As the unavailable highest address bits typically are pulled high in the
; 		REU we will (for a 512KB REU) only get the values $f8-$ff (as it has 8 64KB blocks), as shown here:
; 
; 			$00 into $000000 is actually stored in $f80000
; 			$01 into $010000 is actually stored in $f90000
; 			...
; 			$04 into $040000 is actually stored in $fc0000
; 			...
; 			$07 into $070000 is actually stored in $ff0000
; 			$08 into $080000 is actually stored in $f80000
; 			...
; 			$f0 into $f00000 is actually stored in $f80000
; 			$f7 into $f70000 is actually stored in $ff0000
; 			...
; 			$f8 into $f80000 is stored in $f80000
; 			$ff into $ff0000 is stored in $ff0000
; 
; 		(Exception to this is seen in WinVICE 2.4 where some of the larger memory configurations do not follow this,
; 		for example the 8MB configuration stores $00-$7f in $00xxxx-$7fxxxx but $80-$ff into $ffxxxx which still gives
; 		the correct count ($80) as only values $01-$ff is used as index.)
; 
; 		So when reading back $xx0000 all we will get in return is $f8 to $ff. Using the read data (stored in REUOut+xx) as
; 		index to store 1 in indexed address in REUCount and then counting all the 256 values in REUCount (except index 0)
; 		we get the REU Size (Number of 64KB pages) :
; 
; 			2 = 128KB, 4 = 256KB, 8 = 512KB, 16 = 1MB, 32 = 2MB, 64 = 4MB, 128 = 8MB, 255=16MB
; 
; 		(REUOut is used for saving the read values. REUCount is used for storing 1 in the locations indexed by REUOut.)
; 
; 		Before and after the check the $xx0000 bytes are stored to/from REUBackup for backup.


CheckREUSize:	lda #0
				tax
				tay
ClearREUOut:	sta REUOut,x
				sta REUCount,x
				inx
				bne ClearREUOut

				; Y is 0 from this line on...

				sty REUCommand		; Clear REU command register
				sty REUIRQMask		; and IRQ mask (just to be sure...)
				sty REUAddrMode		; No fixed addresses (increment both C64 and REU counters)
				lda REUStatus		; Get REU status

				; Backup REU first byte of each 64K block ( $xx0000 )
BackupLoop:		stx REUC64		; Location of backup buffer, $100 aligned
				lda #>REUBackup
				sta REUC64+1

				sty REUREU		; REU address $....00
				sty REUREU+1	; REU address $..00..
				stx REUREU+2	; REU address $XX....

				lda #1			; Tell REU to transfer 1 byte
				sta REUTransLen
				sty REUTransLen+1

				lda #REUCMDExecute+REUCMDTransToC64	; Do the transfer
				sta REUCommand

				inx
				bne BackupLoop

				; Write $00-$ff in $xx0000
WriteLoop:		lda #<Byte		; Transfer from Byte c64 memory location
				sta REUC64
				lda #>Byte
				sta REUC64+1

				sty REUREU		; to REU $XX0000 memory location
				sty REUREU+1
				stx REUREU+2

				lda #1			; Transfer 1 byte
				sta REUTransLen
				sty REUTransLen+1

				stx Byte		; Prepare the byte to transfer

				lda #REUCMDExecute+REUCMDTransToREU
				sta REUCommand	; Do the transfer

				inx
				bne WriteLoop

ReadLoop:		lda #<Byte		; Transfer to Byte c64 memory location
				sta REUC64
				lda #>Byte
				sta REUC64+1

				sty REUREU		; from REU $XX0000 memory location
				sty REUREU+1
				stx REUREU+2

				lda #1			; Transfer 1 byte
				sta REUTransLen
				sty REUTransLen+1

				sty Byte		; Clear the byte (if anything should fail... Should not be necessary...)

				lda #REUCMDExecute+REUCMDTransToC64
				sta REUCommand	; Do the transfer

				lda Byte		; Read the transfered byte
				sta REUOut,x	; And store it

				inx
				bne ReadLoop

				; Restore REU data in $xx0000

RestoreLoop:	stx REUC64		; Location of backup buffer, $100 aligned
				lda #>REUBackup
				sta REUC64+1

				sty REUREU		; REU address
				sty REUREU+1
				stx REUREU+2

				lda #1			; Tell REU to transfer 1 byte
				sta REUTransLen
				sty REUTransLen+1

				lda #REUCMDExecute+REUCMDTransToREU	; Do the transfer
				sta REUCommand

				inx
				bne RestoreLoop

				; Now done assuming Y=0 :)

				; Count the result

				lda #1
CountLoop1:		ldy REUOut,x	; REUOut as index
				sta REUCount,y	; Store indexed in REUCount
				inx
				bne CountLoop1

				inx				; Skip position 0
				lda #0
CountLoop2:		clc
				adc REUCount,x	; Count the blocks found (skipping block 0 to avoid getting 0 as result on a 16MB REU)
				inx
				bne CountLoop2
				sta REUSize

				lda REUCount+255	; Take 2 well known indexes and use them for lookup of REU found. Index 255 works
				ora REUCount+1		; for most but one some the 2MB, 4MB or 8MB REU sizes have been observed to not respect the
				sta REUFound		; 'unused high bits of address=1' rule so check result for REU address $010000 also.

				rts

;---------------------------------------------------------------------------------------

InitTestRAM:	lda #<TestRAMArea
				sta RAM
				lda #>TestRAMArea
				sta RAM+1

				ldy #0
IRLoop:			sec
				lda VIC_Raster_Position
				eor Main,y
				lsr
				eor RAM+1
				tax
				lda Main,x
				and #7
				beq _store

				asl
				eor _add+1
				sta _add+1

_store:			lda #23
				ror
_add:			adc #0
				sta (RAM),y
				sta _store+1
				iny
				eor #$ff				; Every second byte is inverted of the previous, to check
				sta (RAM),y				; properly (test is done with TestRAMArea and TestRAMArea+1)
				iny
				bne IRLoop

				inc RAM+1
				lda RAM+1
				cmp #>(TestRAMArea+$8100)
				bne IRLoop

				rts

;---------------------------------------------------------------------------------------

REUHeader:		!scr "reu-detect & test v1.1 by walt of bonzai"
				!scr "reu found : "

				; Text for REU size found
REUText:		!scr "none"
				!scr "128k"
				!scr "256k"
				!scr "512k"
				!scr "1mb "
				!scr "2mb "
				!scr "4mb "
				!scr "8mb "
				!scr "16mb"

REUCheckText:	!scr "testing 000kb of 512kb"

ErrorTexts:		!scr "     sorry. this demo requires a reu    "
				!scr "     with a minimum of 512 kb ram...    "

				!scr "  memory error found (expect bad gfx!)  "
				!scr "        press space to continue.        "

				!align $ff, 0

TestRAMArea:	                   ; Pseudo-random data for REU memory testing
REUBackup		= TestRAMArea +$8100	; Backup of actual content at $xx0000
REUOut			= REUBackup +$100     ; Bytes read from $xx0000
REUCount		= REUOut+$100		    ; REUOut positions set to 1 in this table
