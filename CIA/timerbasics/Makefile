
all: test.prg timer.prg timer_test1.prg

timer.prg: timer.s
	acme timer.s

timer_test1.prg: timer_test1.s
	acme timer_test1.s

test.prg: test.s
	acme test.s

clean:
	-rm *~