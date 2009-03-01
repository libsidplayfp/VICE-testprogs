# Makefile

all:	dmatime.prg

dmatime.prg: dmatime.asm
	dasm $< -o$@

clean:
	rm -f *~ \#*\#
	rm -f a.out
	rm -f dmatime.prg
# eof
