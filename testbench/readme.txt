
================================================================================
running the tests
================================================================================

the Makefile in this directory serves as the main frontend to the testbench. to
get a list of things you can do just run "make".

you can also run ./testbench.sh manually:

$ ./testbench.sh <target> <filter>

.. where <target> is one of "x64", "x64sc", "chameleon"

... and <filter> is an optional string which is matched against the path that
contains the test. (eg use "CIA" to run only the CIA tests)

================================================================================
preparing tests
================================================================================

--------------------------------------------------------------------------------
"debug cartridge" register locations:

C64     $d7ff
C128    $d7ff ?
VSID    $d7ff ?
SCPU    $d7ff ?
DTV     $d7ff ?
VIC20   $9fff ? (discussion: http://sleepingelephant.com/ipw-web/bulletin/bb/viewtopic.php?f=2&t=7763 )
PLUS4   $fe00 ? (discussion: http://plus4world.powweb.com/forum.php?postid=31417#31429)
PET     TBD
CBM510  TBD
CBM610  TBD

--------------------------------------------------------------------------------

the test program writes its exit code to the "debug cartridge" register,

$00 - for success
$ff - for failure

--------------------------------------------------------------------------------

tests that have to be checked by screenshot must contain reference screenshots
that are named the same as the tests with an additional .png extension, in a
subdirectory called "references". like this:

./mytest.prg
./references/mytest.prg.png

the reference screenshots should be taken with default screen dimensions,
CRT emulation disabled, using the pepto palette (vice.vpl, "Default" in menus)

================================================================================
adding new tests
================================================================================

when adding new tests to the test repository, you should also put them into one
(or more) of the following files:

c64-testlist.in
c128-testlist.in
cbm510-testlist.in
cbm610-testlist.in
dtv-testlist.in
pet-testlist.in
plus4-testlist.in
vic20-testlist.in
scpu-testlist.in
vsid-testlist.in


format of the abc-testlist.in files:
------------------------------------

<path to test>,<test executable name>,<test type>,<timeout>,<options>

test type:
    exitcode
    screenshot
    interactive

options:
    - extra options, which are translated to actual commandline options by the
      respective driver script

    cia-old
    cia-new
    vicii-pal
    vicii-ntsc
    vicii-ntscold

--------------------------------------------------------------------------------

TODO:

    - handle old/new sid differences

    - handle all kinds of extra switches (-reu, -cartXX etc)

    - add "self test" kind of templates for all targets

    write proper docs :)
    write TODO list :)

    - add hooks for:
        c128
        cbm510
        cbm610
        dtv
        pet
        plus4
        scpu
        vic20
        vsid
