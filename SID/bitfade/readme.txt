
various "bitfade" tests, related to reading "unconnected" i/o, or read-only
registers respectivly.

test1osc3.prg / test1env3.prg - waveform 0 oscillator value

- plays one "8 bit sample" using the "new" method ("sid vicious"), which relies
  on the oscillator value bits slowly fading away when waveform 0 is selected.
  
  the osc3 test shows the bitfading of the oscillator value, the env3 test just
  (for completeness) shows that the envelope would also stay as is when waveform
  zero is selected.

test1frq0.prg - read only SID registers

- plays a simple note on voice 0, and reads back the (read only) frequency
  register. shows bitfading of read only registers

