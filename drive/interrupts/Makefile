all: timera.prg

timera.prg: timera.asm
	acme timera.asm

test: timera.prg
	x64sc -truedrive -autostartprgmode 2 timera.prg
 
clean:
	rm -f *~
	rm -f timera.prg