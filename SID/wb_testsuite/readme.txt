Here is a reworked writeback testsuite. It checks the writeback effect of 
switching from waveform X+testbit to waveform Y(where X and Y are all the 
combinations that include noise) after having reset the shift register.

I've included all the predictable combinations verified on a couple of chips 
(samplings included in the zip). Tests takes a while to run, especially on the 
8580 (~10 secs to reset the noise generator).

--------------------------------------------------------------------------------

The tests that fail on 3.3 are the following:

6581

9->C
A->C
D->C
D->E
E->C
F->C

8580

C->9
C->E
C->F 
