
all: test.crt test.sid test.prg test.d64

test.d64: test.prg
	c1541 -format "test,00" d64 test.d64 -write test.prg test
test.prg: prgtest.s test.s refio.s refmem.s
	acme prgtest.s
test.crt: crttest.s test.s refioreset.s refmemreset.s
	acme crttest.s
test.sid: sidtest.s test.s refio.s refmem.s
	acme sidtest.s
	
testd64: test.d64
	x64sc -8 test.d64 -keybuf 'Lo"TEST",8,1\0dRu\0d'
#	x64 test.d64
testprg: test.prg
	x64sc test.prg
#	x64 test.prg
testcrt: test.crt
	x64sc -cartcrt test.crt
#	x64 -cartcrt test.crt
testsid: test.sid
	vsid test.sid
	
clean:
	rm -f *~
	rm -f *.o
	rm -f *.prg
	rm -f *.sid
	rm -f *.d64
	rm -f *.crt
	