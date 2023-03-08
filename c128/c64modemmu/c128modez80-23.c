#include <stdlib.h>

void main()
{
#asm
	/* set the border color to indicate we made it into z80 mode */
	ld a,1
	ld bc,0xd020
	out (c),a

	/* check if we can access the z80 bios */
	ld bc,0x048d
	ld a,(bc)
	cp 0x43
	jr nz,noz80bios

	inc bc
	ld a,(bc)
	cp 0x50
	jr nz,noz80bios

	inc bc
	ld a,(bc)
	cp 0x4d
	jr z,z80bios_found

noz80bios:
	jr nz,noz80bios

temp:
	

z80bios_found:
	/* set the border color to indicate we found the z80 bios in c128 mode */
	ld a,3
	ld bc,0xd020
	out (c),a

/* reset the 'flags' (d/e) */
	ld d,0
	ld e,0

/* read from $d700 I/O */
	ld bc,0xd700
	in a,(c)

/* copy this first value into h in case it is a constant value */
	ld h,a

/* check what we got */
	cp 0x55
	jr z,d700_ram
	cp 0x30
	jr z,d700_rom
	jr check_d701

d700_ram:
	ld a,d
	add a,0x10
	ld d,a
	jr check_d701

d700_rom:
	inc d

check_d701:
/* read from $d701 I/O */
	inc bc
	in a,(c)

/* check what we got */
	cp 0xaa
	jr z,d701_ram
	cp 0x07
	jr z,d701_rom
	cp l
	jr z,d701_constant

d701_other:
	ld a,e
	add a,0x10
	ld e,a
	jr check_d702

d701_ram:
	ld a,d
	add a,0x10
	ld d,a
	jr check_d702

d701_rom:
	inc d
	jr check_d702

d701_constant:
	inc e

check_d702:
/* read from $d702 I/O */
	inc bc
	in a,(c)

/* check what we got */
	cp 0x33
	jr z,d702_ram
	cp 0xcd
	jr z,d702_rom
	cp l
	jr z,d702_constant

d702_other:
	ld a,e
	add a,0x10
	ld e,a
	jr final_results

d702_ram:
	ld a,d
	add a,0x10
	ld d,a
	jr final_results

d702_rom:
	inc d
	jr final_results

d702_constant:
	inc e

final_results:
	ld a,d
	and 0xf0
	cp 0x30
	jr z,d7xx_ram

	ld a,d
	and 0xf
	cp 3
	jr z,d7xx_rom

	ld a,e
	and 0xf0
	cp 0x20
	jr z,d7xx_other

	ld a,e
	and 0xf
	cp 2
	jr z,d7xx_constant

d7xx_other:
	ld a,5
	ld d,0
	jr set_border

d7xx_ram:
	ld a,3
	ld d,0xff
	jr set_border

d7xx_rom:
	ld a,4
	ld d,0xff
	jr set_border

d7xx_constant:
	ld a,6
	ld d,0xff
	jr set_border

set_border:
	ld bc,0xd020
	out (c),a
	ld bc,0xd7ff
	out (c),d

justloop:
	jr justloop

#endasm
}
