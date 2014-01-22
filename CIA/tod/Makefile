

all: alarm.prg hour-test.prg

alarm.prg: alarm.s
	acme -o alarm.prg alarm.s

hour-test.prg: hour-test.bas
	petcat -w2 -o hour-test.prg -- hour-test.bas