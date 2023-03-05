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

	/* to make sure, map in the c128 roms, in case the loader switched them back off */
	ld a,0
	ld bc,0xff00
	ld (bc),a

	/* set the 'roms found flag' to zero */
	ld e,0

	/* check if we can change the byte at $4000 */
	ld bc,0x4000
	ld a,(bc)
	ld d,a
	inc a
	ld (bc),a
	ld a,(bc)
	cp d
	jr nz,check_8000
	inc e

check_8000:
	/* check if we can change the byte at $8000 */
	ld bc,0x8000
	ld a,(bc)
	ld d,a
	inc a
	ld (bc),a
	ld a,(bc)
	cp d
	jr nz,check_c000
	inc e

check_c000:
	/* check if we can change the byte at $c000 */
	ld bc,0xc000
	ld a,(bc)
	ld d,a
	inc a
	ld (bc),a
	ld a,(bc)
	cp d
	jr nz,final_results
	inc e

final_results:
	/* check how many roms were found */
	ld a,e
	cp 0
	jr z,no_roms
	cp 3
	jr z,all_roms

some_roms:
	ld a,6
	ld d,0xff
	jr setborder

no_roms:
	ld a,4
	ld d,0xff
	jr setborder

all_roms:
	ld a,5
	ld d,0

setborder:
	ld bc,0xd020
	out (c),a
	ld bc,0xd7ff
	out (c),d

justloop:
	jr justloop

#endasm
}
