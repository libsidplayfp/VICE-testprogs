all: selftest.prg

selftest.prg: main.asm
	acme main.asm

test: selftest.prg
	x64sc -truedrive -autostartprgmode 2 selftest.prg
 
clean:
	rm -f *~
	rm -f selftest.prg