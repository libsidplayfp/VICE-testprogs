
TESTS=\
	alarm.prg alarm-cond.prg alarm-cond2.prg hour-test.prg stability.prg stability-ntsc.prg \
	4tod.prg 4todcia1.prg 5tod.prg 6tod.prg

all: $(TESTS)
	

alarm.prg: alarm.s
	acme -o alarm.prg alarm.s
alarm-cond.prg: alarm-cond.s
	acme -o alarm-cond.prg alarm-cond.s
alarm-cond2.prg: alarm-cond2.s
	acme -o alarm-cond2.prg alarm-cond2.s

stability.prg: stability.s
	acme -DSYNC=0 -o stability.prg stability.s
stability-ntsc.prg: stability.s
	acme -DSYNC=1 -o stability-ntsc.prg stability.s

4tod.prg: 4tod.asm
	64tass -a -o 4tod.prg 4tod.asm
4todcia1.prg: 4todcia1.asm
	64tass -a -o 4todcia1.prg 4todcia1.asm
5tod.prg: 5tod.asm
	64tass -a -o 5tod.prg 5tod.asm
6tod.prg: 6tod.asm
	64tass -a -o 6tod.prg 6tod.asm
	
hour-test.prg: hour-test.bas
	petcat -w2 -o hour-test.prg -- hour-test.bas