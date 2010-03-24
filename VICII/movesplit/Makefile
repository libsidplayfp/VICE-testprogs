NAME = movesplit
BINARY = $(NAME).prg
SOURCE = $(NAME).asm
COMPILER = acme
CFLAGS = -v1 --cpu 6502 -f cbm -o
DEBUGGER = x64sc
DEBUGFLAGS =
REMOVE = rm -f

.PHONY: all test debug clean

all: $(BINARY)

test: $(BINARY)
	$(DEBUGGER) $(BINARY)

debug: $(BINARY)
	$(DEBUGGER) $(DEBUGFLAGS) $(BINARY)

$(BINARY): $(SOURCE)
	$(COMPILER) $(CFLAGS) $@ $<

clean:
	-$(REMOVE) $(BINARY)
