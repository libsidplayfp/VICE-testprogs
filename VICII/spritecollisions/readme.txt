sprite-gfx-collision-cycle.prg:
CCBBBBB    (C64, C64C)
CBBBBBB    (DTV)

sprite-sprite-collision-cycle.prg:
CC@@@@@    (C64, C64C)
C@@@@@@    (DTV)

sprite-sprite.prg: (C64, C64C)
---------@-
---------@-

sprite-sprite.prg: (DTV)
@@--@--@-@-
---------@-

TODO:
- automatically generate DTV versions as well
- verify and fix NTSC versions

--------------------------------------------------------------------------------

sprite-sprite-hi-hi.prg
sprite-sprite-hi-mc.prg
sprite-sprite-mc-hi.prg
sprite-sprite-mc-mc.prg

test the basic functionality of sprite vs sprite collisions. all non transparent
sprite pixels can collide with each other.

sprite-gfx-hi-hi.prg
sprite-gfx-hi-mc.prg
sprite-gfx-mc-hi.prg
sprite-gfx-mc-mc.prg

test the basic functionality of sprite vs gfx collisions. all non transparent
sprite pixels can collide with non background gfx pixels (in multicolor mode
this means "11" and "10" pixels).
