
taken from: https://sites.google.com/site/h2obsession/CBM/C128/Interlace

The program was written in 8502 (6502 compatible) assembly langauage, 
originally using the Commodore 128's ML Montior.  Later I transcribed it to 
source files, and updated it on a Windows machine.  The source files were 
compiled with the publicly available cross assembler "xa" v2.1.4f (c) 1989-98 
by A.Fachat on a Windows machine (in a DOS box)

This produces two binaries, bmldr.prg and ilace.prg.  These were loaded into the 
VICE emulator and then saved onto the disk image 'interac2.d64' as 'BM LOADER' 
and 'CODE 5'.  The BASIC program DEMO 2 is uncompiled.  It was originaly written 
on a real C128 then latter modified using an emulated C128.  In both cases, the 
native version of Commodore BASIC 7.0 was used.


	Interlace Demo 2.1, a program to demonstrate interlaced video
		using the VIC-IIe on a Commodore 128
	Copyright (C) 2007 Robert Willie <hydradix@yahoo.com>

	This program is free software; you can redistribute it and/or modify
	it under the terms of the GNU General Public License version 2 as
	published by the Free Software Foundation.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public License
	("COPYING") along with this program; if not, write to

	Free Software Foundation, Inc.
	59 Temple Place
	Suite 330
	Boston, MA  02111-1307
	USA

[Preface]
Using the undocumented test bit of the VIC-IIe, a true interlaced image can be 
produced -- 320x400 bitmaps and 40x50 text screens are now possible!

* Notice *
This program attempts to produce an interlace display with the VIC-IIe video 
chip by producing a non-standard video output.  There is a small probability it 
may damage a monitor/TV.  This program has been tested on a nice 36-inch JVC 
television (NTSC video standard) with no ill effects.  Unlike customizations to 
the VDC video chip display that can produce a very scrambled display 
(potentially dangerous), this never happened while testing this program.  
The small timing changes the program introduces, coupled with the fact that VIC 
itself does not normally produce a fully compliant display anyway, leads me to 
conclude the program should be safe.  However I make no guarantees, so use at 
your own risk.

This program is for the VIC-IIe, which is the 40-column video chip in the 
Commodore 128, and is written for both NTSC and PAL video standards.  It may not 
work on PAL systems without customization due to lack of technical 
documentation.  The PAL settings were derived (guessed) from the NTSC settings 
and from the 'VIC-II' article by Christian Bauer.  That article deals with the 
original (not subtype e) chip, does not specify the raster of the vertical sync, 
and specifies vertical blanking lengths that do not correspond with the subtype 
e chip.

My experiments indicate a vertical blanking length of only 11 rasters (NTSC).  
I believe this is 2 blank rasters plus 9 for vertical sync / equalization.  The 
PAL settings are based on 2 blank rasters plus 6 for vertical sync / 
equalization.  It may be that the PAL chip also produces 11 rasters with 4 blank 
rasters instead of 2.  If this is the case, the settings for PAL will need to be 
adjusted by +1 raster for each field.

*Update* Several PAL users reported +1 is necessary so this updated version uses 
raster 300 instead of the previous 299.  Also the cycle has been set to 44.  
Some users have reported cycle 46 produces better results for their monitor.

[Introduction]
After reading about how the Atari 2600 can do interlaced video, I began 
wondering if it could be or has been done for the C64.  After reading many 
articles, it appears it is not possible... the closest thing I read about is 
called IFLI a video mode for the VIC-II (C64 or C128) that alternates bitmaps 
every field for the purpose of blending colors and smoothing pixels.  This does 
NOT create an interlaced (400+rasters) video image.

In NTSC video, interlacing is achieved by sending a non-integer number of 
rasters each field (2 fields per frame called even and odd).  The rasters of the 
even field appear above corresponding rasters of the odd field.  Even fields 
start in the middle of a raster, which is to say, the first raster is a half-
raster, then all remaining rasters in the even field are complete, full rasters.  
Then the odd field starts and begins with a full raster but it ends with a half-
raster -- all ready to start again with the next even field.  The even/odd 
nature is determined by timing of the vertical synchronization (v-sync) pulses 
that mark the start of a new field.

The even/odd nature may be reversed for PAL.  If so, PAL users can easily 
compensate by selecting R (reverse fields) from the demo menu.

After reading (in an article of Commodore Hacking probably) about how the C128's 
undocumented test bit of the VIC-IIe works (it makes VIC 'cut' rasters), I 
wondered if that could be used to produce interlaced video.  Well, I got a 
Commodore 128 recently and decided to test the idea.  First I needed to know 
when the VIC-IIe produces the v-sync pules (i.e., on which raster according to 
VIC).  After doing more research on the www, I was unable to uncover any 
information.  This again leads me to believe this has never been done before.

[Development]
By playing with the test bit, I was able to completely eliminate the v-sync.  
This produces a rolling video display. With a rolling display, I was able to see 
(by changing border color with an interrupt routine) when the v-blank starts and 
when it ends.  V-sync occurs in the middle of v-blank so I can't be sure of its 
location, but by deduction (which rasters I needed to kill to roll the screen) I 
concluded the following (NTSC):

VIC-IIe produces odd fields (except the last raster is not a half raster)
V-Blank starts on raster 13 ($0d) and lasts 4 rasters (blank + 3 equalization)
V-Sync starts on raster 17 ($11) and lasts 3 rasters
V-Blank resumes on raster 20 ($14) and lasts 4 rasters (3 equalization + blank)
Video starts on raster 24 ($18) and lasts 252 rasters

With this information, I wrote a single-cycle-exact interrupt routine (using a 
double interrupt technique) that has two parts.  This can be found in 
'interrupt.src'.  'ivirq' enables the interrupt routine 'ikirq' disables it.  
'eField' contains the code for even fields and 'oField' contains the code for 
odd fields.  Also there is common code at 'ixit' to finish the interrupts, 
'iField' to initialize the next field, and 'dblirq' to perform the double-
interrupt synchronization.

Then I experimented with different 'cut' times to create an interlaced effect.  
When I got an 'interlaced' image I was really exited!  In hindsight, it may not 
have been true interlacing but anyway...

Next I created a BIG circle bitmap.  What a pain!  I started with a normal 
bitmap of a half circle: the top half.  I believe the BASIC command was 
CIRCLE 1,160,199,159,199.  I made a copy of the bitmap and in each I eliminated 
every other raster.  Now I had two half-vertical bitmaps (320*100 each).  I 
copied each of these, but did a mirror-y in the process. Which is to say, the 
copies were the bottom halves of circles.  Finally I combined these bottom 
halves with the top halves to create 2 normal bitmaps of segments resembling 
full circles.  These are on the disk image as CIRCLE0 and CIRCLE1.

CIRCLE0 contains what I call even rasters, representing 0,2,4,6...398 (but its 
a normal bitmap so these appear as rasters 0...199 with missing segments).  The 
first raster has a segment in the middle and the last raster has a gap in the 
middle.  CIRCLE1 contains what I call odd rasters, representing 1,3,5,...399.  
The first raster has a gap in the middle while the last raster has a segment in 
the middle.  Neither bitmap by itself could be called a circle because of 
missing segments.

With the bitmaps, I went back to the interrupt code and made it switch VIC 
video banks for each half of the interrupt code.  With the bitmap(s) on screen, 
it was obvious that my 'interlacing' was wrong so I continued experimenting.  
I finally found a method that produced a good result and announced my invention 
on the C128 Alive forums.  I said I would make a demo so that's what I did next.

[Update -- Demo 2]
Unfortunately, the original demo wouldn't permit 'cutting' rasters past 255 so 
it could not work for PAL.  I discovered after releasing the first demo that 
the article by Christian Bauer mentions the raster of video blank start.  
Although this is not the raster for vertical sync (needed for interlace), it is 
close and the value given is also correct for the NTSC VIC-IIe.

So based on the article's statement of PAL blanking, and the fact that PAL 
vertical sync / equalization is 6 rasters (instead of 9), I guessed the 
following:

V-Blank starts on raster 300 ($12c) and lasts 3 rasters (blank + 2 equalization)
V-Sync starts on raster 303 ($12f) and lasts 2 rasters
V-Blank resumes on raster 305 ($131) and lasts 3 rasters (2 equalization + blank)
Video starts on raster 308 ($134) and lasts 304 rasters

This made me update the code to handle rasters past 255.  While I was updating 
the code, I decided to try a true text display in interlace mode.  The original 
demo only used bitmaps and the 'text' demo display (a directory listing) was 
really a bitmap.  To get 50 lines of text, I used FLI (flexible line 
interpretation).

[Real Interlace FLI]
Not to be confused with IFLI which claims to be interlaced!  In FLI, we force 
the VIC to update its pointers more often than the usual (once per 8 rasters). 
The interlace demo uses FLI this way:

	The screen starts normal and VIC fetches text row 0 (raster 51)
	4 rasters later FLI is activated and VIC fetches text row 1 (raster 55)
	Immediately after VIC is set back to normal
	4 rasters later, normal VIC fetch occurs, now for text row 2 (raster 59)

In other words, every 8 rasters FLI is invoked to fetch odd rows then VIC is 
reset to normally fetch even rows which results in new text rows every 4 
rasters.

Doing this for the entire visible (inside the borders) part of the screen 
creates 50 rows of text, 4 rasters each.  Since this is used in combination 
with interlacing, the result is 50 text rows of 8-raster characters.  

The code for this is in 'text-fli.src'.  FLI requires precise timing and for 
variety (and efficiency) I used Timer B of CIA#1 to achieve cycle-exact 
execution.  There is actually two different code sets.  The first is without 
ROM which has an interrupt 1 raster before every badline and the second, with 
ROM, has an interrupt 2 rasters before only the FLI badlines.

FLI does have a bug of fetching 3 bad pointers.  This results in 3 garbage 
characters at the start of every odd text row.  Because I'm lazy, I did not 
hide the bug.  Normally FLI is used with bitmaps and the bug is hidden by 
covering the left side of the screen with sprites.  For FLI text mode, another 
option is to define character 255 as a blank.

Another minor bug (really a detail) is that VIC does not update its row-in-
character counter when FLI is activated, so the bottom half of the font must 
duplicate the top half.  Also a normal font must be split into 2 sets for 
interlace mode (even and odd fields).  The routine 'makeFont' creates 2 such 
sets from the Commodore character ROM for the demo.

Finally note that I only implemented Real Interlace FLI for the text mode 
demonstration.  Feel free to combine this with bitmap mode instead, and if you 
do, please share!

[Demo 2 Bitmaps]
After realeasing the first demo, I wanted to see something more exciting with 
my new video mode than a circle or directory.  Since there are no bitmap 
editors for my new video mode and I'm too lazy to write one, I decided to simply 
split a hi-res image into two files and then convert them to Commodore bitmaps.

To get two files of even and odd fields, I wrote a Windows command-line program.  
I've included the binary 'splitbmp.exe' and it is unsupported freeware.  It 
requires a 24-bit uncompressed BMP (Windows Bitmap) for input and produces two 
files as output (for the even and odd fields).  Then I used Timanthes 
(http://www.tehwinnar.com/pdnabout.html) to convert the BMP files into Commodore 
multi-color bitmaps.  The output from that program seems like a Koala file 
without the 'KK' prefix and missing the background color.  I simply used a hex 
editor to append the correct background color.

Finally I wrote 'bmload.src' to load the bitmaps.  It determines if the bitmap 
is multi-color or hi-res based on filesize (load end address).  Once it knows, 
it moves the data to approprite spots in Bank 1 depending also if it is an even 
or odd field.

I've included two of these on the disk image.  Although much nicer to look at 
than a circle, they really do not take full advantage of the interlace mode -- 
a talented 64 pixeler could do better with a normal multi-color bitmap.  But I 
think they show potential.

Also included is DITHER, a set of bitmaps provided by Nikoniko.  This image is 
designed to show harsh contrast and as a consequence, it flickers terribly!

[BASIC Program Description]
The actual demo program (DEMO 2 on the disk image) is a (uncompiled) BASIC 
program.   It sets BASIC's start of variables to $c000, allocates the BASIC 
bitmap, and displays a message on the VDC screen.  Then it loads:

	Interrupt code (CODE 5 into $1300)
	Bitmap loader (BM LOADER into $b00)
	Circle bitmao (CIRCEL0 to $1c00 and CIRCLE1 to $9c00, Bank 1)
	FLI text and color screens (FLI TEXT to $2000, Bank 0)

It creates the FLI font at $3000 and $3800, and shows the copyright and a 
notice.  If you press RETURN to continue, it checks the VIC-IIe test bit and 
reports if it does not work (such as in an emulator).  Finally you get the main 
menu.

[Interlace Menu]
When first displayed, the interlace interrupt code will be off.  You can turn it 
on/off by pressing the space-bar.  If it works correctly on your display, you 
will hardly notice it on the menu screen!  If the display does not look correct, 
see the Customizing section.

The two main viewing options are V to view an interlaced bitmap or T to view an 
interlaced text screen.  I recommend V first since the circle is monochrome and 
very simple (easy to see if the settings work correctly for you).

When viewing either a bitmap or FLI text, you have these options:
	Press M to go back to the main menu
	Press R to reverse the even and odd fields
	Press + or - to change background color (not all bitmaps)
	Press Space to turn interlace on/off (bitmap only)

You can load another bitmap by pressing L.  When asked for a name, you can type 
$ to see the dirctory.  Enter the name without the zero or one.  For example, 
the disk contains DITHER0 and DITHER1 files; type DITHER to load the interlaced 
image set.

If you don't have this text handy, you can press H or Help for a very brief 
review.  Press Q to quit the interlace demo.

Still on the main menu, you will see a section labeled 'Presets'.  These will 
set various parameters for the interlace code.  You can restore the default 
settings by pressing A.  Preset B will 'cut' the vertical sync and will probably 
cause the entire screen to roll (if interlace is enabled).  And option C is for 
testing/comparsison: it will 'cut' nothing so there will be no interlace!  
Try viewing the bitmap or FLI text screen again with this setting to see the 
difference between IFLI and real interlace.

[Customizing]
If there is no difference in the bitmap or FLI-text between Preset A and Preset 
C, then interlace mode is not working for your display.  You can customize 
three different settings of the interlace code for each field.  The current 
settings and some statistics for each field are shown at the bottom of the 
menu screen.  Below the field statistics are the statistics for a complete 
frame.  In either case, the statistics are:

Number of cycles in frame (or field).  A cycle is approximately 1 microsecond.
Duration of frame (or field).  Given in milliseconds.
Frame (or field) rate.  Given in Hertz (Hz). Equal to 1/duration.

Press 0 (zero) to edit the even field settings or 1 (one) to edit the odd field 
settings.  This erases the statistics and adds editing options.  Note that all 
options are still accessible while editing, but you can remove the editing 
options and restore the statistics by pressing the ESCape key.

The editing options allow you to change 3 items:

Cut Raster is the VIC raster (vertical position) where the test bit is enabled.
Cut Cycle is the cycle (horizontal position) where the test bit is enabled.
Cut is the amount of rasters to be cut, if any.

Use the cursor keys UP and DOWN to change the Cut Raster.  Use the cursor keys 
LEFT and RIGHT to change the Cut Cycle.  Press 3 or 4 to change the number of 
rasters to be cut or press N to cut no rasters.

The way the interrupt code is written, the Cut Cycle can only be changed in 
increments of 2, normally restricting you to even cycles, but you can wrap 
around to the next raster which allows cutting on odd cycles.  For my TV (if 
the raster is correct), any cycle between 21 and 35 will work.

[Experimenting]
While experimenting, I found several settings that were almost right, which is 
why having the bitmap is very handy.  The bitmap should have thin, distinct 
rasters, and of course should look like a circle.  The rasters should not 
overlap.  If the display seems stable but the circle looks 'wrong', try 
reversing the fields by pressing R.  Certain settings, on my TV anyway, produce 
a stable but 'crazy' interlace effect where half (top or bottom) appears correct 
but the other half appears reversed.

I suggest experimenting with the settings for even fields because VIC produces 
odd fields naturally.  You should also cut 1 raster more for even fields 
(NTSC).

You may be curious why the code 'cuts' 4 rasters for even fields and only 3 
rasters for odd fields.  This is because the 'cut' crosses from the end of the 
odd field into the start of the even field and because the code for even fields 
occurs at the end of an odd field (and vice versa).

In other words, 4 rasters are 'cut' to create the even field, but 3.5 are at the 
end of the odd field and 0.5 at the start of the even field.  So the even field 
starts 0.5 rasters short and at the end 3 more rasters are 'cut' before starting 
the odd field (this should not cross over).  In summary, each field has 3.5 
rasters cut but the program displays 3 and 4 because that is the way the VIC-IIe 
test bit works (it skips 1 complete raster for every cycle it is 'on').

*Update* PAL users report success when both cuts are the same length but using 
a different raster number for each field.  Since I do not have a PAL monitor or 
C128 to experiment, I can only guess this is due to PAL using a fractional sync 
length (2.5 rasters).

Some settings produce a color artifact I call rainbowing.  I believe this may 
be due to the generation of even fields and the fact that VIC does not reverse 
the phase of the color burst.  Its hard to describe since the background is 
still dark gray and the characters/pixels are still (mostly) light green, but 
if you see it, you'll notice some color shifting of various amounts resulting 
in a rainbow effect.

Hopefully you'll find a nice setting that shows a super-smooth circle with very 
little jitter.  If you do, the final test is FLI text mode.  It should show 
little flicker and the text should be very legible (small but legible).  The 
amount of flicker is based on a number of factors such as the persistance of 
your monitor, your personal persistance of vision, and ambient lighting.  But 
probably most important is contrast.  Thus black text on a white background is 
probably the worst.  With a medium gray background, I do not notice any flicker 
on my TV for either black or white text and the other text colors look good too.
