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

/* bank in bank 0 and I/O, the rest RAM */
	ld a,0x3e
	ld bc,0xff00
	ld (bc),a

/* set $0000-$3fff and $c000-$ffff as shared memory */
	ld a,0xf
	ld bc,0xd506
	out (c),a

/* bank in bank 1 and I/O, the rest RAM */
	ld a,0x7e
	ld bc,0xff00
	ld (bc),a

/* read from $c000 using in/out */
	ld bc,0xc000
	in a,(c)

	cp 0x55
	jr z,bank1

	cp 0xaa
	jr z,bank0

wtf:
	ld a,2
	ld d,0xff
	jr set_border

bank1:
	ld a,3
	ld d,0xff
	jr set_border

bank0:
	ld a,4
	ld d,0

set_border:
	ld bc,0xd020
	out (c),a
	ld bc,0xd7ff
	out (c),d

justloop:
	jr justloop

#endasm
}
