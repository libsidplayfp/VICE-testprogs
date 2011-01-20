COMPILER = acme
CFLAGS = -v1 --cpu 6502 -f cbm -o

.PHONY: all clean

.SUFFIXES: .prg .asm
%.prg: %.asm
	$(COMPILER) $(CFLAGS) $@ $<

all: paddle.prg fc3detect.prg

paddle.prg: paddle.asm
fc3detect.prg: fc3detect.asm

clean:
	-rm *.prg
	-rm *~
