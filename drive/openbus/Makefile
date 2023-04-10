all: openbus.prg

openbus.prg: main.asm
	acme main.asm

test: openbus.prg
	x64sc -truedrive -autostartprgmode 2 openbus.prg

clean:
	rm -f *~
	rm -f openbus.prg
