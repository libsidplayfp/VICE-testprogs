This is a port of zexdoc, zexall, and prelim (by Frank D. Cringle) for the
Commodore 128. It loads and starts in native 8502 mode and is automated so
each module can be run independently primary for batch testing purposes.
The code has been altered slightly so that it can be assembled with GNU
z80asm. z80asm has some issues with macros, so there are some work arounds
to overcome these issues. Some portions of the Z80 testing code have been
further optimized to increase speed (loop unrolling of CRC calculation, and
absolute references to testing data since only one test is performed per
file). "orig.zip" contains the original ".com" and source files.
"modified.zip" contains the modified source that works with z80asm.

The "start.asm" is the 8502 stub which runs and loads the next module. The
next module name is embedded into the code by the Makefile.
The Z80 code is a concatenation of start.z80, the specific testing data
structure, and then end.z80 (which holds the testing code). The resulting
CRC is compared in the 8502 code.

The Makefile generates a d81 image (which uses 1078 blocks) so it won't fit
on a d64 image. This shouldn't be an issue for real world testing as sd2iec
can mount d81 images.

2024-04-24 Roberto Muscedere (rmusced@uwindsor.ca)
