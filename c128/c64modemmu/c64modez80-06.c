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

     /* get the mmu version register in z80 reg D */
	ld bc,0xd50b
	in d,(c)

	/* toggle bit 0 of $ff00/$d500 */
	ld bc,0xd500
	in a,(c)
	or 1
	out (c),a

	/* switch into c64 mode */
	ld a,0xf6
	ld bc,0xd505
	out (c),a

	/* get the mmu version register in z80 reg A */
	ld bc,0xd50b
	in a,(c)
	cp a,d
	jr nz,in_c64mode

noc64mode:
	jr z,noc64mode

in_c64mode:

	/* check if we find the color memory at $1000-$13ff using memory access */
	ld d,0
	ld bc,0x1000

check_1000_loop:
	ld a,(bc)
	and 0xf
	cp d
	jr nz,no_1000
	ld a,d
	inc a
	and 0xf
	ld d,a
	inc bc
	ld a,c
	cp 0
	jr nz,check_1000_loop
	ld a,b
	cp 0x14
	jr nz,check_1000_loop

got_1000:
	ld a,6
	jr set_border

no_1000:
	ld a,4

set_border:
	ld bc,0xd020
	out (c),a

	ld a,1
	cp 1
justloop:
	jr z,justloop

#endasm
}
