Register writes are not delayed one cycle on the 8580, from circuit analysis the 
control logic looks identical on both chips.

As the OSC3 register is sampled in the first clock phase while the tri/saw 
output is latched on the second phase the delay will be noticed only on OSC3 
read, since we produce the waveform output when phi2 is high.

The following table shows that in the second half of the clock the saw output 
and the OSC3 register have different values:

phi2    acc saw osc3
low     yy  xx  xx
high    yy  yy  xx
low     zz  yy  yy
...

Ideally the emulation should be clocked at each half cycle producing a 2MHz
output.
