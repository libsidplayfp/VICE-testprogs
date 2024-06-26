;ACME 0.97

	my_primm	= address($ff7d)	; from c128 kernal

; driver enumeration (FIXME: do not define separately for c64 and c128!)
	ENUM_JOYSTICK	= 0
	ENUM_1351	= 1
	ENUM_AMIGA	= 2
	ENUM_ATARIST	= 3
	ENUM_CX22	= 4
	ENUM_KOALA	= 5
	ENUM_TOTAL	= 6

; zp variables
!addr	tmp	= $fa

; basic header
	* = $1c01
		!wo line2, 2023
		!h de9c3afe0231353a9e	; "graphicclr:bank15:sys"
		!by '0' + entry % 10000 / 1000
		!by '0' + entry %  1000 /  100
		!by '0' + entry %   100 /   10
		!by '0' + entry %    10
		!pet $3a, $8f, " saufbox!", $0	; ":rem "
line2		!wo 0

; NMI, called when user presses RESTORE
; (C128 NMI saves A/X/Y before calling this)
my_nmi		inc reset_pos	; set flag to let main loop know
		; now call original nmi handler
		jmp MODIFIED16	: .ori_nmi = * - 2

; irq hook (c128 uses raster irq as system irq, so this is even simpler than on c64):
my_irq		inc vsync	; set flag to let main loop know
		; now call original irq handler
		jmp MODIFIED16	: .ori_irq = * - 2

; include main code
	!src "mousetest.asm"

; make sure sprites can be seen by vic
	!if * < $2000 {
		* = $2000
	}
; include sprite patterns
	!src "sprites.asm"

external_data
