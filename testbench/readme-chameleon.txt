Prerequisites:
--------------

- reset the chameleon configuration to default
- make sure no d64 is mounted. some tests will upload GCR data to the memory
  and overwrite whatever is there.

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
