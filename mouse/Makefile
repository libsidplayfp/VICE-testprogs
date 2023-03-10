

all: mouse-c64-1351.prg mouse-c64-pot.prg mouse-c128-1351.prg mouse-c128-pot.prg

mouse-c64-1351.prg:  mousedemo.c c64-1351.mou
	co65 --code-label _mouse_driver c64-1351.mou
	ca65 c64-1351.s
	cl65 -o mouse-c64-1351.prg mousedemo.c c64-1351.o
	rm -rf c64-1351.s c64-1351.o mousedemo.o

mouse-c64-pot.prg:  mousedemo.c c64-pot.mou
	co65 --code-label _mouse_driver c64-pot.mou
	ca65 c64-pot.s
	cl65 -o mouse-c64-pot.prg mousedemo.c c64-pot.o
	rm -rf c64-pot.s c64-pot.o mousedemo.o

mouse-c128-1351.prg:  mousedemo.c c128-1351.mou
	co65 --code-label _mouse_driver c128-1351.mou
	ca65 -t c128  c128-1351.s
	cl65 -t c128  -o mouse-c128-1351.prg mousedemo.c c128-1351.o
	rm -rf c128-1351.s c128-1351.o mousedemo.o

mouse-c128-pot.prg:  mousedemo.c c128-pot.mou
	co65 --code-label _mouse_driver c128-pot.mou
	ca65 -t c128  c128-pot.s
	cl65 -t c128  -o mouse-c128-pot.prg mousedemo.c c128-pot.o
	rm -rf c128-pot.s c128-pot.o mousedemo.o

mousedemo.d64:
	
clean:
	rm -f *.o
	rm -f *~

zap: clean
	rm -f *.prg
