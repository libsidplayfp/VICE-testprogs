** NTSC VIC-20 field cycle scanner

written by Michael Kircher, adapted for the testbench by groepaz

analyze.prg - extracts raster numbers and cycle count from pairs of "900x *" scan files
analyze.c - c version of the above

test9004nolace.prg - creates "9004-nolace" scan
test9003nolace.prg - creates "9003-nolace" scan
test9004top.prg - creates "9004lacetop" scan
test9003top.prg - creates "9003lacetop" scan
test9004bot.prg - creates "9004lacebot" scan
test9003bot.prg - creates "9003lacebot" scan

test.d64 contains all of the above (for running on real vic20)

./scans contains reference scans provided by Torsten Kracke

./results/lacebot.txt - analysed interlaced bottom field
./results/lacetop.txt - analysed interlaced top field
./results/nolace.txt - analysed non-interlaced field

./timing_2021-08-15.xlsx - design of main scan loop

use "make test" to run all test on xvic and compare the results against he
reference data


Note: the first and last lines of the result files
      start resp. end their scan somewhere in the middle
      of a raster (thus disregard their counts!),
      but still at a _cycle exact_ synced-to position!

- "nolace.txt" contains the cycle count of each raster in a complete field
  as defined by $9004/$9003, surrounded by a few rasters of the preceding
  and following field.

- "lacetop.txt" contain the cycle count of each raster in the interlaced
  top field as defined by $9004/$9003, surrounded by a few rasters of the
  preceding and following bottom field.

- "lacetop.txt" contain the cycle count of each raster in the interlaced
  bottom field as defined by $9004/$9003, surrounded by a few rasters of
  the preceding and following top field.


round up:

- Non-interlaced fields start with a partial raster 0 ($9003 = $2E, $9004 = $00) of 32 cycles,
  rasters 1 ($9003 = $AE, $9004 = $00) up to 260 ($9003 = $2E, $9004 = $82) are complete with 65 cycles each,
  the fields end with a partial raster 261 ($9003 = $AE, $9004 = $82) of 33 cycles.

- Interlaced top fields start with a partial raster 0 ($9003 = $2E, $9004 = $00) of 32 cycles,
  rasters 1 ($9003 = $AE, $9004 = $00) up to 262 ($9003 = $2E, $9004 = $83) are complete with 65 cycles each.

- Interlaced bottom fields start with a complete raster 0 ($9003 = $2E, $9004 = $00)
  up to complete raster 261 ($9003 = $AE, $9004 = $82) with 65 cycles each,
  they end with a partial raster 262 ($9003 = $2E, $9004 = $83) of 33 cycles.


in short:

- no-laced fields: line 0 with 32 cycles, lines 1..260 with 65 cycles, line 261 with 33 cycles.
  total number: 32+260x65+33 = _261x65_ cycles

- laced top field: line 0 with 32 cycles, lines 1..262 with 65 cycles

- laced bottom field: lines 0..261 with 65 cycles, line 262 with 33 cycles

- top + bottom field combined cycle count: 32+262x65 + 262x65+33 = _525x65_ cycles


Thanks to Torsten Kracke for providing reference scans on his NTSC VIC-20.

2021-08-16  Michael Kircher 
