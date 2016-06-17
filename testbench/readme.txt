NOTE: this is still initial WIP


TODO:

    - handle old/new SID differences
    - handle old/new VIC differences

    - handle all kinds of extra switches (-reu, -cartXX etc)

    - prepare dtv/x128/xpet/plus4/vic20/cbm2 for tests that use screenshots

    write proper docs :)
    write proper TODO list :)

    fix VICE bugs:
        - crash when using -exitscreenshot with -console
        xcbm2:
            -VICIIfilter doesnt work?
            -VICIIextpal
            -VICIIpalette

KLUDGES:
    - when crt or d64 is mounted and no .prg is given, only the path (and not
      the actual failed test) will go into the results file

--------------------------------------------------------------------------------
================================================================================
################################################################################
#                               VICE test bench                                #
################################################################################
================================================================================
--------------------------------------------------------------------------------

* preparing tests
* adding new tests
* running the tests

--------------------------------------------------------------------------------
================================================================================
preparing tests
================================================================================
--------------------------------------------------------------------------------

"debug cartridge" register locations:

C64     $d7ff
C128    $d7ff
VSID    $d7ff
SCPU    $d7ff
DTV     $d7ff
VIC20   $910f  (discussion: http://sleepingelephant.com/ipw-web/bulletin/bb/viewtopic.php?f=2&t=7763 )
PLUS4   $fdcf  (discussion: http://plus4world.powweb.com/forum.php?postid=31417#31429)
PET     $8bff
CBM510  $fdaff
CBM610  $fdaff

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

--------------------------------------------------------------------------------
================================================================================
adding new tests
================================================================================
--------------------------------------------------------------------------------

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

after updating any of these files, regenerate the test lists:

$ make testlist


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

    geo256k
    reu512k

    mountd64:<image>
    mountg64:<image>
    mountcrt:<image>

    vic20-8k

--------------------------------------------------------------------------------
================================================================================
running the tests
================================================================================
--------------------------------------------------------------------------------

the Makefile in this directory serves as the main frontend to the testbench. to
get a list of things you can do just run "make".

you can also run ./testbench.sh manually:

usage: ./testbench.sh [target] <filter> <options>
  targets: x64, x64sc, x128, xscpu64, xpet, xcbm2, xcbm5x0, xvic, xplus4, chameleon
  <filter> is a substring of the path of tests to restrict to
  --help       show this help
  --verbose    be more verbose
  --pal        skip tests that do not work on PAL
  --ntsc       skip tests that do not work on NTSC
  --ntscold    skip tests that do not work on NTSC(old)
  --8565       target VICII type is 8565 (grey dot)
  --8565early  target VICII type is 8565 (new color instead of grey dot)
  --8565late   target VICII type is 8565 (old color instead of grey dot)
