
all: bugtest.prg

bugtest.prg: bugtest.s
	cl65 -t c64 -C c64-asm.cfg -u __EXEHDR__ -o bugtest.prg bugtest.s
# OK: only vdrive
test1: bugtest.prg
	x64sc -default -virtualdev8 -iecdevice8 -device8 1 +drive8truedrive bugtest.prg
# FAIL: vdrive and TDE enabled at the same time!
test2: bugtest.prg
	x64sc -default -virtualdev8 -iecdevice8 -device8 1 -drive8truedrive bugtest.prg

clean:
	$(RM) bugtest.prg
