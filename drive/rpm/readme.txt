
This directory collects programs that measure the drives spindle motor speed in
RPM.

The result should be somewhere around 300rpm, +/- 1% (297-303)

All programs show on screen:

- the number of cycles measured for one revolution (~200000)
- calculated RPM (highest precision, not rounded)
- calculated RPM (rounded to two decimals)

--------------------------------------------------------------------------------

rpm1.prg:
- Measures directly on the drive using VIA timers. each value represents the
  number of cycles between a sector header and the next sector header, which
  adds up to the total time for one rotation.

rpm2.prg:
- Is a variant of rpm1.prg which lets the timer free running for one revolution
  and relies on the wraparound, so we can measure the time for one revolution
  indirectly.

rpm3.prg:
- Inspired by "1541 Speed Test" by Zibri (https://csdb.dk/release/?id=194046).
  Writes a test track on track 36, which contains one long SYNC and then 5
  regular bytes. Time for one revolution is measured by reading 6 bytes.

--------------------------------------------------------------------------------
How does it work?
--------------------------------------------------------------------------------

The general idea is: have a "marker" on a track, then measure the time for one 
revolution using timers. From the measured time we can calculate the rotation
speed.

Generally there are different ways to achieve this:

- Wait for the marker and toggle a IEC line. the C64 measures the time using CIA 
  timer. This is what eg the well known "Kwik Load" copy does, the problem is 
  that it is PAL/NTSC specific, and it can never be 100% exact due to the timing 
  drift between drive and C64.

- Wait for the marker and measure the time using VIA timers on the drive. The 
  problem with this is that VIA timers are only 16bit and can not be cascaded, 
  so you either have to measure smaller portions at a time, or rely on the 
  wraparound and the value being in certain bounds at the time you read it.

Now, to make either way slightly more accurate, a special kind of reference 
track can be used. typically this track will contain nothing except one marker - 
which makes the code a bit simpler and straightforward. This is what rpm3.prg
does. The CBM DOS also does something similar when formatting, to calculate the 
gaps. This obviosly has the problem that we are overwriting said track.

--------------------------------------------------------------------------------
How accurate is it actually, and why?
--------------------------------------------------------------------------------

The basic math to calculate the RPM is this:

expected ideal:
300 rounds per minute
= 5 rounds per second
= 200 milliseconds per round
at 1MHz (0,001 milliseconds per clock)
= 200000 cycles per round

to calculate RPM from cycles per round:
RPM = (200000 * 300) / cycles

--------------------------------------------------------------------------------

What causes the jittering in the code is the waiting for "byte ready", 
typically done by a BVC * - after that the code is in sync with the disk data, 
jittering 2 cycles.

CAUTION: When running the test programs in VICE (and perhaps other emulators)
the observation made may be fooling you due to metastable behaviour. In VICE the
rotation is in perfect sync with the drive CPU, and the drive CPU is in perfect
sync with the C64 CPU - none of this will ever be the case with real hardware.

rpm2.prg works like this:

- wait for sync
- read a byte (now we are jittering 2 cycles)
- check if this is a sector header, if not repeat
- if yes read the header, check if it is sector 0, if not repeat.
- at this point the jittering is still 2 cycles
- reset the timer
- wait for sync
- read a byte (now we are jittering 2 cycles)
- check if this is a sector header, if not repeat
- if yes read the header, check if it is sector 0, if not repeat.
- at this point the jittering is still 2 cycles
- read the timer

rpm3.prg works like this:

- (first a test track is written, containing one long sync and 6 $5a bytes)
- wait for sync
- read a byte (now we are jittering 2 cycles)
- reset the timer
- read 5 more bytes (after that we are again jittering 2 cycles)
- read the timer

so ultimatively, BVC * syncs to the disk (with two cycles jitter) two times in 
both cases. what happens in between doesnt actually matter, since the timer is 
free running. both measure the time for one revolution, both jitter pretty much 
the same way.

rpm1.prg is a special case that uses the same technique as rpm2.prg. it reads 
all sector headers on a track and adds up the deltas. provided we dont miss a 
sector header for some reason, this does infact provide the same jitter, since 
again at sector 0 the timer will get resetted, and only checked after each 
header. reading each sector header and using the delta times provides no 
advantage, its only overengineered unnecessary bolloks that can be omitted - 
but doesnt it affect the jitter either.

--------------------------------------------------------------------------------

Does the disk speed matter? - no, it doesnt. the answer is simple: the angular 
position of the referenced "markers" does not change, and their relative 
distance stays the same, and thats all that matters to the code.

If we are writing a reference track, how much will that affect the accuracy of 
the following measurement? - it does not, because of the same reason as above,
all we need is to start and read the timer at the same angular position.

Will using a certain speedzone make it more or less accurate? - probably this
will result in a negliable difference (less than one CPU cycle).

--------------------------------------------------------------------------------
Conclusion:
--------------------------------------------------------------------------------

The standard deviation of the measurement on the drive is 15ppm or 0,0015%, 
ie 0,0045RPM for the observed 3 cycles jitter total - for all those methods.

We could, in theory, increase the accuracy/remove the jitter further by reading 
more bytes and adding a BVS *+2 half-variance cascade.

Now, until now we completely ignored another source of error - the oscillator
frequency (CPU clock). Unfortunately it is not easy to dig up actual data on 
the oscillators used in the 1541 drives, what is known until now is:

TOYOCOM TCO-745A 16.000Mhz  (+/- 50ppm according to the Datasheet)

(get in touch if you can add more info/datasheets)

Assuming 50ppm, the oscillator deviation can be taken as +/- 10 cycles per 
revolution, or ~ +/- 0.015 RPM, ie ~6 times as much as the supposed 3 cycles 
jitter of the measurement on the drive.

That means that - unless we provide a way to let the user enter the oscillator
frequency (which he would have to measure with a frequency counter) - the
actual deviation of the measurement would be somewhere in between 10 and 15
cycles, ie ~0,02RPM.

1541FreqDeviation.png is a diagram showing the oscillator clock over time 
(deviation from 16Mhz on Y, seconds on X) after powerup of a cold drive.

The measurement was made using a Hameg 8122 Frequency counter (without Option 
HO85)after around an hour of warmup before the measurement.
