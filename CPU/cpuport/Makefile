
.SILENT:

all: initvalue.crt
	cl65 -C c64-asm.cfg -u __EXEHDR__ --asm-define SCANCPU0 --asm-define SCANSPD=3 -o bitfade.prg bitfade.s
	cl65 -C c64-asm.cfg -u __EXEHDR__ -o test1.prg test1.s
	cl65 -C c64-asm.cfg -u __EXEHDR__ --asm-define SCANSPD=0 -o delaytime.prg delaytime.s
	rm -f *.o
	
initvalue.bin: initvalue.s
	acme -f plain -o initvalue.bin initvalue.s
initvalue.crt: initvalue.bin
	cartconv -t normal -i initvalue.bin -o initvalue.crt

clean:
	rm -f *~
	rm -f *.prg
	rm -f *.o
	rm -f initvalue.bin
	rm -f initvalue.crt
