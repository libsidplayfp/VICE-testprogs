Enclosed are a couple of unit tests for SID envelope timing, 

one for when ADSR is 0000 at start of note, 
and the other when ADSR is 0100 (the latter to catch the 'single cycle at decay 
rate' behaviour).  Each syncs the CPU to a known internal SID state by 

- performing a hard restart
- triggering a note with ADSR = 0000
- waiting for ENV3 to increment
- summing ENV3 at four cycle intervals for 9 samples and clearing gate
- waiting $1b-{total} cycles.

It then plots the results of waiting M cycles, triggering a new note, and 
reading ENV3 at 4-15 cycles after gate is triggered, and the results plotted to 
a column of characters onscreen.

M loops from 15 down to 0, plotting one column per test.


The following programs are all based on env_test_ra_0000.prg:
 
env_test_ar_1.prg: Test release during attack
env_test_ar_2.prg: Test release around ENV3 =$FF
env_test_ar_3.prg: Test release during decay
env_test_adra_1.prg: Attack during release (exponential period > 1)
env_test_adra_2.prg: Attack during release (exponential period == 1)

env_test_adra_2 reveals strange behaviour where attack either gets accepted
or is ignored or causes the volume to stay the same for the current rate
counter period.

Left side of screen shows measured behaviour, right is expected.  

Errors in red, correct values in green, 


Pass on real C64C with 8580 and Hoxs64 1.0.10.0 (David Horrocks)
Pass on real C64 with 6581 (groepaz)
