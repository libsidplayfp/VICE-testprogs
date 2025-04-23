This program tests what happens if unconnected space is addressed.
The normal behaviour is that the last byte on the bus remains what it was and that
is the value that is read. Usually this is the high byte of the address,
since that's what the CPU most recently read from memory.

This is still true for indirect reads like LDA ($12),Y: the last read byte before
a possibly empty read would be from $13, the high byte of the base address.

For zero pages with empty space, somebody could adjust the tests to run in the
drive CPU of a 4040 disk drive. I'm not holding my breath :)

In case of indexed instructions with page crossings, there is first an dummy read.
So for example LDA $93FF,X with X=3 will do a dummy-read from $9302, and since
the last valid read from memory was #$93 (part of the address in the instruction),
the dummy read will return #$93. Then the real read from $9402 is also from empty
space, and hence will still read #$93.

The test (in this case) stores #$AA at $9402 (the proper indexed address), #$00
at $93FF (the base address), and #$55 at #9302 (the dummy read address, if
there is one), to detect RAM.

If either read is from non-empty space, this will of course override the bus value.
Several of the cases below exercise this.

Results on a 3016:

un*connected testprog
test: result - ref/1st
$f000  : rom - rom/$ 54            ; rom
$f000,x: rom - rom/$ 20            ; rom
$1500  : ram - ram/$ aa            ; ram
$16ff,x: ram - ram/$ aa            ; ram
$9000  : msb - msb/$ 90            ; empty space
$9000,x: msb - msb/$ 90            ; empty space
$87ff,x: nox - nox/$ 55            ; X=3, 8702 is RAM, 8802 is empty; reads 8702
$9d34  : msb - msb/$ 9d            ; empty space
$93ff,x: msb - msb/$ 93            ; empty space
$e800  : msb - msb/$ e8            ; E800-E80F is empty
$e80f  : msb - msb/$ e8            ; E800-E80F is empty
$e7ff,x: rom - rom/$ 00            ; X=3, E80x is empty, E7xx is ROM; reads E702
$7fff,x: ram - ram/$ aa            ; X=3, 7F02 is empty, 8002 is RAM; reads 8002
$bfff,x: rom - rom/$ 57            ; X=3, BF02 is empty, C002 is ROM; reads C002
press a key to restart


          U

The * and the shift-U are from the tests $7fff,x and $87ff,x.

