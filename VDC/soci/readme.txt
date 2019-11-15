
this directory contains various VDC tests written by Soci/Singular

--------------------------------------------------------------------------------

test01.prg:

Double pixel text mode with 8x8 characters in mono.
Exact 64us/312 lines pal timing.
There's 1 extra junk pixel column on the right side.
The cursor is in the top left corner inverting @.

test02.prg:

Single pixel text mode with 16x16 characters in mono.
Exact 64us/312 lines pal timing.
The cursor is in the top left corner inverting the top
and bottom 4 lines of @.
The green area is the vertical blanking. It ends at
first line of text area and starts at first line after it.
The raster bug has no relation to the position of horizontal
blanking or the position of horizontal sync signal, it's
always at the same position.
The font is expanded using semi graphic mode.

test03.prg:

Double pixel text mode with 16x24 characters with attributes.
64us/313 lines pal timing, if it's 312 only, then there's no
sync at all, as the sync is placed at the row and there's no
time to latch.
The cursor is in the top left but it does not blink. If the
sync is moved one row earlier, then it does with the same
frequency as the right side of the screen, which looks empty
now.
The screen address is latched at the end of screen, if it's
changed one cycle later then everything is shifting by one
depending on the timing.
The underline is configured to be line 7, the bottom of the
screen displays the alternate charset.
This test needs a 64K VDC.

test04.prg:

Double pixel text mode with 16x24 characters with attributes.
64us/625 lines pal interlace timing.
The cursor is in the top left and blinks fast.
Every second line is blinking, even if it's looks empty or
as a white bar on the picture or with different color,
it's all white.
The color bar on top is green + red flashing every other
frame, but it's just mixed with flickering as the electron
beam is to thick to make up individual lines.
Attributes are applied on chars, and underline is line 7.
This test needs a 64K VDC.

test05.prg:

Single pixel text mode with 9x16 characters with attributes.
64us/525 lines ntsc interlace timing.
The cursor is at char 32 (space) and blinks slow.
Text mode is 80x30. Only alternate charset attribute is applied.
Semi graphic is enabled, but cannot trigger.

test06.prg:

Double pixel text mode with 6x12 characters with attributes.
64us/263 lines ntsc timing.
Text mode is 64x18. Only color attribute is applied.
Screen is reversed, charset bitmap is reversed, and vertical
scrolling is applied, which results in the upper line.

test07.prg:

Double pixel text mode with 8x9 characters with attributes.
64us/263 lines ntsc timing.
Text mode is 40x25. Only reverse attribute is applied every
256th char.
Screen is reversed, charset bitmap is reversed.
Display of characters is cropped to 8x8 in a 9x9 matrix.

test08.prg:

Raster test. Text is the same color as background, just brighter.
Using 40x25 text with 32 pixel borders.
PAL timing 64us/312 lines.

test09.prg:

Shift test. All combinations of horizontal shift and
character stop positions by using 15x8 characters on
a 20x33 text field. PAL 64us/312 lines, double pixel mode.

test10.prg:

Shift test. All combinations of horizontal shift and
character stop positions by using 8x8 characters on
a 20x33 text field. PAL 64us/312 lines.

test11.prg:

Blanking test over text field.
PAL 64us/312 lines, double pixel.
If the start and end positions are the same
the result is not stable.

test12.prg:

Blanking test over text field.
PAL 64us/312 lines, double pixel.
If the start and end positions are the same
the result is not stable.

