
all: env_test_ra_0000.prg \
    env_test_ra_0100.prg \
    env_test_ar_1.prg \
    env_test_ar_2.prg \
    env_test_ar_3.prg \
    env_test_adra_1.prg \
    env_test_adra_2.prg

%.prg: %.s common.s common.inc
	cl65 -C c64-asm.cfg -u __EXEHDR__ -t c64 --cpu 6502X -o $@ common.s $<
clean:
	rm -f *.o *.prg
