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

	/* switch into c64 mode */
	ld a,0xf6
	ld bc,0xd505
	out (c),a

	/* set the border color to indicate we are in c64 mode and we have access to the I/O, even when not memory mapped in */
	ld a,4
	ld bc,0xd020
	out (c),a

	/* try to set the border color with memory access */
	ld a,7
	ld (bc),a

	ld a,1
	cp 1
justloop:
	jr z,justloop

#endasm
}
