# Makefile

all:	d044.prg

# rules for common
.SUFFIXES: .prg .bin
# build .bin from .prg by stripping the first 2 bytes (loadaddr)
%.bin: %.prg
	dd if=$< bs=1 skip=2 > $@

d044.prg: d044.asm
	dasm $< -o$@

clean:
	rm -f *~ \#*\#
	rm -f a.out
	rm -f d044.prg
# eof
