This directory contains a cp/m 3 (1581) boot image for the c128.

To start the image just set drive 8 to 1581 and insert the image and reset the machine.

If after booting the screen is on 40col mode, type the following after you get the A> prompt:

device conout:=80col
screen40

There are two z80 test programs on the disk image:

- zexdoc.com - Tests all documented instructions.
- zexall.com - Tests all (including undocumented) instructions.
