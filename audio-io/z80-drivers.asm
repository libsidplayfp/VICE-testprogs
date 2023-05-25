#include "z80-defines.h"

SECTION code_user

; public

PUBLIC _test_os
PUBLIC _set_sid_addr_asm
PUBLIC _set_digimax_addr_asm
PUBLIC _userport_4bit_input_init
PUBLIC _userport_2bit_4bit_input_init
PUBLIC _userport_2bit_4bit_ks1_sb2_input_init
PUBLIC _sid_output_init
PUBLIC _sfx_expander_output_init
PUBLIC _userport_digimax_output_init
PUBLIC _userport_dac_output_init
PUBLIC _set_input_function
PUBLIC _set_output_function
PUBLIC _stream
PUBLIC _disable_irq

._test_os
	push af
	push bc
	push de
	ld bc,IOBASE+0x0020
	in a,(c)
	ld e,a
	and 0x0f
	inc a
	ld bc,IOBASE+0x0060
	ld d,a
	out (c),a
	ld bc,IOBASE+0x0020
	in a,(c)
	and 0x0f
	cp d
	jr nz,not_correct_os
	ld l,1
	jr end_os_test
    
.not_correct_os
	ld l,0

.end_os_test
	out (c),e
	pop de
	pop bc
	pop af
	ret

; input software, returns sample in A
.input_software
	ld bc,IOBASE+0x0000
	in a,(c)
	inc a
	out (c),a
	ret

; input SFX SAMPLER, returns sample in A
.input_sfx_sampler
	ld bc,IOBASE+0x0f00
	in a,(c)
	ld bc,IOBASE+0x0e00
	out (c),a
	ret

; input USERPORT 4BIT & PET2 4BIT, returns sample in A
.input_userport_4bit
	ld bc,IOBASE+0x0d01
	in a,(c)
	and 0xf0
	ret

; input JOY1 4BIT, returns sample in A
.input_joy1_4bit
	ld bc,IOBASE+0x0c01
	in a,(c)
.do_asl4
	sla a
	sla a
	sla a
	sla a
	ret

; input JOY1 2BIT, returns sample in A
.input_joy1_2bit
	ld bc,IOBASE+0x0c01
	in a,(c)
.do_asl6
	sla a
	sla a
	jr do_asl4

; input JOY2 2BIT, returns sample in A
.input_joy2_2bit
	ld bc,IOBASE+0x0c00
	in a,(c)
	sla a
	sla a
	jr do_asl4

; input JOY2 4BIT, returns sample in A
.input_joy2_4bit
	ld bc,IOBASE+0x0c00
	in a,(c)
	jr do_asl4

; input PET1 2BIT, returns sample in A
.userport_2bit_input
	ld bc,IOBASE+0x0d01
	in a,(c)
	sla a
	sla a
	jr do_asl4

; input PET1 4BIT, returns sample in A
.userport_4bit_input
	ld bc,IOBASE+0x0d01
	in a,(c)
	jr do_asl4

; input PET2 2BIT, returns sample in A
.userport_2bit_pet2_input
	ld bc,IOBASE+0x0d01
	in a,(c)
	sla a
	sla a
	ret

; input KINGSOFT1 2BIT, returns sample in A
.userport_2bit_ks1_input
	ld bc,IOBASE+0x0d00
	in a,(c)
	and 0x04
	sla a
	sla a
	sla a
	sla a
	ld d,a
	ld bc,IOBASE+0x0d01
	in a,(c)
	and 0x80
	or d
	ret

; input KINGSOFT1 4BIT, returns sample in A
.userport_4bit_ks1_input
	ld bc,IOBASE+0x0d00
	in a,(c)
	and 0x04
	sla a
	sla a
	ld d,a
	ld bc,IOBASE+0x0d01
	in a,(c)
	ld e,a
	and 0x20
	sla a
	sla a
	or d
	ld d,a
	ld a,e
	and 0x40
	or d
	ld d,a
	ld a,e
	and 0x80
	sla a
	sla a
	or d
	ret

; input KINGSOFT2 2BIT, returns sample in A
.userport_2bit_ks2_input
	ld bc,IOBASE+0x0d01
	in a,(c)
	ld e,a
	and 0x04
	sla a
	sla a
	sla a
	sla a
	sla a
	ld d,a
	ld a,e
	and 0x08
	sla a
	sla a
	sla a
	or d
	ret

; input KINGSOFT2 4BIT, returns sample in A
.userport_4bit_ks2_input
	ld bc,IOBASE+0x0d01
	in a,(c)
	ld e,a
	and 0x01
	sla a
	sla a
	sla a
	sla a
	sla a
	sla a
	sla a
	ld d,a
	ld a,e
	and 0x02
	sla a
	sla a
	sla a
	sla a
	sla a
	or d
	ld d,a
	ld a,e
	and 0x04
	sla a
	sla a
	sla a
	or d
	ld d,a
	ld a,e
	and 0x08
	sla a
	or d
	ret

; input STARBYTE1 2BIT, returns sample in A
.userport_2bit_sb1_input
	ld bc,IOBASE+0x0d01
	in a,(c)
	ld e,a
	and 0x01
	sla a
	sla a
	sla a
	sla a
	sla a
	sla a
	sla a
	ld d,a
	ld a,e
	and 0x08
	sla a
	sla a
	sla a
	or d
	ret
	
; input STARBYTE1 4BIT, returns sample in A
.userport_4bit_sb1_input
	ld bc,IOBASE+0x0d01
	in a,(c)
	ld e,a
	and 0x01
	sla a
	sla a
	sla a
	sla a
	sla a
	ld d,a
	ld a,e
	and 0x02
	sla a
	sla a
	sla a
	sla a
	sla a
	sla a
	or d
	ld d,a
	ld a,e
	and 0x04
	sla a
	sla a
	sla a
	sla a
	or d
	ld d,a
	ld a,e
	and 0x08
	sla a
	or d
	ret

; input STARBYTE2 2BIT, returns sample in A
.userport_2bit_sb2_input
	ld bc,IOBASE+0x0d00
	in a,(c)
	and 0x04
	sla a
	sla a
	sla a
	sla a
	ld d,a
	ld bc,IOBASE+0x0d01
	in a,(c)
	and 0x20
	sla a
	sla a
	or d
	ret

; input STARBYTE2 4BIT, returns sample in A
.userport_4bit_sb2_input
	ld bc,IOBASE+0x0d00
	in a,(c)
	and 0x04
	sla a
	sla a
	ld d,a
	ld bc,IOBASE+0x0d01
	in a,(c)
	ld e,a
	and 0x20
	or d
	ld d,a
	ld a,e
	and 0x40
	sla a
	or d
	ld d,a
	ld a,e
	and 0x80
	srl a
	or d
	ret

; store sid, data in L, offset in H
.store_sid
	ld bc,IOBASE+0x0400
	ld a,c
	add a,h
	ld c,a
	out (c),l
	ret

; address in HL
._set_sid_addr_asm
	push af
	push bc
	ld bc,store_sid+1
	ld a,l
	ld (bc),a
	inc bc
	ld a,h
	ld (bc),a
	pop bc
	pop af
	ret

.setup_sid
    ld h,0
    ld l,h
.sid_loop
	call store_sid
	inc h
	ld a,h
	cp 0x20
	jr nz,sid_loop
	ret

._sid_output_init
	push af
	push bc
	push hl
	call setup_sid
	ld l,0xff
	ld h,0x06
	call store_sid
	ld h,0x0d
	call store_sid
	ld h,0x14
	call store_sid
	ld l,0x49
	ld h,0x04
	call store_sid
	ld d,0x0b
	call store_sid
	ld h,0x12
	call store_sid
	pop hl
	pop bc
	pop af
	ret

; L = register, H = value
.sfx_se_write
	ld bc,IOBASE+0x0f40
	out (c),l
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
	ld bc,IOBASE+0x0f50
	out (c),h
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
	nop
	nop
	nop
	nop
	ret

._sfx_expander_output_init
	push af
	push bc
	push hl
	ld h,0x21
	ld l,0x20
	call sfx_se_write        ; Sets MULTI=1,AM=0,VIB=0,KSR=0,EG=1 for operator 1
	ld h,0xf0
	ld l,0x60
	call sfx_se_write        ; Sets attack rate to 15 and decay rate to 0 for operator 1
	ld l,0x80
	call sfx_se_write        ; Sets the sustain level to 15 and the release rate to 0 for operator 1
	ld h,0x01
	ld l,0xc0
	call sfx_se_write        ; Feedback=0 and Additive Synthesis is on  for voice 1 [which is operator 1 and operator 4]
	ld h,0x00
	ld l,0xe0
	call sfx_se_write        ; Waveform=regular sine wave for operator 1
	ld h,0x3f
	ld l,0x43
	call sfx_se_write        ; sets total level=63 and attenuation for operator 4
	ld h,0x01
	ld l,0xb0
	call sfx_se_write
	ld h,0x8f
	ld l,0xa0
	call sfx_se_write
	ld h,0x2e
	ld l,0xb0
	call sfx_se_write
	ld bc,IOBASE+0x0012
	in a,(c)
	ld b,0x0a
.sfx_se_loop1
	ld c,0xde
.sfx_se_loop2
	dec c
	ld a,c
	cp 0
	jr nz,sfx_se_loop2
	dec b
	ld a,b
	cp 0
	jr nz,sfx_se_loop1
	ld h,0x20
	ld l,0xb0
	call sfx_se_write
	ld h,0x00
	ld l,0xb0
	call sfx_se_write
	pop hl
	pop bc
	pop af
	ret

._userport_digimax_output_init
._userport_dac_output_init
	push af
	push bc
	ld bc,IOBASE+0x0d03
	ld a,0xff
	out (c),a
	pop bc
	pop af
	ret

._userport_4bit_input_init
	push af
	push bc
	ld bc,IOBASE+0x0d02
	in a,(c)
	or 0x04
	out (c),a
	ld bc,IOBASE+0x0d00
	in a,(c)
	and 0xfb
	out (c),a
._userport_2bit_4bit_input_init
	ld bc,IOBASE+0x0d03
	ld a,0x00
	out (c),a
	pop bc
	pop af
	ret

._userport_2bit_4bit_ks1_sb2_input_init
	push af
	push bc
	ld bc,IOBASE+0x0d02
	in a,(c)
	and 0xfb
	out (c),a
	ld a,0x00
	ld bc,IOBASE+0x0d03
	out (c),a
	pop bc
	pop af
	ret

.inception_byte_1
	defb 0

.inception_byte_2
	defb 0

.inception_byte_3
	defb 0

.inception_byte_4
	defb 0

.inception_byte_5
	defb 0

.inception_byte_6
	defb 0

.inception_byte_7
	defb 0

.inception_byte_8
	defb 0

.inception_j1_input_bytes
	ld a,0x00
	ld bc,IOBASE+0x0c01
	out (c),a
	ld a,0x1f
	ld bc,IOBASE+0x0c03
	out (c),a
	ld a,0x10
	ld bc,IOBASE+0x0c01
	out (c),a
	ld bc,IOBASE+0x0c03
	out (c),a
	ld de,inception_byte_1
	ld bc,IOBASE+0x0c01
	ld l,0
.inception_j1_loop
	in a,(c)
	sla a
	sla a
	sla a
	sla a
	ld h,a
	ld a,0x00
	out (c),a
	in a,(c)
	and 0x0f
	or h
	ld (de),a
	ld a,0x10
	out (c),a
	inc de
	inc l
	ld a,l
	cp 0x08
	jr nz,inception_j1_loop
	ld a,0x7f
	out (c),a
	ld a,0xff
	ld bc,IOBASE+0x0c03
	out (c),a
	ret

.inception_j2_input_bytes
	ld a,0x00
	ld bc,IOBASE+0x0c00
	out (c),a
	ld a,0x1f
	ld bc,IOBASE+0x0c02
	out (c),a
	ld a,0x10
	ld bc,IOBASE+0x0c00
	out (c),a
	ld bc,IOBASE+0x0c02
	out (c),a
	ld de,inception_byte_1
	ld bc,IOBASE+0x0c00
	ld l,0
.inception_j2_loop
	in a,(c)
	sla a
	sla a
	sla a
	sla a
	ld h,a
	ld a,0x00
	out (c),a
	in a,(c)
	and 0x0f
	or h
	ld (de),a
	ld a,0x10
	out (c),a
	inc de
	inc l
	ld a,l
	cp 0x08
	jr nz,inception_j2_loop
	ld a,0x7f
	out (c),a
	ld a,0xff
	ld bc,IOBASE+0x0c02
	out (c),a
	ret

.inc_2bit_j1p1_input
	call inception_j1_input_bytes
	ld de,inception_byte_1
	ld a,(de)
	jp do_asl6

.inc_2bit_j1p2_input
	call inception_j1_input_bytes
	ld de,inception_byte_2
	ld a,(de)
	jp do_asl6

.inc_2bit_j1p3_input
	call inception_j1_input_bytes
	ld de,inception_byte_3
	ld a,(de)
	jp do_asl6

.inc_2bit_j1p4_input
	call inception_j1_input_bytes
	ld de,inception_byte_4
	ld a,(de)
	jp do_asl6

.inc_2bit_j1p5_input
	call inception_j1_input_bytes
	ld de,inception_byte_5
	ld a,(de)
	jp do_asl6

.inc_2bit_j1p6_input
	call inception_j1_input_bytes
	ld de,inception_byte_6
	ld a,(de)
	jp do_asl6

.inc_2bit_j1p7_input
	call inception_j1_input_bytes
	ld de,inception_byte_7
	ld a,(de)
	jp do_asl6

.inc_2bit_j1p8_input
	call inception_j1_input_bytes
	ld de,inception_byte_8
	ld a,(de)
	jp do_asl6

.inc_4bit_j1p1_input
	call inception_j1_input_bytes
	ld de,inception_byte_1
	ld a,(de)
	jp do_asl4

.inc_4bit_j1p2_input
	call inception_j1_input_bytes
	ld de,inception_byte_2
	ld a,(de)
	jp do_asl4

.inc_4bit_j1p3_input
	call inception_j1_input_bytes
	ld de,inception_byte_3
	ld a,(de)
	jp do_asl4

.inc_4bit_j1p4_input
	call inception_j1_input_bytes
	ld de,inception_byte_4
	ld a,(de)
	jp do_asl4

.inc_4bit_j1p5_input
	call inception_j1_input_bytes
	ld de,inception_byte_5
	ld a,(de)
	jp do_asl4

.inc_4bit_j1p6_input
	call inception_j1_input_bytes
	ld de,inception_byte_6
	ld a,(de)
	jp do_asl4

.inc_4bit_j1p7_input
	call inception_j1_input_bytes
	ld de,inception_byte_7
	ld a,(de)
	jp do_asl4

.inc_4bit_j1p8_input
	call inception_j1_input_bytes
	ld de,inception_byte_8
	ld a,(de)
	jp do_asl4

.inc_2bit_j2p1_input
	call inception_j2_input_bytes
	ld de,inception_byte_1
	ld a,(de)
	jp do_asl6

.inc_2bit_j2p2_input
	call inception_j2_input_bytes
	ld de,inception_byte_2
	ld a,(de)
	jp do_asl6

.inc_2bit_j2p3_input
	call inception_j2_input_bytes
	ld de,inception_byte_3
	ld a,(de)
	jp do_asl6

.inc_2bit_j2p4_input
	call inception_j2_input_bytes
	ld de,inception_byte_4
	ld a,(de)
	jp do_asl6

.inc_2bit_j2p5_input
	call inception_j2_input_bytes
	ld de,inception_byte_5
	ld a,(de)
	jp do_asl6

.inc_2bit_j2p6_input
	call inception_j2_input_bytes
	ld de,inception_byte_6
	ld a,(de)
	jp do_asl6

.inc_2bit_j2p7_input
	call inception_j2_input_bytes
	ld de,inception_byte_7
	ld a,(de)
	jp do_asl6

.inc_2bit_j2p8_input
	call inception_j2_input_bytes
	ld de,inception_byte_8
	ld a,(de)
	jp do_asl6

.inc_4bit_j2p1_input
	call inception_j2_input_bytes
	ld de,inception_byte_1
	ld a,(de)
	jp do_asl4

.inc_4bit_j2p2_input
	call inception_j2_input_bytes
	ld de,inception_byte_2
	ld a,(de)
	jp do_asl4

.inc_4bit_j2p3_input
	call inception_j2_input_bytes
	ld de,inception_byte_3
	ld a,(de)
	jp do_asl4

.inc_4bit_j2p4_input
	call inception_j2_input_bytes
	ld de,inception_byte_4
	ld a,(de)
	jp do_asl4

.inc_4bit_j2p5_input
	call inception_j2_input_bytes
	ld de,inception_byte_5
	ld a,(de)
	jp do_asl4

.inc_4bit_j2p6_input
	call inception_j2_input_bytes
	ld de,inception_byte_6
	ld a,(de)
	jp do_asl4

.inc_4bit_j2p7_input
	call inception_j2_input_bytes
	ld de,inception_byte_7
	ld a,(de)
	jp do_asl4

.inc_4bit_j2p8_input
	call inception_j2_input_bytes
	ld de,inception_byte_8
	ld a,(de)
	jp do_asl4

; output SID, sample in A
.output_sid
	srl a
	srl a
	srl a
	srl a
	ld l,a
	ld h,0x18
	call store_sid
	ret

; output SFX SAMPLER, sample in A
.output_sfx_sampler
	ld bc,IOBASE+0x0f00
	out (c),a
	ret

; output SFX SOUND EXPANDER, sample in A
.output_sfx_expander
	srl a
	srl a
	ld h,a
	ld l,0x40
	call sfx_se_write
	ret

; output DIGIMAX, sample in A
.store_digimax
.output_digimax
	ld bc,IOBASE+0x0e00
	out (c),a
	inc bc
	out (c),a
	inc bc
	out (c),a
	inc bc
	out (c),a
	ret

; address in HL
._set_digimax_addr_asm
	push af
	push bc
	ld bc,store_digimax+1
	ld a,l
	ld (bc),a
	inc bc
	ld a,h
	ld (bc),a
	pop bc
	pop af
	ret

; output USERPORT DIGIMAX/DAC, sample in A
.output_userport_digimax
.output_userport_dac
	ld bc,IOBASE+0x0d01
	out (c),a
	ret

; show sample in border color, sample in A
.show_sample
	ld d,a
	ld bc,IOBASE+0x0020
	srl a
	srl a
	srl a
	srl a
	out (c),a
	ld a,d
	ret

._stream
	di
.stream_loop
; input
.input_function
	call 0x1234
; show sample
	call show_sample
; output
.output_function
	call 0x4321
; repeat
	jr stream_loop

; input function type in L
._set_input_function
	push af
	push bc
	push de
	ld a,l
	cp INPUT_SOFTWARE
	jp z,set_input_software
	cp INPUT_SFX_SAMPLER
	jp z,set_input_sfx_sampler
	cp INPUT_USERPORT_4BIT
	jp z,set_input_userport_4bit
	cp INPUT_JOY1_4BIT
	jp z,set_input_joy1_4bit
	cp INPUT_JOY1_2BIT
	jp z,set_input_joy1_2bit
	cp INPUT_JOY2_4BIT
	jp z,set_input_joy2_4bit
	cp INPUT_JOY2_2BIT
	jp z,set_input_joy2_2bit
	cp INPUT_USERPORT_JOY_4
	jp z,set_userport_4bit_input
	cp INPUT_USERPORT_JOY_2
	jp z,set_userport_2bit_input
	cp INPUT_USERPORT_PET2
	jp z,set_userport_2bit_pet2_input
	cp INPUT_USERPORT_KS1_2BIT
	jp z,set_userport_2bit_ks1_input
	cp INPUT_USERPORT_KS1_4BIT
	jp z,set_userport_4bit_ks1_input
	cp INPUT_USERPORT_KS2_2BIT
	jp z,set_userport_2bit_ks2_input
	cp INPUT_USERPORT_KS2_4BIT
	jp z,set_userport_4bit_ks2_input
	cp INPUT_USERPORT_SB1_2BIT
	jp z,set_userport_2bit_sb1_input
	cp INPUT_USERPORT_SB1_4BIT
	jp z,set_userport_4bit_sb1_input
	cp INPUT_USERPORT_SB2_2BIT
	jp z,set_userport_2bit_sb2_input
	cp INPUT_USERPORT_SB2_4BIT
	jp z,set_userport_4bit_sb2_input
	cp INPUT_INCEPTION_J1P1_2BIT
	jp z,set_2bit_inc_j1p1_input
	cp INPUT_INCEPTION_J1P2_2BIT
	jp z,set_2bit_inc_j1p2_input
	cp INPUT_INCEPTION_J1P3_2BIT
	jp z,set_2bit_inc_j1p3_input
	cp INPUT_INCEPTION_J1P4_2BIT
	jp z,set_2bit_inc_j1p4_input
	cp INPUT_INCEPTION_J1P5_2BIT
	jp z,set_2bit_inc_j1p5_input
	cp INPUT_INCEPTION_J1P6_2BIT
	jp z,set_2bit_inc_j1p6_input
	cp INPUT_INCEPTION_J1P7_2BIT
	jp z,set_2bit_inc_j1p7_input
	cp INPUT_INCEPTION_J1P8_2BIT
	jp z,set_2bit_inc_j1p8_input
	cp INPUT_INCEPTION_J1P1_4BIT
	jp z,set_4bit_inc_j1p1_input
	cp INPUT_INCEPTION_J1P2_4BIT
	jp z,set_4bit_inc_j1p2_input
	cp INPUT_INCEPTION_J1P3_4BIT
	jp z,set_4bit_inc_j1p3_input
	cp INPUT_INCEPTION_J1P4_4BIT
	jp z,set_4bit_inc_j1p4_input
	cp INPUT_INCEPTION_J1P5_4BIT
	jp z,set_4bit_inc_j1p5_input
	cp INPUT_INCEPTION_J1P6_4BIT
	jp z,set_4bit_inc_j1p6_input
	cp INPUT_INCEPTION_J1P7_4BIT
	jp z,set_4bit_inc_j1p7_input
	cp INPUT_INCEPTION_J1P8_4BIT
	jp z,set_4bit_inc_j1p8_input
	cp INPUT_INCEPTION_J2P1_2BIT
	jp z,set_2bit_inc_j2p1_input
	cp INPUT_INCEPTION_J2P2_2BIT
	jp z,set_2bit_inc_j2p2_input
	cp INPUT_INCEPTION_J2P3_2BIT
	jp z,set_2bit_inc_j2p3_input
	cp INPUT_INCEPTION_J2P4_2BIT
	jp z,set_2bit_inc_j2p4_input
	cp INPUT_INCEPTION_J2P5_2BIT
	jp z,set_2bit_inc_j2p5_input
	cp INPUT_INCEPTION_J2P6_2BIT
	jp z,set_2bit_inc_j2p6_input
	cp INPUT_INCEPTION_J2P7_2BIT
	jp z,set_2bit_inc_j2p7_input
	cp INPUT_INCEPTION_J2P8_2BIT
	jp z,set_2bit_inc_j2p8_input
	cp INPUT_INCEPTION_J2P1_4BIT
	jp z,set_4bit_inc_j2p1_input
	cp INPUT_INCEPTION_J2P2_4BIT
	jp z,set_4bit_inc_j2p2_input
	cp INPUT_INCEPTION_J2P3_4BIT
	jp z,set_4bit_inc_j2p3_input
	cp INPUT_INCEPTION_J2P4_4BIT
	jp z,set_4bit_inc_j2p4_input
	cp INPUT_INCEPTION_J2P5_4BIT
	jp z,set_4bit_inc_j2p5_input
	cp INPUT_INCEPTION_J2P6_4BIT
	jp z,set_4bit_inc_j2p6_input
	cp INPUT_INCEPTION_J2P7_4BIT
	jp z,set_4bit_inc_j2p7_input
	cp INPUT_INCEPTION_J2P8_4BIT
	jp z,set_4bit_inc_j2p8_input
.end_set_input_function
	pop de
	pop bc
	pop af
	ret

.set_input
	ld bc,input_function+1
	ld a,e
	ld (bc),a
	inc bc
	ld a,d
	ld (bc),a
	jr end_set_input_function

.set_input_software
	ld de,input_software
	jr set_input

.set_input_sfx_sampler
	ld de,input_sfx_sampler
	jr set_input

.set_input_userport_4bit
	ld de,input_userport_4bit
	jr set_input

.set_input_joy1_4bit
	ld de,input_joy1_4bit
	jr set_input

.set_input_joy1_2bit
	ld de,input_joy1_2bit
	jr set_input

.set_input_joy2_4bit
	ld de,input_joy2_4bit
	jr set_input

.set_input_joy2_2bit
	ld de,input_joy2_2bit
	jr set_input

.set_userport_2bit_input
	ld de,userport_2bit_input
	jr set_input

.set_userport_4bit_input
	ld de,userport_4bit_input
	jr set_input

.set_userport_2bit_pet2_input
	ld de,userport_2bit_pet2_input
	jr set_input

.set_userport_2bit_ks1_input
	ld de,userport_2bit_ks1_input
	jr set_input

.set_userport_4bit_ks1_input
	ld de,userport_4bit_ks1_input
	jr set_input

.set_userport_2bit_ks2_input
	ld de,userport_2bit_ks2_input
	jr set_input

.set_userport_4bit_ks2_input
	ld de,userport_4bit_ks2_input
	jr set_input

.set_userport_2bit_sb1_input
	ld de,userport_2bit_sb1_input
	jr set_input

.set_userport_4bit_sb1_input
	ld de,userport_4bit_sb1_input
	jr set_input

.set_userport_2bit_sb2_input
	ld de,userport_2bit_sb2_input
	jr set_input

.set_userport_4bit_sb2_input
	ld de,userport_4bit_sb2_input
	jr set_input

.set_2bit_inc_j1p1_input
	ld de,inc_2bit_j1p1_input
	jr set_input

.set_2bit_inc_j1p2_input
	ld de,inc_2bit_j1p2_input
	jp set_input

.set_2bit_inc_j1p3_input
	ld de,inc_2bit_j1p3_input
	jp set_input

.set_2bit_inc_j1p4_input
	ld de,inc_2bit_j1p4_input
	jp set_input

.set_2bit_inc_j1p5_input
	ld de,inc_2bit_j1p5_input
	jp set_input

.set_2bit_inc_j1p6_input
	ld de,inc_2bit_j1p6_input
	jp set_input

.set_2bit_inc_j1p7_input
	ld de,inc_2bit_j1p7_input
	jp set_input

.set_2bit_inc_j1p8_input
	ld de,inc_2bit_j1p8_input
	jp set_input

.set_4bit_inc_j1p1_input
	ld de,inc_4bit_j1p1_input
	jp set_input

.set_4bit_inc_j1p2_input
	ld de,inc_4bit_j1p2_input
	jp set_input

.set_4bit_inc_j1p3_input
	ld de,inc_4bit_j1p3_input
	jp set_input

.set_4bit_inc_j1p4_input
	ld de,inc_4bit_j1p4_input
	jp set_input

.set_4bit_inc_j1p5_input
	ld de,inc_4bit_j1p5_input
	jp set_input

.set_4bit_inc_j1p6_input
	ld de,inc_4bit_j1p6_input
	jp set_input

.set_4bit_inc_j1p7_input
	ld de,inc_4bit_j1p7_input
	jp set_input

.set_4bit_inc_j1p8_input
	ld de,inc_4bit_j1p8_input
	jp set_input

.set_2bit_inc_j2p1_input
	ld de,inc_2bit_j2p1_input
	jp set_input

.set_2bit_inc_j2p2_input
	ld de,inc_2bit_j2p2_input
	jp set_input

.set_2bit_inc_j2p3_input
	ld de,inc_2bit_j2p3_input
	jp set_input

.set_2bit_inc_j2p4_input
	ld de,inc_2bit_j2p4_input
	jp set_input

.set_2bit_inc_j2p5_input
	ld de,inc_2bit_j2p5_input
	jp set_input

.set_2bit_inc_j2p6_input
	ld de,inc_2bit_j2p6_input
	jp set_input

.set_2bit_inc_j2p7_input
	ld de,inc_2bit_j2p7_input
	jp set_input

.set_2bit_inc_j2p8_input
	ld de,inc_2bit_j2p8_input
	jp set_input

.set_4bit_inc_j2p1_input
	ld de,inc_4bit_j2p1_input
	jp set_input

.set_4bit_inc_j2p2_input
	ld de,inc_4bit_j2p2_input
	jp set_input

.set_4bit_inc_j2p3_input
	ld de,inc_4bit_j2p3_input
	jp set_input

.set_4bit_inc_j2p4_input
	ld de,inc_4bit_j2p4_input
	jp set_input

.set_4bit_inc_j2p5_input
	ld de,inc_4bit_j2p5_input
	jp set_input

.set_4bit_inc_j2p6_input
	ld de,inc_4bit_j2p6_input
	jp set_input

.set_4bit_inc_j2p7_input
	ld de,inc_4bit_j2p7_input
	jp set_input

.set_4bit_inc_j2p8_input
	ld de,inc_4bit_j2p8_input
	jp set_input

; output function type in L
._set_output_function
	push af
	push bc
	push de
	ld a,l
	cp OUTPUT_SID
	jr z,set_output_sid
	cp OUTPUT_SFX_SAMPLER
	jr z,set_output_sfx_sampler
	cp OUTPUT_SFX_EXPANDER
	jr z,set_output_sfx_expander
	cp OUTPUT_CART_DIGIMAX
	jr z,set_output_digimax
	cp OUTPUT_SHORTBUS_DIGIMAX
	jr z,set_output_digimax
	cp OUTPUT_USERPORT_DIGIMAX
	jr z,set_output_userport_digimax
	cp OUTPUT_USERPORT_DAC
	jr z,set_output_userport_dac
.end_set_output_function
	pop de
	pop bc
	pop af
	ret

.set_output
	ld bc,output_function+1
	ld a,e
	ld (bc),a
	inc bc
	ld a,d
	ld (bc),a
	jr end_set_output_function

.set_output_sid
	ld de,output_sid
	jr set_output

.set_output_sfx_sampler
	ld de,output_sfx_sampler
	jr set_output

.set_output_sfx_expander
	ld de,output_sfx_expander
	jr set_output

.set_output_digimax
	ld de,output_digimax
	jr set_output

.set_output_userport_digimax
.set_output_userport_dac
	ld de,output_userport_digimax
	jr set_output

._disable_irq
	di
	ret
