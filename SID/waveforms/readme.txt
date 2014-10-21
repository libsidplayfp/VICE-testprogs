
waveforms-6581.prg, waveforms-8580.prg:

this program first stops the oscillator by setting the test bit, and then starts
it again with the choosen waveform. the output is sampled and then compared
against recorded reference data.

ref6581.prg comes from my C64 with 6581 (gpz)
ref8580.prg comes from my C64C with 8580 (gpz)

key     wave

a       0       none (not audible/zero output)

b       1       triangle
c       2       saw
e       4       pulse
i       8       noise

legal combinations:

d       3       triangle + saw
f       5       triangle + pulse
g       6       saw + pulse (not audible/zero output on 6581)

h       7       triangle + saw + pulse (not audible/zero output on 6581)

note: combined waveforms may not exactly match the reference data, and may not
      be totally stable either. this is due to how they are combined on the chip
      (some weird analog effects)

illegal combinations with noise (all not audible/zero output)

j       9       noise + triangle
k       a       noise + saw
l       b       noise + triangle + saw
m       c       noise + pulse
n       d       noise + triangle + pulse
o       e       noise + saw + pulse
p       f       noise + triangle + saw + pulse

note: tests for waveforms 9-f will mostly fail. on 8580 it seems that the LFSR
      does not stop at all, on 6581 the results are still somewhat random due
      to how the combining of waveforms works


