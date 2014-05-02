
waveforms-6581.prg, waveforms-8580.prg:

this program first stops the oscillator by setting the test bit, and then starts
it again with the choosen waveform. the output is sampled and then compared
against recorded reference data.

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

illegal combinations with noise (all not audible/zero output)

j       9       noise + triangle (*1)
k       a       noise + saw
l       b       noise + triangle + saw
m       c       noise + pulse
n       d       noise + triangle + pulse
o       e       noise + saw + pulse
p       f       noise + triangle + saw + pulse

 (*1) seems to produce some semi random output once(?)

ref6581.prg comes from my C64 with 6581 (gpz)
ref8580.prg comes from my C64C with 8580 (gpz)

note: test I (waveform 8) will always fail, since the noise generator is free
      running
      test J (waveform 9) will likely fail on first (automatic) run, the exact
      reason for this is not exactly clear yet.

--------------------------------------------------------------------------------
TODO:
- ringmod test
- sync test
- envelope test
- pulse width test
- envelope test