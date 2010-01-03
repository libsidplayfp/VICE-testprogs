TARGETS = cmp-b-counts-a.prg cia-b-counts-a.prg
COMPILER = acme
CFLAGS = -v1 --cpu 6502 -f cbm -o
REMOVE = rm -f

.PHONY: all clean

all: $(TARGETS)

%.prg: %.asm
	$(COMPILER) $(CFLAGS) $@ $<

clean:
	-$(REMOVE) $(TARGETS)
