
This directory contains test code for the NEOS mouse. Unless otherwise noted,
all programs use port 1.

neosmouse.prg:
neosmouse-port2.prg:
- code extracted from the original "mouse cheese" drawing program. use this as
  a reference for own programs.

arkanoid.prg:
- code extracted from arkanoid - this code is kindof broken and only works by
  chance. its a good test for emulation attempts, since it relies on correct
  timeout handling.

  this code allows to move only vertically!

krakout.prg:
- code extracted from a krakout crack. the original code is broken, it did not
  initialize DDR.

  also note that this code does NOT allow the move to move horizontally!

krakoutbug.prg
- test to expose an actual VICE bug triggered by that krakout crack. The mouse
  was not polled when POTs were never read, so the mouse could not move.

  the bug exists, if the character at the top left of the screen does not change
  when the mouse is being moved.

