# Makefile

all:	timing.prg

timing.prg: timing.asm ../common/scandump.asm
	dasm $< -o$@

clean:
	rm -f *~ \#*\#
	rm -f a.out
	rm -f timing.prg
# eof
