this test program demonstrates an emu bug i stumbled about when coding a certain
intro, i stripped it down to a simple FLD. basically it starts FLD somewhere at
the top of the screen and goes on into a few lines into the display area.

for some weird reason the FLD apparently aborts early on the C64

gpz, 1.5.2018


fld0.prg (VERSION=0):

in the FLD loop BIT $EAEA is being used to waste 4 cycles. this version does NOT
work correctly on a real C64. it DOES work on X64SC (r34000)

fld1.prg (VERSION=1):

in the FLD loop STA $D020 is being used to waste 4 cycles. this kindof makes it
"self stabilizing" somehow and the result is that is DOES work on the real C64
(and on VICE).

more variations can likely be created that fail in different ways (on the real
C64) by adding some more cycles delay before the FLD. while coding the intro
i have seen different misbehaviour (things that looked like accidental DMA 
delay, linecrunch etc - all when it would still work fine on x64sc)
