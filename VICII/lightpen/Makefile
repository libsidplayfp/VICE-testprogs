# Makefile

all:	lightpen.prg

lightpen.prg: lightpen.asm
	dasm $< -o$@

analyse: analyse.c
	gcc -Wall -o $@ $<

clean:
	rm -f *~ \#*\#
	rm -f a.out
	rm -f lightpen.prg

# eof
