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

/* zero out the '$ff00 working' 'flag' (register d) */
	ld d,0

/* zero out the '$ff01-$ff04 working' 'flag' (register e) */
	ld e,0

/* try to set the $d500 register through in/out to $ff00 */
	ld a,0x30
	ld bc,0xff00
	out (c),a

/* check if $d500 changed */
	ld bc,0xd500
	in a,(c)
	cp 0x30
	jr nz,check_read_ff00
	ld d,2

/* set the $d500 register */
check_read_ff00:
	ld a,0x38
	out (c),a

/* check if $ff00 can be used to read the new value */
	ld bc,0xff00
	in a,(c)
	cp 0x38
	jr nz,check_ff01
	inc d

/* trigger PCRA at $ff01 */
check_ff01:
	ld bc,0xd500
	ld a,0x3e
	out (c),a
	ld bc,0xff01
	ld a,0xff
	out (c),a

/* check if $d500 is now #$3c */
	ld bc,0xd500
	in a,(c)
	cp 0x3c
	jr nz,check_ff02
	inc e

/* trigger PCRB at $ff02 */
check_ff02:
	ld bc,0xff02
	ld a,0xff
	out (c),a

/* check if $d500 is now #$38 */
	ld bc,0xd500
	in a,(c)
	cp 0x38
	jr nz,check_ff03
	inc e

/* trigger PCRC at $ff03 */
check_ff03:
	ld bc,0xff03
	ld a,0xff
	out (c),a

/* check if $d500 is now #$34 */
	ld bc,0xd500
	in a,(c)
	cp 0x34
	jr nz,check_ff04
	inc e

/* trigger PCRC at $ff04 */
check_ff04:
	ld bc,0xff04
	ld a,0xff
	out (c),a

/* check if $d500 is now #$30 */
	ld bc,0xd500
	in a,(c)
	cp 0x30
	jr nz,result_time
	inc e

result_time:
	ld a,d
	cp 0
	jr z,ff00_nothing
	cp 1
	jr z,ff00_readable_only
	cp 2
	jr z,ff00_writable_only
	cp 3
	jr z,ff00_both

wtf:
	ld a,2
	jr set_border

ff00_nothing:
	ld a,e
	cp 0
	jr z,ff00_nothing_ff0x_nothing
	cp 4
	jr z,ff00_nothing_ff0x_all
	jr wtf

ff00_readable_only:
	ld a,e
	cp 0
	jr z,ff00_readable_only_ff0x_nothing
	cp 4
	jr z,ff00_readable_only_ff0x_all
	jr wtf

ff00_writable_only:
	ld a,e
	cp 0
	jr z,ff00_writable_only_ff0x_nothing
	cp 4
	jr z,ff00_writable_only_ff0x_all
	jr wtf

ff00_both:
	ld a,e
	cp 0
	jr z,ff00_both_ff0x_nothing
	cp 4
	jr z,ff00_both_ff0x_all
	jr wtf

ff00_nothing_ff0x_nothing:
	ld a,3
	ld d,0xff
	jr set_border

ff00_nothing_ff0x_all:
	ld a,9
	ld d,0xff
	jr set_border

ff00_readable_only_ff0x_nothing:
	ld a,4
	ld d,0xff
	jr set_border

ff00_readable_only_ff0x_all:
	ld a,10
	ld d,0xff
	jr set_border

ff00_writable_only_ff0x_nothing:
	ld a,6
	ld d,0xff
	jr set_border

ff00_writable_only_ff0x_all:
	ld a,12
	ld d,0xff
	jr set_border

ff00_both_ff0x_nothing:
	ld a,7
	ld d,0xff
	jr set_border

ff00_both_ff0x_all:
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
