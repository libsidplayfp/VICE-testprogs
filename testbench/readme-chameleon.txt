Prerequisites:
--------------

- reset the chameleon configuration to default
- enable one drive 8 and mount some d64. make sure you can read the directory
  before you start the tests, else the drive tests hang for some reason.
  CAUTION: some tests will upload GCR data to the memory and overwrite whatever 
  is there.

Quirks:
-------

- right now tests for all hardware/chip variations are always run, resulting in
  in a bunch of "failing" tests

- not all CRT types are supported right now

- sending d64/GCR data takes a long time and no progress is shown

Running the testbench:
----------------------

$ cd testbench
$ ./testbench.sh chameleon

to save a lot of time, you can restrict a bit what tests to run by using
additional options:

$ ./testbench.sh chameleon spriteenable --pal --8565early

note:

--8565early describes the supposed behaviour of the chameleon. that means and
"ideal" 8565 that shows no grey dot, but instead the new color is shown.

some tests will currently fail when using this option, although the test itself
is not really related to color splits. these have to be checked manually, for
example:

VICII/spriteenable/ (--8565late can be used)
VICII/spritesplit/ (--8565late can be used)

