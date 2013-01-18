
all: cmp-b-counts-a.prg cmp-b-counts-a-new.prg cia-b-counts-a.prg

cmp-b-counts-a.prg: cmp-b-counts-a-old.asm cmp-b-counts-a.asm
	acme -v1 --cpu 6502 -f cbm -o cmp-b-counts-a.prg cmp-b-counts-a-old.asm
cmp-b-counts-a-new.prg: cmp-b-counts-a-new.asm cmp-b-counts-a.asm
	acme -v1 --cpu 6502 -f cbm -o cmp-b-counts-a-new.prg cmp-b-counts-a-new.asm

cia-b-counts-a.prg: cia-b-counts-a.asm
	acme -v1 --cpu 6502 -f cbm -o cia-b-counts-a.prg cia-b-counts-a.asm

clean:
	rm -f *~
	rm -f *.prg
