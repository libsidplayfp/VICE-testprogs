this is a collection of test programs, primarily used for the VICE project, but
useful for other commodore emulators too.

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

* VICE tools

./petcat

--------------------------------------------------------------------------------

TODO: the long term goal is to have some tests for everything that is emulated
      by VICE. still a long way to go, this is what might be missing:

* tests related to the various emulated chips

CRTC, ACIA, ...

* tests specifically related to the various commodore computers

PET, PLUS4, ...

* expansions

* VICE subsystems

* VICE tools

cartconv, c1541, ...
