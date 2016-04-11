Prerequisites:
--------------

- reset the chameleon configuration to default, and enable one emulated drive
  at device id #8
- mount some d64 to that drive (it doesnt matter which one, this is needed so
  the chameleon will actually enable the drive - the GCR data will be
  overwritten/changed by the testbench when running tests)


Quirks:
-------

- the REU tests must be run seperately right now (with enabled 512kb REU):

$ ./testbench.sh chameleon REU/

- right now tests for all hardware/chip variations are always run, resulting in
  in a bunch of "failing" tests

Running the testbench:
----------------------

$ cd testbench
$ ./testbench.sh chameleon
