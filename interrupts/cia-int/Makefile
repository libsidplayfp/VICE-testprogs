# Makefile

all:	cia-int.prg

cia-int.prg: cia-int.asm
	dasm $< -o$@

clean:
	rm -f *~ \#*\#
	rm -f a.out
	rm -f cia-int.prg

# eof
