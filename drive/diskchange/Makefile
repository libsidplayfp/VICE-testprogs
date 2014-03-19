all: pollwp.prg

pollwp.prg: pollwp.asm
	acme pollwp.asm

test: pollwp.prg
	x64sc -truedrive -autostartprgmode 2 pollwp.prg
 
clean:
	rm -f *~
	rm -f pollwp.prg