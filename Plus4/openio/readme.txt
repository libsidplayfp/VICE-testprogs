
Tests that read from unconnected I/O space.


outrun.prg:

"Emulator detection" that can be found in "Turbo Outrun". Checks if subsequent
reads from unconnected I/O will return always 0. This appears to be tailored
against older VICE releases which do just that :)


outrun2.prg:

Another "Emulator detection" that can be found in "Turbo Outrun" (although
apparently it is never executed?). Checks if subsequent reads from unconnected
I/O will always give the same value.


Note: similar checks appear to have been used in "Giana Sisters" and "Prince of
Persia".


TODO: (much) more elaborated test(s) that scan the entire memory space
