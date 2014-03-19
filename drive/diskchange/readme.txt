
In this directory we collect some tests related to changing disks (and -images).
In many loaders this is buggy business, so we need to put some extra care on
somehow simulating things in a plausible, yet mostly conveniently fast and
most compatible way.

--------------------------------------------------------------------------------

pollwp.prg:

polls the write protect sensor on the drive, and measures the time between state 
transitions. the output should look similar to this:

removing (non write protected) disk:

write-protect is off 03c5b6f0   <- disk in drive (non write protected)
write-protect is on  0008df27   <- pulling disk out of drive
write-protect is off            <- no disk in drive

note: in reality its kind of hard to pull the disk out in less than $00020000 
      ticks, and it is probably reasonable to use a larger delay in emulation

inserting (non write protected) disk:

write-protect is off 06891ee4   <- no disk in drive
write-protect is on  001b177a   <- putting disk into drive
write-protect is off            <- disk in drive

note: in reality its kind of hard to push the disk in in less than $00020000 
      ticks, and it is probably reasonable to use a larger delay in emulation

removing (write protected) disk:

write-protect is on  03c5b6f0   <- disk in drive (write protected)
write-protect is off            <- no disk in drive

inserting (write protected) disk:

write-protect is off 06891ee4   <- no disk in drive
write-protect is on             <- disk in drive (write protected)

a disk change should generate two transitions, as in this example:

write-protect is off 00483c9b   <- disk in drive (non write protected)
write-protect is on  0008df30   <- pulling disk out of drive
write-protect is off 00091241   <- no disk in drive
write-protect is on  0008db7d   <- putting disk into drive
write-protect is off            <- disk in drive (non write protected)

--------------------------------------------------------------------------------
