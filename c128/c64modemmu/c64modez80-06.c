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

/* get the value from i/o space at $a004 using in */
	ld bc,0xa004
	in a,(c)

/* is it ram (#$55) ?? */
	cp 0x55
	jr z,looks_like_ram

/* is it rom (#$43) ?? */
	cp 0x43
	jr z,looks_like_rom

/* copy the value into register d */
	ld d,a

/* get the value from i/o space at $a005 using in */
	inc bc
	in a,(c)

/* is it the same value ?? */
	cp d
	jr nz,vicii_value

/* just to be sure the value is static, get the value from i/o space at $a006 using in */
	inc bc
	in a,(c)

/* is it still the same ?? */
	cp d
	jr nz,wtf

static_value:
	ld a,7
	jr set_border

vicii_value:
	ld a,9
	jr set_border

/* we possible got ram, make sure $a005 and $a006 return what we expect from ram */
looks_like_ram:
	inc bc
	in a,(c)
	cp 0xaa
	jr nz,wtf
	inc bc
	in a,(c)
	cp 0x33
	jr nz,wtf

we_got_ram:
	ld a,4
	jr set_border
	
/* we possible got rom, make sure $a005 and $a006 return what we expect from rom */
looks_like_rom:
	inc bc
	in a,(c)
	cp 0x42
	jr nz,wtf
	inc bc
	in a,(c)
	cp 0x4d
	jr nz,wtf

we_got_rom:
	ld a,6
	jr set_border

wtf:
	ld a,2

set_border:
	ld bc,0xd020
	out (c),a

justloop:
	jr justloop

#endasm
}
