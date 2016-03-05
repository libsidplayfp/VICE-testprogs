
COMMON=common.asm ../framework.asm ../framework-drive.asm

PROGS = \
	via1.prg \
	via2.prg \
	via3.prg \
	via3a.prg \
	via4.prg \
	via5.prg \
	via9.prg \
	via10.prg \
	via11.prg \
	via12.prg \
	via13.prg

all: $(PROGS) disk

%.prg:%.asm $(COMMON)
	acme $*.asm

test: all
	x64sc -truedrive -autostartprgmode 2 via3.prg

disk: $(PROGS)
	c1541 -format "viavarious,00" d64 viavarious.d64 \
		-write via1.prg via1 \
		-write via2.prg via2 \
		-write via3.prg via3 \
		-write via3a.prg via3a \
		-write via4.prg via4 \
		-write via5.prg via5 \
		-write via9.prg via9 \
		-write via10.prg via10 \
		-write via11.prg via11 \
		-write via12.prg via12 \
		-write via13.prg via13
clean:
	rm -f *~
	rm -f $(PROGS)
	rm -f viavarious.d64
