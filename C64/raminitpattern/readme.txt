
background: when you power on your C64, the RAM will not be zero, instead
typically (about) half of the RAM cells will be 1, and the other half will be 0.
this results in some kind of pattern typically (mostly) consisting of $00 and
$ff.

the actual pattern may depend on many things, such as the type of RAM used
(organisation, manufacturer, etc) and the main board.

since a surprising number of program (probably not deliberatly) depend on the
"correct" RAM init pattern, it is important to get this right in emulation.

================================================================================

pattern00ff.prg
---------------

this program scans the a000-ffff area and tries to find the page that has least
bytes that are neither $00 nor $ff. this page will be displayed at the bottom
(white).

this program will not get useful results for RAMs that show a pattern that is
more complex/longer than one page.

================================================================================

results from current emulators
------------------------------

CCS64 (3.9)

- page starts with 64 times $ff, then 64 times $00 etc. additionally the bytes
  at offset $13, $53, $93, $d3 seem to be random

HOXS54 (1.0.8.8)

- first come two pages with 128 bytes $ff, then 128 bytes $00... followed by two
  pages with 128 bytes $99, then 128 bytes $66. additionally the first bytes of
  each page seems to be random. (this is supposed to be taken from a real C64)

Micro64 (1.00.2013.05.11 - build 714)

- page starts with 64 bytes $00, then 64 bytes $ff etc

VICE (2.4.27, rev 31063)

- page starts with 64 bytes $00, then 64 bytes $ff etc

results from real C64s
----------------------

C64C (gpz)

- repeating ff,ff,00,00,00,00,ff,ff pattern, every $4000 bytes the pattern seems
  to be inverted (for another $4000 bytes). occasional random bytes

================================================================================

some problematic programs:

Typical/Beyond Force  (https://csdb.dk/release/?id=4136)
