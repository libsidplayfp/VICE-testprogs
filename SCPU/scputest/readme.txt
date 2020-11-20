from https://sourceforge.net/p/vice-emu/bugs/543/

Binary, sources and screenshots from my C64C with v2 SuperCPU64 is included.

Both tests (rasterline and badline) begin by waiting for a certain rasterline 
(which line is changing all the time). Then they wait 0-24 cycles before 
starting the CIA timer.

The rasterline test wait until the rasterline counter changes, reads the CIA
counter value, and keeps track of the min/max value for each delay (0-24).
Other than the instability with 23 cycles delay on the real hardware, the
results are identical.

The badline test wait until the rasterbeam is in the middle of a badline and
then reads the CIA counter. The read wont happend until the badline is done and
the SCPU can access the C64 IO region again. This test is always one off between
VICE and real hardware.

The tests keep looping (there's a counter in the upper right corner), but even
allowing it to run for several minutes doesn't change the result on my C64. Only
the 23 cycles delay in the tests does seem to be on the border and produce two
different values.
