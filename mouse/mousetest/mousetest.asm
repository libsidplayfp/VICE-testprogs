;ACME 0.95.7
; Name		mousetest
; Purpose	Use several input drivers to move sprites, so user can tell which type of mouse they are using.
; Author	(c) Marco Baye, 2016
; Licence	Free software
; Changes:
; 10 Jun 2016	First try, derived from aamouse and DuoDriver.
; 12 Jun 2016	Fixed comments (version 1b).
;		Flipped joystick and 1351 sprites.
; 14 Jun 2016	Added primm to make re-startable and allowed reposition-on-restore (version 1c)
; 16 Jun 2016	Fixed bug where each port change was reported twice (made amigatari use 2-pixel steps)
;		Made Amiga/ST drivers act upon _every_ port change instead of just clk bits.
;		Used raster irq to do sprite stuff in border, making version 2.
; 24 Mar 2023	Version 3: Now shows min/max of pot values. Added driver for Koala pad.

	!src "petscii.inc"
	!src "vic.inc"
	!src "sid.inc"
	!src "cia1.inc"

; helper values
	BITMASK_ALL	= (1 << ENUM_TOTAL) - 1
	CR		= 13
	MODIFIED8	= $ff
!addr	MODIFIED16	= $ffff
	BUTTON_PRESS	= %#......#	; these are written to top
	BUTTON_NOPRESS	= %########	; row of sprite patterns
; In the sprite coordinate system, the graphics pixel (0,0) has the
; coordinates ($18, $32), so these are needed for converting. Blame the
; VIC.
	SPRITE_TO_WINDOW_X	= $18
	SPRITE_TO_WINDOW_Y	= $32
; maximum pointer coordinates (smaller than usual to force sprites to be visible)
	MAX_COORD_X	= 320 - 24
	MAX_COORD_Y	= 200 - 21

!addr	sys_iirq	= $0314	; interrupt vector
!addr	sys_inmi	= $0318	; nmi vector
!addr	screen		= $0400	; for displaying port bits
!addr	spr_ptr		= 2040	; sprite pointers

; zp variables
!addr	state_now	= $fb
!addr	state_change	= $fc
!addr	potx		= $fd	; potx and poty must be consecutive!
!addr	poty		= $fe

; main program
entry ; entry point for SYS
		cld
		; output text
		jsr my_primm
		!pet petscii_LOWERCASE, petscii_CLEAR
		;     ########________########________########
		!pet "$dc01: %             min:       max:", CR
		!pet "$d419: %          %          %        ", CR	; (spaces are for v1/v2 kernal)
		!pet "$d41a: %          %          %        ", CR
	SCREENOFFSET_cia	= 8	; show cia bits in upper left corner
	SCREENOFFSET_potx	= 8 + 40	; and pot values
	SCREENOFFSET_poty	= 8 + 2 * 40	; below
	SCREENOFFSET_min_potx	= SCREENOFFSET_potx + 11
	SCREENOFFSET_min_poty	= SCREENOFFSET_poty + 11
	SCREENOFFSET_max_potx	= SCREENOFFSET_min_potx + 11
	SCREENOFFSET_max_poty	= SCREENOFFSET_min_poty + 11
!if SCREENOFFSET_max_poty > 256 - 8 { !error "X index would overrun in bit display" }
		!pet CR
		!pet "This is mousetest, version 3.", CR
		!pet "Plug mouse in joyport #1 and use it,", CR
		!pet "then check which sprite moves correctly."
		!pet CR
		!pet CR
		!pet CR
		!pet CR
		!pet CR
		!pet "Button presses are shown in top line of", CR
		!pet "sprite. Unfortunately there is no safe", CR
		!pet "way to determine the state of additional"
		!pet "buttons on Amiga and Atari mice.", CR
		!pet CR
		!pet "Press RESTORE to reset sprite positions", CR
		!pet "and min/max values.", CR
		!pet CR
		!pet "If none of the icons move, the mouse may"
		!pet "be a 'NEOS mouse', which is not yet", CR
		!pet "supported by this program."
		!byte 0	; terminate
		; init sprite registers
		ldy #0
		sty vic_sdy	; no double height
		sty vic_smc	; no multicolor
		sty vic_sdx	; no double width
		ldy #BITMASK_ALL
		sty vic_sactive	; activate sprites
		sty vic_sback	; priority
		lda #int(sprites / 64) + ENUM_TOTAL - 1	; last sprite
		sta .ptr
		; set sprite block pointers
		ldx #ENUM_TOTAL - 1
--			lda #viccolor_GRAY3	; set sprite color
			sta vic_cs0, x
			lda #MODIFIED8	: .ptr = * - 1	; set sprite pointer
			sta spr_ptr, x
			dec .ptr	; prepare for next iteration
			dex
			bpl --
		inc reset_pos	; make sure next interrupt re-positions the sprites
		; keep current nmi
		lda sys_inmi
		ldx sys_inmi + 1
		sta .ori_nmi
		stx .ori_nmi + 1
		; install own nmi
		lda #<my_nmi
		ldx #>my_nmi
		sta sys_inmi
		stx sys_inmi + 1
		; keep current irq
		lda sys_iirq
		ldx sys_iirq + 1
		sta .ori_irq
		stx .ori_irq + 1
		; install own irq
		lda #<my_irq
		ldx #>my_irq
		php
		sei
		sta sys_iirq
		stx sys_iirq + 1
		plp
		; raster irq
		lda #251	; first line of lower border
		sta vic_line
		lda #%...##.##
		sta vic_controlv
		lda #1	; enable raster irq
		sta vic_irqmask
; main loop ;)
; endless polling loop (amiga/atari mice must be polled as often as possible)
mainloop	; get state of joyport
		lda #0	; set port b to input
		sta cia1_ddrb
--			lda cia1_prb
			cmp cia1_prb
			bne --
		tax	; X = now
		eor state_now	; A = change
		sei
		stx state_now
		sta state_change
		cli
		; call drivers
		jsr amiga_st_idle
		jsr cx22_idle
		; check for irq stuff
		lda #MODIFIED8 & 0	: vsync = * - 1	; selfmod, but init to zero
		beq mainloop
; "interrupt" (ok, not really, only triggered by it)
		lsr vsync
; poll joystick and 1351 (and Amiga/Atari buttons), and update sprite positions
		ldx #0
		jsr do_pot_stuff
		inx;ldx#1
		jsr do_pot_stuff
		jsr joystick_poll
		jsr cbm1351_poll
		jsr amiga_st_poll	; shared function for buttons
		jsr cx22_poll
		jsr koala_poll
		; check whether to reset positions
		lda #MODIFIED8 & 0	: reset_pos = * - 1	; selfmod, but init to zero
		beq ++
			lsr reset_pos
			; set x/y values to defaults
			ldx #4 * ENUM_TOTAL - 1
--				lda initial_x_lo, x
				sta table_x_lo, x
				dex
				bpl --
			; reset min/max
			;ldx #$ff
			stx minpot
			stx minpot + 1
			inx;ldx#0
			stx maxpot
			stx maxpot + 1
++		; now update sprite positions and screen contents
		; show current port bits in upper right corner
		lda state_now
		ldx #SCREENOFFSET_cia
		jsr show_bits
		; show potx value below
		lda potx
		ldx #SCREENOFFSET_potx
		jsr show_bits
		; show poty value below
		lda poty
		ldx #SCREENOFFSET_poty
		jsr show_bits
		; show minimum values
		lda minpot
		ldx #SCREENOFFSET_min_potx
		jsr show_bits
		lda minpot + 1
		ldx #SCREENOFFSET_min_poty
		jsr show_bits
		; show maximum values
		lda maxpot
		ldx #SCREENOFFSET_max_potx
		jsr show_bits
		lda maxpot + 1
		ldx #SCREENOFFSET_max_poty
		jsr show_bits
		; move sprites
		ldx #ENUM_TOTAL - 1
--			; prepare Y to hold 2*X because sprite register layout is unfortunate
			txa
			asl
			tay
			; set x position
			lda table_x_lo, x
			clc
			adc #SPRITE_TO_WINDOW_X
			sta vic_xs0, y
			; collect x overflow bits
			lda table_x_hi, x
			adc #0
			lsr
			rol tmp
			; set y position
			lda table_y_lo, x
			clc
			adc #SPRITE_TO_WINDOW_Y
			sta vic_ys0, y
			; high byte of y is unused
			dex
			bpl --
		; fix x overflow
		lda tmp
		sta vic_msb_xs
		jmp mainloop

; helper function to update pot value
; entry: X = 0 for potx, X = 1 for poty
do_pot_stuff	lda sid_potx, x
		sta potx, x
		cmp minpot, x
		bcs +
			sta minpot, x
+		cmp maxpot, x
		bcc +
			sta maxpot, x
+		rts

; helper function to display bits of port byte
; entry: A = value, X = offset
show_bits	sec	; make sure first ROL inserts a 1
		rol	; get msb
		sta tmp
--			lda #'.'
			bcc ++
				lda #'#'
				clc
++			sta screen, x
			inx
			;clc
			rol tmp	; insert 0
			bne --
		rts


; helper function for Amiga/Atari mice, increments/decrements value
; entry: X = target offset ([0..ENUM_TOTAL[ for x change, +ENUM_TOTAL for y change)
; KEEPS Y!
; Z set means decrement, Z clear means increment
changeZ		beq .decrement
		bne .increment
; helper function for Amiga/Atari mice, increments/decrements value
; entry: X = target offset ([0..ENUM_TOTAL[ for x change, +ENUM_TOTAL for y change)
; KEEPS Y!
; C set means decrement, C clear means increment
changeC		bcs .decrement
.increment	inc table_x_lo, x
		bne restrict
			inc table_x_hi, x
			jmp restrict
.decrement	lda table_x_lo, x
		bne +
			dec table_x_hi, x
+		dec table_x_lo, x
		;FALLTHROUGH
; restrict to valid range ([0..ENUM_TOTAL[ for x, +ENUM_TOTAL for y)
; KEEPS Y!
restrict	lda table_x_hi, x
		bmi .zero_it
		cmp max_x_hi, x
		bcc .rts
		bne +
			lda max_x_lo, x
			cmp table_x_lo, x
			bcs .rts
+		lda max_x_lo, x
		sta table_x_lo, x
		lda max_x_hi, x
		sta table_x_hi, x
.rts		rts

.zero_it	lda #0
		sta table_x_lo, x
		sta table_x_hi, x
		rts


	!src "joystick.asm"
	!src "1351.asm"
	!src "amiga_st.asm"
	!src "cx22.asm"
	!src "koala.asm"


; tables
initial_x_lo	!for .i, 0, ENUM_TOTAL - 1 {
			!by 70 + .i * 32	; x lo
		}
		!fill ENUM_TOTAL, 64	; y lo
		!fill ENUM_TOTAL	; x hi
		!fill ENUM_TOTAL	; y hi

max_x_lo	!fill ENUM_TOTAL, <MAX_COORD_X
max_y_lo	!fill ENUM_TOTAL, <MAX_COORD_Y
max_x_hi	!fill ENUM_TOTAL, >MAX_COORD_X
max_y_hi	!fill ENUM_TOTAL, >MAX_COORD_Y

; variables
minpot	!word $ffff	; lowest pot values yet
maxpot	!word $0000	; highest pot values yet

; external data:

	table_x_lo	= external_data
	table_y_lo	= external_data + ENUM_TOTAL
	table_x_hi	= external_data + ENUM_TOTAL * 2
	table_y_hi	= external_data + ENUM_TOTAL * 3
