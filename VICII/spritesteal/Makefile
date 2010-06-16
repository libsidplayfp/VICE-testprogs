COMPILER = acme
CFLAGS = -v1 --cpu 6502 -f cbm -o

.PHONY: all clean

.SUFFIXES: .prg .asm
%.prg: %.asm
	$(COMPILER) $(CFLAGS) $@ $<

all: spritesteal.prg spritesteal_ntsc.prg

spritesteal.prg: spritesteal.asm core.asm
spritesteal_ntsc.prg: spritesteal_ntsc.asm core.asm

clean:
	-rm *.prg
