This directory contains some programs to check memory mapping for various
cartridges.

16kgame.crt
- shows memory maps in 16k game mode and all 8 bitcombinations in $01

romram.crt
- rom banks must be switched immediatly, a value fetched in the next cycle must
  come from the new bank

writeram.crt
- a value written to $8000-$bfff always goes to C64 memory aswell

rr-reu.crt
- checks if retro replay and reu work at the same time

  x64 +cart -cartcrt rr-reu.crt -reu -reusize 512

exos.prg
- test mapping with external kernal

mmcr-64krom.crt, mmcrplugin.prg, mmcr.prg
- show memory setup for MMCR
