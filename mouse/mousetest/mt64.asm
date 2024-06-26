;ACME 0.97

	!src "kernal.inc"

; driver enumeration (FIXME: do not define separately for c64 and c128!)
	ENUM_JOYSTICK	= 0
	ENUM_1351	= 1
	ENUM_AMIGA	= 2
	ENUM_ATARIST	= 3
	ENUM_CX22	= 4
	ENUM_KOALA	= 5
	ENUM_TOTAL	= 6

; zp variables
!addr	tmp		= $02

; basic header
	* = $0801
		!wo line2, 2023
		!by $9e, $20	; "sys "
		!by '0' + entry % 10000 / 1000
		!by '0' + entry %  1000 /  100
		!by '0' + entry %   100 /   10
		!by '0' + entry %    10
		!pet $3a, $8f, " saufbox!", $0	; ":rem "
line2		!wo 0

; PRIMM - this fits neatly before next sprite block
	primm_ptr	= tmp	; we need a zp pointer
my_primm	pla	; get low byte of return address - 1
		tay	; into Y
		pla	; get high byte of return address - 1
		sta primm_ptr + 1	; to ptr high
		lda #0	; and zero ptr low, so "(ptr), y" points before text
		sta primm_ptr
		beq +
		;--
---			; fix high byte
			inc primm_ptr + 1
			bne +++	; I trust this branch always gets taken
			;--
-			jsr k_chrout
+			iny
			beq ---
+++			lda (primm_ptr), y
			bne -
		; push updated address onto stack
		lda primm_ptr + 1
		pha
		tya
		pha
		rts	; return to caller (after zero-terminated text)

; NMI, called when user presses RESTORE
; (CAUTION, C64 NMI does not save A/X/Y before calling this)
my_nmi		inc reset_pos	; set flag to let main loop know
		; now call original nmi handler
		jmp MODIFIED16	: .ori_nmi = * - 2

; include sprite patterns
	!src "sprites.asm"

; irq hook
my_irq		lda vic_irq
		bmi .raster_irq
		; now call original irq handler
		jmp MODIFIED16	: .ori_irq = * - 2

; raster interrupt
.raster_irq	sta vic_irq	; acknowledge interrupt
		inc vsync	; set flag to let main loop know
		jmp address($ea81)

; include main code
	!src "mousetest.asm"

external_data
