
These programs try to determine the decay timing of the floating bus. They are
ment to be run on a 256k REU (which is really a 512k REU with half the RAM
missing)

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

floating3a.prg:

writes a 0 to floating bus, then waits a while and then reads the value back and
checks if its still 0. uses binsearching to figure out the actual delay

floating3b.prg:

like floating3a.prg but uses two cascaded timers and a much longer initial delay
