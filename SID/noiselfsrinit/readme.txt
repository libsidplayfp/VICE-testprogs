
related to https://sourceforge.net/p/vice-emu/bugs/1920/

simple.asm:

Inits the LFSR to a specific value, then runs the oscillator and stops it at a
specific hard coded phase accu value and then samples and prints the output from
the noise waveform.

Hold down space to repeat the process.

Printed value every time with real 8580 SIDs:
7F


File scan.asm:

Same process as in simple.asm but repeats the process automatically and stores
the output from the noise waveform to memory for every $1000th phase accu value
(skipping some in the beginning) for approx one half period.

Values in memory with real 8580 SIDs:
$2000-$2061: $3F
$2062-$2261: $7F
$2262-$2561: $ff
$2562-$2761: $fe
$2762-$27ef: $fc


These routines has been tested on at least 10 real 8580 SID chips and the result
on all of them are consistent.
