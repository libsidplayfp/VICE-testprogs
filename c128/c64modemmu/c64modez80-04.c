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

	/* check what we find in the vicii color memory at $d800-$dbff */
	ld d,0
	ld e,0
	ld bc,0xd800

	in a,(c)
	and 0xf
	ld d,a
	inc bc

check_d800_loop:
	in a,(c)
	and 0xf
	cp d
	jr nz,wtf
	inc bc
	ld a,c
	cp 0
	jr nz,check_d800_loop
	ld a,b
	cp 0xdc
	jr nz,check_d800_loop

got_d800:
	ld a,d
	cp 5
	jr z,got_5
	cp 0xa
	jr z,got_a
wtf:
	ld a,4
	ld d,0xff
	jr set_border

got_5:
	ld a,5
	ld d,0
	jr set_border

got_a:
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
