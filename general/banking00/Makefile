# Makefile

all:	banking00.prg

banking00.prg: banking00.asm
	dasm $< -o$@

clean:
	rm -f *~ \#*\#
	rm -f a.out
	rm -f banking00.prg

# eof
