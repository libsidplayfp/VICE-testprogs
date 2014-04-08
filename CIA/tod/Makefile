

all: alarm.prg alarm-cond.prg alarm-cond2.prg hour-test.prg stability.prg stability-ntsc.prg

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

hour-test.prg: hour-test.bas
	petcat -w2 -o hour-test.prg -- hour-test.bas