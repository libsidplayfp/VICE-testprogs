COMPILER = acme
CFLAGS = -v1 --cpu 6502 -f cbm -o

.PHONY: all clean

.SUFFIXES: .prg .asm
%.prg: %.asm
	$(COMPILER) $(CFLAGS) $@ $<

all: spriteenable1.prg spriteenable2.prg spriteenable3.prg spriteenable4.prg spriteenable5.prg

spriteenable1.prg: spriteenable1.asm
spriteenable2.prg: spriteenable2.asm
spriteenable3.prg: spriteenable3.asm
spriteenable4.prg: spriteenable4.asm
spriteenable5.prg: spriteenable5.asm

clean:
	rm *.prg
