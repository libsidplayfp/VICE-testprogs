this is a collection of test programs, primarily used for the VICE project, but
useful for other commodore emulators too.
--------------------------------------------------------------------------------

./testbench contains the testbench scripts. see the readme.txt in this directory
for instructions on how to do automated testing.

--------------------------------------------------------------------------------
this is a (very) brief overview of the contents in this repository:

./general         - tests that do not fit into any other categories, usually
                    combined tests

* tests related to the various emulated chips

./CPU
./CIA
./SID
./VICII

./VDC             - VDC related, these run on C128

* tests specifically related to the various commodore computers

./C64             - specific C64 related tests
./interrupts

./DTV
./VIC20

./drive           - floppy drive tests

./vsid

* expansions

./GEO-RAM
./REU
./mouse
./propmouse
./userportjoy

* VICE subsystems

./crtemulation
./printer
./vdrive
./RS232
./MIDI

* VICE tools

./petcat

--------------------------------------------------------------------------------

TODO: the long term goal is to have some tests for everything that is emulated
      by VICE. still a long way to go, this is what might be missing:

* some existing tests are missing proper source code

VIC20/vic6581
VDC/40columns
DTV/tsuitDTV

* tests related to the various emulated chips

6510
----
- add more elaborated SHA/SHY/SHX page-boundary crossing tests

ACIA
----

CRTC
----

SID
---
- make test to check the POTX/Y sample period
- make envelope generator timing test (like waveform check)
- make test to check noise LFSR behavior on reset / test bit (it should take
  about 0x8000 cycles until it resets)
- make test to check correct noise LFSR sequence (like waveform check?)
- make proper test for "new" waveforms created by selecting noise with other
  waveforms (the regular waveform should get ANDed into the LFSR)

VIA
---
- make test program for power-on values
- make VIA shiftregister test program

VIC-II
------
- make test to check that the correct value is fetched for the "FLI-bug" area
- make more detailed sprite-collision timing test(s)
- make sprite-stretch test (cl13 plasma)

* tests specifically related to the various commodore computers

C64, C128, VIC20, PET, PLUS4, CBM2 ...

* tests specifically related to drives

1541:
-----
- make test program that measures mechanical delays (such as stepping)
- make a test program to check half tracks
- make a testcase for the case when V flag is set by "byte ready" and it is
  modified by an opcode at the same time. (ARR?)
- make test program to check various track lengths (in a g64)
- make test program to check various speed zones (in a g64)

* expansions

super snapshot v5:
------------------

- make test for using SSV5+REU

* VICE subsystems

* VICE tools

petcat
------

- find more references for control-char notation used by magazines

cartconv
--------

c1541
-----

- a couple of vdrive related regression tests could be done using c1541
- no tests for c1541, these should be added

vdrive
------

- add tests for directory wildcard handling, still some bugs: multiple wildcards
  aren't supported (eg "$:A*,B*") (#614)
- add tests for various CBMDOS commands

