This directory contains some tests related to the serial shift register of the
CIA6526(A).


cia-sp-test-oneshot-new.prg
cia-sp-test-oneshot-old.prg
---------------------------

serial shiftregister irq checks derived from the protection of arkanoid
(http://csdb.dk/release/?id=40451)

border color shows the test result:

red: no irq occured at all
yellow: number of occured interrupts is wrong
green: passed

NOTE: this test fails on hoxs64 v1.0.8.7, micro64 1.00.2013.05.11 - build 714,
      x64sc 2.4.15 r29241

cia-sp-test-continues-new.prg
cia-sp-test-continues-old.prg
-----------------------------

same as above but using continues timer

cia-icr-test-continues-new.prg
cia-icr-test-continues-old.prg
cia-icr-test-oneshot-new.prg
cia-icr-test-oneshot-old.prg
cia-icr-test2-continues.prg
cia-icr-test2-oneshot.prg
-----------------------------

related ICR ($dc0d) behaviour checks


cia-sdr-load.prg
----------------

from https://sourceforge.net/p/vice-emu/bugs/1219/

It seems the new byte is only taken into the shift register on the first timer 
underflow. So one has to introduce the delay to make sure one timer underflow 
appears before writing a new byte.

The CIA datasheet however says: "The data in the Serial Data Register will be 
loaded into the shift register, then shift out to the SP pin when a CNT pulse 
occurs."

So it should be possible (and in my previous (historic) experience I think it 
is) that when the SDR is empty one can directly write two bytes without delays: 
one that is immediately passed through to the actual shift register, while the 
second byte stops in the SDR, to be loaded into the shift register when it ran 
empty. (I probably should confirm this next week, but the code without the delay 
ran successfully in older days on real hardware)

The test program shows different timing between the x64sc and a C128 in C64 
mode or a C64. VICE prints out 10 times "$FCF2" while the C64 prints out "$FCEB" 
(with only 1-2 cycles off in the first iterations each).

However, that does not show the actual problem when shifting out the data. The 
test writes to SDR twice directly after each other. In the real machine, the 
RS232 transmits all 16 bits - in VICE SDR, the rs232 code only gets a single 
byte - so output is mangled. But that is not something an all-in-the-machine 
test can show.


cia-sdr-init.prg
----------------

from https://sourceforge.net/p/vice-emu/bugs/1219/

"This simply tests when the shift register acknowledges it is empty with 1 byte 
writen to the SDR register. 

This passes on my real c64c and c128D in c64 mode. It fails in VICE. VICE result 
is FCF1, real result is FCEA."


cia-sdr-delay.prg
----------------

from https://sourceforge.net/p/vice-emu/bugs/1219/

"Another test which adds a delay before writing a byte to the SDR after Timer A 
has started and waits until the SDR flag is set. The test executes 21 times 
decreasing the delay by 1 cycle each run. Red text in results shows mismatch in 
timing compared to my real hardware(same systems as decribed above) .

Pattern on real hardware:  FCE6, FCE7, FCE8, FCE9, FCEA, FCE4, FCE5
Pattern on VICE:           FCED, FCEE, FCE8, FCE9, FCEA, FCEB, FCEC

Based on these results it looks like there is a 4 cycle delay on real hardware 
compared to VICE for when the SDR flag is set. More tests should probably be 
done with different baud rates to see if the delay is consistent."

cia-sdr-icr-new.prg
cia-sdr-icr-old.prg
-------------------

from https://sourceforge.net/p/vice-emu/bugs/1219/

"This is another test that shows the ICR value for every cycle from just before 
the first Timer A underflow to when the SDR is empty. On real hardware the 
Timer A flag is set after the first underflow. The SDR flag is set when the 
final bit is shifted via the shift register. These results are shown by default. 

On VICE it seems to support the 4 cycle delay theory looking at the last series 
of I's at the bottom of the screen. The results on VICE also show the SDR flag 
is set well before the final underflow for shifting. This is probably something 
to do with what's discussed in the next paragraph.

Pressing space toggles the screen which shows the value of the ICR immediated 
after loading the SDR register for each of the cycles. 

On VICE they are all zeros. On real hardware the SDR bit is set depending on 
when TImer A was stopped on the previous test. Timer A is stopped by the test 
as soon as it detects SDR flag i set. This needs more investigation but I'm 
guessing the shift register picks up from where it left off from the previous 
test because it hadn't finished the final shift in the previous test, it only 
flagged the SDR was available for new data....

The attached test passes on my real hardware. My C64C has new CIA and my C128 
has old CIA. First screen of results is the same for both. The second screen of 
results are very similar for old and new CIA. The only difference is the SDR is 
cleared in the cycle after it is first set for new CIA before being set again 
in the following cycles. Look at the dumps for more detail."
