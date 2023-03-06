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

/* reset the z80bios (d) and $04xx ram (e) and $d4xx ram (h) 'flags' */
	ld d,0
	ld e,0
	ld h,0

/* read from $048d memory */
	ld bc,0x048d
	in a,(c)
	cp 0x43
	jr z,got_048d_bios
	cp 0x55
	jr z,got_048d_ram
	cp 0x66
	jr z,got_d48d_ram
	jr wtf

got_048d_bios:
	inc d
	jr check_048e

got_048d_ram:
	inc e
	jr check_048e

got_d48d_ram:
	inc h

check_048e:
	inc bc
	in a,(c)
	cp 0x50
	jr z,got_048e_bios
	cp 0xaa
	jr z,got_048e_ram
	cp 0x99
	jr z,got_d48e_ram
	jr wtf

got_048e_bios:
	inc d
	jr check_048f

got_048e_ram:
	inc e
	jr check_048f

got_d48e_ram:
	inc h

check_048f:
	inc bc
	in a,(c)
	cp 0x4d
	jr z,got_048f_bios
	cp 0x33
	jr z,got_048f_ram
	cp 0xcc
	jr z,got_d48f_ram
	jr wtf

got_048f_bios:
	inc d
	jr final_results

got_048f_ram:
	inc e
	jr final_results

got_d48f_ram:
	inc h

final_results:
	ld a,d
	cp 3
	jr z,got_04xx_bios
	ld a,e
	cp 3
	jr z,got_04xx_ram
	ld a,h
	cp 3
	jr z,got_d4xx_ram

wtf:
	ld a,2
	ld d,0xff
	jr set_border

got_04xx_bios:
	ld a,3
	ld d,0xff
	jr set_border

got_04xx_ram:
	ld a,4
	ld d,0xff
	jr set_border

got_d4xx_ram:
	ld a,5
	ld d,0

set_border:
	ld bc,0xd020
	out (c),a
	ld bc,0x7ff
	out (c),d

justloop:
	jr justloop

#endasm
}
