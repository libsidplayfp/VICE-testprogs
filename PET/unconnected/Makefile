NAME = unconnected
BINARY = $(NAME).prg
SOURCE = $(NAME).asm
COMPILER = acme
CFLAGS = -v1 --cpu 6502 -r $(NAME).lst -f cbm -o
DEBUGGER = xpet -default -model 3016
DEBUGFLAGS = 
REMOVE = rm -f

.PHONY: all debug clean

all: $(BINARY)

debug: $(BINARY)
	$(DEBUGGER) $(DEBUGFLAGS) $(BINARY)

$(BINARY): $(SOURCE)
	$(COMPILER) $(CFLAGS) $@ $<

clean:
	-$(REMOVE) $(BINARY)
