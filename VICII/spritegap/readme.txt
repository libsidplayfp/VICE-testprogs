
spritegap3.prg:
Testprog to determine the unusual behaviour of sprites in the border area.

The prog moves sprite#n and sprite#m (n=0..6, m=n+1..7) in x-position (x=0..0x1FF)
The sprites patterns are

  sprite#n:
00000...00000
...
01000...00000

   sprite#m:
 00000...00000
 ...
 10000...00000

and xpos(sprite#m) = xpos(sprite#n) + 1 (y = 128 for both).

so they usually should collide all the time. But they don't.

The testprogs reads/clears $D01E at line 144 and tests for collision at line 160,
so the FF-<idle>-FF effect at sprites row 0 has no effect for the test.

Every change in the collision behaviour is logged at memory $4000 in the form
<sprite mask> <xpos-low> <xpos-high> <new collision mask>

Example:
4000  03 63 01 00  03 7f 01 03
4008  03 f8 01 00  05 01 00 05
4010  05 63 01 00  05 8f 01 05
...

This means:
Sprite#0 and sprite#1 stop colliding at 0x0163, they collide again at 0x17f
and stop colliding at 0x1f8. Sprite#0 and Sprite#2 collide at 0x001, they
stop colliding at 0x163 and collide again at 0x18f.


spritegap2.prg:
Uses slightly different sprite pattern.


---------------------------------------------------------------------------


spritegap3-6569r1.prg
---------------------

Dumped on Machine 1 (tlr):

C64: PAL Breadbox (silver badge)
Ser# WG C 3264

CPU:  MOS/6510 CBM/4782
CIA1: MOS/6526/3884
CIA2: MOS/6526R4/3583
VICII: 6569R1 (guess)
SID: none


spritegap3-6569.prg
-------------------

Dumped on Machine 1 (tlr):

C64: PAL Breadbox
Ser# U.K.B 1521345

CPU:  MOS/6510 CBM/3184
CIA1: MOS/6526/3884
CIA2: MOS/6526 R4/3283
VICII: 6569R3 (guess)
SID: <unknown>


spritegap3-6572.prg
-------------------

Dumped on Machine 1 (hedning):

Drean C64C (SC-136712), rev a-motherboard from 1982 (assy: 326298).
CPU: MOS/6510/0683
CIA1: <unknown>
CIA2: <unknown>
VICII: 6572R1 (guess)
SID: MOS/6581/5182 


spritegap2-ntsc-c128.dump
spritegap3-ntsc-c128.dump
-------------------------

Dumped on unknown machine.

spritegap3-pal-newvic.dump
--------------------------

Dumped on unknown machine. (Rubi?)

---------------------------------------------------------------------------
