# Makefile

all:	fulltime.prg fulltime_record.prg

# rules for common
.SUFFIXES: .prg .bin
# build .bin from .prg by stripping the first 2 bytes (loadaddr)
%.bin: %.prg
	dd if=$< bs=1 skip=2 > $@

fulltime.prg: fulltime.asm
	dasm $< -o$@

fulltime_record.prg: fulltime.asm
	dasm $< -o$@ -DRECORD_REFDATA

clean:
	rm -f *~ \#*\#
	rm -f a.out
	rm -f fulltime.prg fulltime_record.prg
# eof
