NAME = screenpos
BINARY = $(NAME).prg
SOURCE = $(NAME).asm
COMPILER = acme
CFLAGS = -v1 --cpu 6502 -f cbm -o
DEBUGGER = x64
DEBUGFLAGS =
DTVTRANS = dtv2sertrans
REMOVE = rm -f

.PHONY: all test dtvtest debug dtvupload clean

all: $(BINARY)

test: $(BINARY)
	$(DEBUGGER) $(BINARY)

dtvtest: $(BINARY)
	$(DTVTRANS) reset + load $(BINARY) + run

dtvupload: $(BINARY)
	$(DTVTRANS) reset + wr $(BINARY)

debug: $(BINARY)
	$(DEBUGGER) $(DEBUGFLAGS) $(BINARY)

$(BINARY): $(SOURCE)
	$(COMPILER) $(CFLAGS) $@ $<

clean:
	-$(REMOVE) $(BINARY)
