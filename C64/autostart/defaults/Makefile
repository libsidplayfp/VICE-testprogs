
all:
	acme test.s
	c1541 -format "test,00" d64 test.d64 -write test.prg test

testd64:
	x64sc -8 test.d64 -keybuf 'Lo"TEST",8,1\0dRu\0d'
	
clean:
	rm -f *~
	rm -f *.o
	rm -f *.prg
	