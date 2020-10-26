; common.asm include file by Walt of Bonzai - Version 1.0
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
