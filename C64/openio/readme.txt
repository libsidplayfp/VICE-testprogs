Unconnected address space ("open i/o") tests
--------------------------------------------

If these programs do not work on your computer, make sure you don't have any 
memory devices in these addresses.  If you haven't customized your computer, 
then you have bad luck: your computer is not "$DE00-compatible".
You could try to put your computer in a metal box or something, so that it 
wouldn't pick any noise to the data lines when reading the weak signals from 
the open address space.

* de00int.prg

uses IO1 (de00-de7f) for it's irq routine

when the program is working, the border color can be changed from black to
white by pressing space

* de00all.prg

runs all the time in IO1 (de00-de7f)

when the program is working, the border color can be changed from black to
white by pressing space

* dadb.prg

runs code in color-ram (using the high nibbles)

when the program is working, the border color can be changed from white to 
black by pressing space.

* trivial.prg

trivial test that shows that the values read from open i/o are somewhat "random"

* gauntlet.prg

cartridge check extracted from "Gauntlet - The Deeper Dungeons"

from https://sourceforge.net/p/vice-emu/bugs/1011/

[...] here's what memory looks like starting at $2000 gathered using a simple 
for loop with peek [forx=0to8192:printpeek(8192+x):nextx]

$2000: 00 00 ff ff ff ff 00 00 00 00 ff ff ff ff 00 00
$2010: 00 00 ff ff ff ff 00 00 00 00 ff ff ff ff 00 00
$2020: 00 00 ff ff ff ff 00 00 00 00 ff ff ff ff 00 00
$2030: 00 00 ff ff ff ff 00 00 00 00 ff ff ff ff 00 00
$2040: 00 00 ff ff ff ff 00 00 00 00 ff ff ff ff 00 00
$2050: 00 00 ff ff ff ff 00 00 00 00 ff ff ff ff 00 00
$2060: 00 00 ff ff ff ff 00 00 00 00 ff ff ff ff 00 00
...

If I use a RAM reset pattern in Vice of:
Value of first byte: 0
Length of constant values: 2
Length of constant pattern: 4

It passes the cart check every time with these settings.
