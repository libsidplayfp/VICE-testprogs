
(slightly reworded) from http://sleepingelephant.com/ipw-web/bulletin/bb/viewtopic.php?f=14&t=7629&p=84541#p84478

"The VIC chip doesn't reset the text screen address pointer in the border area
below the regular text screen, it then displays the first pixel line of the next
text line, as if the border area actually hadn't been there.
Only during vertical retrace the text screen address pointer then is resetted.

You can test with POKEs to addresses 8186..8191 with an unexpanded VIC-20 - the
first 6 chars in that most bottom line should change accordingly. With that
memory configuration, the VIC chip wraps over to the character ROM for the
remaining 16 bytes of the lines, and that is what's shown as garbage in the
screenshot."

vert0test.prg:

"Works on NTSC and PAL with or without expansion. Shifts screen memory to $1c00
and poke reverse space, space and "dithered" reverse space into the invisible
24th line. Press Space to cycle through the 3 values.
You will see the line changing at the bottom."

does not work correctly on xvic (r30500)
