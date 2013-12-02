This directory contains some programs to check memory mapping for various
cartridges.

main-16kgame.s
- shows memory maps in 16k game mode and all 8 bitcombinations in $01

romram.s
- rom banks must be switched immediatly, a value fetched in the next cycle must
  come from the new bank
  
writeram.s
- a value written to $8000-$bfff always goes to C64 memory aswell