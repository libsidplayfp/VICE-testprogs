
dmatest.prg:

related to bug #2124


reu-check.prg:

related to bug #2124

- The top block is what's to be stashed into REU from the SCPU/65816's RAM.
- The middle block is what ended up in the C64's own RAM when fetching that
  data back.
- The bottom block is what ended up in the 65816's RAM in that same area.

The middle region is first filled with $ff before fetching the stashed data
back, and then this region is copied to the lower part of the screen after
the fetch, to make it possible to see if the fetch actually worked and how
much data it actually copied.

The normal behavior of an REU when used with a SCPU is that each byte
fetched is written to the 65816's local RAM, and if the target is within a
mirrored address range per the SCPU's optimization register, that byte is
also written into the C64's own RAM at the same address, so that the VIC-II
can potentially display it.

A DMA stash can only read data from the 65816's RAM or from another I/O
device, and always ignores the C64 RAM (hence the reason for the third,
copied data dump).

A fail happens on the first failed comparison, and is indicated with a red
border and highlighting of the failed bytes in the data blocks. The expected
and actual values thereof are printed at the bottom of the screen.

A pass is indicated with a green border. For the result to be truly correct,
all three data blocks must match, but while it is trivial to compare the
fetched data to the original, the 65816 can only see its own RAM; it is not
possible for a user program to reach into C64 memory to compare it with 65816
memory. So, if the border indicates a pass, look the screen over thoroughly,
too.

(fails in r46140, apparently a fetch is not depositing any data into the 65816
RAM, only to C64 RAM.)


dmastart.prg:

related to bug #2233

SuperCPU REU DMA does not immediately stop the 65816.

(fails in r46140, The program prints PASS on x64sc and FAIL on xscpu64 because
the "sta command" doesn't trigger the DMA immediately and the buffer is either
written/read before the DMA starts.)
