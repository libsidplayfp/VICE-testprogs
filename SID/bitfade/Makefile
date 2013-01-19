
.SILENT:

all:
	cl65 --asm-define SCANOSC3 --asm-define SCANSPD=3 -o test1osc3.prg test1.s
	cl65 --asm-define SCANENV3 --asm-define SCANSPD=3 -o test1env3.prg test1.s
	cl65 --asm-define SCANFRQ0 --asm-define SCANSPD=3 -o test1frq0.prg test1.s
	cl65 --asm-define SCANOSC3 --asm-define SCANSPD=0 -o delayosc3.prg delaytime.s
	cl65 --asm-define SCANENV3 --asm-define SCANSPD=0 -o delayenv3.prg delaytime.s
	cl65 --asm-define SCANFRQ0 --asm-define SCANSPD=0 -o delayfrq0.prg delaytime.s
	rm -f *.o

clean:
	rm -f *~
	rm -f *.prg
	rm -f *.o
