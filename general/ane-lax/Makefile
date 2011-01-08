# Makefile

all:	ane-lax.prg

ane-lax.prg: ane-lax.asm
	dasm $< -o$@

analyze:	analyze.c
	gcc -Wall $^ -o$@

clean:
	rm -f *~ \#*\#
	rm -f a.out
	rm -f ane-lax.prg

# eof
