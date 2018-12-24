
this directory contains tests to verify and examine how the RDY line (DMA)
affects the ANE #imm opcode.

in general it appears the timing of the side effects are stable, but the values
are not.

--------------------------------------------------------------------------------

ane.prg:

test ane #imm for side effects connected with the RDY line. 

for some combinations of A and IMM bit0 (?) will drop off (turn 0?) when the RDY
line changes state at the beginning of badline DMA (?)

interesting values will appear in the pattern where marked with dark(er) grey

ane-border.prg:

runs the same test in border with sprites, demonstrates the side effects are
there also.

interesting values will appear in the pattern where marked with dark(er) grey

ane-none.prg:

runs the same test in border with no sprites to show there are no more side 
effects.

--------------------------------------------------------------------------------

ane.prg and ane-border.prg are verified on my c64c (gpz)

ane.prg and ane-border.prg do NOT work as expected in VICE (r35876)

