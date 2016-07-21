
all: a.prg b.prg

b.prg: b.asm
	64tass -a -B $< -o $@

a.prg: a.asm a.hpi
	64tass -a -B $< -o $@
