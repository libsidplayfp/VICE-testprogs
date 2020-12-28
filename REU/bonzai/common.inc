; common.asm include file by Walt of Bonzai - Version 1.2
; adapted for VICE testbench by gpz

IRQ_Low		= $fffe
IRQ_High		= $ffff

!macro BeginIRQ {
  pha
  txa
  pha
  tya
  pha
  lda #1
  sta VIC_Interrupt
}

!macro NextIRQ IRQ, YPos {
	lda #<IRQ
	ldx #>IRQ
	ldy #YPos
	jmp IRQSetAXYRTI
}

!macro SetIRQ_NoSEI IRQ, YPos {
	lda #<IRQ
	ldx #>IRQ
	ldy #YPos
	jsr IRQSet
}

!macro SetIRQ_SEI IRQ, YPos {
	sei
	+SetIRQ_NoSEI IRQ, YPos
	cli
}

!macro RestoreIRQ_NoSEI {
	+SetIRQ_NoSEI DefaultIRQ, 255
}

!macro RestoreIRQ_SEI {
	sei
	+RestoreIRQ_NoSEI
	cli
}

DetectMachine:	sei			; Based on Sokrates' NTSC/PAL/DREAN detect on codebase64.org

				ldx #0
				stx $d015

				jsr WaitForRetrace

RasLine:		lda $d012
RasComp:		cmp $d012
				beq RasComp
				bmi RasLine
				and #3
				cmp #3
				bne Detected

				tay
Count:			inx
				lda $d012
				bpl Count
				cpx #$5e
				bcc IsPal

				iny

IsPal:			tya

Detected:		sta MachineType
				dec MachineType

				cli

				rts

MachineType:	!byte 0		; 0 : 262 rasterlines and 64 cycles per line [NTSC: 6567R56A VIC] (OLD NTSC)
							; 1 : 263 rasterlines and 65 cycles per line [NTSC: 6567R8 VIC]
							; 2 : 312 rasterlines and 63 cycles per line [PAL: 6569 VIC]
							; 3 : 312 rasterlines and 65 cycles per line [Drean PAL-N: 6572 VIC]


SetupIRQ:		sei

				lda #$7f
				sta $dc0d
				sta $dd0d

				lda $dc0d
				lda $dd0d

				lda #$01
				sta $d01a

				lda #$1b
				sta $d011

				lda #<nmi
				sta $fffa
				lda #>nmi
				sta $fffb

				+RestoreIRQ_NoSEI

				lda #$35
				sta $01

				cli
				rts

DefaultIRQ:		pha
				lda #1
				sta $d019
				pla
				rti

IRQSet:			sta IRQ_Low
				stx IRQ_High
				sty VIC_Raster_Position
				rts

IRQSetAXYRTI:	sta IRQ_Low
				stx IRQ_High
				sty VIC_Raster_Position
StackRTI:		pla
				tay
				pla
				tax
				pla
nmi:			rti

WaitForRetrace:	lda VIC_Screen_YPos
				bpl WaitForRetrace

- 				lda VIC_Screen_YPos
				bmi -

				rts

WaitOrgIRQ:		ldx #<DefaultIRQ
				ldy #>DefaultIRQ
- 				cpx IRQ_Low
				bne -

				cpy IRQ_High
				bne -

				rts

REUDetect:		lda REUStatus				; Just to be safe...
				lda #0
				sta REUCommand
				sta REUAddrMode				; Normal REU operation (not needed here as we only transfer 1 byte but good idea anyway :))
				sta REUREU
				sta REUREU+1
				sta REUREU+2				; Set REU address to $000000
				lda #<REUTestData
				sta REUC64
				lda #>REUTestData
				sta REUC64+1				; Set C64 address to REUTestData
				lda #4
				sta REUTransLen				; Transfer length is 4 byte
				lda #0
				sta REUTransLen+1
				lda #REUCMDExecute+REUCMDTransToREU		; Do the transfer
				sta REUCommand

				lda #0
				sta REUREU
				sta REUREU+1
				sta REUREU+2				; Set REU address to $000000
				lda #<REUTestResult
				sta REUC64
				lda #>REUTestResult
				sta REUC64+1				; Set C64 address to REUTestResult
				lda #4
				sta REUTransLen				; Transfer length is 4 byte
				lda #0
				sta REUTransLen+1
				lda #REUCMDExecute+REUCMDTransToC64		; Do the transfer
				sta REUCommand

				ldx #3
CompareLoop:	lda REUTestData,x
				cmp REUTestResult,x			; Compare transmitted and received data to see if REU transfer worked
				bne REUNotFound				; If difference, no REU...
				dex
				bpl CompareLoop

				rts

REUNotFound:	sei
				lda #0						; Setup screen
				sta $3fff
				lda #12
				sta $d016
				lda #31
				sta $d011
				lda #21
				sta $d018

				ldx #79
-				lda NotFoundText,x			; And copy text
				sta $0400,x
				lda #1
				sta ColorRAM,x
				dex
				bpl -

;SpaceReset:		lda $dc01
;				and #$10
;				bne SpaceReset				; Wait for space press
;
;				sei
;				lda #$37
;				sta 1						; Ensure proper kernal functions
;				jmp ($fffc)					; Reset
				
				ldx #$ff
				ldy #$02
                stx $d7ff
                sty $d020
                jmp *

REUTestData:	!scr "REU?"
REUTestResult:	!scr "----"
NotFoundText:	!scr "this test program requires a ram expan- "
				!scr "sion unit to work. press space to reset "

MachineTypes:	!scr "Old NTSC"
				!scr "NTSC    "
				!scr "PAL     "
				!scr "Drean   "
