# Makefile

all:	spritescan.prg

spritescan.prg: spritescan.asm ../common/startup.asm ../common/scandump.asm
	dasm $< -o$@

clean:
	rm -f *~ \#*\#
	rm -f a.out
	rm -f spritescan.prg

# eof
