# Makefile

all:	dmatest.prg blittertest_dtv3.prg blittertest_rec.prg

# rules for common
.SUFFIXES: .prg .bin
# build .bin from .prg by stripping the first 2 bytes (loadaddr)
%.bin: %.prg
	dd if=$< bs=1 skip=2 > $@

dmatest.prg: dmatest.asm
	dasm $< -o$@

blittertest_rec.prg: blittertest.asm
	dasm $< -o$@ -DRECORD_MODE

blittertest_dtv3.prg: blittertest.asm blitref_dtv3.bin
	dasm $< -o$@ -DDTV3

clean:
	rm -f *~ \#*\#
	rm -f a.out
	rm -f dmatest.prg
	rm -f blittertest_rec.prg
	rm -f blittertest_dtv3.prg
# eof
