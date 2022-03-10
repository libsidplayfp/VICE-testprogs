
Some tests to check REU DMA timing vs VICII (badline- and sprite-) DMA

--------------------------------------------------------------------------------
--- testing REU->C64
--------------------------------------------------------------------------------

a.prg:

all 8 Sprites are active, x- and y-expanded, starting at line 132 and 8 lines
apart vertically (y-pos = 132, 140, 148, 156, 164, 172, 180, 188)

one REU transfer is started at the top of the gfx area, producing a color change
in $d020 each cycle.

a2.prg:

same as a.prg, but the sprites are NOT active

b.prg:

same as a.prg, but with the gfx area disabled (but still producing badline DMA)

b2.prg:

like b.prg, but the sprites are NOT active

b3.prg:

like b.prg, but the sprites are in revers vertical order (y-pos = 188, 180, 172,
164, 156, 148, 140, 132)

c.prg:

one short REU transfer per 8 rasterlines, offset by one cycle so one will end
on the start of a badline.

- does NOT work in x64sc 3.5 r39581

c2.prg:

like c.prg, but the transfer is one cycle shorter, resulting in a different 
pattern.

- does NOT work in x64sc 3.5 r39581

d.prg:

like c.prg, but with sprite 7 active in the lines where the dma happens

- does NOT work in x64sc 3.5 r39581

d2.prg:

like d.prg, but the transfer is one cycle shorter, resulting in a different 
pattern.

- does NOT work in x64sc 3.5 r39581

--------------------------------------------------------------------------------
--- testing C64->REU
--------------------------------------------------------------------------------

e.prg:

all 8 Sprites are active, x- and y-expanded, starting at line 132 and 8 lines
apart vertically (y-pos = 132, 140, 148, 156, 164, 172, 180, 188)

one REU transfer is started at the top of the gfx area, transfering the low byte
of CIA timer A into the REU each cycle. The resulting pattern is then transferred
back and compared with a reference.

e2.prg:

like e.prg, but sprites are NOT active

e3.prg:

like e.prg, but the sprites are in revers vertical order (y-pos = 188, 180, 172,
164, 156, 148, 140, 132)

f.prg:

one short REU transfer per 8 rasterlines, offset by one cycle so one will end
on the start of a badline. transfers the low byte of CIA timer A into the REU
each cycle. The resulting pattern is then transferred back and compared with a
reference.

f2.prg:

like f.prg, but the transfer is one cycle shorter, resulting in a different 
pattern.

g.prg:

like f.prg, but with sprite 7 active in the lines where the dma happens

g2.prg:

like g.prg, but the transfer is one cycle shorter, resulting in a different 
pattern.

xxx-m2.prg variants of all of the above are the same programs, but contain
reference data taken from a breadbin C64 with "old" VICII - see below

--------------------------------------------------------------------------------
--- testing C64<->REU (swap)
--------------------------------------------------------------------------------

a3.prg:

all 8 Sprites are active, x- and y-expanded, starting at line 132 and 8 lines
apart vertically (y-pos = 132, 140, 148, 156, 164, 172, 180, 188)

one REU transfer is started at the top of the gfx area, producing a color change
in $d020 every other cycle.

FIXME: reference screenshot for this test is missing

a4.prg:

same as a3.prg, but the sprites are NOT active

FIXME: reference screenshot for this test is missing

b4.prg:

same as a3.prg, but with the gfx area disabled (but still producing badline DMA)

FIXME: reference screenshot for this test is missing

b5.prg:

like b4.prg, but the sprites are NOT active

FIXME: reference screenshot for this test is missing

b6.prg:

like b4.prg, but the sprites are in revers vertical order (y-pos = 188, 180, 172,
164, 156, 148, 140, 132)

FIXME: reference screenshot for this test is missing

c3.prg:

one short REU transfer per 8 rasterlines, offset by one cycle so one will end
on the start of a badline.

FIXME: reference screenshot exists but isnt 100% verified

c4.prg:

like c3.prg, but the transfer is one cycle shorter, resulting in a different 
pattern.

FIXME: reference screenshot for this test is missing

d3.prg:

like c3.prg, but with sprite 7 active in the lines where the dma happens

FIXME: reference screenshot exists but isnt 100% verified

d4.prg:

like d3.prg, but the transfer is one cycle shorter, resulting in a different 
pattern.

FIXME: reference screenshot for this test is missing

e4.prg:

all 8 Sprites are active, x- and y-expanded, starting at line 132 and 8 lines
apart vertically (y-pos = 132, 140, 148, 156, 164, 172, 180, 188)

one REU transfer is started at the top of the gfx area, swapping the low byte
of CIA timer A with the REU memory every other cycle. The resulting pattern is
then transferred back and compared with a reference.

e5.prg:

like e4.prg, but sprites are NOT active

e5.prg:

like e4.prg, but the sprites are in revers vertical order (y-pos = 188, 180, 172,
164, 156, 148, 140, 132)


f3.prg:

one short REU transfer per 8 rasterlines, offset by one cycle so one will end
on the start of a badline. swaps the low byte of CIA timer A with REU memory
every other cycle. The resulting pattern is then transferred back and compared
with a reference.

f4.prg:

like f3.prg, but the transfer is one byte (two cycles) shorter, resulting in a
different pattern.

g3.prg:

like f3.prg, but with sprite 7 active in the lines where the dma happens

g4.prg:

like g3.prg, but the transfer is one byte (two cycles) shorter, resulting in a
different pattern.

xxx-m2.prg variants of all of the above are the same programs, but contain
reference data taken from a breadbin C64 with "old" VICII - see below

--------------------------------------------------------------------------------

There are a couple interesting edge cases:

- When the DMA is triggered by writing to $ff00 using a RMW instruction, the
  first "dummy" write will start the DMA immediatly, the CPU will be
  disconnected from the bus instantly and the second write cycle will go to
  "nowhere", so it will not end up in the computers RAM.
  (emulated in VICE 3.6.1, -> see rmwtrigger test)

- When a REU DMA is interrupted by a VIC DMA it will take one extra cycle
  (emulated in VICE 3.6.1)

- When reading from I/O, the first byte of a transfer that is started in the
  same cycle as a VIC DMA would be may come from the RAM under the I/O instead.
  This seems to happen (to be confirmed) when the "new" VICII is used and/or
  a "new" motherboard is used (C64C) - on "breadbox" with "old" VICII we
  apparently get the expected value from I/O (see the -m2 test variants).

- TODO: There exists some weird condition when one (the last?) value of a 
  transfer is written twice (also see badoublewrite test)

--------------------------------------------------------------------------------

TODO:
- check $ff00 trigger
-- with timing
- check "compare"
- for all tests add a check for the overall transfer length (timing in cycles)
