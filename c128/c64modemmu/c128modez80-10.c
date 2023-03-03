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

/* clear the i/o bit of the mmu */
	ld a,0x3f
	ld bc,0xd500
	out (c),a

/* try to set the border color to violet */
	ld a,4
	ld bc,0xd020
	out (c),a

/* the border color itself will indicate if the i/o range has been disabled or not
   cyan means yes, i/o range is disabled
   violet means no, i/o range is NOT disabled
 */

justloop:
	jr justloop

#endasm
}
