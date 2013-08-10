
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

the delayXXXX.prg tests work the same, but measure the delay using a CIA timer
and display the result.

results from real C64:

(new SID) (250469/8580R5) (250469/8580R5)

delayosc3     00019          00019
delayenv3     00019          00019
delayfrq0    ~7a000        ~108000

(old SID) (250407/6581)

delayosc3     00019
delayenv3     00019
delayfrq0    ~01d00
