VICE Monitor testbench
-------------------------------------------------------------------------------

This directory contains a collection of monitor command files, plus a makefile
and helper script(s) to run those command files, and compare the result against
a given reference.


WIP WIP WIP - this is very much work in progress, in particular:

- results are not logged except on screen
- many more tests are needed
- this document needs to be completed/extended


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

$ make

(you will need a bash-shell and *nix like environment, msys on windows should work. acme
is also required :). make -j will work to some extend, but the output will be garbled.)

if any of the regular tests fail, the testbench will abort with an error. note that
this is NOT true for the tests in ./todo/

If you made any of the tests in ./todo/ work, make sure to move the respective test(s)
out of ./todo/ :)


you can run individual tests manually without the help of the scripts like this:

x64sc -default -moncommands foo.mon


To add a (working!) new test:

- in Makefile add "foo.log" to the RESULTS0 list
- if the test uses an external .asm file, add "foo.prg" to the PROGS list

To add a (non working!) new test:

- in Makefile add "todo/foo.log" to the RESULTS0TODO list
- if the test uses an external .asm file, add "todo/foo.prg" to the PROGSTODO list


-------------------------------------------------------------------------------
The individual tests:
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
TODO!
-------------------------------------------------------------------------------

bug942.mon

https://sourceforge.net/p/vice-emu/bugs/942/


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


bug2024.mon

attempt at making a test from the original bug report. however, since this is
not stable, it can not work

https://sourceforge.net/p/vice-emu/bugs/2024/

-------------------------------------------------------------------------------
Working
-------------------------------------------------------------------------------

comparing bug2025.log and bug2025.ref... [ OK ]
comparing bug2025-3.log and bug2025-3.ref... [ OK ]
comparing bug2025-4.log and bug2025-4.ref... [ OK ]
comparing bug2025-4b.log and bug2025-4b.ref... [ OK ]
comparing bug2025-4c.log and bug2025-4c.ref... [ OK ]
comparing bug2178.log and bug2178.ref... [ OK ]
comparing bug2178-2.log and bug2178-2.ref... [ OK ]
comparing bug2221.log and bug2221.ref... [ OK ]
comparing bug2221-1.log and bug2221-1.ref... [ OK ]


radix-binary.mom

binary number without % prefix is/was incorrectly recognized as octal

(fixed in r42582)

https://sourceforge.net/p/vice-emu/bugs/1488/


goonbreak.mon
goonbreak-2.mon

When jumping to an instruction, that triggers a breakpoint, with "g" in the
monitor, this would currently NOT trigger the breakpoint (and re-enter the
monitor) the first time that instruction is executed, but only on the second
time!

(goonbreak-2.mon failing is a regression caused by the fixes done for #2025,
#2024 - it works in 3.8)


bug2025-2.mon
bug2025-2b.mon

the instruction on that a breakpoint hit is/was repeated

(bug exists in 3.8, fixed in trunk)

https://sourceforge.net/p/vice-emu/bugs/2025/






