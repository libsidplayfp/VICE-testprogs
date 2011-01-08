# Makefile

all:	ane-lax.prg

ane-lax.prg: ane-lax.asm
	dasm $< -o$@

clean:
	rm -f *~ \#*\#
	rm -f a.out
	rm -f ane-lax.prg

# eof
