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

	/* check if we can change the byte at $4000 */
	ld bc,0x4000
	ld a,(bc)
	ld d,a
	inc a
	ld (bc),a
	ld a,(bc)
	cp d
	jr z,c128romfound

	/* check if we can change the byte at $8000 */
	ld bc,0x8000
	ld a,(bc)
	ld d,a
	inc a
	ld (bc),a
	ld a,(bc)
	cp d
	jr z,c128romfound

	/* check if we can change the byte at $c000 */
	ld bc,0xc000
	ld a,(bc)
	ld d,a
	inc a
	ld (bc),a
	ld a,(bc)
	cp d
	jr z,c128romfound

	/* set color for no c128 roms found */
	ld a,4
	jr setborder

c128romfound:
	/* set color for c128 roms found */
	ld a,3

setborder:
	ld bc,0xd020
	out (c),a

	ld a,1
	cp 1
justloop:
	jr z,justloop

#endasm
}
