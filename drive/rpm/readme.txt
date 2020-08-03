
this directory collects programs that measure the drives spindle motor speed in
RPM.

the result should be somewhere around 300rpm, +/- 1% (297-303)

--------------------------------------------------------------------------------
rpm1.prg:
- measures directly on the drive using VIA timers. each value represents the
  number of cycles between a sector header and the next sector header, which
  adds up to the total time for one rotation

rpm2.prg:
- is a variant of rpm1.prg which lets the timer free running for one revolution
  and relies on the wraparound, so we can measure the time for one revolution
  indirectly. this is slightly more accurate.
