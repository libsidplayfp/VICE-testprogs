
subdirectories contain various floppy drive related test programs.

unless mentioned otherwise, all tests are for the 1541 and should be run with
just one drive on the IEC bus, and a disk inserted into the drive. some tests
may require being run from the exact d64 provided in the respective directory.

the "util" subdirectory contains helper programs used to generate test data and
images

--------------------------------------------------------------------------------

selftest:
- simple test of the framework, transfer routines, etc

scanner:
- reads through the entire disk contents (track 1-42) and shows available
  tracks

pwm:
- simple drive-led pwm test

interrupts:
- interrupt related tests

--------------------------------------------------------------------------------

TODO:
- various VIA tests (similar to ciavarious)
- physical limits test (check for highest and lowest reachable track)

..?
