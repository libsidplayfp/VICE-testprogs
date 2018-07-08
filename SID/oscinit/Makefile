
all: oscinit.prg noiseinit.prg allinit.prg

oscinit.prg: osc_init_value.asm
	acme -f cbm -o oscinit.prg osc_init_value.asm
noiseinit.prg: noise_init_value.asm
	acme -f cbm -o noiseinit.prg noise_init_value.asm
allinit.prg: all_init_value.asm
	acme -f cbm -o allinit.prg all_init_value.asm

clean:
	rm -f oscinit.prg noiseinit.prg allinit.prg
