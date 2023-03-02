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

	/* set the border color to indicate we are in c64 mode */
	ld a,4
	ld bc,0xd020
	out (c),a

	/* check if we can still access the z80 bios */
	ld bc,0x048d
	ld a,(bc)
	cp 0x43
	jr nz,noz80bios_in_c64mode

	inc bc
	ld a,(bc)
	cp 0x50
	jr nz,noz80bios_in_c64mode

	inc bc
	ld a,(bc)
	cp 0x4d
	jr z,z80bios_found_in_c64mode

noz80bios_in_c64mode:
	ld d,0
	jr scan_for_c64_basic

z80bios_found_in_c64mode:
	ld d,1

scan_for_c64_basic:
	ld bc,0xa004
	ld a,(bc)
	cp 0x43
	jr nz,noc64basic

	inc bc
	ld a,(bc)
	cp 0x42
	jr nz,noc64basic

	inc bc
	ld a,(bc)
	cp 0x4d
	jr z,c64basic_found

noc64basic:
	ld e,0
	jr final_border_color

c64basic_found:
	ld e,1

final_border_color:
	ld b, 0xff
	ld a,1
	cp d
	jr nz,no_d
	cp e
	jr nz,got_d_no_e

got_d_got_e:
; got bios, got basic in c64 mode
	ld a,10
	jr setborder

no_d:
	cp e
	jr nz,no_d_no_e

no_d_got_e:
	ld a,5
	jr setborder

got_d_no_e:
	ld a,7
	jr setborder

no_d_no_e:
	ld a,4

setborder:
	ld d,b
	ld bc,0xd020
	out (c),a
	ld bc,0xd7ff
	out (c),b

justloop:
	jr justloop

#endasm
}
