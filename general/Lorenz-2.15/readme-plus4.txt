
TODO:
- check all sources for leftover usage of CIA interrupts and other C64 specific
  things.
  - d012
  - d020
  - 00/01
  - brk vector
- there are various absolute memory addresses used as buffers in various tests

Not all tests are working right now:

Disk2:

trap1-17 - hangs (waitborder)
branchwrap - c64 specific hackery
mmufetch - c64 specific hackery
mmu - c64 specific
cpuport - c64 specific
cputiming -hangs (CIA)

Disk3:

n/a
