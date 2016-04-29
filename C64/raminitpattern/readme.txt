
background: when you power on your C64, the RAM will not be zero, instead
typically (about) half of the RAM cells will be 1, and the other half will be 0.
this results in some kind of pattern typically (mostly) consisting of $00 and
$ff.

the actual pattern may depend on many things, such as the type of RAM used
(organisation, manufacturer, etc) and the main board.

since a surprising number of program (probably not deliberatly) depend on the
"correct" RAM init pattern, it is important to get this right in emulation.

================================================================================

hints on how to examine the init pattern
----------------------------------------

you can examine the init pattern using a cartridge with ML monitor (AR) like
this:

- power off the C64. leave it powered off for at least some minutes (yes really)
- power on the C64
- go to "fastload"
- enter the ML monitor (AR: MON)
- look at the memory in "screencode" mode (AR: I*0800-). let the whole memory
  scroll by, this makes it somewhat easier to recognize a pattern even when a
  bunch of values are not exactly $00 or $ff

if in doubt, save the entire memory range (AR: s"dump" 8 0000 ffff) and send the
file to someone from the VICE team for examination

================================================================================

pattern00ff.prg
---------------

this program scans the RAM area not used by the program itself and tries to find
the page that has least bytes that are neither $00 nor $ff. this page will be
displayed at the bottom (white).

this program will not get useful results for RAMs that show a pattern that is
more complex/longer than one page or when the initial pattern contains other
values than $00 and $ff.

platoontest.prg
---------------

extracted from the original Platoon tape - checks if the memory at $1000-$10ff
has been filled with the same constant value

darkstarbbstes.prg
------------------

extracted from the original Disk - checks if a couple of pages have been filled
with a constant value (first 10 values), or contain incrementing values in the
first 8 locations.

note: the first test fails on some common RAM init patterns!

================================================================================

VICE (2.4.27, rev 31063)

- page starts with 64 bytes $00, then 64 bytes $ff etc


results from other emulators
----------------------------

CCS64 (3.9)

- page starts with 64 times $ff, then 64 times $00 etc. additionally the bytes
  at offset $13, $53, $93, $d3 seem to be random

  -raminitstartvalue    255
  -raminitvalueinvert   64
  -raminitpatterninvert 0

HOXS54 (1.0.8.8)

- first come two pages with 128 bytes $ff, then 128 bytes $00... followed by two
  pages with 128 bytes $99, then 128 bytes $66. additionally the first bytes of
  each page seems to be random. (this is supposed to be taken from a real C64)

  -raminitstartvalue    255
  -raminitvalueinvert   128
  -raminitpatterninvert 0       (the $99/$66 stuff is not produced)

Micro64 (1.00.2013.05.11 - build 714)

- page starts with 64 bytes $00, then 64 bytes $ff etc

  -raminitstartvalue    0
  -raminitvalueinvert   64
  -raminitpatterninvert 0

results from real C64s
----------------------

C64 PAL Breadbox (gpz) (ASSY NO 250407, RAM: mT4264-15 / USA)

- page starts with $00, then $ff, $00, $ff etc. first 16 bytes of each page seem
  completely random. some more occasional random bytes in the rest of the page.
  pattern seems consistant across the whole memory range.

  -raminitstartvalue    0
  -raminitvalueinvert   1
  -raminitpatterninvert 0

C64 NTSC Breadbox (gpz) (ASSY 250425, RAM: KM4164B-10 / 931C KOREA)

- page starts with 8 times $00, then 8 times $ff, etc. lots of random bytes at
  no particular offsets. pattern seems to be the same on whole memory range

  -raminitstartvalue    0
  -raminitvalueinvert   8
  -raminitpatterninvert 0

C64C PAL (gpz) (ASSY NO 250469 R4, RAM: M41464-10 / OKI / JAPAN 833050)

- repeating 00,00,ff,ff,ff,ff,00,00 pattern, $every $4000 bytes the pattern
  seems to be inverted (for another $4000 bytes) ($4000-$7fff and $c000-$ffff
  show the inverted pattern). occasional random bytes, almost none after longer
  power off period.

  -raminitstartvalue    0
  -raminitvalueinvert   4
  -raminitpatterninvert 16384   (pattern starts with 4 zeros instead of 2)

C64C PAL (gpz) (ASSY NO 250469 R4, RAM: MN414644-08 / JAPAN 75252)

- page starts with $80 times $00, then $80 times $ff, etc. random bytes only at
  offset 0 of each page. oddly enough $4000-$cfff show the inverted pattern
  In this C64 the RAM content is persistant for literally minutes after power
  off!

  -raminitstartvalue    0
  -raminitvalueinvert   128
  -raminitpatterninvert 16384   (only $4000-$7fff will be inverted)

C64reloaded (gpz)

- page starts with 8 times $00, then 8 times $ff, etc. very few random bytes

  -raminitstartvalue    0
  -raminitvalueinvert   8
  -raminitpatterninvert 0

================================================================================

some problematic programs:

Typical/Beyond Force  (https://csdb.dk/release/?id=4136)
 - crashes in upscroller (first part), clearing RAM with zeros before RUN makes
   it work.

Flying Shark Preview+/Federation Against Copyright (https://csdb.dk/release/?id=21889)
 - crashes after crack intro, clearing RAM with zeros before RUN makes it work

Comic Art 09/Mayhem (https://csdb.dk/release/?id=38695)
 - crashes shortly after start, starting reset pattern with 255 makes it work

Defcom/Jazzcat Cracking Team (https://csdb.dk/release/?id=29387)
 - crashes right at the start, starting reset pattern with 255 makes it work

Platton.tap (original)
 - crashes while loading around counter 22 when RAM is cleared with zeros before


