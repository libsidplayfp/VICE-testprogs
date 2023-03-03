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

/* set a new value for mmu register 0 through memory access $ff00 */
	ld bc,0xff00
	ld a,0x3c
	ld (bc),a

/* get the current value of mmu register 0 through i/o $d500 */
	ld bc,0xd500
	in d,(c)

/* check if they are the same */
	cp d
	jr nz,ff00_cannot_write

/* check if a change in $ff00 is reflected in $d500 */
check_d500_change:
	ld a,0x30
	ld bc,0xff00
	ld (bc),a
	ld bc,0xd500
	in d,(c)
	cp d
	jr nz,ff00_cannot_write

	ld a,0x3f
	ld bc,0xff00
	ld (bc),a
	ld bc,0xd500
	in d,(c)
	cp d
	jr nz,ff00_cannot_write

	ld a,0x3e
	ld bc,0xff00
	ld (bc),a
	ld bc,0xd500
	in d,(c)
	cp d
	jr z,ff00_can_write

	ld a,0x3f
	ld bc,0xff00
	ld (bc),a
	ld bc,0xd500
	in d,(c)
	cp d
	jr z,wtf

ff00_depens_on_mmu_io_bit:
	ld a,4
	ld d,0xff
	jr set_border

ff00_can_write:
	ld a,6
	ld d,0xff
	jr set_border

ff00_cannot_write:
	ld a,5
	ld d,0
	jr set_border

wtf:
	ld a,7

set_border:
	ld bc,0xd020
	out (c),a
	ld bc,0xd7ff
	out (c),d

justloop:
	jr justloop

#endasm
}
