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

z80bios_found:
	/* set the border color to indicate we found the z80 bios in c128 mode */
	ld a,3
	ld bc,0xd020
	out (c),a

	/* check if we can change the border color through the out opcode */
	in d,(c)
	inc d
	out (c),d
	in a,(c)
	cp d
	jr nz,no_out

got_out:
	ld e,1
	jr check_mem

no_out:
	ld e,0

check_mem:
	/* try to set the border color through memory access */
	in d,(c)
	ld a,(bc)
	cp d
	jr nz,no_mem
	inc a
	ld (bc),a
	in a,(c)
	cp d
	jr nz,no_mem

got_mem:
	ld a,1
	cp e
	jr nz,wtf

got_mem_got_out:
	ld a,4
	ld d,0xff
	jr set_border

no_mem:
	ld a,1
	cp e
	jr nz,wtf

no_mem_got_out:
	ld a,5
	ld d,0
	jr set_border

wtf:
	ld a,3
	ld d,0xff

set_border:
	ld bc,0xd020
	out (c),a
	ld bc,0xd7ff
	out (c),d

justloop:
	jr justloop

#endasm
}
