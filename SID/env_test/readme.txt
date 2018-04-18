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

Left side of screen shows measured behaviour, right is expected.  

Errors in red, correct values in green, 
