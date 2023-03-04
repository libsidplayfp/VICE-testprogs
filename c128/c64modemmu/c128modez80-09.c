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

/* disable $1000-$13ff vicii color memory mapping */
	ld a,0x3f
	ld bc,0xff00
	ld (bc),a

/* fill ram at $1000-$13ff with #$aa */
fill_1000:
	ld a,0xaa
	ld bc,0x1000

fill_1000_loop:
	ld (bc),a
	inc bc
	ld a,c
	cp 0
	jr nz,fill_1000_loop
	ld a,b
	cp 0x14
	jr nz,fill_1000_loop

/* enable $1000-$13ff vicii color memory mapping */
	ld a,0x3e
	ld bc,0xff00
	ld (bc),a

/* fill vicii color ram at $1000-$13ff with #$55 */
fill_vicii_color_1000:
	ld a,0xaa
	ld bc,0x1000

fill_vicii_color_1000_loop:
	ld (bc),a
	inc bc
	ld a,c
	cp 0
	jr nz,fill_vicii_color_1000_loop
	ld a,b
	cp 0x14
	jr nz,fill_vicii_color_1000_loop

/* disable $1000-$13ff vicii color memory mapping */
	ld a,0x3f
	ld bc,0xff00
	ld (bc),a


/* check ram at $1000-$13ff, if it has #$55, there was bleed through, if it has #$aa there was none
	ld d,0x55
	ld bc,0x1000

check_1000_loop:
	ld a,(bc)
	cp d
	jr nz,no_bleed_through
	inc bc
	ld a,c
	cp 0
	jr nz,check_1000_loop
	ld a,b
	cp 0x14
	jr nz,check_1000_loop

/* there was bleed through, set the correct border color to indicate it */
bleed_through:
	ld a,5
	ld d,0
	jr set_border

/* there was NO bleed through, set the correct border color to indicate it */
no_bleed_through:
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
