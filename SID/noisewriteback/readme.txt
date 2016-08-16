
noisewriteback.prg: noise register write back test

related to https://sourceforge.net/p/vice-emu/bugs/746/

"When the noise waveform is combined with others the waveform selector output is
 written back to the noise generator register causing the infamous lockup,
 the current implementation however seems flawed as shown by nata's test [1].
 If you play the example sid, which alternates between $D and $8 waveforms, you
 notice that the noise component disappears too quickly compared to the real sid."

"My rough guess is that the write to the register only happens during LFSR
 clocking. I had a look at the vectorized IC and I see that the output of each
 bit, which gets connected to the output of the other waveforms when combined
 waveforms are selected, is also the input for the next bit when the shift
 register is clocked so likely the write back happens during the shifting phase."

[1] original D1_+_81_wave_test.sid by Nata

So, to summarize this is what happens when the lfsr is clocked:

* cycle 0: bit 19 of the accumulator goes from low to high, the noise register 
           acts normally, the output may overwrite a bit;

* cycle 1: first phase of the shift, the bits are interconnected and the output 
           of each bit is latched into the following. The output may overwrite 
           the latched value.

* cycle 2: second phase of the shift, the latched value becomes active in the 
           first half of the clock and from the second half the register returns 
           to normal operation.

When the test or reset lines are active the first phase is executed at every 
cyle until the signal is released triggering the second phase.
