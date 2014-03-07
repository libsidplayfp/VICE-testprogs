all: scanner.prg

scanner.prg: main.asm
	acme main.asm

test: scanner.prg
	x64sc -truedrive -autostartprgmode 2 scanner.prg
 
clean:
	rm -f *~
	rm -f scanner.prg