
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

--------------------------------------------------------------------------------

* PSID (regular)

- init/play may actually be located under ROM or I/O - the caller is expected to
  set up $01 correctly.

* RSID (regular)

- VIC - IRQ set to raster $137, but not enabled.
- CIA 1 timer A - set to 60Hz with the counter running and IRQs active.
- Other timers - disabled and loaded with $FFFF.
- Bank register $01 - $37

- A side effect of the bank register is that init MUST NOT be located under a
  ROM/IO memory area (addresses $A000-$BFFF and $D000-$FFFF) or outside the
  load image. 

- Since every effort needs to be made to run the tune on a real C64 the load 
  address of the image MUST NOT be set lower than $07E8.

* PSID v1 and v2 (compute sidplayer)

These tunes can not be played directly, as no player is included - so a proper
"sidplayer" binary must be injected first.

* RSID (BASIC tunes)

These are regular BASIC programs, and as such must be run using the C64 BASIC
interpreter.

- reset emulated machine
- inject tune into RAM
- set 780 to sub tune nr (starting with 0)
- start by "RUN"
