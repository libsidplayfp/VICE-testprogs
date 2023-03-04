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

/* store #$55 at memory address $4000 */
	ld a,0x55
	ld bc,0x4000
	ld (bc),a

/* store #$aa at memory address $4001 */
	ld a,0xaa
	inc bc
	ld (bc),a

/* store #$33 at memory address $4002 */
	ld a,0x33
	inc bc
	ld (bc),a

/* get a value from i/o address $4000 using in */
	ld bc,0x4000
	in a,(c)

/* is it #$55 ?? */
	cp 0x55
	jr z,check_4001_for_aa

/* save the value in register d */
	ld d,a

/* get the value from i/o address $4001 using in */
	inc bc
	in a,(c)

/* is it the same value as from i/o address $4000 ?? */
	cp d
	jr nz,vicii_value

/* just to be sure it is static get the value from i/o address $4002 using in */
	inc bc
	in a,(c)

/* is it a static value ?? */
	cp d
	jr z,static_value

/* get a value from i/o address $4001 using in */
check_4001_for_aa:
	inc bc
	in a,(c)

/* is it #$aa ?? */
	cp 0xaa
	jr nz,wtf

/* get a value from i/o address $4002 using in */
	inc bc
	in a,(c)

/* is it #$33 ?? */
	cp 0x33
	jr nz,wtf

got_ram:
	ld a,5
	ld d,0
	jr set_border

wtf:
	ld a,2
	ld d,0xff
	jr set_border

static_value:
	ld a,4
	ld d,0xff
	jr set_border

vicii_value:
	ld a,6
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
