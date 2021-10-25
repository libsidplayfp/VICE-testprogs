related to https://sourceforge.net/p/vice-emu/bugs/86/

This program puts the VDC into interlaced bitmap mode, 640x484 resolution, with
8x4 color cells. Its purpose is to create a very simple test pattern consisting
of colored bars and diagonal lines, and let you tweak various VDC registers to
get the best picture. It gives you enough control to change the refresh rate and
screen size (though it doesn't let you move the bitmap or color attributes
within memory). 64K VDC RAM is needed.

When you run the test program, use Control-F to Fill the screen with the test
pattern. Since it's entirely in BASIC, it will take several minutes to fill the
screen with the test pattern, even in "warp" mode.

Then use keys: qwertyuiop@ with and without shift to raise and lower the value
in each of the registers listed in the DATA statement at line 63000.

Control-Q quits the program and prints a DATA statement containing the new
register values.

Careful with the program - it lets me adjust the H-sync enough that it will
cause my 1902 to shut down to protect itself - don't damage your hardware!!

vdc-stage1.png is what you first see a few seconds after you hit control-F. Wait
a bit and the top starts to fill with "garbage", which actually looks like
values 0-255 are being stuffed into the bitmap.

vdc-stage2.png is right after the garbage stopped filling, just as the diagonal
lines started to draw. 

vdc-stage3.png you can see the full screen of diagonal lines - this is as close
as the VDC emulation comes to my C128.

If I wait long enough, the image shown in vdc-stage4.png starts to appear.

After this is finished, the program begins accepting keystrokes.

In real-c128-1.png and -2.png, you can see what should be displayed by the time
the program starts accepting keys, with one of these images being an extreme
closeup of the screen.
