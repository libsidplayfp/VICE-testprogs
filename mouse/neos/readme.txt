
This directory contains test code for the NEOS mouse. both programs use port 1

neosmouse.prg:
- code extracted from the original "mouse cheese" drawing program. use this as
  a reference for own programs.
  
arkanoid.prg:
- code extracted from arkanoid - this code is kindof broken and only works by
  chance. its a good test for emulation attempts, since it relies on correct
  timeout handling.

krakout.prg:
- code extracted from a krakout crack. the original code is broken, it did not
  initialize DDR.

krakoutbug.prg
- test to expose an actual VICE bug triggered by that krakout crack. The mouse
  was not polled when POTs were never read, so the mouse could not move.
