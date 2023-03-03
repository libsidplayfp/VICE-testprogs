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

/* prepare $d501-$d504 mmu registers */
	ld bc,0xd501
	ld a,0x3c
	out (c),a
	inc bc
	ld a,0x38
	out (c),a
	inc bc
	ld a,0x34
	out (c),a
	inc bc
	ld a,0x30
	out (c),a

/* set $d500 to #$3e */
	ld bc,0xd500
	ld a,0x3e
	out (c),a

/* zero out the 'working' 'flag' (register d) */
	ld d,0

/* trigger PCRA at $ff01 */
check_ff01:
	ld bc,0xff01
	ld a,0xff
	ld (bc),a

/* check if $d500 is now #$3c */
	ld bc,0xd500
	in a,(c)
	cp 0x3c
	jr nz,check_ff02
	inc d

/* trigger PCRB at $ff02 */
check_ff02:
	ld bc,0xff02
	ld a,0xff
	ld (bc),a

/* check if $d500 is now #$38 */
	ld bc,0xd500
	in a,(c)
	cp 0x38
	jr nz,check_ff03
	inc d

/* trigger PCRC at $ff03 */
check_ff03:
	ld bc,0xff03
	ld a,0xff
	ld (bc),a

/* check if $d500 is now #$34 */
	ld bc,0xd500
	in a,(c)
	cp 0x34
	jr nz,check_ff04
	inc d

/* trigger PCRC at $ff04 */
check_ff04:
	ld bc,0xff04
	ld a,0xff
	ld (bc),a

/* check if $d500 is now #$30 */
	ld bc,0xd500
	in a,(c)
	cp 0x30
	jr nz,result_time
	inc d

result_time:
	ld a,d
	cp 0
	jr z,none
	cp 4
	jr z,all

some:
	ld a,4
	ld d,0xff
	jr set_border

none:
	ld a,3
	ld d,0xff
	jr set_border

all:
	ld a,5
	ld d,0

set_border:
	ld bc,0xd020
	out (c),a
	ld bc,0xd7ff
	out (c),d

justloop:
	jr justloop

#endasm
}
