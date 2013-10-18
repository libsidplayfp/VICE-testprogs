This directory contains some programs to check memory mapping for various
cartridges.

romram.s
- rom banks must be switched immediatly, a value fetched in the next cycle must
  come from the new bank
  
writeram.s
- a value written to $8000-$bfff always goes to C64 memory aswell