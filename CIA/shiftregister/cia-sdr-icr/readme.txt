
CIA serial shift register timing tests. (v2)
--------------------------------------------

from https://sourceforge.net/p/vice-emu/bugs/1219/

This is another test that shows the ICR value for every cycle from just before 
the first Timer A underflow to when the SDR is empty. On real hardware the 
Timer A flag is set after the first underflow. The SDR flag is set when the 
final bit is shifted via the shift register. These results are shown by default. 

Pressing space toggles the screen which shows the value of the ICR immediated 
after loading the SDR register for each of the cycles. 

On real hardware the SDR bit is set depending on 
when TImer A was stopped on the previous test. Timer A is stopped by the test 
as soon as it detects SDR flag i set. This needs more investigation but I'm 
guessing the shift register picks up from where it left off from the previous 
test because it hadn't finished the final shift in the previous test, it only 
flagged the SDR was available for new data....

A surprising discovery for these tests was that apparently a certain batch of
"old" 6526 CIAs, with timestamp 4485, show different behaviour than usual.

First screen of results is the same for both. The second screen of results are 
very similar for "normal" and "4485" CIA. The only difference is the SDR is 
cleared in the cycle after it is first set for "normal" CIA before being set 
again  in the following cycles. Look at the dumps for more detail.

--------------------------------------------------------------------------------

https://sourceforge.net/p/vice-emu/bugs/1219/?page=2#62bc:

Attached are a suite of tests that generates the reference data for normal
CIA's and CIA's with timestamp of 4485. The functionality is the same as the
previous test but the reference data is different because I modified some of
the timing of the main test loop including starting clockslide with offset of
255.

The storing of results, the reference data locations and number of samples can
be fully adjusted assuming memory allocated doesn't overlap. There is no need
to start at the beginning of a page now. See source for details.

All attached tests pass on real hardware with the correct CIA type for the
test. i.e. If you have CIA with timestamp 4485 you should use the 4485 version
of the tests.

All tests have been confirmed to pass on real hardware.

Single run tests will only test one baud rate. Pressing space once results are
shown will toggle the result screens.
icr-0
icr-3
icr-19
icr-39

Automatic tests will test all possible baud rates between a range of baud
rates. It will stop at the first failed test. Holding down space will stop the
program once the current test has completed. Pressing space once results are
shown will toggle the result screens. RUN STOP/RESTORE and peek(2098) is a
quick way to see what the TImerA latch value was for the last test.
icr-0 7f
icr-1 7f
icr-4 7f

EDIT: Included test for 39. Similar to test 19, the second set of results for
that test are nicely aligned for a 40 column screen .

--------------------------------------------------------------------------------

If you run the tests on your own gear, please consider the following:

Please first note down:
- what machine are you testing (c64/c128)
- what ASSY is it (ASSY number on the motherboard)
- what CIAs are on the board. write down ALL markings (eg: MOS 6526 / 1888 216A)

Now run the "delay2-new" and "delay2-old" programs. Green border means "test
passed", and will generally tell if you have a "new" or "old" CIA. (Contrary to
popular belief this can NOT be reliably determined from whats written on the 
chip). Incase both of these programs show a red border, that means the two CIAs
in your machine have different characteristic - in that case please compare the
expected values shown on screen and determine the CIA type from that.

After that, run the other programs. (green border means passed)

cia1- tests check the first CIA, cia2- tests check the second CIA

-4485 tests are assumed to pass only on 6526 with the timestamp 4485. these will
then NOT pass the equivalent tests without -4485.

-generic tests will pass on all CIAs, as they skip the differences.

To confirm the above, please make sure to really run ALL programs and tell which 
fail and which do not.
