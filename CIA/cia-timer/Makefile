
all: cia-timer-oldcias.prg cia-timer-newcias.prg cia-timer-alt-oldcias.prg cia-timer-alt-newcias.prg

cia-timer-oldcias.prg: cia-timer.asm dump-oldcia.bin
	dasm cia-timer.asm -DDUMP=0 -DSHOWREF=1 -ocia-timer-oldcias.prg

cia-timer-newcias.prg: cia-timer.asm dump-newcia.bin
	dasm cia-timer.asm -DDUMP=1 -DSHOWREF=1 -ocia-timer-newcias.prg

cia-timer-alt-oldcias.prg: cia-timer.asm dump-oldcia.bin
	dasm cia-timer.asm -DDUMP=0 -DSHOWREF=0 -ocia-timer-alt-oldcias.prg

cia-timer-alt-newcias.prg: cia-timer.asm dump-newcia.bin
	dasm cia-timer.asm -DDUMP=1 -DSHOWREF=0 -ocia-timer-alt-newcias.prg

clean:
	$(RM) *~
	$(RM) cia-timer-oldcias.prg
	$(RM) cia-timer-newcias.prg
	$(RM) cia-timer-alt-oldcias.prg
	$(RM) cia-timer-alt-newcias.prg
