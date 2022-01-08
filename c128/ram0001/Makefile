 

all: test1.prg test2.prg

test1.prg: test1.s stableraster_lightpen.s
	cl65 -t c128 -u __EXEHDR__ -o test1.prg test1.s stableraster_lightpen.s
	rm -f *.o

test2.prg: test2.asm
	acme -f cbm -o test2.prg test2.asm

clean:
	rm -f *~
	rm -f *.o
	rm -f test*.prg
