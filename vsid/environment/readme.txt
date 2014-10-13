
some artificial tests to check a bunch of border cases that a PSID capable
player should support.

since most players do not show the C64 screen, CALYPSO.SID is played instead
when the test is working.

--------------------------------------------------------------------------------

* basicram-v1.sid, basicram-v2.sid

various variations of the most simple case, using memory from $0800 to $9fff
for the binary image

* underbasic.sid

uses memory from $0800 to $bfff

init/play are in basic ROM area

* underkernal.sid

uses memory from $0800 to $fff8

init/play are in kernal ROM area

* underio.sid

uses memory from $0800 to $f000

init/play are in I/O area

--------------------------------------------------------------------------------
following are some notes on the environment that should be used when playing
PSID files:

* PSID (regular)

Note: The original playsid program for the Amiga used a flat 64k RAM space, and
      ignored the layered memory map of the C64. However, with the advent of
      SD-card based storage solutions for the C64 (such as the 1541ultimate and
      the Chameleon) players for .sid files that run on the real hardware be-
      came common. The following rules are a compromise between following a
      strict pattern (related to the original psid specification) and what is
      (sometimes) required to play the existing rips on a real C64.

- init/play may actually be located under ROM or I/O - the caller is expected to
  set up $01 correctly. the following rules proved to be mostly working in
  practise:

  - if init/play is in range $d000 - $dfff, set $01 to $34
  - else if init/play is in range $e000 - $fffa, set $01 to $35
  - else if load end address/play is in range $a000 - $cfff, set $01 to $36
  - else set $01 to $37

  Note: this implies that the caller sets $01 to $3x before calling either init
        or play. however both of these functions may for example re-enable the 
        i/o area and thus change $01 again (although this is considered bad 
        practise and fixed if found in .sid files)

- the player should restore $01 to $37 after init/play, because of that
  - the relocated player should not be placed under ROM or I/O
  - the player can not use the hardware vectors at $fffe/$ffff (It is however
    recommended to implement the IRQ handling in a way that BOTH the "soft"
    ($0314/$0315) and the hardware vectors point to a valid IRQ handler, since
    some tunes may change the value of $01 and bank in/out the kernal)

- when play is $0000, then do NOT set $01 to another value after init (as the
  init call is responsible to do it in that case)

- the caller is responsible for SEI/CLI before/after init

- tunes should not load over the vectors ($fffa-$ffff)

- the PAL/NTSC flag in memory ($02a6) should be initialized according to the
  respective flag in the .sid file prior calling init

* RSID (regular)

- VIC - IRQ set to raster $137, but not enabled.
- CIA 1 timer A - set to 60Hz with the counter running and IRQs active.
- Other timers - disabled and loaded with $FFFF.
- Bank register $01 - $37
- the PAL/NTSC flag in memory ($02a6) should be initialized according to the
  respective flag in the .sid file prior calling init

- A side effect of the bank register is that init MUST NOT be located under a
  ROM/IO memory area (addresses $A000-$BFFF and $D000-$FFFF) or outside the
  load image. 

- Since every effort needs to be made to run the tune on a real C64 the load 
  address of the image MUST NOT be set lower than $07E8.

* PSID v1 and v2 (compute sidplayer)

These tunes can not be played directly, as no player is included - so a proper
"sidplayer" binary must be injected first. see the sidplayer subdirectory for
some specific tests.

* RSID (BASIC tunes)

These are regular BASIC programs, and as such must be run using the C64 BASIC
interpreter.

- reset emulated machine
- inject tune into RAM
- set 780/781/782 (A/X/Y) to sub tune nr (starting with 0)
- start by "RUN"
