
autostart tests
---------------


TODO: all tests should check d64/d82, t64, prg


----------------------------------------------------------------------------

./autostart-resources.sh

tests if some drive related resources are set up as expected at 3 distinct
points during autostart:

1) when entering the monitor
2) before LOAD (this is likely the same as 1))
3) before RUN

when "handle TDE during autostart" is enabled, the first two might be
different from the third (since TDE is automatically disabled during
autostart, in favour of traps)

(tests d64)

TODO: we should fix traps in IEEE machines, and bus device in xvic, to
get rid of the special cases for those

TODO: test t64 and prg

----------------------------------------------------------------------------

./autostart.sh

tests if:

a) autostart works in various combinations of settings

b) the drive config is as expected after the autostart completed

(tests d64, t64, prg with fsdrive/disk/inject)


----------------------------------------------------------------------------

./autostart-drivemem.sh

tests if:

a) the last two blocks of the loaded file can be read back from the drives
   internal buffer(s)

b) TODO: some zero page addresses are set up as expected

TODO: this test should run at least once on each type of drive

TODO: test d64/d82

(tests prg+copy to disk)

----------------------------------------------------------------------------

Brief description of the expected behaviour:

a) If "handle TDE at autostart" is _not_ enabled (which is the default):

generally no resources will be touched (and depending on the settings auto-
starting may fail), with the following exceptions:

When starting disk images:

- Drive(8..11)Type       to switch drive type depending on the image used
                         (happens before autostart and will NOT be reverted)

When starting tape images:

- TapePort(1..2)Device   to enable the Datasette or Tapecart if needed
                         (happens before autostart and will NOT be reverted)
- TrapDevice(1..2)       to enable the device traps for t64 files
                         (will be enabled before autostart, but will be dis-
                          abled again if not enabled in the settings)

- When starting prg files directly:

FileSystemDevice(8)
FSDevice(8)ConvertP00
FSDeviceLongNames


b) If "handle TDE at autostart" _is_ enabled, the autostart functions will
temporarily disable true drive emulation, and enable either TrapDevice or
BusDevice (depending on the Machine).

Drive(8..11)TrueEmulation
BusDevice(8..11)
TrapDevice(8..11)


TODO: check/complete the above description
