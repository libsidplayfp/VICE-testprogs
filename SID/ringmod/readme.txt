The following expression represents the input of the triangle XOR logic, when 
TriXOR is true the oscillator bits are inverted forming the descending ramp of 
the triangle.

TriXOR = !Saw & ((!V3 & Ring) ^ bit23)

where
- Saw is the sawtooth bit from the control register;
- Ring is the ring modulator bit from the control register;
- bit23 is the top bit of the current voice oscillator;
- V3 is the 23rd bit of the ring modulating voice's oscillator.

Therefore when ring mod is active the MSB is substituted with MSB EOR NOT 
sync_source MSB. 

This test program sets the frequency for voices 2 and 3 at zero and starts a 
ring modulated triangle for voice 3. The output of OSC3 should be $ff as if we 
substitute in the above expression Saw=0, Ring=1, V3=0 and bit23=0 the result is 
1 and thus the bits must come out inverted.
