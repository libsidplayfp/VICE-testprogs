
these programs have been derived from "REUTools 1.0" and "REUTools 1.1" by 
Walt of Bonzai, get the original releases here: 

https://csdb.dk/release/?id=196880
https://csdb.dk/release/?id=198061

-------------------------------------------------------------------------------

CheckChar
=========

Tests if streaming to char works as expected. Uses char to sprite collision 
check with a predefined test pattern.

Will fail on VICE x64 but not on VICE x64sc. Also fails on "The C64"
(See https://www.youtube.com/watch?v=UInN-ta9CkA for how-to)

The check is running every 8th frame so you can see what happens. If used in 
your own work, this should be changed.


REUDetect
=========

Detects if REU is present and its size. Tests the needed amount of memory
(512KB, can be changed in the source code).


SpriteTiming
============


This program tests how the VIC and the REU handles writes to memory on top of a
row of 8 sprites. Uses char to sprite collision check to detect where char
position 0 is in the stream for the first and second line of the sprites.

The sprites are placed just above the screen area. The first sprite is visible
at position 24,29.

The sprite data is cleared except for the first byte which is set to all ones.

A stable raster is set up and the border is opened. A 256 bytes array is 
transfered from the REU to $3fff (magic byte) and sprite to char collision is
used to detect which positions matches specific screen positions. When the first
sprite collision is found the sprite is altered so the first byte is cleared and
byte 3 is set (thereby moving it down one pixel).

The test is then repeated to find the next position.

When we have the two positions we know where the timing matches first screen
char and we know how many cycles we have per raster line, by subtracting the two
values. This is actually the number of cycles left after sprite cycles have been
"stolen" by the VIC :)

For real REU this should be 45 ($2d) which I consider strange:

63-45 = 18 cycles for 8 sprites. Normally you would spend 19 (3 + 2*8) cycles 
for 8 sprites?

Returned is the two values. A 3rd value is displayed, this is the number of 
cycles available per raster line with 8 sprites turned on, calculated by 
subtracting value 1 from value 2.

The check is running every 8th frame so you can see what happens. If used in
your own work, this should be changed.

This test was needed for the end part of Expand as it uses 8 sprites with magic
byte overlay in the upper border. I noticed that between different VICE
versions, 1541 Ultimate and real REU the magic byte overlay was either displaced
in X or a byte too long or short per rasterline. These differences also explains
the problem with (and the many versions of) the demo Treu Love by Booze Design.

As of now I have found these values:

$59,$85 (=$2c)
--------------

C64 Ultimate 1.24, 1.34
Chameleon Beta-9j
The C64 1.3.2-amora
VICE x64 and x128 2.4, 3.1, 3.4 
VICE x64sc 2.4


$5a,$86 (=$2c)
--------------

1541 Ultimate-II Plus 3.6 (115)


$5b,$88 (=$2d)
--------------

Commodore RAM Expansion Unit
VICE x64sc 3.1, 3.4

