related to https://sourceforge.net/p/vice-emu/bugs/824/

This program just writes 65536 bytes to mirrored memory and checks how many
cycles it takes.

currently in VICE the result is always $10002 cycles when writing to mirrored
memory no matter if the VIC screen is disabled (no badlines) or enabled. Since
it takes a little more than three frames to transfer those bytes, I would
expect it to take some 3 * 40 * 25=3000 cycles longer with badlines. If I write
to IO instead, I get $20002 without badlines and $21b5a with badlines. 
