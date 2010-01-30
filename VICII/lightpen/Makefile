# Makefile

all:	lightpen.prg

lightpen.prg: lightpen.asm
	dasm $< -o$@

clean:
	rm -f *~ \#*\#
	rm -f a.out
	rm -f lightpen.prg

# eof
