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

temp:
	

z80bios_found:
	/* set the border color to indicate we found the z80 bios in c128 mode */
	ld a,3
	ld bc,0xd020
	out (c),a

/* reset the z80bios (d) and $04xx ram (e) and $d4xx ram (h) 'flags' */
	ld d,0
	ld e,0
	ld h,0
	ld l,0

/* switch to bank 1, since the z80 code is in both banks this is fine */
	ld a,0x7e
	ld bc,0xff00
	ld (bc),a

/* read from $048d memory */
	ld bc,0x048d
	in a,(c)
	cp 0x43
	jr z,got_048d_bios
	cp 0x11
	jr z,got_048d_ram_bank0
	cp 0x44
	jr z,got_d48d_ram_bank0
	cp 0x77
	jr z,got_048d_ram_bank1
	cp 0xaa
	jr z,got_d48d_ram_bank1
	jp wtf

got_048d_bios:
	inc d
	jr check_048e

got_048d_ram_bank0:
	ld a,e
	add a,0x10
	ld e,a
	jr check_048e

got_048d_ram_bank1:
	inc e
	jr check_048e

got_d48d_ram_bank0:
	ld a,h
	add a,0x10
	ld h,a
	jr check_048e

got_d48d_ram_bank1:
	inc h

check_048e:
/* read from $048e memory */
	inc bc
	in a,(c)
	cp 0x50
	jr z,got_048e_bios
	cp 0x22
	jr z,got_048e_ram_bank0
	cp 0x55
	jr z,got_d48e_ram_bank0
	cp 0x88
	jr z,got_048e_ram_bank1
	cp 0xbb
	jr z,got_d48e_ram_bank1
	jr wtf

got_048e_bios:
	inc d
	jr check_048f

got_048e_ram_bank0:
	ld a,e
	add a,0x10
	ld e,a
	jr check_048f

got_048e_ram_bank1:
	inc e
	jr check_048f

got_d48e_ram_bank0:
	ld a,h
	add a,0x10
	ld h,a
	jr check_048f

got_d48e_ram_bank1:
	inc h

check_048f:
/* read from $048f memory */
	inc bc
	in a,(c)
	cp 0x4d
	jr z,got_048f_bios
	cp 0x33
	jr z,got_048f_ram_bank0
	cp 0x66
	jr z,got_d48f_ram_bank0
	cp 0x99
	jr z,got_048f_ram_bank1
	cp 0xcc
	jr z,got_d48f_ram_bank1
	jr wtf

got_048f_bios:
	inc d
	jr final_results

got_048f_ram_bank0:
	ld a,e
	add a,0x10
	ld e,a
	jr final_results

got_048f_ram_bank1:
	inc e
	jr final_results

got_d48f_ram_bank0:
	ld a,h
	add a,0x10
	ld h,a
	jr final_results

got_d48f_ram_bank1:
	inc h

final_results:
	ld a,d
	cp 3
	jr z,got_04xx_bios
	ld a,e
	and 0xf0
	cp 0x30
	jr z,got_04xx_ram_bank0
	ld a,e
	and 0xf
	cp 3
	jr z,got_04xx_ram_bank1
	ld a,h
	and 0xf0
	cp 0x30
	jr z,got_d4xx_ram_bank0
	ld a,h
	and 0xf
	cp 3
	jr z,got_d4xx_ram_bank1

wtf:
	ld a,2
	jr set_border

got_04xx_bios:
	ld a,3
	jr set_border

got_04xx_ram_bank0:
	ld a,4
	jr set_border

got_04xx_ram_bank1:
	ld a,7
	jr set_border

got_d4xx_ram_bank0:
	ld a,6
	jr set_border

got_d4xx_ram_bank1:
	ld a,9

set_border:
	ld bc,0xd020
	out (c),a

justloop:
	jr justloop

#endasm
}
