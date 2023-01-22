
copied from https://sourceforge.net/p/vice-emu/bugs/1815/

The z80 implementation of OUTI, OUTD is:

b--
out (bc), (hl)
hl++ (for OUTI, hl-- for OUTD)

This means that the following code should work (and does work -verified- on real HW)

        LD hl, mmutable+10  ; point to end of mmutable
        LD bc, #$D50A       ; point to end of MMU registers
mmuloop:
        INC B               ; preincrease B to D6 so that in OUTD D5 will be found
        OUTD
        DEC C
        JR NZ, mmuloop      ; this way we intentionally exclude D500

mmutable: DB 3f, 7f, 3e, 7e, B0, 0A, 00, 01, 01, 01

NOTE: there is a story around stating c128 'outi' and such are defunct but this
incorrectly assumes the 'b--' happens at the end (like in INI, IND). Because the
b-- happens at the start the output to the bus does work as intended.

The Zilog documentation states OUTI,OUTD do 'b--' at the start.


tstouti.prg:

basic loader starts Z80 and tests the above.

Black border means success, grey border means failure.
