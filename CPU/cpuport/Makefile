
.SILENT:

all:
	cl65 --asm-define SCANCPU0 --asm-define SCANSPD=3 -o bitfade.prg bitfade.s
	cl65 -o test1.prg test1.s
	cl65 --asm-define SCANSPD=0 -o delaytime.prg delaytime.s
	rm -f *.o

clean:
	rm -f *~
	rm -f *.prg
	rm -f *.o
