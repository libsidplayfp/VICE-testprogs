RAMLink Hardware Tests for C64 and C128

Run as follows:

x64sc -debugcart -cartramlink ramlink2.bin -ramlinksize 0 -drive8type 0 -autostartprgmode 1 rlhw64.prg

x128 -debugcart -cartramlink ramlink2.bin -ramlinksize 0 -drive8type 0 -go64 -autostartprgmode 1 rlhw64.prg
x128 -debugcart -cartramlink ramlink2.bin -ramlinksize 0 -drive8type 0 -autostartprgmode 1 rlhw128.prg

The removal of drive 8 above is to speed up the tests.
