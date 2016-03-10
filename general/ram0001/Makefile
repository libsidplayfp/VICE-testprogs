 

all: test1.prg

test1.prg: test1.s stableraster_lightpen.s
	cl65 -C c64-asm.cfg -u __EXEHDR__ -o test1.prg test1.s stableraster_lightpen.s
	rm -f *.o

clean:
	rm -f *~
	rm -f *.o
	rm -f test1.prg

