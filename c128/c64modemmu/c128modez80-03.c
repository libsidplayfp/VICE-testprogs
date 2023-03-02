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

	/* check if we find the color memory at $d800-$dbff */
	ld d,0
	ld e,0
	ld bc,0xd800

check_d800_loop:
	in a,(c)
	and 0xf
	cp d
	jr nz,check_1000
	ld a,d
	inc a
	and 0xf
	ld d,a
	inc bc
	ld a,c
	cp 0
	jr nz,check_d800_loop
	ld a,b
	cp 0xdc
	jr nz,check_d800_loop

got_d800:
	ld e,1

check_1000:
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
	ld a,e
	cp 1
	jr nz,no_d800_got_1000

got_d800_got_1000:
	ld a,5
	ld d,0
	jr set_border

no_1000:
	ld a,e
	cp 1
	jr nz,no_d800_no_1000

got_d800_no_1000:
	ld a,6
	ld d,0xff
	jr set_border

no_d800_got_1000:
	ld a,4
	ld d,0xff
	jr set_border

no_d800_no_1000:
	ld a,3
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
