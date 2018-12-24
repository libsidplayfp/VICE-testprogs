
this directory contains tests to verify and examine how the RDY line (DMA)
affects the LAX #imm opcode.

in general it appears the timing of the side effects are stable, but the values
are not.

--------------------------------------------------------------------------------

lax.prg:

test lax #imm for side effects connected with the RDY line. 

for some combinations of A and IMM bit0 (?) will drop off (turn 0?) when the RDY
line changes state at the beginning of badline DMA (?)

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

lax.prg and lax-border.prg do NOT work as expected in VICE (r35876)

