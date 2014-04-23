this directory contains some CPU (6502) related tests originally
written by Poitr Fusik for "ASAP - Another Slight Atari Player"

taken from: https://sourceforge.net/p/asap/code/ci/master/tree/ 


the tests have been converted to ACME syntax and made to run on C-64

note: some tests had to be fixed to actually work properly (ane/anx)

--------------------------------------------------------------------------------

cpu_ane.prg:

tests opcode $8b (ANE #imm)     (unstable if imm != 0, unstable constant)

TODO: find C64 where constant is stable... (unstable on mine /gpz)


cpu_anx.prg:

tests opcode $ab (LAX #imm)     (unstable if imm != 0, unstable constant)


cpu_las.prg:

tests opcode $bb (LAS abs,y)


cpu_shx.prg:

tests opcode $9c (SHY abs,x) and $9e (SHX abs,y) (unstable under some conditions)


cpu_decimal:

tests decimal mode (and tests opcode $6b (ARR #imm))
