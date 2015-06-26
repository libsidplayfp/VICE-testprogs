all: defaults.prg defaults.d64

defaults.prg: main.asm
	acme -f cbm -o defaults.prg main.asm

test: defaults.prg
	x64sc -truedrive -autostartprgmode 2 defaults.prg

defaults.d64: defaults.prg
	c1541 -format "defaults,00" d64 defaults.d64 \
		-write defaults.prg "defaults"

clean:
	rm -f *~
	rm -f defaults.prg
	rm -f defaults.d64