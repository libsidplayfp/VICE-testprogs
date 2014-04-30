
waveforms-6581.prg, waveforms-8580.prg:

this program first stops the oscillator by setting the test bit, and then starts
it again with the choosen waveform. the output is sampled and then compared
against recorded reference data.

key     wave

a       0       none

b       1       triangle
c       2       saw
e       4       pulse
i       8       noise

legal combinations:

d       3       triangle + saw
f       5       triangle + pulse
g       6       saw + pulse

h       7       triangle + saw + pulse  (very silent on 6581, if at all audible)

illegal combinations with noise, all not audible:

j       9       noise + triangle (*1)
k       a       noise + saw
l       b       noise + triangle + saw
m       c       noise + pulse
n       d       noise + triangle + pulse
o       e       noise + saw + pulse
p       f       noise + triangle + saw + pulse

 (*1) seems to produce some semi random output on my 8580

ref8580.prg comes from my C64C with 8580 (gpz)

TODO: get reference data from real 6581
