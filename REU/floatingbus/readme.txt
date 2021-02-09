
These programs try to determine the decay timing of the floating bus. They are
ment to be run on a 256k REU (which is really a 512k REU with half the RAM
missing)

floating.prg:

expected result is a bunch of 0s at the top, then values fading to $ff and the
rest all $ff

floating2.prg:

measures the time until the value decays to $ff with CIA timers, value to the
top left is the first timer, the value next to it the cascaded second timer.
