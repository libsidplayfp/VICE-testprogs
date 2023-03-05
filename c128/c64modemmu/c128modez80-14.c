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

/* map the zero page to page $40 */
	ld bc,0xd508
	ld a,0
	out (c),a
	dec bc
	ld a,0x40
	out (c),a

/* read from $4080 using in/out */
	ld bc,0x4080
	in a,(c)

	cp 0x55
	jr z,zeropage

	cp 0xaa
	jr z,page40

	cp 0x0a
	jr z,z80bios

wtf:
	ld a,2
	ld d,0xff
	jr set_border

zeropage:
	ld a,5
	ld d,0
	jr set_border

page40:
	ld a,4
	ld d,0xff
	jr set_border

z80bios:
	ld a,6
	ld d,0xff

set_border:
	ld bc,0xd020
	out (c),a
	ld bc,0xd7ff
	out (c),a

justloop:
	jr justloop

#endasm
}
