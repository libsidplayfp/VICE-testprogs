
These programs try to determine the decay timing of the floating bus. They are
ment to be run on a 256k REU (which is really a 512k REU with half the RAM
missing)

CAUTION: some of the observed results may rely on the REU RAM powerup pattern,
so always run them after a powercycle. (see further down)

floating.prg:

writes 0 to invalid RAM location, and then reads back that location

-> reads 0s on real REU

floating-a.prg:

before reading from floating bus, read from valid RAM once

-> reads 0s on real REU

floating-b.prg:

before reading from floating bus, write to valid RAM once

-> reads the value written to valid RAM before

floating2.prg:

measures the time until the value decays to $ff with CIA timers, value to the
top left is the first timer, the value next to it the cascaded second timer.

-> never stops on real REU

floating3a.prg:

writes a 0 to floating bus, then waits a while and then reads the value back and
checks if its still 0. uses binsearching to figure out the actual delay

-> reads only 0s on real hardware

floating3b.prg:

like floating3a.prg but uses two cascaded timers and a much longer initial delay

-> reads only 0s on real hardware

floating4a.prg:

writes 0 to floating bus, then does X valid reads, and reads back the floating
value

-> reads all $ff on real hardware (depends on non initialized RAM)

floating4b.prg:

like floating4a.prg, but does valid reads from increasing bank numbers

-> reads a 2*$ff,6*$00 pattern on real hardware (depends on non initialized RAM)

floating4c.prg:

like floating4a.prg, but initializes the RAM we do the valid reads from

-> reads all $78 on real hardware

floating4d.prg:

like floating4b.prg, but initializes the RAM we do the valid reads from

-> reads a $78,$79,$7a,$7b,$7b,$7b,$7b,$7b pattern on real hardware

===============================================================================

The following tries to describe the behaviour that was observed.
WARNING: this is pure guesswork based on the existing testprograms!

There appears to be a latch that drives the (data)bus from/to the RAM on the
REU. When reading from invalid RAM locations (non populated sockets) nothing
drives the bus, and the returned value is whatever was latched before.

- When transferring from C64 to REU, the last value written will stay in the
  latch.

- When transferring from REU to C64 apparently the REC prefetches the next value
  it would read on the next transfer. If this comes from a valid RAM address,
  then the RAM drives the latch and the value stays in it.

