# Makefile

all:	steal.prg

# rules for common
.SUFFIXES: .prg .bin
# build .bin from .prg by stripping the first 2 bytes (loadaddr)
%.bin: %.prg
	dd if=$< bs=1 skip=2 > $@

steal.prg: steal.asm
	dasm $< -o$@

clean:
	rm -f *~ \#*\#
	rm -f a.out
	rm -f steal.prg
# eof
