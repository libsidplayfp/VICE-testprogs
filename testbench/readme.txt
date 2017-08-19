NOTE: this is still initial WIP


TODO:
    - prepare dtv/x128/xpet/plus4/cbm2 for tests that use screenshots

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
* adding support for another target/emulator

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
with CRT emulation disabled.

- for C64: use the pepto palette (vice.vpl, "Default" in menus)
- for VIC20: use the "mike" palette

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
    sid-old
    sid-new
    vicii-pal
    vicii-ntsc
    vicii-ntscold

    geo256k
    reu512k

    mountd64:<image>
    mountg64:<image>
    mountcrt:<image>

    vic20-unexp
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
  targets: x64, x64sc, x128, xscpu64, xpet, xcbm2, xcbm5x0, xvic, xplus4, 
           chameleon, hoxs64, micro64, emu64, yace
  <filter> is a substring of the path of tests to restrict to
  --help       show this help
  --verbose    be more verbose
  --pal        skip tests that do not work on PAL
  --ntsc       skip tests that do not work on NTSC
  --ntscold    skip tests that do not work on NTSC(old)
  --ciaold     run tests on 'old' CIA, skip tests that do not work on 'new' CIA
  --cianew     run tests on 'new' CIA, skip tests that do not work on 'old' CIA
  --6581       run tests on 6581 (old SID), skip tests that do not work on 8580 (new SID)
  --8580       run tests on 8580 (new SID), skip tests that do not work on 6581 (old SID)
  --8565       target VICII type is 8565 (grey dot)
  --8565early  target VICII type is 8565 (new color instead of grey dot)
  --8565late   target VICII type is 8565 (old color instead of grey dot)
  --8k         skip tests that do not work with 8k RAM expansion

by default, the testbench script expects the VICE binaries in a directory
called "trunk" which resides in the same directory as the "testprogs"
directory. if that is not the case you can give the VICE directory on the
commandline like this:

$ VICEDIR=/c/users/youruser/somedir/WinVICE-2.4.99 ./testbench x64

--------------------------------------------------------------------------------
================================================================================
running tests on another supported target/emulator
================================================================================
--------------------------------------------------------------------------------

make sure to give the full path to the emulator binary, and use the respective 
switches to skip tests that make no sense and/or can not work.

$ VICEDIR="/c/hoxs64_x64_1_0_9_3_sr1" ./testbench.sh hoxs64 --pal --8565early --8580

--------------------------------------------------------------------------------
================================================================================
adding support for another target/emulator
================================================================================
--------------------------------------------------------------------------------

additional targets/emulators can be hooked up fairly easy, only a few simple
features are needed. in case of VICE they are called like this:


-debugcart
  enable a virtual "debug cartridge" which consists of one write-only register.
  when a value is written to that register, the emulator should exit with the
  written value as exitcode. see "preparing tests" above for the location of the
  debug registers for the different machines.

-limitcycles <n>
  after the emulation has run N cycles, exit the emulator with exitcode 1 - this
  will enable the testbench to continue even when a test hangs/crashes.

-exitscreenshot <name>
  at exit, save a screenshot. this is required for the tests that can not work
  with an exitcode, ie the result can only be determined by looking at the output


additionally, there must be a way to automatically run a program from commandline,
and to mount disk- and cartridge images. it also helps to have a "warp" mode, and
to be able to disable the GUI/graphics screen (but this is not strictly necessary)


for further hints see testbench.sh and x64-hooks.sh
  
  
