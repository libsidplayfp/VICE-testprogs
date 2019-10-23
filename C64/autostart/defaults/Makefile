
all: test.crt test.sid test.prg test.d64

test.d64: test.prg
	c1541 -format "test,00" d64 test.d64 -write test.prg test
test.prg: prgtest.s test.s refio.s refmem.s
	acme -f cbm -o test.prg -DCRTMODE=0 prgtest.s
test.crt: crttest.s test.s refioreset.s refmemreset.s
	acme -f plain -o test.crt -DCRTMODE=1 crttest.s
test.sid: sidtest.s test.s refio.s refmem.s
	acme -f plain -o test.sid -DCRTMODE=0 sidtest.s
	
testd64: test.d64
	x64sc -8 test.d64 -keybuf 'Lo"TEST",8,1\0dRu\0d'
testprg: test.prg
	x64sc test.prg
testcrt: test.crt
	x64sc -cartcrt test.crt
testsid: test.sid
	vsid test.sid
	
clean:
	rm -f *~
	rm -f *.o
	rm -f *.prg
	rm -f *.sid
	rm -f *.d64
	rm -f *.crt
	
