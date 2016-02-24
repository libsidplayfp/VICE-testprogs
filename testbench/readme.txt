
================================================================================
running the tests
================================================================================

the Makefile in this directory serves as the main frontend to the testbench. to
run the tests just use "make"

you can also run ./testbench.sh manually


================================================================================
preparing tests
================================================================================

--------------------------------------------------------------------------------
"debug cartridge" register locations:

C64     $d7ff
VSID    $d7ff
SCPU    TBD
DTV     TBD
VIC20   TBD     (discussion: http://sleepingelephant.com/ipw-web/bulletin/bb/viewtopic.php?f=2&t=7763 )
PLUS4   TBD     (discussion: http://plus4world.powweb.com/forum.php?postid=31417#31429)
PET     TBD
CBM2    TBD

--------------------------------------------------------------------------------

the test program writes its exit code to the "debug cartridge" register,

$00 - for success
$ff - for failure

--------------------------------------------------------------------------------

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
