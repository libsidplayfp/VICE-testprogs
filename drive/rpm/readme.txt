
This directory collects programs that measure the drives spindle motor speed in
RPM.

The result should be somewhere around 300rpm, +/- 1% (297-303)

All programs show on screen:

- the number of cycles measured for one revolution (~200000)
- calculated RPM (highest precision, not rounded)
- calculated RPM (rounded to two decimals)

--------------------------------------------------------------------------------

The RPM can be adjusted with a potentiometer in the drive. In the 1541 (old)
this can be reached on the bottom side of the drive mech. In the 1541-II it can
be found on the motor control board on the top/left of the drive mech. it's a
small quadratic, usually blue, potentiometer. turn carefully and without force.

On a 1541 the limits that can be reached are ~266 and ~336 RPM.

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

rpm1plot.prg:
rpm2plot.prg:
rpm3plot.prg:
- These use the same drivecode for measuring the RPM, but instead of showing the
  raw values they will display a long term plot that shows how the speed changes
  over time (the so called "wobble").
  At startup, the program(s) will measure a couple revolutions and compute the
  average, so it can center the plot on screen. Then it will start to plot one
  dot per revolution, number of revolutions on the Y axis of the screen. The X 
  axis shows the time for each revolution. When the program(s) start, the timer
  value will be divided by 8. You can change the divisor by using the function-
  keys (F7: 8, F5: 4, F3: 2, F1: 0).

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

--------------------------------------------------------------------------------

Measurements:
-------------

(get in touch if you can provide more measurements)

by Unseen:

 1541FreqDeviation.png is a diagram showing the oscillator clock over time 
 (deviation from 16Mhz on Y, seconds on X) after powerup of a cold drive.

 The measurement was made using a Hameg 8122 Frequency counter (without Option 
 HO85)after around an hour of warmup before the measurement.

by Ready.:

 Measured Crystal reads: "DOC-20NA / 16000.00KHZ / KDS-4K"

 The test lasted about 2h and 30 mins, during which the electronics were covered 
 to simulate the presence of the top of the chassis. The maximum temperature 
 reached by the quartz was about 45c if covered and about 39 if uncovered.

 The hardware frequency counter feature of a Rigol DS1054Z oscilloscope was used 
 to measure the frequency. Accuracy for this measurement should be less than 
 10ppm.

 For the whole duration of the test a frequency value oscillating between 16.000 
 and 16.0001 mhz was detected. No values higher or lower than these.


Deviation in practice:
----------------------

In practise the deviation of the crystal will most likely be (much) less than
what the manufacturer guarantees in the specification (datasheet). We have to
be careful though with interpreting too much into a small number of 
measurements, the statistical relevance is almost non existant right now :)

However, if we'd assume our measurements are actually a good representation of
the reality, we could assume the following:

In the worst case we observe a drift of 100hz, therefore 1/8 of the theoretical
one found in the datasheet, ie 50/8 = 6.25ppm.

Making a few calculations, just to relate ppm to rpm, we get:

6.25 / 5 = 1.25 (ppm / (1mhz / hz per revolution)) = deviation per revolution
1.25 / 200,000 = 0.00000625
300 * 0.00000625 = 0.001875 RPM max deviation due to the quartz drift
