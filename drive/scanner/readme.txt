
scan35.d64, scan40.d64, scan42.d64
scan35.g64, scan40.g64, scan42.g64

scans all tracks and checks if the expected sector data can be read.

scan35err.d64, scan40err.d64, scan42err.d64

the same scanner, but with disk errors in the error map of the D64. some older
original games used this for protection, for example: space taxi, platoon (pal), 
typhoon (pal), combat school (pal)

scan35.d71, scan35err.d71, scan35.g71

like the above, but scans 70 tracks (35 per side) on a 1571

FIXME: the 1571 tests fail randomly for some reason

TODO:
- run tests from .p64 too
- on 1571 we can not read tracks > 35 using jobcodes, for this another test that
  reads directly from disk must be made
