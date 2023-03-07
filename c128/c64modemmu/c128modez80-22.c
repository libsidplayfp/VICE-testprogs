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

/* reset the mirror amount 'flag' (d) */
	ld d,0

/* read from $d020 I/O */
	ld bc,0xd020
	in a,(c)

/* keep the result in e, increment the value and put it in the I/O mirror at $d060 */
	inc a
	and 0xf
	ld e,a
	ld bc,0xd060
	out (c),a

/* read from $d020 again and compare with e */
	ld bc,0xd020
	in a,(c)
	and 0xf
	cp e
	jr nz,try_d120
	inc d

/* read from $d020 I/O */
try_d120:
	ld bc,0xd020
	in a,(c)

/* keep the result in e, increment the value and put it in the I/O mirror at $d120 */
	inc a
	and 0xf
	ld e,a
	ld bc,0xd120
	out (c),a

/* read from $d020 again and compare with e */
	ld bc,0xd020
	in a,(c)
	and 0xf
	cp e
	jr nz,try_d220
	inc d

/* read from $d020 I/O */
try_d220:
	ld bc,0xd020
	in a,(c)

/* keep the result in e, increment the value and put it in the I/O mirror at $d220 */
	inc a
	and 0xf
	ld e,a
	ld bc,0xd220
	out (c),a

/* read from $d020 again and compare with e */
	ld bc,0xd020
	in a,(c)
	and 0xf
	cp e
	jr nz,try_d320
	inc d

/* read from $d020 I/O */
try_d320:
	ld bc,0xd020
	in a,(c)

/* keep the result in e, increment the value and put it in the I/O mirror at $d320 */
	inc a
	and 0xf
	ld e,a
	ld bc,0xd320
	out (c),a

/* read from $d020 again and compare with e */
	ld bc,0xd020
	in a,(c)
	and 0xf
	cp e
	jr nz,final_results
	inc d

final_results:
	ld a,d
	cp 0
	jr z,no_mirrors
	cp 1
	jr z,only_d0xx_mirrors
	cp 4
	jr z,all_d0xx_d3xx_mirrors

wtf:
	ld a,2
	jr set_border

no_mirrors:
	ld a,3
	jr set_border

only_d0xx_mirrors:
	ld a,4
	jr set_border

all_d0xx_d3xx_mirrors:
	ld a,6

set_border:
	ld bc,0xd020
	out (c),a

justloop:
	jr justloop

#endasm
}
