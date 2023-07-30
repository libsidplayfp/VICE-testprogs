Lt. Kernal Hardware Tests for C64 and C128

You can use an active system to run these tests or one with a "blank" ROM.
The ROM should not contain all $00s or all $FFs. The one included here
contains all $80s.

Run as follows:

x64sc -debugcart -cartltk emptyrom -drive8type 0 -autostartprgmode 1 ltkhw64.prg

x128 -debugcart -cartltk emptyrom -drive8type 0 -go64 -autostartprgmode 1 ltkhw64.prg
x128 -debugcart -cartltk emptyrom -drive8type 0 -autostartprgmode 1 ltkhw128.prg

The removal of drive 8 above is to avoid issues with a running LTK DOS.
