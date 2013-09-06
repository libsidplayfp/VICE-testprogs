

all: test1.prg test2.prg test3.prg test4.prg

test1.prg: dmadelay.s test1.s
	acme test1.s
test2.prg: dmadelay.s test2.s
	acme test2.s
test3.prg: dmadelay.s test3.s
	acme test3.s
test4.prg: test4.s
	acme test4.s

clean:
	rm -f *~
	rm -f test1.prg test2.prg test3.prg test4.prg