
spritegap3.tas:
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
