

all: alarm.prg hour-test.prg stability.prg

alarm.prg: alarm.s
	acme -o alarm.prg alarm.s

stability.prg: stability.s
	acme -o stability.prg stability.s

hour-test.prg: hour-test.bas
	petcat -w2 -o hour-test.prg -- hour-test.bas