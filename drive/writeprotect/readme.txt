this test program simply writes (garbage) to track 18 - since it does that
without using the drive ROM, it will not error out when the write protect sensor
is "open" (ie the disk is write protected). this can be used to check if the
disk drives write protection is implemented correctly, writing should be not
possible at all even when ignoring the state of the sensor.

