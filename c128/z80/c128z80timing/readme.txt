Commodore 128 Z80 timing tester (2024-04-29)

by Jussi Ala-Könni
and Roberto Muscedere (rmusced@uwindsor.ca)

The Makefile dynamically generates all the rules to build a series of
individual testing programs that can be used on real systems and emulators.

The testers will report the status of each test to the debug cart.

Each program uses the "startup.asm" stub to pass control to the Z80 to run
the test, and then to verify and display the results. Lastly, it will load
the "next" module for testing. The "next" module is hardcoded into the
tester, so changing the testing order will require a fresh build.

The "prglist" file lists all the test names along with the 1MHz cycle delta
in hexadecimal format. The diskimages are build in the order provided in the
"prglist" file.

All instructions are covered, even undocumented and redundant ones - except
for the HALT instruction. This will be supported in the future when a reliable
test has been created.
