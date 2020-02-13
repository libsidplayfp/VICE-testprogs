
all: env_test_exr.prg

%.prg: %.s
	cl65 -C c64-asm.cfg -u __EXEHDR__ -t c64 --cpu 6502X -o $@ $<

clean:
	rm -f *.o *.prg
