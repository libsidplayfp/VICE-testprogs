
these programs have been derived from "REUTools 1.0" by Walt of Bonzai, get the
original release here: https://csdb.dk/release/?id=196880

CheckChar
=========

Tests if streaming to char works as expected. Uses char to sprite collision 
check with a predefined test pattern.

Will fail on VICE x64 but not on VICE x64sc. Also fails on The C64 
(See https://www.youtube.com/watch?v=UInN-ta9CkA for how-to)

The check is running every 8th frame so you can see what happens. If used in 
your own work, this should be changed.


REUDetect
=========

Detects if REU is present and its size. Tests the needed amount of memory
(512KB, can be changed in the source code).


SpriteTiming
============

Tests by streaming to magic byte starting a few rasterlines before where 8 
sprites is displayed. Uses char to sprite collision check to detect where char
position 0 is in the stream for the first and second line of the sprites.

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

$59,$85
-------

C64 Ultimate 1.24, 1.34
The C64 1.3.2-amora
VICE x64 and x128 2.4, 3.1, 3.4 
VICE x64sc 2.4


$5a,$86
-------
1541 Ultimate-II Plus 3.6 (115)


$5b,$88
-------
Commodore RAM Expansion Unit
VICE x64sc 3.1, 3.4

