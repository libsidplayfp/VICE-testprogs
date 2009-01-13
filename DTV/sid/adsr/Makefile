NAME = adsr
BINARY = $(NAME).prg
SOURCE = $(NAME).asm config.asm
COMPILER = acme
CFLAGS = -v1 --cpu 6502 -f cbm -o
DEBUGGER = x64dtv
DEBUGFLAGS =
DTVTRANS = dtv2sertrans
REMOVE = rm -f

.PHONY: all getdata getemudata test debug upload clean

all: $(BINARY)

getdata: $(BINARY)
	$(DTVTRANS) reset + read 0x020000-0x02ffff adsrdata.raw

getemudata: $(BINARY)
	$(DEBUGGER) $(DEBUGFLAGS) -initbreak 0x900 $(BINARY) < moncommands

test: $(BINARY)
	$(DTVTRANS) reset + load $(BINARY) + run

upload: $(BINARY)
	$(DTVTRANS) reset + wr $(BINARY)

debug: $(BINARY)
	$(DEBUGGER) $(DEBUGFLAGS) $(BINARY)

$(BINARY): $(SOURCE)
	$(COMPILER) $(CFLAGS) $@ $<

clean:
	-$(REMOVE) $(BINARY)
