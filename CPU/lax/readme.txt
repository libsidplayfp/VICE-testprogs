
this directory contains tests to verify and examine how the RDY line (DMA)
affects the LAX #imm opcode.

in general it appears the timing of the side effects are stable, but the values
are not.

LAX #imm
--------

A = X = ((A | CONST) & IMM)

with N = IMM we get: A = X = (A | ?) & N

A       N           !A   N    
0 | ? & 0 = 0        1 & 0 = 0
1 | ? & 0 = 0        0 & 0 = 0
0 | ? & 1 = ?        1 & 1 = 1
1 | ? & 1 = 1        0 & 1 = 0

so when a bit in A is 0 and in N is 1, the result is unknown/unstable

((A ^ 0xff) & N) returns the affected unstable bits, ie operation is unstable 
if ((A ^ 0xff) & N) != 0

--------------------------------------------------------------------------------

lax.prg:

test lax #imm for side effects connected with the RDY line. 

for some combinations of A and IMM bit0 and/or bit4 (?) will drop off (turn 0?) 
when the RDY line changes state at the beginning of badline DMA (?)

interesting values will appear in the pattern where marked with dark(er) grey

lax-border.prg:

runs the same test in border with sprites, demonstrates the side effects are
there also.

interesting values will appear in the pattern where marked with dark(er) grey

lax-none.prg:

runs the same test in border with no sprites to show there are no more side 
effects.

--------------------------------------------------------------------------------

lax.prg and lax-border.prg are verified on my c64c (gpz)

the values after rA: and rX: in the bottom line should always be green (it will 
be green when all stable bits match what we expect them to be)

--------------------------------------------------------------------------------

WANTED: examples of real world usage of this opcode, especially when its used
in a way that the instable bits matter (not the common LAX #0).
