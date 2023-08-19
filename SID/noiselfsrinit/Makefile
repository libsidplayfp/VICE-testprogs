

all: scan.prg simple.prg

scan.prg: scan.asm
	acme -f cbm -o scan.prg scan.asm
simple.prg: simple.asm
	acme -f cbm -o simple.prg simple.asm

clean:
	$(RM) simple.prg
	$(RM) scan.prg
