VDC Dump - memory test program for C128

It must be run on C128 in 40-column mode (to leave the VDC untouched). Or,
alternatively, you may also run it in the C64 mode (but then started with
SYS7181 instead of RUN).

---------------------------------------------------------------
This program does the following:
---------------------------------------------------------------

First it turns the VDC chip to 64K mode (by setting bit4 at register #28) and
writes all the memory full with some specific numbers. Then it reads all 64K
back and dumps it on the screen (so that you can control what it contains).

Then it turns the VDC to 16K mode and dumps it on the screen again (so that
you can see the changes caused by altering that bit).

After having that, it repeats everything above just one more time, but with
different values (so finally the memory is dumped at four times in total).

In the first round, all pages are filled with the same byte of the page number
(so thus 256 pieces of 0 bytes, then 256 pieces of 1 bytes etc. until 256
pieces of 255's finally). It can be used to see, where each page is reordered
after the 64K->16K change.

In the second round, all pages are filled with the very same pattern: all 256
bytes in increasing order (from 0 to 255 again and again). It can be used to
see, whether the order of the bytes are changed within one page.

(Also, the overall test shows as well, how reliable your VDC and/or VRAM is.)

Please keep in mind that it is a very painstaking test and the dumping will
last for several minutes. (Actually about half an hour on my machines!)

---------------------------------------------------------------
My personal results:
---------------------------------------------------------------

Once having the test finished, it also displays a summary in four rows: from
1/1 to 2/2 (regarding the four dumps), each of which is indicated with an "ok"
if it exactly matches the results of my test machines.

If you see no "ok" there, it does not necessarily mean yet that your VRAM is
faulty or so... It only means that a different pattern is found.

Actually, three of the four rows SHOULD be the same on all machines (1/1, 2/1
and 2/2). So if any of them is not the same, it likely indicates an error.

The 1/2 is the exception, since it can be imagined that the pattern is not the
same everywhere.

I have got two real C128 machines, both of which are the standard "flat"
models, and both of them have got the 64K VRAM upgraded by the most common
expansion boards can be bought on eBay today.

I have also got two machines, which are not upgraded (stock systems).

If the results match my upgraded machines, then a "64k" is also displayed
after the "ok"; if they only match my stock machines, then a "16k" instead.

If you see an "emu" instead of the "ok", then it means the results only match
the emulator layout (based on VICE emulation which is quite different from any
of my real machines; that is just a straightforward, simple increasing order).

Unfortunately, I have got no C128D, and especially no C128DCR models to test
with (the latter has the 8568 version of the chip and is slightly different)
nor any other kind of expansion... Thus, if you have a different machine, it
might be quite normal if perhaps they do not match (or match the emu layout).

This test might also be used as measurement for emulators, whether how much
they are emulating the correct behaviour of the real systems.

Also can be used as a very detailed, thorough test for detecting any little
error of your VDC chip or memory.

VDC Dump is freeware and open-source and can be downloaded here:

---------------------------------------------------------------
http://istennyila.hu/stuff/archive/vdcdump.zip
---------------------------------------------------------------

MemTest64 project homepage:

http://istennyila.hu/memtest64

SDOS project page:

http://istennyila.hu/sdos

Rosetta Interactive Fiction project homepage:

http://istennyila.hu/rosetta

(c) 2012-2017 by Robert Olessak