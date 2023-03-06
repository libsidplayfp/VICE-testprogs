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

/* switch off the i/o bit */
	ld a,0x3f
	ld bc,0xff00
	ld (bc),a

/* reset the z80bios (d) and ram (e) 'flags' */
	ld d,0
	ld e,0

/* read from $048d memory */
	ld bc,0x048d
	ld a,(bc)
	cp 0x43
	jr nz,check_048d_ram
	inc d
	jr check_048e

check_048d_ram:
	cp 0x55
	jr nz,wtf
	inc e

check_048e:
	inc bc
	ld a,(bc)
	cp 0x50
	jr nz,check_048e_ram
	inc d
	jr check_048f

check_048e_ram:
	cp 0xaa
	jr nz,wtf
	inc e

check_048f:
	inc bc
	ld a,(bc)
	cp 0x4d
	jr nz,check_048f_ram
	inc d
	jr final_results

check_048f_ram:
	cp 0x33
	jr nz,wtf
	inc e

final_results:
	ld a,d
	cp 3
	jr z,got_bios
	ld a,e
	cp 3
	jr z,got_ram

wtf:
	ld a,2
	ld d,0xff
	jr set_border

got_bios:
	ld a,5
	ld d,0
	jr set_border

got_ram:
	ld a,4
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
