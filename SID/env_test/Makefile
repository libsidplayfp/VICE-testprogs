
all: env_test_ra_0000.prg env_test_ra_0100.prg

%.prg: %.s common.s common.inc
	cl65 -C c64-asm.cfg -u __EXEHDR__ -t c64 --cpu 6502X -o $@ common.s $<
clean:
	rm -f *.o *.prg
