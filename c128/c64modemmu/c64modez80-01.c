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

	/* try to change the border color using in/out */
	ld bc,0xd020
	in a,(c)
	ld d,a
	inc a
	out (c),a
	in a,(c)
	cp d
	jr z,wtf

	/* try to set the border color using memory access */
	in a,(c)
	inc a
	ld d,a
	ld (bc),a
	in a,(c)
	cp d
	jr z,both

only_io:
	ld a,4
	ld d,0xff
	jr set_border

wtf:
	ld a,6
	ld d,0xff
	jr set_border

both:
	ld a,5
	ld d,0

set_border:
	ld bc,0xd020
	out (c),a
	ld bc,0xd7ff
	out (c),d

	ld a,1
	cp 1
justloop:
	jr z,justloop

#endasm
}
