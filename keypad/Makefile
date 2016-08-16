
all: coplin-c64.prg coplin-c64dtv.prg

coplin-c64.prg: coplin-c64.asm
	acme -v1 --cpu 6502 -f cbm -o coplin-c64.prg coplin-c64.asm

coplin-c64dtv.prg: coplin-c64dtv.asm
	acme -v1 --cpu 6502 -f cbm -o coplin-c64dtv.prg coplin-c64dtv.asm

clean:
	rm -f *~
	rm -f *.prg
