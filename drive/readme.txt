
subdirectories contain various floppy drive related test programs.

unless mentioned otherwise, all tests are for the 1541 and should be run with
just one drive on the IEC bus, and a disk inserted into the drive. some tests
may require being run from the exact d64 provided in the respective directory.

the "util" subdirectory contains helper programs used to generate test data and
images

--------------------------------------------------------------------------------

diskchange:
- various methods of detecting disk changes

iecdelay:
- iec bus delay test, original program by Jochen Adler

interrupts:
- interrupt related tests

pwm:
- simple drive-led pwm test

rpm:
- drive rotation speed measurement

selftest:
- simple test of the framework, transfer routines, etc

scanner:
- reads through the entire disk contents (track 1-42) and shows available
  tracks

viavarious:
- various tests, ported from andre fachats "ciavarious"

--------------------------------------------------------------------------------

TODO:
- physical limits test (check for highest and lowest reachable track)
- VIA serial shift register test
- test if half-tracks behave correctly

..?
