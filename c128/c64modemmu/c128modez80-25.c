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
	ld a,10
	ld bc,0xd020
	out (c),a

/* put #$33 in $0100 through memory access */
	ld bc,0x0100
	ld a,0x33
	ld (bc),a

/* exit the main function and return to the 8502 */

#endasm
}
