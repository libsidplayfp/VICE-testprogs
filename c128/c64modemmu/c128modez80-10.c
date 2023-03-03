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

/* see if we can read $d500 */
	in a,(c)
	cp 0x3f
	jr z,d5xx_still_active

/* re-enable the mmu bit through memory access to $ff00 */
	ld a,0x30
	ld bc,0xff00
	ld (bc),a

/* check if $d500 is back and has 0x30 in it */
	ld bc,0xd500
	in a,(c)
	cp 0x30
	jr nz,wtf

d5xx_depends_on_mmu_bit:
	ld a,3
	jr set_border

d5xx_still_active:
	ld a,4
	jr set_border

wtf:
	ld a,2

set_border:
	ld bc,0xd020
	out (c),a

justloop:
	jr justloop

#endasm
}
