
this directory collects programs that measure the drives spindle motor speed in
RPM.

the result should be somewhere around 300rpm, +/- 1% (297-303)

--------------------------------------------------------------------------------
rpm1.prg:
- measures directly on the drive using VIA timers. each value represents the
  number of cycles between a sector header and the next sector header, which
  adds up to the total time for one rotation
