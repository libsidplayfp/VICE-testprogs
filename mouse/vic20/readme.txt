
prop_vic20_amiga.prg:
prop_vic20_cx22.prg:
prop_vic20_st.prg:
------------------

This is a prototype driver for the Amiga mouse, the Atari ST mouse and
the Atari trackballs cx22 and cx80. Please note that it has only been
tested on emulators and the vic20 emulators I know doesn't emulate any
of these devices.

When run the test progam displays several hex-numbers at the top of
the screen. The first reflects the four joystick input bits. The
second and third are the X and Y-coordinates read from the driver. The
fourth is an internal error counter.

For documentation of the driver please see the prop.inc file. The test
progam calls prop_update in a tight loop. A real program probably
would call prop_update from a timer interrupt with about 1ms between
calls.

The target input device is selected by defining symbols when assembing
it, see the Makefile for details.

Please note that the cx80 trackball has no driver of its own since the
early versions are compatible with the cx22 and the later versions are
compatible with the ST mouse.

various 1351-* programs:
------------------------

these will work with the micromys adapter by individual computers. a regular
1351 mouse does NOT work with VIC20!

neos0k.prg:
neos8k.prg:
-----------

tests for modified NEOS mouse
