VICE Monitor testbench
-------------------------------------------------------------------------------

This directory contains a collection of monitor command files, plus a makefile
and helper script(s) to run those command files, and compare the result against
a given reference.

WIP WIP WIP - this is very much work in progress, in particular:

- results are not logged except on screen
- it will always run all tests, even if they fail (at some point, when all tests
  are working, we want the testbench to fail by itself if any test fails)
- perhaps we should make a "todo" directory that contains all tests that are
  expected to fail, because of known bugs
- many more tests are needed


Each tests consists of:

foo.mon         the monitor command file (note: this file is expected to open
                a monitor logfile "foo.log")
foo.ref         expected "correct" reference output
foo.asm         optional: an external .asm snippet (ACME) which the test can
                use.

note: have a look at eg bug2025*.mon on how to open a logfile, or how to execute
custom assembly code.


configure the Makefile:

- at the top set EMU to the x64sc you want to test


run the tests:

$ make clean all

(you will need a bash-shell and *nix like environment, msys on windows should work)


you can run individual tests manually without the help of the scripts like this:

x64sc -default -moncommands foo.mon


To add a new test:

- in Makefile add "foo.log" to the RESULTS0 list
- if the test uses an external .asm file, add "foo.prg" to the PROGS list


-------------------------------------------------------------------------------
The individual tests:
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------

bug942.mon

https://sourceforge.net/p/vice-emu/bugs/942/

-------------------------------------------------------------------------------

bug2025-2.mon
bug2025-2b.mon

the instruction on that a breakpoint hit is/was repeated

(bug exists in 3.8, fixed in trunk)

https://sourceforge.net/p/vice-emu/bugs/2025/

-------------------------------------------------------------------------------

radix-binary.mom

binary number without % prefix is/was incorrectly recognized as octal

(fixed in r42582)

https://sourceforge.net/p/vice-emu/bugs/1488/

-------------------------------------------------------------------------------
TODO!
-------------------------------------------------------------------------------

bug2024.mon

attempt at making a test from the original bug report. however, since this is
not stable, it can not work

https://sourceforge.net/p/vice-emu/bugs/2024/


goonbreak.mon
goonbreak-2.mon

When jumping to an instruction, that triggers a breakpoint, with "g" in the
monitor, this would currently NOT trigger the breakpoint (and re-enter the
monitor) the first time that instruction is executed, but only on the second
time!

(goonbreak-2.mon failing is a regression caused by the fixes done for #2025,
#2024 - it works in 3.8)


bug1488.log
bug1836.log

The parser has problems recognizing a hex number that is not prefixed by $ -
which these tests demonstrate

https://sourceforge.net/p/vice-emu/bugs/1488/
https://sourceforge.net/p/vice-emu/bugs/1836/


bug1984.log
bug1984-2.log

The trace output is out of order

https://sourceforge.net/p/vice-emu/bugs/1984/
