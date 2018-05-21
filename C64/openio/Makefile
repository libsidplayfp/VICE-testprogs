
all: de00all.prg de00int.prg dadb.prg trivial.prg gauntlet.prg

de00all.prg: de00all.asm
	acme -f cbm -o de00all.prg de00all.asm
de00int.prg: de00int.asm
	acme -f cbm -o de00int.prg de00int.asm
dadb.prg: dadb.asm
	acme -f cbm -o dadb.prg dadb.asm
trivial.prg: trivial.asm
	acme -f cbm -o trivial.prg trivial.asm
gauntlet.prg: gauntlet.asm
	acme -f cbm -o gauntlet.prg gauntlet.asm

clean:
	rm -f de00all.prg
	rm -f de00int.prg
	rm -f dadb.prg
	rm -f trivial.prg
	rm -f gauntlet.prg

