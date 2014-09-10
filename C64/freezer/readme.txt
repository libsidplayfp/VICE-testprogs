some tests to verify if a cartridges freezer can successfully
- break a running program
- restore execution of the interrupted program

freeze-test             simple check to confirm freezing works at all
freeze-test-cia1        check if CIA1 irq is handled correctly
freeze-test-cia2        check if CIA2 nmi is handled correctly
freeze-test-raster      check if raster irq is handled correctly
freeze-test-combined    combination of the above

freezeblock
-----------

This test is the frezer protection that was extracted from the game "protium".

What it does is pointing the nmi vector to the first handler, and then it sets
up a timer for that nmi. the nmi triggers, and switches the vector to the other
handler. then it returns to mainloop without acknowledging the timer irq flag
(which is commonly known as "NMI disable"). subsequent NMIs will not trigger
because of this.

When the freezer code reads the acknowledge bits in $dd0d, the NMI will trigger
when restarting from the freezer, and the protection fails.

this is why it works with the 1541u:

The 1541u uses the DMA line to stop the C64s CPU and then accesses the C64s
memory (screen etc) using the ZPU in the cartridge. This allows to not handle
(read) $dd0d and properly restart. the downside of that is that you can NOT
save a snapshot (not even an AR quality freeze) using this technique - because
you need to find out what CIA2 NMIs are enabled to do that, and to find that
out, you must read the flags in $dd0d (which acknowledges them).
