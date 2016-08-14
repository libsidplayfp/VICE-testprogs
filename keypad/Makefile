
all: coplin-c64.prg

coplin-c64.prg: coplin-c64.asm
	acme -v1 --cpu 6502 -f cbm -o coplin-c64.prg coplin-c64.asm

clean:
	rm -f *~
	rm -f *.prg
