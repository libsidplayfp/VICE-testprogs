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

/* switch to bank 1, code in bank 0 is the same as bank 1, so switching is fine */
	ld a,0x7e
	ld bc,0xd500
	out (c),a

/* check if we find vicii color memory mapped in at $1000-$13ff */
check_1000:
	ld d,0
	ld bc,0x1000

check_1000_loop:
	ld a,(bc)
	and 0xf
	cp d
	jr nz,unmapped
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

/* looks like the vicii color memory is still accessable, so set border color to indicate it */
still_mapped:
	ld a,4
	jr set_border

/* looks like the vicii color memory is not longer accessable, so set border color to indicate it */
unmapped:
	ld a,3
	jr set_border

wtf:
	ld a,6

set_border:
	ld bc,0xd020
	out (c),a

	ld a,1
	cp 1
justloop:
	jr z,justloop

#endasm
}
