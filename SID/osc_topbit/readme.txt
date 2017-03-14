In the 8580, the oscillator topbit is buffered by a flipflop before it enters 
the sawtooth switch in the waveform selector.

On the 6581 instead the connection is direct so if the line is pulled low by 
combined waveforms a zero will enter the oscillator adder MSB in the next cycle 
causing the topbit to go low.

NOTE: a new sampling of the PS waveform for the 6581 might be required, as the 
current one has the topbit going down in the second half. It must either have 
been sampled with a non-zero pulse width value or there are acutally some chips 
that do not exhibit this behavior. 
