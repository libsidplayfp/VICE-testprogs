all: timera.prg watchdog.prg

timera.prg: timera.asm
	acme timera.asm
watchdog.prg: watchdog.asm
	acme watchdog.asm

test:
#	x64sc -truedrive -autostartprgmode 2 timera.prg
	x64sc -truedrive -autostartprgmode 2 watchdog.prg
 
clean:
	rm -f *~
	rm -f timera.prg
	rm -f watchdog.prg
