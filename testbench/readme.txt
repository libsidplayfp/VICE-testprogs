
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

currently just add them to c64-testlist.in

format of the abc-testlist.in files:
------------------------------------

<path to test>,<test executable name>,<test type>,<timeout>

test type:
    exitcode
    screenshot
    interactive

--------------------------------------------------------------------------------

TODO:

    - handle old/new sid differences
    - handle old/new cia differences
    - handle pal/ntsc differences

    write proper docs :)
    write TODO list :)
