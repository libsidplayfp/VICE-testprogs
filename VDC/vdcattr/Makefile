#.SILENT:

NAME = vdcattr
BINARY = $(NAME).prg
SOURCE = $(NAME).tas
COMPILER = acme
CFLAGS = -v1 --cpu 6502 -f cbm -o
DEBUGGER = x128
DEBUGFLAGS = --autostart
DTVTRANS = dtv2sertrans
REMOVE = rm -f


.PHONY: all test debug upload clean

all: $(BINARY)

test: $(BINARY)
	$(DEBUGGER) $(DEBUGFLAGS) $(BINARY)

upload: $(BINARY)
	$(DTVTRANS) reset + wr $(BINARY)

debug: $(BINARY)
	$(DEBUGGER) $(DEBUGFLAGS) $(BINARY)

$(BINARY): $(SOURCE)
	$(COMPILER) $(CFLAGS) $@ $<

clean:
	-$(REMOVE) $(BINARY)
