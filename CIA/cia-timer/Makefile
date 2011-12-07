
all: cia-timer-oldcias.prg cia-timer-newcias.prg

cia-timer-oldcias.prg: cia-timer.asm
	dasm cia-timer.asm -DDUMP=0 -ocia-timer-oldcias.prg
	
cia-timer-newcias.prg: cia-timer.asm
	dasm cia-timer.asm -DDUMP=1 -ocia-timer-newcias.prg
	
clean:
	rm -f *~
	rm -f cia-timer-oldcias.prg
	rm -f cia-timer-newcias.prg
