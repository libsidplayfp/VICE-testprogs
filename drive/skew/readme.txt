
This test measures the track skew of a mounted test disk.

Two cases are explicitly checked:

1) when the mounted disk is in d64 format, we expect the tracks being NOT
aligned, ie the emulator would internally do the equivalent of a DOS format

2) when the mounted disk is in g64 format, we expect the emulator to take the
disk layout as is. Due to how we create the file, using c1541, we expect the
tracks being aligned.

TODO: if we can somehow generate a g64 with non-aligned layout, then a 3rd test
for this could be made


That means two programs are generated:

skew1.prg - passes if kernal format, and tracks are NOT aligned (used for skew.d64)
skew2.prg - passes if kernal format, and tracks ARE aligned (used for skew.g64)
