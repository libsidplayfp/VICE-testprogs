
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
