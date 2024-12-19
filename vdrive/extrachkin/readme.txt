
related to https://sourceforge.net/p/vice-emu/bugs/2097/

Problem: Under certain conditions, when reading from the host filesystem,
calling CHKIN() with the input channel already set, causes the next byte from
the input stream to be consumed and discarded.

This appears to happen when both vdrive and TDE is enabled at the same time.


bugtest.prg

creates a test file, reads it back to verify it against memory, then does so
again with the extra CHKINs that trigger the bug.


Workaround: do not enable TDE and vdrive at the same time. (We might even change
the UI in a way that this is no more possible in the future)
