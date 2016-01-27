This directory contains a cp/m 2.2 boot image for the c64 (cp/m cart).

To start, insert the image and type:

load"cpm",8
run

After booting the screen is on 40col mode, if you want 80col mode type the following after you get the A> prompt:

soft80

There are two z80 test programs on the disk image:

- zexdoc.com - Tests all documented instructions.
- zexall.com - Tests all (including undocumented) instructions.
